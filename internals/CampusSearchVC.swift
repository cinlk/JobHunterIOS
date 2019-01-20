//
//  CampusSearchVC.swift
//  internals
//
//  Created by ke.liang on 2018/9/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import RxCocoa
import RxSwift
import MJRefresh
import ObjectMapper

fileprivate let menuTitles:[String] = ["城市","专业分类","公司性质"]
fileprivate let dropMenuH:CGFloat = 40

class CampusSearchVC: UIViewController, SearchControllerDeletgate {

    
    
    private  lazy var cityMenu:DropItemCityView =  {
         let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
         city.passData = { citys in
            self.requestBody.city = citys
            self.table.mj_header.beginRefreshing()
            
        }
         city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
         return city
    }()
    
    
    private lazy var kind:DropCarrerClassifyView = {
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        k.passData = {  industry in
            self.requestBody.industry =  industry
            self.table.mj_header.beginRefreshing()
        }
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return k
    }()
    
    private lazy var company:DropCompanyPropertyView = {
        let c = DropCompanyPropertyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height:  6*45))
        c.passData = { company in
            self.requestBody.company = company
            self.table.mj_header.beginRefreshing()
        }
        c.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return c
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        
        return configDropMenu(items: [cityMenu, kind, company], titles: menuTitles, height: dropMenuH)
    }()
    
    
    
    private lazy var table:UITableView = {
        let tb = UITableView.init()
        tb.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        tb.rx.setDelegate(self).disposed(by:dispose)
        tb.tableFooterView = UIView()
        tb.tableHeaderView = UIView()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return tb
    }()
    
    //table refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            self?.searchVM.graduateRefresh.onNext((true, (self?.requestBody)!))
            //self?.searchVM. .onNext((true, (self?.requestBody)!))
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.searchVM.graduateRefresh.onNext((false, (self?.requestBody)!))
            
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    private var requestBody:searchGraduateRecruiteBody = searchGraduateRecruiteBody(JSON: [:])!

    //rxSwift
    private let dispose = DisposeBag()
    private let searchVM = searchViewModel()
    private var searchResult:BehaviorRelay<[CompuseRecruiteJobs]> = BehaviorRelay<[CompuseRecruiteJobs]>.init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        // Do any additional setup after loading the view.
    }


}

extension CampusSearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}



extension CampusSearchVC{
    private func setView(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.view.backgroundColor = UIColor.white
        _ = table.sd_layout().topSpaceToView(dropMenu,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    
    private func setViewModel(){
        
        
        searchResult.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, element, cell) in
            cell.mode = element
        }.disposed(by: dispose)
        
        
        searchResult.share().map { jobs in
            jobs.isEmpty
        }.bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
        
        
        
        self.searchVM.graduateRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { status in
                switch status{
                case .beginHeaderRefrsh:
                    self.table.mj_header.beginRefreshing()
                case .endHeaderRefresh:
                    self.table.mj_footer.resetNoMoreData()
                    self.table.mj_header.endRefreshing()
                case .beginFooterRefresh:
                    self.table.mj_footer.beginRefreshing()
                case .endFooterRefresh:
                    self.table.mj_footer.endRefreshing()
                case .NoMoreData:
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                case .error(let err):
                    self.view.showToast(title: "online appy \(err)", customImage: nil, mode: .text)
                    //showOnlyTextHub(message: "online appy \(err)", view: self.view)
                default:
                    break
                }
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }
    
    
    // 搜索数据
    open func searchData(word:String){
        
        requestBody.word = word
        
        // 选项切换的刷新
        searchVM.searchGraduteJobs(mode: requestBody, offset: 0).catchError({ (error) -> Observable<[CompuseRecruiteJobs]> in
            self.view.showToast(title: "error \(error)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "error \(error)", view: self.view)
            return Observable<[CompuseRecruiteJobs]>.just([])
            
        }).share().bind(to: searchResult).disposed(by: dispose)
        
        // 界面内table 自身的刷新
        self.searchVM.graduateRes.share().bind(to: searchResult).disposed(by: dispose)
        
    }
    
    
    
}


extension CampusSearchVC{
    
    open func resetCondition(){
        self.cityMenu.clearAll.sendActions(for: .touchUpInside)
        self.kind.clearSelected()
        self.company.clearSelected()
        
        self.requestBody.city = nil
        self.requestBody.industry = nil
        self.requestBody.company = nil
    }
}


