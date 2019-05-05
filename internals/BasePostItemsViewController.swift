//
//  BasePostItemsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import MJRefresh
import RxCocoa
import RxSwift
import RxDataSources


class BasePostItemsViewController: BaseViewController {

    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    //internal var modes:[ForumType : [PostArticleModel]] = [:]
    internal var modes:[PostArticleModel] = []
    // 帖子主题类型
    internal var type:ForumType = .none{
        didSet{
            self.req.currentType = type
            self.refreshHeader.beginRefreshing()
        }
    }
    
    private lazy var vm:ForumViewModel = ForumViewModel.init()
    // 请求类型
    private lazy var req:ArticleReqModel = ArticleReqModel.init()
    
    
    internal lazy var table:UITableView = { [unowned self] in
        let table = UITableView()
        table.tableFooterView = UIView()
        //table.dataSource = self
        table.rx.setDelegate(self).disposed(by: self.dispose)
        //table.delegate = self
        table.backgroundColor = UIColor.viewBackColor()
        table.register(ListPostItemCell.self, forCellReuseIdentifier: ListPostItemCell.identity())
        return table
    }()
    
    private lazy var refreshHeader: MJRefreshNormalHeader = {
        let h =  MJRefreshNormalHeader.init { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.req.setOffset(offset:0)
            self.vm.sectionRequest.onNext(self.req)
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
    }()
    
    
    private lazy var refreshFooter: MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: {  [weak self] in
            guard let `self` = self else {
                return
            }
            self.req.setOffset(offset: 10)
            self.vm.sectionRequest.onNext(self.req)
        })
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        //loadData()
        setViewModel()
    }
    
    
    
    override func setViews() {
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hiddenViews.append(table)
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
       
    }
    
    
    override func reload() {
        super.reload()
        self.req.setOffset(offset: 0)
        self.vm.sectionRequest.onNext(self.req)
    }
    
    deinit {
        print("deinit BasePostItemsViewController \(self)")
    }


}


extension BasePostItemsViewController{
    
    private func setViewModel(){
        
        self.noData.tap.drive(onNext: { [weak self] in
            self?.reload()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.errorView.tap.drive(onNext: { [weak self]  in
            self?.reload()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.postItems.share().subscribe(onNext: { [weak self] (data) in
            self?.modes = data
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.postItems.share().bind(to: self.table.rx.items(cellIdentifier: ListPostItemCell.identity(), cellType: ListPostItemCell.self)){   (row, mode, cell) in
            if self.type == .hottest{
                mode.showTag = true
            }
            cell.mode = mode
            
        }.disposed(by: self.dispose)
        
        
        self.table.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else {
                return
            }
           
            
            let post = PostContentViewController()
            let mode = self.modes[indexPath.row]
            
            post.mode = (data: mode, row: indexPath.row)
            post.deleteSelf = { [weak self]  row in
                
                self?.modes.remove(at: row)
                self?.table.reloadData()
            }
            post.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(post, animated: true)
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.vm.refreshStatus.asDriver(onErrorJustReturn: .none).debug().drive(onNext: { [weak self] (state) in
            guard let `self` = self else{
                return
            }
            switch state{
            case .endHeaderRefresh:
                
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
                self.didFinishloadData()
                if self.modes.isEmpty{
                    // 没有数据 view  TODO
//                    let v = UIView.init(frame: CGRect.zero)
//                    v.backgroundColor = UIColor.blue
//                    self.table.backgroundView = v
                    //self.table.mj_footer.endRefreshingWithNoMoreData()
                    self.showNoData()
                }
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
                
            case .error(let err):
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()
                self.didFinishloadData()
                self.view.showToast(title: "err \(err)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "err \(err)", view: self.view)
            default:
                break
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
}

extension BasePostItemsViewController:  UITableViewDelegate{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return modes.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: listPostItemCell.identity(), for: indexPath) as? listPostItemCell{
//            cell.mode = modes[indexPath.row]
//            return cell
//        }
//
//        return UITableViewCell()
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = self.modes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ListPostItemCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        let post = PostContentViewController()
//        let mode = modes[indexPath.row]
//        post.mode = (data:mode, row: indexPath.row)
//        post.deleteSelf = { [weak self]  row in
//            self?.modes.remove(at: row)
//            self?.table.reloadData()
//        }
//
//
//        post.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(post, animated: true)
//
//    }
    
    
}


