//
//  CareerTalkSearchVC.swift
//  internals
//
//  Created by ke.liang on 2018/9/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import YNDropDownMenu
import MJRefresh


fileprivate let dropMenuH:CGFloat = 40
fileprivate let dropMenuTitles:[String] = ["学校","行业领域","宣讲时间"]

class CareerTalkSearchVC: UIViewController, SearchControllerDeletgate{

    
    private lazy var colleageMenu: DropCollegeItemView = { [unowned self] in
        let college = DropCollegeItemView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        college.passData = { colleges in
            self.requestBody.college = colleges
            self.table.mj_header.beginRefreshing()
        }
        college.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
        
        return college
    }()
    
   
    private lazy var kind: DropItemIndustrySectorView = { [unowned self] in
        let k = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        
        k.passData = { industry in
            self.requestBody.industry = industry
            self.table.mj_header.beginRefreshing()
        }
        
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
        
        return k
        
    }()
    
    // MARK: 日期选择具体到某天??
    private lazy var meetingTimeMenu:DropValidTimeView = { [unowned self] in
        
        let m = DropValidTimeView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 90))
        m.passData = { date in
            self.requestBody.date = date
            self.table.mj_header.beginRefreshing()
        }
        m.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
        
        return m
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        
        let m =  configDropMenu(items: [colleageMenu, kind, meetingTimeMenu], titles: dropMenuTitles, height: dropMenuH)
        m.isHidden = false
        return m
    }()
    
    
    private lazy var table:UITableView = {
        let t = UITableView()
        t.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        t.tableFooterView = UIView()
        t.tableHeaderView = UIView()
        t.rx.setDelegate(self).disposed(by: dispose)
        t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return t
    }()
    
    
    // mj refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            self?.searchVM.careerTalkRefresh.onNext((true, (self?.requestBody)!))
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            
            self?.searchVM.careerTalkRefresh.onNext((false, (self?.requestBody)!))

        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    private var requestBody:searchCareerTalkBody = searchCareerTalkBody(JSON: [:])!
    
    //rxSwift
    let dispose = DisposeBag()
    let searchVM:searchViewModel = searchViewModel()
    let searchResult:BehaviorRelay<[CareerTalkMeetingModel]> = BehaviorRelay<[CareerTalkMeetingModel]>.init(value: [])
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setViewModel()
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = table.sd_layout().topSpaceToView(self.view,dropMenuH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
    }

}




extension CareerTalkSearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}


extension CareerTalkSearchVC{
    
    private func setView(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.view.backgroundColor = UIColor.white
    }
    
    open func searchData(word:String){
        requestBody.word = word
        
        // 选项切换的刷新
        searchVM.searchCareerTalkMeetins(mode: requestBody, offset: 0).catchError({ (error) -> Observable<[CareerTalkMeetingModel]> in
            showOnlyTextHub(message: "error \(error)", view: self.view)
            return Observable<[CareerTalkMeetingModel]>.just([])
            
        }).share().bind(to: searchResult).disposed(by: dispose)
        
        // 界面内table 自身的刷新
        self.searchVM.carrerTalkRes.share().bind(to: searchResult).disposed(by: dispose)
        
    }
    
    private func  setViewModel(){
        
        searchResult.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CareerTalkCell.identity(), cellType: CareerTalkCell.self)){ (row, element, cell) in
            cell.mode = element
            }.disposed(by: dispose)
        
        searchResult.share().map({ applys  in
            applys.isEmpty
        }) .bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
        
        
        // table 刷新状态
        
        self.searchVM.careerRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { refreshStatus in
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
                showOnlyTextHub(message: "online appy \(err)", view: self.view)
            default:
                break
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
    }
    
    
}


extension CareerTalkSearchVC{
    open func resetCondition(){
        self.colleageMenu.clearAll.sendActions(for: .touchUpInside)
        self.kind.clearSelected()
        self.meetingTimeMenu.clearSelected()
        
        self.requestBody.college = nil
        self.requestBody.date = nil
        self.requestBody.industry = nil
        
        
    }
}
