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


class GraduateJobsViewController: UIViewController {


    private var datas:[JobListModel] = []
    
    
    internal lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 200))
        // 覆盖指定高度
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        return city
    }()
    
    
    // 职业类型
    lazy var careerClassify:DropCarrerClassifyView = { [unowned self] in
        let v1 = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        
        
        return v1
    }()
    
    
    
    lazy var degree:DropDegreeMenuView = { [unowned self] in
        let v = DropDegreeMenuView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 45*5))
        v.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        
        return v
    }()
    
    
    
    
    // 自定义条件选择下拉菜单view
    private lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: DROP_MENU_H), dropDownViews: [cityMenu,careerClassify,degree], dropDownViewTitles: ["城市","行业分类","学历"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        menu.addSwipeGestureToBlurView()
        
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
            
            self?.vm.graduateRefresh.onNext(true)
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            
            self?.vm.graduateRefresh.onNext(false)
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
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,DROP_MENU_H)?.bottomEqualToView(self.view)
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
        }, onError: { (err) in
            self.datas = []
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
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
                    print("get err \(err)")
                    self.table.mj_footer.endRefreshing()
                    self.table.mj_header.endRefreshing()
                default:
                    break
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
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

