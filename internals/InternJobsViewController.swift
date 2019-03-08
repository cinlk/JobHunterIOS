//
//  InternJobsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import YNDropDownMenu


fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                        GlobalConfig.DropMenuTitle.subBusinessField,
                                        GlobalConfig.DropMenuTitle.interCondition]

fileprivate let dropMenuHeigh:CGFloat = GlobalConfig.ScreenH - 240

fileprivate let jobHomeTitleH: CGFloat = JobHomeVC.titleHeight()


class InternJobsViewController: UIViewController {
    
    private var datas:[JobListModel] = []
    private var req:InternFilterModel = InternFilterModel(JSON: [:])!
    
    
    private lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        
        city.passData = { citys in
            if self.req.setCitys(citys: citys){
                self.table.mj_header.beginRefreshing()
            }
        }
        
        return city
    }()

    private lazy var kind:DropCarrerClassifyView = {
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        k.passData = { b in
            if self.req.setBusinessField(b: b){
                self.table.mj_header.beginRefreshing()
            }
            
            
        }
        return k
    }()
    
    private lazy var intern:DropInternCondtionView = {
        let intern = DropInternCondtionView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        intern.backGroundBtn.frame =  CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        intern.passData = {  condition in
            guard let c = condition else {
                return
            }
            if self.req.setCondition(c: c){
                self.table.mj_header.beginRefreshing()
            }
        }
        return intern
    }()
    
    
    lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        let menu = configDropMenu(items: [cityMenu,kind,intern], titles: dropMenuTitles, height: GlobalConfig.dropMenuViewHeight, originY: 0)
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        
        return menu
    }()
    
    
    private lazy var table:UITableView = {
        let table = UITableView()
        
        table.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        table.tableFooterView = UIView()
        table.rx.setDelegate(self).disposed(by: dispose)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return table
    }()
    
    //refresh
    
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            guard let s = self else {
                return
            }
            s.req.setOffset(offset: 0)
            s.vm.internRefresh.onNext(s.req)
            
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let s = self else {
                return
            }
            s.req.setOffset(offset: s.req.offset + Int64(s.req.limit))
            s.vm.internRefresh.onNext(s.req)
            
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    
    //rxSwift
    
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
       
        // Do any additional setup after loading the view.
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.datas.count > 0{
            return
        }
        self.table.mj_header.beginRefreshing()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,GlobalConfig.dropMenuViewHeight)?.bottomEqualToView(self.view)
        
    }
    
}



extension InternJobsViewController{
    
    
    private func  setViews(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        
    }
    
    private func setViewModel(){
        self.vm.internRes.share().subscribe(onNext: { (interns) in
            self.datas = interns
        }).disposed(by: dispose)
        
        self.vm.internRes.share().bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, mode, cell) in
                cell.showTag = false
                cell.mode = mode
        }.disposed(by: dispose)
        
        
        self.vm.internRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()
                self.view.showToast(title: "err \(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "err \(err)", view: self.view)
            default:
                break
            }
            
        }).disposed(by: dispose)
        
        
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.datas[idx.row]
            let internJob = JobDetailViewController()
            
            internJob.job = (mode.jobId!, .intern)
            
            internJob.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(internJob, animated: true)
            
            
        }).disposed(by: dispose)
        
    }
}


extension InternJobsViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
}


