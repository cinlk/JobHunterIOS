//
//  CompanySearchVC.swift
//  internals
//
//  Created by ke.liang on 2018/9/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import YNDropDownMenu


fileprivate let dropMenuH:CGFloat = 40
fileprivate let dropMenuTitles:[String] = ["城市","行业分类"]


class CompanySearchVC: UIViewController, SearchControllerDeletgate {


    private lazy var cityMenu:DropItemCityView = { [unowned self] in
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        city.passData = { citys in
                self.requestBody.city = citys
                self.table.mj_header.beginRefreshing()
        }
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return city
    }()
    
    
    private lazy var kind:DropCarrerClassifyView = { [unowned self] in
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        k.passData = {  s in
            self.requestBody.field = s
            self.table.mj_header.beginRefreshing()
        }
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
        return k
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = { [unowned self] in
        let d = configDropMenu(items: [cityMenu, kind], titles: dropMenuTitles, height: dropMenuH)
        d.isHidden = true
        return d
    }()
    
    
    private lazy var table:UITableView = {
        let tb = UITableView()
        tb.register(CompanyItemCell.self, forCellReuseIdentifier: CompanyItemCell.identity())
        tb.rx.setDelegate(self).disposed(by: dispose)
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tb.tableFooterView = UIView()
        tb.tableHeaderView = UIView()
        return tb
    }()
    
    
    
    
    // refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            
            self?.searchVM.companyRefresh.onNext((true, (self?.requestBody)!))
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.searchVM.companyRefresh.onNext((false, (self?.requestBody)!))
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    
    private var requestBody:searchCompanyBody = searchCompanyBody(JSON: [:])!
    
    //rxSwift
    let dispose = DisposeBag()
    let searchVM:searchViewModel = searchViewModel()
    let searchResult:BehaviorRelay<[CompanyModel]> =  BehaviorRelay<[CompanyModel]>.init(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _ = table.sd_layout().topSpaceToView(self.view,dropMenuH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
}



extension CompanySearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  75
    }
    
}



extension CompanySearchVC{
    
    private func setView(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        self.view.backgroundColor = UIColor.white
    }
    
    
    open func searchData(word:String){
        
        self.requestBody.word  = word
        searchVM.searchCompany(mode: self.requestBody, offset: 0).catchError { (error) -> Observable<[CompanyModel]> in
             self.view.showToast(title: "error \(error)", customImage: nil, mode: .text)
             //showOnlyTextHub(message: "error \(error)", view: self.view)
             return Observable<[CompanyModel]>.just([])
        }.share().bind(to: searchResult).disposed(by: dispose)
        
        self.searchVM.companyRes.share().bind(to: searchResult).disposed(by: dispose)
    }
    
    private func setViewModel(){
        
        
        searchResult.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CompanyItemCell.identity(), cellType: CompanyItemCell.self)){ (row, element, cell) in
            cell.mode = element
        }.disposed(by: dispose)
        
        searchResult.share().map({ applys  in
            applys.isEmpty
        }) .bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
        
        
        // table 刷新状态
        
        self.searchVM.companyRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { refreshStatus in
            switch refreshStatus{
            case .beginHeaderRefrsh:
                self.table.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
                // table view 滚动到第一row
                if self.searchResult.value.count > 0{
                    self.table.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                }
            case .beginFooterRefresh:
                self.table.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.view.showToast(title: "company appy \(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "company appy \(err)", view: self.view)
            default:
                break
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
    }
}


extension CompanySearchVC{
    
    open func resetCondition(){
        
        self.cityMenu.clearAll.sendActions(for: .touchUpInside)
        self.kind.clearSelected()
        self.requestBody.city = nil
        self.requestBody.field = nil
        
    }
}
