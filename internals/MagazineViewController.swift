//
//  MagazineViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import RxCocoa
import RxDataSources



class MagazineViewController: BaseViewController {

    
    private var newsType:String?
    
    private var firstShow = true
    
    private lazy var  vm: MagazineViewModel = MagazineViewModel()
    private lazy var dispose = DisposeBag()
    
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.tableFooterView = UIView()
        tb.separatorStyle = .singleLine
        tb.register(MagineTableViewCell.self, forCellReuseIdentifier: MagineTableViewCell.identity())
        return tb
        
    }()
    
    
    init(type: String) {
        self.newsType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        setViews()
        setViewModel()
        tableRefresh()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if  self.firstShow{
            self.table.mj_header.beginRefreshing()
            self.firstShow = !self.firstShow
        }
        
    }
    
    
    override func setViews() {
        
        
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hiddenViews.append(table)
        super.setViews()
        
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        //self.table.reloadData()
    }
    
    override func reload() {
        self.vm.refresh.onNext(true)
        super.reload()
        //loadData()
    }
    
    
    
}


// table refresh
extension MagazineViewController{
    
    private func tableRefresh(){
       self.table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
                self.vm.refresh.onNext(true)
       })
       (self.table.mj_header as! MJRefreshNormalHeader).activityIndicatorViewStyle = .gray
       (self.table.mj_header as! MJRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
       (self.table.mj_header as! MJRefreshNormalHeader).setTitle("正在加载", for: .refreshing)
       (self.table.mj_header as! MJRefreshNormalHeader).setTitle("开始刷新", for: .pulling)
       (self.table.mj_header as! MJRefreshNormalHeader).setTitle("结束", for: .idle)

        self.table.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.vm.refresh.onNext(false)
        })
        (self.table.mj_footer as! MJRefreshAutoNormalFooter).setTitle("上拉刷新", for: .idle)
        (self.table.mj_footer as! MJRefreshAutoNormalFooter).setTitle("刷新", for: .refreshing)
        (self.table.mj_footer as! MJRefreshAutoNormalFooter).setTitle("没有数据", for: .noMoreData)
    }
    
    
}



extension MagazineViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
        let mode =  self.vm.models.value[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: MagineTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }

    
    
    private func setViewModel(){
        
        
        self.errorView.tap.drive(onNext: { _ in
            self.reload()
        }).disposed(by: self.dispose)
        
       self.table.rx.setDelegate(self).disposed(by: self.dispose)
        
        
       let dataSource =  RxTableViewSectionedReloadDataSource<MagazineModelSection>.init(configureCell:  { (ds, table, indexPath, element) ->  UITableViewCell  in
            
            if let cell = table.dequeueReusableCell(withIdentifier: MagineTableViewCell.identity(), for: indexPath) as? MagineTableViewCell{
                cell.mode = element
                
                return cell
            }
            
            return UITableViewCell()
            
        })

       

        self.vm.models.map({ modes  in
            [MagazineModelSection.init(items: modes)]
        }).asDriver(onErrorJustReturn: []).drive(self.table.rx.items(dataSource: dataSource)).disposed(by: self.dispose)
        
       
        
        self.table.rx.itemSelected.asDriver().drive(onNext: { (indexPath) in

            self.table.deselectRow(at: indexPath, animated: false)
            let webview = BaseWebViewController()
            if let cell = self.table.cellForRow(at: indexPath) as? MagineTableViewCell{
                webview.mode = cell.mode?.link
                self.navigationController?.pushViewController(webview, animated: true)
            }
        }).disposed(by: self.dispose)
        
        
        _ = self.vm.refreshState.takeUntil(self.rx.deallocated).subscribe(onNext: { (state) in
            switch state {
                
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing(completionBlock: {
                    self.didFinishloadData()
                })
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case  let .error(err):
                self.view.showToast(title: "\(err)", customImage: nil, mode: .text)
                self.showError()
                
            default:
                break
            }
        })
        //self.vm.result
    }
    
}
