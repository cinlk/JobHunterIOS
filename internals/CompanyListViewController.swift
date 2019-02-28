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


fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                        GlobalConfig.DropMenuTitle.businessField,
                                        GlobalConfig.DropMenuTitle.companyType]

fileprivate let dropMenuHeight:CGFloat = GlobalConfig.ScreenH - 240
fileprivate let jobHomeTitleH: CGFloat = JobHomeVC.titleHeight()

class CompanyListViewController: UIViewController {

    
    private var datas:[CompanyListModel] = []
    private lazy var req:CompanyFilterModel = CompanyFilterModel(JSON: [:])!
    
    private lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
        city.passData = { citys in
            if self.req.setCitys(citys: citys){
                self.table.mj_header.beginRefreshing()
            }
        }
        // 覆盖指定高度
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        return city
    }()
    
    private lazy var industryKind:DropItemIndustrySectorView = {
        let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
        
        indus.passData = { b in
            if self.req.setBusinessField(b: b){
                self.table.mj_header.beginRefreshing()
            }
        }
        indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        
        return indus
        
    }()
    
    private lazy var companyType:DropCompanyPropertyView = {
        let comp = DropCompanyPropertyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
        
        comp.passData = { t in
            if self.req.setCompanyType(t: t){
                self.table.mj_header.beginRefreshing()
            }
        }
        comp.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        
        return comp
    }()
    
    
    
    // 自定义条件选择下拉菜单view
    private lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = configDropMenu(items: [cityMenu,industryKind, companyType], titles: dropMenuTitles, height: GlobalConfig.dropMenuViewHeight, originY: 0)
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
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
            guard let s = self else {
                return
            }
            s.req.setOffset(offset: 0)
            s.vm.companyRefresh.onNext(s.req)
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
            s.vm.companyRefresh.onNext(s.req)
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
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,GlobalConfig.dropMenuViewHeight)?.bottomEqualToView(self.view)
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
        }).disposed(by: dispose)
        
        self.vm.companyRes.share().bind(to: self.table.rx.items(cellIdentifier: CompanyItemCell.identity(), cellType: CompanyItemCell.self)) { (row, mode, cell) in
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
            
        }).disposed(by: dispose)
    
        
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

