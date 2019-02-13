//
//  SpecialJobVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import RxCocoa
import RxDataSources

// 特定属性的职位集合

class SpecialJobVC: BaseViewController {

    
    private var vm: SpecailJobViewModel!
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var firstLoad:Bool = true
    
    private lazy var tableView:UITableView = {
        let table = UITableView.init(frame: CGRect.zero)
        table.backgroundColor = UIColor.viewBackColor()
        table.tableFooterView = UIView()
        table.showsHorizontalScrollIndicator = false
        table.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        return table
    }()
    
    init(kind:String) {
        super.init(nibName: nil, bundle: nil)
        self.title = kind
        self.vm = SpecailJobViewModel.init(kind: kind, limit: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.setViewModel()
        self.setRefresh()
        
        
    }
    

    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 背景颜色
        self.navigationController?.insertCustomerView(UIColor.orange)
       
        if self.firstLoad{
            
            self.tableView.mj_header.beginRefreshing()
            self.firstLoad = !self.firstLoad
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(self.tableView)
        _ = tableView.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    
    override func setViews() {
        
        self.hidesBottomBarWhenPushed = true
        self.hiddenViews.append(self.tableView)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        //self.tableView.reloadData()
    }
    
    override func reload() {
        
        self.tableView.mj_header.beginRefreshing()
        self.vm.refresh.accept(true)
        super.reload()
        
    }
    
  
    

    // MARK: - Table view data source


    
}


extension SpecialJobVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode =  self.vm.data.value[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
}

extension SpecialJobVC{
    
    
    private func setRefresh(){
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.vm.refresh.accept(true)
        })
        (self.tableView.mj_header as! MJRefreshNormalHeader).activityIndicatorViewStyle = .gray
        (self.tableView.mj_header as! MJRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
        (self.tableView.mj_header as! MJRefreshNormalHeader).setTitle("正在加载", for: .refreshing)
        (self.tableView.mj_header as! MJRefreshNormalHeader).setTitle("开始刷新", for: .pulling)
        (self.tableView.mj_header as! MJRefreshNormalHeader).setTitle("结束", for: .idle)
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.vm.refresh.accept(false)
        })
        (self.tableView.mj_footer as! MJRefreshAutoNormalFooter).setTitle("上拉刷新", for: .idle)
        (self.tableView.mj_footer as! MJRefreshAutoNormalFooter).setTitle("刷新", for: .refreshing)
        (self.tableView.mj_footer as! MJRefreshAutoNormalFooter).setTitle("没有数据", for: .noMoreData)
        
        
    }
    
    private func setViewModel(){
        
        
        self.tableView.rx.setDelegate(self).disposed(by: self.dispose)
        self.errorView.tap.asDriver().drive(onNext: { _ in
            self.reload()
            
        }).disposed(by: self.dispose)
       
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, JobListModel>>(configureCell: { (ds, table, indePath, element) -> UITableViewCell in
            
            if let cell = table.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indePath) as? CommonJobTableCell{
                // 显示实习标记
                cell.showTag = true 
                cell.mode = element
                return cell
            }
            
            return UITableViewCell.init()
            
        })
        
        self.vm.data.map { jobs  in
            return [SectionModel<String, JobListModel>.init(model: "", items: jobs)]
        }.asDriver(onErrorJustReturn: []).drive(self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.dispose)
        
        self.tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: false)
            if let cell = self.tableView.cellForRow(at: indexPath) as? CommonJobTableCell, let id = cell.mode?.jobId{
                let vc = JobDetailViewController()
                vc.uuid = id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: self.dispose)
        
        
        self.vm.refreshState.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
            case .endHeaderRefresh:
                self.tableView.mj_header.endRefreshing(completionBlock: {
                    self.didFinishloadData()
                })
                self.tableView.mj_footer.resetNoMoreData()
            case .endFooterRefresh:
                self.tableView.mj_footer.endRefreshing()
            case .NoMoreData:
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                print(err)
                self.showError()
            default:
                break
            }
            
        }).disposed(by: self.dispose)
        
    }
}

