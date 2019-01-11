//
//  InternSearchVC.swift
//  internals
//
//  Created by ke.liang on 2018/9/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import RxSwift
import RxCocoa
import MJRefresh


fileprivate let dropMenuH:CGFloat = 40
fileprivate let dropMenuTitles = ["城市","行业分类","实习条件"]

class InternSearchVC: UIViewController, SearchControllerDeletgate {
    
    
    private lazy var cityMenu:DropItemCityView = { [unowned self] in
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        city.passData = { citys in
            self.requestBody.city = citys
            self.table.mj_header.beginRefreshing()
        }
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
        return city
    }()
    
    
    private lazy var kindMenu:DropCarrerClassifyView = { [unowned self] in
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        k.passData = { industry in
            self.requestBody.industry = industry
            self.table.mj_header.beginRefreshing()
            
        }
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
        return k
        
    }()
    
    
    private lazy var internMenu:DropInternCondtionView = { [unowned self] in
        let i = DropInternCondtionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        i.passData = {  condition in
            self.requestBody.interns = condition
            self.table.mj_header.beginRefreshing()
        }
        
        i.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
        
        return i
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        
        let d =  configDropMenu(items: [cityMenu, kindMenu, internMenu], titles: dropMenuTitles, height: dropMenuH)
        d.isHidden = false
        return d
    }()
    
    
    private lazy var table:UITableView = {  [unowned self] in
        
        let table = UITableView.init()
        table.rx.setDelegate(self).disposed(by: self.dispose)
        table.tableFooterView = UIView()
        table.tableHeaderView = UIView()
        table.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return table
    }()
    
    
    
    
    
    //table refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            self?.searchVM.internRefresh.onNext((true, (self?.requestBody)!))
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
            self?.searchVM.internRefresh.onNext((false, (self?.requestBody)!))
            
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    private var requestBody:searchInternJobsBody  = searchInternJobsBody(JSON: [:])!

    
    
    //rxSwift
    let dispose = DisposeBag()
    let searchVM:searchViewModel = searchViewModel()
    let searchResult:BehaviorRelay<[CompuseRecruiteJobs]> = BehaviorRelay<[CompuseRecruiteJobs]>.init(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        self.setViewModel()
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view, dropMenuH)?.bottomEqualToView(self.view)
    }
    
}


extension InternSearchVC{
    private func setView(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        
         self.view.backgroundColor = UIColor.white
        
    }
    
    
    open func searchData(word:String){
        
        requestBody.word = word
        searchVM.searchInternJobs(mode: requestBody, offset: 0).catchError({ (error) -> Observable<[CompuseRecruiteJobs]> in
            self.view.showToast(title: "error \(error)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "error \(error)", view: self.view)
            return Observable<[CompuseRecruiteJobs]>.just([])
            
        }).share().bind(to: searchResult).disposed(by: dispose)
        
        self.searchVM.internRes.share().bind(to: searchResult).disposed(by: dispose)
    }
    
    private func setViewModel(){
        
        searchResult.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, element, cell) in
            cell.mode = element
            }.disposed(by: dispose)
        
        
        searchResult.share().map { jobs in
            jobs.isEmpty
        }.bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
        
        
        
        self.searchVM.internRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { status in
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
}



extension InternSearchVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}


extension InternSearchVC{
    open func resetCondition(){
        self.cityMenu.clearAll.sendActions(for: .touchUpInside)
        self.kindMenu.clearSelected()
        self.internMenu.clearAll.sendActions(for: .touchUpInside)
        self.requestBody.city = nil
        self.requestBody.industry = nil
        self.requestBody.interns = nil
        
    }

}
