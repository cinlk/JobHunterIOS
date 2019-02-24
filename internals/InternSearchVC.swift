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
fileprivate let dropMenuTitles = [GlobalConfig.DropMenuTitle.city,
                                  GlobalConfig.DropMenuTitle.subBusinessField,
                                  GlobalConfig.DropMenuTitle.interCondition]

fileprivate let dropDownHeight:CGFloat = GlobalConfig.ScreenH - 240

class InternSearchVC: BaseViewController, SearchControllerDeletgate {
    
    
    private lazy var modes:[JobListModel] = []
    private lazy var filterModes:[JobListModel] = []
    private lazy var firstLoad:Bool = true
    
    private var condition:([String], String, [String:String]) = ([],"",[:]){
        didSet{
            
            // 根据条件过滤 显示内容 TODO
        }
    }
    
    private lazy var cityMenu:DropItemCityView = { [unowned self] in
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropDownHeight))
        city.passData = { citys in
//            self.requestBody.city = citys
//            self.table.mj_header.beginRefreshing()
            self.condition.0 = citys
        }
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return city
    }()
    
    
    private lazy var kindMenu:DropCarrerClassifyView = { [unowned self] in
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropDownHeight))
        k.passData = { industry in
//            self.requestBody.industry = industry
//            self.table.mj_header.beginRefreshing()
            self.condition.1 = industry
//
        }
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return k
        
    }()
    
    
    private lazy var internMenu:DropInternCondtionView = { [unowned self] in
        let i = DropInternCondtionView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropDownHeight))
        i.passData = {  condition in
//            self.requestBody.interns = condition
//            self.table.mj_header.beginRefreshing()
            
            self.condition.2 = condition ?? [:]
        }
        
        i.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
        return i
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        
        let d =  configDropMenu(items: [cityMenu, kindMenu, internMenu], titles: dropMenuTitles, height: dropMenuH)
        //d.isHidden = false
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
    
    
    
    //private var requestBody:searchInternJobsBody  = searchInternJobsBody(JSON: [:])!

    
    
    //rxSwift
    let dispose = DisposeBag()
    let searchVM:SearchViewModel = SearchViewModel()
    //let searchResult:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.setViewModel()
      
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
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view, dropMenuH)?.bottomEqualToView(self.view)
        self.view.backgroundColor = UIColor.white
        self.hub.isHidden = true
        self.hiddenViews.append(table)
        self.hiddenViews.append(dropMenu)
        //super.setViews()
    }
    
}


extension InternSearchVC{
   
    private func showloading(){
        self.hub.isHidden = false
        self.hub.show(animated: true)
        self.hiddenViews.forEach { (view) in
            view.isHidden = true
        }
    }
    
    
    open func searchData(word:String){
        
        
        searchVM.searchInternJobs(word: word)
        self.showloading()
    }
    
    private func setViewModel(){
        
        self.searchVM.internRes.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, element, cell) in
            cell.mode = element
            }.disposed(by: dispose)
        
        
        self.searchVM.internRes.asDriver(onErrorJustReturn: []).drive(onNext: { (modes) in
            if self.modes.isEmpty{
                self.modes = modes
            }
            self.filterModes = modes
            self.dropMenu.isHidden = modes.isEmpty
            self.didFinishloadData()
            
        }).disposed(by: self.dispose)
        
//        searchResult.share().map { jobs in
//            jobs.isEmpty
//        }.bind(to: self.dropMenu.rx.isHidden).disposed(by: dispose)
//
        
        
    
       
    
    }
}



extension InternSearchVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.filterModes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
    
}


extension InternSearchVC{
    open func resetCondition(){
        self.cityMenu.clear()
        self.kindMenu.clearSelected()
        self.internMenu.clear()
        self.modes = []
        
    }

}
