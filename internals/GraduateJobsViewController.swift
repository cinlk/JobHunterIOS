//
//  GraduateJobsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import RxSwift
import RxCocoa
import MJRefresh

fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                        GlobalConfig.DropMenuTitle.subBusinessField,
                                        GlobalConfig.DropMenuTitle.degree]


fileprivate let dropMenuHeigh:CGFloat = GlobalConfig.ScreenH - 240


class GraduateJobsViewController: UIViewController {


    private var datas:[JobListModel] = []
    private var req: GraduateFilterModel = GraduateFilterModel(JSON: [:])!
    
    internal lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        // 覆盖指定高度
        city.passData = { citys in
            if self.req.setCitys(citys: citys){
                self.table.mj_header.beginRefreshing()
            }
            
        }
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titleHeight())
        return city
    }()
    
    
    // 职业类型
    lazy var careerClassify:DropCarrerClassifyView = { [unowned self] in
        let subBusiness = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        subBusiness.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titleHeight())
        subBusiness.passData = { field in
            if self.req.setBusinessField(b: field){
                self.table.mj_header.beginRefreshing()
            }
        }
        
        return subBusiness
    }()
    
    
    
    lazy var degree:DropDegreeMenuView = { [unowned self] in
        let v = DropDegreeMenuView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        v.passData = { degree in
            if self.req.setDegree(d: degree){
                self.table.mj_header.beginRefreshing()
            }
        }
        v.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titleHeight())
        
        return v
    }()
    
    
    
    
    // 自定义条件选择下拉菜单view
    private lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        let menu = configDropMenu(items: [cityMenu,careerClassify,degree], titles: dropMenuTitles, height: GlobalConfig.dropMenuViewHeight, originY: 0)
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
            s.vm.graduateRefresh.onNext(s.req)
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
            s.vm.graduateRefresh.onNext(s.req)
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
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


extension GraduateJobsViewController{
    
    private func setViews() {
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
    }
    
    private func setViewModel(){
        
        self.vm.graduateRes.share().subscribe(onNext: { (jobs) in
            self.datas = jobs
        }).disposed(by: dispose)
        
        
        self.vm.graduateRes.share().bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, mode, cell) in
            cell.mode = mode
        }.disposed(by: dispose)
        
        self.vm.graduateRefreshStasu.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
                case .endHeaderRefresh:
                    self.table.mj_header.endRefreshing()
                    self.table.mj_footer.resetNoMoreData()
                
                case .endFooterRefresh:
                    self.table.mj_footer.endRefreshing()
                case .NoMoreData:
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                case .error(let err):
                    self.view.showToast(title: "error \(err)", customImage: nil, mode: .text)
                    self.table.mj_footer.endRefreshing()
                    self.table.mj_header.endRefreshing()
                default:
                    break
            }
            
        }).disposed(by: dispose)
        
        // table
        
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.datas[idx.row]
            let graduateJob = JobDetailViewController()
            graduateJob.uuid = mode.jobId!
            
            graduateJob.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(graduateJob, animated: true)
            
            
        }).disposed(by: dispose)
    
        
    }
}

extension GraduateJobsViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    
}

