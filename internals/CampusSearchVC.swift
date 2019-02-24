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

fileprivate let menuTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                       GlobalConfig.DropMenuTitle.subBusinessField,
                                       GlobalConfig.DropMenuTitle.companyType]
fileprivate let dropMenuH:CGFloat = 40
fileprivate let cityMenuHeight:CGFloat = GlobalConfig.ScreenH - 240
fileprivate let bussinessMenuHeight:CGFloat = GlobalConfig.ScreenH - 240
fileprivate let companyMenuHeight:CGFloat = GlobalConfig.ScreenH - 240

class CampusSearchVC: BaseViewController, SearchControllerDeletgate {

    
    private lazy var modes:[JobListModel] = []
    private lazy var filterModes:[JobListModel] = []
    private lazy var firstLoad:Bool = true
    
    private var condition:([String], String, String) = ([], "", ""){
        didSet{
            // 过滤条件
            //self.filterModes.removeAll()
            self.modes.forEach { m in
//                if m.address?.contains(condition.0) && m.businessField?.contains(condition.1) && m.companyType == condition.2{
//                    self.filterModes.append(m)
//                }
            }
            
            //self.searchVM.graduateRes.onNext(self.filterModes)
        }
    }
    
    
    private  lazy var cityMenu:DropItemCityView =  {
         let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: cityMenuHeight))
         city.passData = { citys in
            self.condition.0 = citys
            
        }
         city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
         return city
    }()
    
    
    private lazy var businessKind:DropCarrerClassifyView = {
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: bussinessMenuHeight))
        k.passData = {  industry in
            self.condition.1 = industry
        }
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return k
    }()
    
    private lazy var company:DropCompanyPropertyView = {
        let c = DropCompanyPropertyView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height:  companyMenuHeight))
        c.passData = { company in
           
            self.condition.2 = company
        }
        c.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return c
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        
        return configDropMenu(items: [cityMenu, businessKind, company], titles: menuTitles, height: dropMenuH)
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
    


    private let dispose = DisposeBag()
    private let searchVM = SearchViewModel()
    //private var searchResult:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 控制其他vc 先显示时， 该vc的hub不显示
        if self.firstLoad{
            super.setViews()
            self.firstLoad = !self.firstLoad
        }
    }
    
    override func setViews(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.view.backgroundColor = UIColor.white
        _ = table.sd_layout().topSpaceToView(dropMenu,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hub.isHidden = true
        self.hiddenViews.append(table)
        self.hiddenViews.append(dropMenu)
        //super.setViews()
    }
    
    

}

extension CampusSearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.filterModes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
}



extension CampusSearchVC{
    
    
    private func setViewModel(){
        
        
        self.searchVM.graduateRes.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, element, cell) in
            cell.mode = element
        }.disposed(by: dispose)
        
        
        self.searchVM.graduateRes.asDriver(onErrorJustReturn: []).drive(onNext: { (modes) in
            if self.modes.isEmpty{
                self.modes = modes
            }
            self.filterModes = modes
            self.dropMenu.isHidden = modes.isEmpty
            self.didFinishloadData()
            
            
        }).disposed(by: self.dispose)
        
        
    }
    
    
    private func showloading(){
        self.hub.isHidden = false
        self.hub.show(animated: true)
        self.hiddenViews.forEach { (view) in
            view.isHidden = true
        }
    }
    // 搜索数据
    open func searchData(word:String){
        
        
        // 界面内table 自身的刷新
        //self.searchVM.graduateRes.share().bind(to: searchResult).disposed(by: dispose)
        self.searchVM.searchGraduteJobs(word: word)
        self.showloading()
    }
    
    
    
}


extension CampusSearchVC{
    
    open func resetCondition(){
        self.cityMenu.clear()
        self.businessKind.clearSelected()
        self.company.clearSelected()
        self.modes = []
        
        
    }
}


