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
fileprivate let cityMenuHeight:CGFloat = GlobalConfig.ScreenH - 240

fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                           GlobalConfig.DropMenuTitle.businessField]
fileprivate let pass = ["不限", "全国"]

class OnlineApplySearchVC: BaseViewController, SearchControllerDeletgate {

    // 初始值
    private lazy var modes:[OnlineApplyListModel] = []
    // 显示的值
    private lazy var filterModes:[OnlineApplyListModel] = []
    private lazy var firstLoad:Bool = true
    
    //private lazy var filterFlag:Bool = false
    private  var condition:([String], String) = ([],""){
        didSet{
            
            self.filterModes.removeAll()
            self.modes.forEach { (mode) in
                if (mode.businessField?.contains(condition.1) ?? false) || pass.contains(condition.1){
                    if condition.0.contains(pass[1]){
                        self.filterModes.append(mode)
                        return
                    }
                    condition.0.forEach({ (c) in
                        if mode.citys?.contains(c) ?? false{
                            self.filterModes.append(mode)
                        }
                    })
                }
            }
            
            
            
            self.searchVM.onlineApplyRes.onNext(self.filterModes)
        }
    }
    
    private lazy var cityMenu:DropItemCityView = { [unowned self] in
        let c = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: cityMenuHeight))
        c.passData  = { cities in
            //self.filterFlag = true
            // 多个条件过滤 TODO
            self.condition.0 = cities
            
        }
        
        c.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return c
    }()
    
    
    private lazy var kind:DropItemIndustrySectorView = { [unowned self] in
        let v = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
      
        v.passData = { item in
            self.condition.1 = item
        }
        
        v.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return v
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = {
        let menu = configDropMenu(items: [cityMenu, kind], titles: dropMenuTitles, height: dropViewH)
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
    
   
    // rxSwift
    private let dispose = DisposeBag()
    private let searchVM = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
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
        
        
    }
    
    

}

extension OnlineApplySearchVC: UITableViewDelegate{
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode =  self.filterModes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: OnlineApplyCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        //return 60
    }
    
}

extension OnlineApplySearchVC{
    
   
    private func showloading(){
        self.hub.isHidden = false
        self.hub.show(animated: true)
        self.hiddenViews.forEach { (view) in
            view.isHidden = true
        }
    }
    
    // 搜索数据
    open func searchData(word:String){
        
        // requestBody.word = word
        
        // 选项切换的刷新
        searchVM.searchOnlineAppy(word: word)
        self.showloading()
        
        // 界面内table 自身的刷新
        //self.searchVM.onlineApplyRes.share().bind(to: searchResult).disposed(by: dispose)
        
    }
    
    private func setViewModel(){
        
        
        self.searchVM.onlineApplyRes.share().observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: OnlineApplyCell.identity(), cellType: OnlineApplyCell.self)){ (row, element, cell) in
            cell.mode = element
            }.disposed(by: dispose)
        
        
        self.searchVM.onlineApplyRes.asDriver(onErrorJustReturn: []).drive(onNext: { modes in
            // 搜索初始值
            if self.modes.isEmpty{
                self.modes = modes
            }
            //self.modes = modes
            self.filterModes = modes
            self.dropMenu.isHidden = modes.isEmpty
            self.didFinishloadData()
            
        }).disposed(by: self.dispose)
    }
    
}



extension OnlineApplySearchVC{
    open func resetCondition(){
        self.cityMenu.clear()
        self.kind.clearSelected()
        self.modes = []
     }
    
   
}




