//
//  OnlineApplySearchVC.swift
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
import ObjectMapper

fileprivate let dropViewH:CGFloat = 40
fileprivate let dropMenuTitles:[String] = ["城市","行业领域"]


class OnlineApplySearchVC: UIViewController, SearchControllerDeletgate {

    
    private lazy var cityMenu:DropItemCityView = { [unowned self] in
        let c = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        c.passData  = { citys in
            
            self.requestBody.city = citys
            self.table.mj_header.beginRefreshing()
            
        }
        c.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: NavH)
        return c
    }()
    
    
    private lazy var kind:DropItemIndustrySectorView = { [unowned self] in
        let v = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
      
        v.passData = { item in
            
            self.requestBody.industry = item
            self.table.mj_header.beginRefreshing()
        }
        
        v.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: NavH)
        return v
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        let menu = configDropMenu(items: [cityMenu, kind], titles: dropMenuTitles, height: dropViewH)
        menu.isHidden = false
        
        return menu
    }()
    
    
    
    
    private lazy var table:UITableView = { [unowned self] in
        
        let tb = UITableView.init()
        tb.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        tb.rx.setDelegate(self).disposed(by: dispose)
        tb.tableHeaderView = UIView()
        tb.tableFooterView = UIView()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return tb
        
    }()
    
    
    // table refresh
    
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            
            self?.searchVM.onlineApplyRrefresh.onNext((true, (self?.requestBody)!))
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            
            
            self?.searchVM.onlineApplyRrefresh.onNext((false, (self?.requestBody)!))

        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    // 请求数据body
    private var requestBody:searchOnlineApplyBody = searchOnlineApplyBody(JSON: [:])!
    
   
    // rxSwift
    private let dispose = DisposeBag()
    private let searchVM = searchViewModel()
    private var searchResult:BehaviorRelay<[OnlineApplyModel]> = BehaviorRelay<[OnlineApplyModel]>(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()

        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
    }
  

}

extension OnlineApplySearchVC: UITableViewDelegate{
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension OnlineApplySearchVC{
    
    private func setView(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.view.backgroundColor = UIColor.white
    
        _ = table.sd_layout().topSpaceToView(dropMenu,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    // 搜索数据
    open func searchData(word:String){
        
        requestBody.word = word
        
        // 选项切换的刷新
        searchVM.searchOnlineAppy(mode: requestBody, offset: 0).catchError({ (error) -> Observable<[OnlineApplyModel]> in
            self.view.showToast(title: "error \(error)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "error \(error)", view: self.view)
            return Observable<[OnlineApplyModel]>.just([])
                
        }).share().bind(to: searchResult).disposed(by: dispose)

        // 界面内table 自身的刷新
        self.searchVM.onlineApplyRes.share().bind(to: searchResult).disposed(by: dispose)
        
    }
    
    private func setViewModel(){
        
        
        searchResult.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: OnlineApplyCell.identity(), cellType: OnlineApplyCell.self)){ (row, element, cell) in
            cell.mode = element
            }.disposed(by: dispose)
        
        searchResult.share().map({ applys  in
            applys.isEmpty
        }) .bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
        
        
        // table 刷新状态
        
        self.searchVM.onlineApplyStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { refreshStatus in
            switch refreshStatus{
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



extension OnlineApplySearchVC{
    open func resetCondition(){
        self.cityMenu.clearAll.sendActions(for: .touchUpInside)
        self.kind.clearSelected()
        self.requestBody.city = nil
        self.requestBody.industry = nil
        
    }
}




