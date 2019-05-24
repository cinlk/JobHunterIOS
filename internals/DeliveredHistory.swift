//
//  deliveredHistory.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YNDropDownMenu


fileprivate let titleName = "投递记录"
fileprivate let dropTitles = ["职位类型","投递状态"]

class DeliveredHistory: BaseViewController,UIScrollViewDelegate {

    private lazy var dispose = DisposeBag.init()
    private lazy var vm: PersonViewModel = PersonViewModel.shared
    
    // 所有数据
    private var datas:[DeliveryJobsModel] = []{
        didSet{
            filterDatas = datas
            self.didFinishloadData()
        }
    }
    
    // 条件筛选数据 (MARK)
    private var filterDatas:[DeliveryJobsModel] = []
    
    // 过滤条件
    private var currentJobType:jobType = .all
    private var currentDelivery:ResumeDeliveryStatus = .all
    
    // dropItem
    private lazy var jobTypes:DropJobTypeView = { [unowned self] in
        let view = DropJobTypeView(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 45*4))
        view.showTabBar = false
        view.passData = { [weak self] type in
            self?.currentJobType = jobType.getType(name: type)
            self?.filterJobType()
            self?.dropMenu.changeMenu(title: type, at: 0)

        }
        return view
    }()
    
    
    private lazy var deliveryStatus:DropDelieveryStatusView = { [unowned self] in
        let view = DropDelieveryStatusView(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 45*7))
        view.showTabBar = false
        
        view.passData = { [weak self] status in
            self?.currentDelivery = ResumeDeliveryStatus.getType(name: status)
            self?.filterJobType()
            self?.dropMenu.changeMenu(title: status, at: 1)
        }
        return view
    }()
    
    
    
    // dropMenu
    private lazy var dropMenu:YNDropDownMenu = { [unowned self] in
       
        let dropView =  configDropMenu(items: [jobTypes, deliveryStatus], titles: dropTitles, height: GlobalConfig.dropMenuViewHeight)
        dropView.origin.y  = 64
        dropView.isHidden = false
        return dropView
    }()
    
    // table
    
    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + self.dropMenu.height , width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - (GlobalConfig.NavH + self.dropMenu.height)))
        table.tableFooterView = UIView()
        table.register(deliveryItemCell.self, forCellReuseIdentifier: deliveryItemCell.identity())
        table.tableHeaderView = UIView()
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.viewBackColor()
        
        return table
    }()

    
    override func viewDidLoad() {
        //self.oldSetViews()
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        NotificationCenter.default.rx.notification(NotificationName.deliveryHistoryItem, object: nil).subscribe(onNext: { [weak self] (notify) in
            if let userinfo = notify.userInfo as? [String: DeliveryJobsModel], let item = userinfo["item"]{
                self?.datas.insert(item, at: 0)
                // 刷新 ui？
                
                
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView(UIColor.orange)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // ??? 不然多出view 
 
        
    }
   
    
    override func setViews() {
        
        
        self.title = titleName
        //self.view.backgroundColor = UIColor.viewBackColor()

        self.hiddenViews.append(table)
        self.hiddenViews.append(dropMenu)
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        
        //self.navigationController?.delegate = self
        super.setViews()
    }
    
    override func didFinishloadData() {
        
        super.didFinishloadData()
        // 只有获取数据后 才能设置view
        self.table.reloadData()
        
        
    }
    
    
    override func reload() {
        super.reload()
        self.loadData()
        
        // 监听新的投递记录 TODO
        
        
    }
    
    
    deinit {
        print("deinit deliverHistory \(self)")
    }

}


//extension DeliveredHistory: UINavigationControllerDelegate{
//
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if viewController.isKind(of: PersonViewController.self){
//            self.navigationController?.removeCustomerView()
//
//
//        }
//
//    }
//}

extension DeliveredHistory{
    
    private func filterJobType(){
        
        //print("职位类型\(currentJobType) 投递类型\(currentDelivery)")
        
        if currentJobType == .all && currentDelivery == .all{
            filterDatas = datas
        }else if currentJobType == .all && currentDelivery != .all{
            filterDatas = datas.filter({ mode -> Bool in
                return mode.resumeStatue == currentDelivery
            })
        }else if currentDelivery == .all && currentJobType != .all{
            filterDatas = datas.filter({ mode -> Bool in
                return  mode.jtype == currentJobType
            })
        }else{
            filterDatas  = datas.filter({ mode -> Bool in
                return mode.jtype == currentJobType && mode.resumeStatue == currentDelivery
            })
        }
        
       
        self.table.reloadData()
        if  filterDatas.count > 0{
            self.table.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
        
    }

}

// load data
extension DeliveredHistory{
    
    private func loadData(){
        
        self.vm.deliveryHistoryJobs().asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.datas = modes
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
}



extension DeliveredHistory:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filterDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filterDatas[indexPath.row]
        if let cell = table.dequeueReusableCell(withIdentifier: deliveryItemCell.identity(), for: indexPath) as? deliveryItemCell{
            
            cell.mode = item
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = filterDatas[indexPath.row]
        let height =  table.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: deliveryItemCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        return height + 10
        
    }
    
    
    // 查看详细记录
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = filterDatas[indexPath.row]
        let detail = DetailDeliveryStatus()
        detail.mode = item
        
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    
    
}

