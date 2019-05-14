//
//  ForumSearchResultViewController.swift
//  internals
//
//  Created by ke.liang on 2019/5/13.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

fileprivate let cellIdentity:String = "cell"

class ForumSearchResultViewController: UIViewController {

    private lazy var vm:ForumViewModel = ForumViewModel.init()
    private lazy var req: ForumSearchReq = ForumSearchReq.init()
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    
    private var modes:[PostArticleModel] = []

    private lazy var table:UITableView = { [unowned self] in
        let t = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        t.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        t.backgroundColor = UIColor.clear
        t.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        t.register(ListPostItemCell.self, forCellReuseIdentifier: ListPostItemCell.identity())
        t.tableFooterView = UIView.init()
        t.rx.setDelegate(self).disposed(by: self.dispose)
        
        return t
    }()
    
    private lazy var loading:UIView = { [unowned self] in
        let activity = UIActivityIndicatorView.init()
        activity.style = UIActivityIndicatorView.Style.gray
        activity.startAnimating()
        let label = UILabel.init()
        label.text = "加载中..."
        label.setSingleLineAutoResizeWithMaxWidth(200)
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.clear
        v.addSubview(activity)
        v.addSubview(label)
        _ = activity.sd_layout()?.leftSpaceToView(v, (GlobalConfig.ScreenW - 45)/2)?.centerYEqualToView(v)?.heightIs(45)?.widthEqualToHeight()
        _ = label.sd_layout()?.leftSpaceToView(activity, 20)?.centerYEqualToView(activity)?.autoHeightRatio(0)
        
        return v
    }()
    
    
    
    private lazy var refrehFooter: MJRefreshAutoNormalFooter = {
        let footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.req.setOffset(offset: 10)
            self.vm.postSearch.onNext(self.req)
            
        })
        
        
        footer?.setTitle("加载中..", for: .refreshing)
        footer?.setTitle("下拉刷新", for: .idle)
        footer?.setTitle("没有更多数据", for: .noMoreData)
        footer?.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        
        
        return footer!
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
        // Do any additional setup after loading the view.
    }
    
    
    deinit {
        print("deinit forumSearchResult \(self)")
    }

}


extension ForumSearchResultViewController{
    private func setView(){
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.table)
        self.view.addSubview(loading)
        _ = self.table.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = self.loading.sd_layout()?.topSpaceToView(self.view, GlobalConfig.NavH + 10)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(60)
        
        self.table.mj_footer = refrehFooter
        
        
    }
    
    private func setViewModel(){
        
        // 监听搜索控件退出

        
        // 监听消息
        NotificationCenter.default.rx.notification(NotificationName.forumSearchWord, object: nil).subscribe(onNext: { [weak self] (notify) in
            guard let `self` = self else {
                return
            }
            if let userinfo = notify.userInfo as? [String: String],  let word =  userinfo["word"]{
                // 开始搜索
                // 显示进度条 TODO
                 self.req.word = word
                 self.req.setOffset(offset: 0)
                 self.vm.postSearch.onNext(self.req)
            }
            
            // 搜索控件退出, 情况搜索结果
//            if let userinfo = notify.userInfo as? [String: Bool],  let quit =  userinfo["quit"], quit{
//
//                self.req.word = ""
//                self.req.setOffset(offset: 0)
//                self.vm.searchRes.accept([])
//            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        // 显示搜索view
        //let hud = MBProgressHUD.showAdded(to: self.table, animated: true)
        self.vm.searching .filter({ [unowned self] _ in
            return !self.table.mj_footer.isRefreshing
        }).map { !$0
            }.debug().drive(self.loading.rx.isHidden).disposed(by: self.dispose)
        //self.vm.searching
        self.vm.searching.filter({  [unowned self] _ in
            return !self.table.mj_footer.isRefreshing
        }).map { $0
            }.debug().drive(self.table.rx.isHidden).disposed(by: self.dispose)
        
        self.vm.searchRes.share().subscribe(onNext: { [weak self] (data) in
            self?.modes = data
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.searchRes.bind(to: self.table.rx.items(cellIdentifier: ListPostItemCell.identity(), cellType: ListPostItemCell.self)){ (row, mode, cell) in
            
            cell.mode = mode
            
        }.disposed(by: self.dispose)
        
        // 下拉刷新
        self.vm.searchRefresh.asDriver(onErrorJustReturn: .none).drive(onNext: { [weak self] (status) in
            switch status{
            case .endFooterRefresh:
                self?.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self?.table.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        // 选择某个d帖子
        self.table.rx.itemSelected.asDriver().drive(onNext: { [weak self] (indexPath) in
            
            guard let `self` = self else {
                return
            }
            
            
            let post = PostContentViewController()
            let mode = self.modes[indexPath.row]
            
            // 更新浏览数量
            self.vm.addReadCount(postId: mode.id!)
            
            post.mode = (data: mode, row: indexPath.row)
            post.deleteSelf = { [weak self]  row in
                
                if var old =  self?.vm.postItems.value{
                    old.remove(at: row)
                    self?.vm.postItems.accept(old)
                }
            }
            self.table.deselectRow(at: indexPath, animated: false)
            post.hidesBottomBarWhenPushed = true
            self.presentingViewController?.navigationController?.pushViewController(post, animated: true)
            
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
    }
}


extension ForumSearchResultViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.modes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ListPostItemCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
}


