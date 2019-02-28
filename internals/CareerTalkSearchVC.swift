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


fileprivate let dropMenuH:CGFloat = GlobalConfig.dropMenuViewHeight
fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.college,
                                           GlobalConfig.DropMenuTitle.businessField,
                                           GlobalConfig.DropMenuTitle.meetingTime]

fileprivate let dropMenuHeight:CGFloat = GlobalConfig.ScreenH - 240
fileprivate let meetingDateHeight:CGFloat = 120

class CareerTalkSearchVC: BaseViewController, SearchControllerDeletgate{

    private lazy var modes:[CareerTalkMeetingListModel] = []
    private lazy var filterModes:[CareerTalkMeetingListModel] = []
    private lazy var firstLoad:Bool = true
    
    private var condition:([String:[String]], String, String) = ([:], "", ""){
        didSet{
            // 根据条件过滤结果
            print(self.condition)
        }
    }
    
    
    private lazy var colleageMenu: DropCollegeItemView = { [unowned self] in
        let college = DropCollegeItemView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
        college.passData = { colleges in
//            self.requestBody.college = colleges
//            self.table.mj_header.beginRefreshing()
            self.condition.0 = colleges
        
        }
        college.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
        return college
    }()
    
   
    private lazy var kind: DropItemIndustrySectorView = { [unowned self] in
        let k = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
        
        k.passData = { industry in
//            self.requestBody.industry = industry
//            self.table.mj_header.beginRefreshing()
            self.condition.1 = industry
        }
        
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
        return k
        
    }()
    
    // MARK: 日期选择具体到某天??
    private lazy var meetingTimeMenu:DropValidTimeView = { [unowned self] in
        
        let m = DropValidTimeView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: DropValidTimeView.myHeigh()))
        m.passData = { date in

            self.condition.2 = date
        }
        m.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
        return m
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        
        let m =  configDropMenu(items: [colleageMenu, kind, meetingTimeMenu], titles: dropMenuTitles, height: dropMenuH)
        //m.isHidden = false
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
    
    

    
    
   // private var requestBody:searchCareerTalkBody = searchCareerTalkBody(JSON: [:])!
    
    //rxSwift
    let dispose = DisposeBag()
    let searchVM:SearchViewModel = SearchViewModel()
    //let searchResult:BehaviorRelay<[CareerTalkMeetingModel]> = BehaviorRelay<[CareerTalkMeetingModel]>.init(value: [])
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstLoad{
            super.setViews()
            self.firstLoad = !self.firstLoad
        }
    }
    
    
    override func setViews() {
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        _ = self.table.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view, dropMenuH)?.bottomEqualToView(self.view)
        self.view.backgroundColor = UIColor.white
        self.hub.isHidden = true
        self.hiddenViews.append(table)
        self.hiddenViews.append(dropMenu)
        
        
    }

}




extension CareerTalkSearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.filterModes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
}


extension CareerTalkSearchVC{
    

    private func showloading(){
        self.hub.isHidden = false
        self.hub.show(animated: true)
        self.hiddenViews.forEach { (view) in
            view.isHidden = true
        }
    }
    
    
    open func searchData(word:String){
        //requestBody.word = word
        
        // 选项切换的刷新
        searchVM.searchCareerTalkMeetins(word: word)
        self.showloading()
        // 界面内table 自身的刷新
        //self.searchVM.carrerTalkRes.share().bind(to: searchResult).disposed(by: dispose)
        
    }
    
    private func  setViewModel(){
        
        
        self.searchVM.carrerTalkRes.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CareerTalkCell.identity(), cellType: CareerTalkCell.self)){ (row, element, cell) in
            cell.mode = element
            }.disposed(by: dispose)
        
//        searchResult.share().map({ applys  in
//            applys.isEmpty
//        }) .bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
//
        
        // table 刷新状态
        self.searchVM.carrerTalkRes.asDriver(onErrorJustReturn: []).drive(onNext: { (modes) in
            if self.modes.isEmpty{
                self.modes = modes
            }
            self.filterModes = modes
            self.dropMenu.isHidden = modes.isEmpty
            self.didFinishloadData()
            
        }).disposed(by: self.dispose)
        
    }
    
    
}


extension CareerTalkSearchVC{
    open func resetCondition(){
        self.colleageMenu.reset()
        self.kind.clearSelected()
        self.meetingTimeMenu.clearSelected()
        self.modes = []
        
        
    }
}
