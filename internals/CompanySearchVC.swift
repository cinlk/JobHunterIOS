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
fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                           GlobalConfig.DropMenuTitle.businessField]


fileprivate let dropMenuHeight:CGFloat = GlobalConfig.ScreenH - 240

class CompanySearchVC: BaseViewController, SearchControllerDeletgate {

    private lazy var modes:[CompanyListModel] = []
    private lazy var filterModes:[CompanyListModel] = []
    private lazy var firstLoad:Bool = true

    private  var condition:([String], String)  = ([],""){
        didSet{
            //
            print(condition)
        }
    }

    private lazy var cityMenu:DropItemCityView = { [unowned self] in
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW,
                                                            height: dropMenuHeight))
        city.passData = { citys in
            self.condition.0 = citys
        }
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        return city
    }()
    
    
    private lazy var kind:DropItemIndustrySectorView = { [unowned self] in
        let k = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW,
                                                               height: dropMenuHeight))
        k.passData = {  s in
            self.condition.1 = s
        }
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH)
        
        return k
    }()
    
    
    private lazy var dropMenu:YNDropDownMenu = { [unowned self] in
        let d = configDropMenu(items: [cityMenu, kind], titles: dropMenuTitles, height: dropMenuH)
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
    
    

    let dispose = DisposeBag()
    let searchVM:SearchViewModel = SearchViewModel()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
    }
    
    override func setViews() {
        
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.view.backgroundColor = UIColor.white
           _ = table.sd_layout().topSpaceToView(self.view,dropMenuH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hub.isHidden = true
        self.hiddenViews.append(table)
        self.hiddenViews.append(dropMenu)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstLoad{
            super.setViews()
            self.firstLoad = !self.firstLoad
        }
    }
    
    
    
}



extension CompanySearchVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.filterModes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanyItemCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
}



extension CompanySearchVC{
    
    private func showloading(){
        self.hub.isHidden = false
        self.hub.show(animated: true)
        self.hiddenViews.forEach { (view) in
            view.isHidden = true
        }
    }
    
    
    
    open func searchData(word:String){
        
        
        searchVM.searchCompany(word: word)
        self.showloading()
    }
    
    private func setViewModel(){
        
        
        self.searchVM.companyRes.share().observeOn(MainScheduler.instance).bind(to:
        self.table.rx.items(cellIdentifier: CompanyItemCell.identity(), cellType: CompanyItemCell.self)){ (row, element, cell) in
            cell.mode = element
        }.disposed(by: dispose)
        
        self.searchVM.companyRes.asDriver(onErrorJustReturn: []).drive(onNext: { (modes) in
            if self.modes.isEmpty{
                self.modes = modes
            }
            self.filterModes = modes
            self.dropMenu.isHidden = modes.isEmpty
            self.didFinishloadData()
            
        }).disposed(by: self.dispose)
 
    
        
    }
}


extension CompanySearchVC{
    
    open func resetCondition(){
        
        self.cityMenu.clear()
        self.kind.clearSelected()
        self.modes  = []
        
    }
}
