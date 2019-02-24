//
//  CompanyListViewController.swift
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


class CompanyListViewController: UIViewController {

    
    private var datas:[CompanyListModel] = []
    
    internal lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 200))
        // 覆盖指定高度
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        return city
    }()
    
    internal lazy var industryKind:DropItemIndustrySectorView = {
        let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        
        indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        
        return indus
        
    }()
    
    // 自定义条件选择下拉菜单view
    private lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: DROP_MENU_H), dropDownViews: [cityMenu,industryKind], dropDownViewTitles: ["城市","行业领域"])
        
        menu.setImageWhens(normal: [#imageLiteral(resourceName: "arrow_dim")], selectedTintColor: UIColor.blue, disabledTintColor: UIColor.black)
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        //menu.addSwipeGestureToBlurView()
        return menu
        
    }()
    
    private lazy var table:UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.viewBackColor()
        table.register(CompanyItemCell.self, forCellReuseIdentifier: CompanyItemCell.identity())
        table.rx.setDelegate(self).disposed(by: dispose)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return table
    }()
    
    
    // refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            self?.vm.companyRefresh.onNext(true)
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.vm.companyRefresh.onNext(false)
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
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,DROP_MENU_H)?.bottomEqualToView(self.view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if datas.count > 0{
            return
        }
        
        self.table.mj_header.beginRefreshing()
        
    }
    
}

extension CompanyListViewController{
    
    private func setViews() {
        
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        
        
    }
    
    private func  setViewModel(){
        
        self.vm.companyRes.share().asDriver(onErrorJustReturn: []).drive(onNext: { (companys) in
            self.datas = companys
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        self.vm.companyRes.share().catchError { (err) -> Observable<[CompanyListModel]> in
            return  Observable<[CompanyListModel]>.just([])
            }.observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CompanyItemCell.identity(), cellType: CompanyItemCell.self)) { (row, mode, cell) in
                cell.mode = mode
        }.disposed(by: dispose)
    
    
        self.vm.companyRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.view.showToast(title: "get error \(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "get error \(err)", view: self.view)
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
            default:
                break
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    
        
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
                self.table.deselectRow(at: idx, animated: false)
                let mode = self.datas[idx.row]
                let companyVC = CompanyMainVC()
                companyVC.companyID = mode.companyID
                companyVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(companyVC, animated: true)
            
        }).disposed(by: dispose)
    
    }
    
}

extension CompanyListViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanyItemCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
}

