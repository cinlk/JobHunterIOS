//
//  deliveredHistory.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu


fileprivate let titleName = "投递记录"
fileprivate let dropViewH:CGFloat = 40

class deliveredHistory: BaseViewController,UIScrollViewDelegate {

    
    // 所有数据
    private var datas:[DeliveredJobsModel] = []{
        didSet{
            filterDatas = datas
        }
    }
    
    // 条件筛选数据 (MARK)
    private var filterDatas:[DeliveredJobsModel] = []
    
    // 过滤条件
    private var currentJobType:jobType = .all
    private var currentDelivery:ResumeDeliveryStatus = .all
    
    // dropItem
    private lazy var jobTypes:DropJobTypeView = { [unowned self] in
        let view = DropJobTypeView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 45*4))
        view.showTabBar = false
        view.passData = { type in
            self.currentJobType = jobType.getType(name: type)
            self.filterJobType()
            self.dropMenu.changeMenu(title: type, at: 0)

        }
        
        
        return view
    }()
    
    
    private lazy var deliveryStatus:DropDelieveryStatusView = { [unowned self] in
        let view = DropDelieveryStatusView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 45*7))
        view.showTabBar = false
        
        view.passData = { status in
            self.currentDelivery = ResumeDeliveryStatus.getType(name: status)
            self.filterJobType()
            self.dropMenu.changeMenu(title: status, at: 1)
        }
        return view
    }()
    
    
    
    // dropMenu
    private lazy var dropMenu:YNDropDownMenu = { [unowned self] in
       
        let dropView =  configDropMenu(items: [jobTypes,deliveryStatus], titles: ["职位类型","投递状态"], height: dropViewH)
        dropView.origin.y  = 64
        dropView.isHidden = false
        return dropView
    }()
    
    // table
    
    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView(frame: CGRect.init(x: 0, y: NavH + self.dropMenu.height , width: ScreenW, height: ScreenH - (NavH + self.dropMenu.height)))
        table.tableFooterView = UIView()
        table.register(deliveryItemCell.self, forCellReuseIdentifier: deliveryItemCell.identity())
        table.tableHeaderView = UIView()
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.viewBackColor()
        
        return table
    }()

    
    override func viewDidLoad() {
        //self.oldSetViews()
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // ??? 不然多出view 
 
        
    }
   
    
    override func setViews() {
        
        
        self.title = titleName
        self.view.backgroundColor = UIColor.viewBackColor()

        self.handleViews.append(table)
        self.handleViews.append(dropMenu)
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        
        self.navigationController?.delegate = self
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
    }
    

}


extension deliveredHistory: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: PersonViewController.self){
            self.navigationController?.removeCustomerView()
            
            
        }
        
    }
}

extension deliveredHistory{
    
    private func filterJobType(){
        
        print("职位类型\(currentJobType) 投递类型\(currentDelivery)")
        
        if currentJobType == .all && currentDelivery == .all{
            filterDatas = datas
        }else if currentJobType == .all && currentDelivery != .all{
            filterDatas = datas.filter({ mode -> Bool in
                return mode.deliveryStatus == currentDelivery
            })
        }else if currentDelivery == .all && currentJobType != .all{
            filterDatas = datas.filter({ mode -> Bool in
                return  mode.jobtype == currentJobType
            })
        }else{
            
            filterDatas  = datas.filter({ mode -> Bool in
                return mode.jobtype == currentJobType && mode.deliveryStatus == currentDelivery
            })
        }
        
       
        self.table.reloadData()
        if  filterDatas.count > 0{
            self.table.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
        
    }

}

// load data
extension deliveredHistory{
    
    private func loadData(){
        
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            
            
            for _ in 0..<5{
                self?.datas.append(DeliveredJobsModel(JSON: ["id":"dqw-dqwd","type":jobType.intern.rawValue,
                "icon":"chrome","title":"测试实习","companyName":"google","address":["北京","天津"],
                "create_time":Date().timeIntervalSince1970,"currentStatus":ResumeDeliveryStatus.read.rawValue,"feedBack":"当前为多群无多群无多当前为多群无多当前为多群无多群无当前为多群多群当前的群",
                "historyStatus":[(status:"面试",time:"2017-03-23"),(status:"HR已阅",time:"2017-03-20"),(status:"投递成功",time:"2017-03-19 ")]])!)
                
                
            }
            
            for _ in 0..<5{
                self?.datas.append(DeliveredJobsModel(JSON: ["id":"dqw-dqwd","type":jobType.graduate.rawValue,
                    "icon":"chrome","title":"前端nodejs工程师","companyName":"google",
                    "create_time":Date().timeIntervalSince1970,"currentStatus":ResumeDeliveryStatus.read.rawValue,"address":["北京","天津"],
                    "historyStatus":[(status:"面试",time:"2017-03-23"),(status:"HR已阅",time:"2017-03-20 "),(status:"投递成功",time:"2017-03-19")]])!)
                
                
            }
            
            for _ in 0..<4{
                self?.datas.append(DeliveredJobsModel(JSON: ["id":"dqw-dqwd","type":jobType.onlineApply.rawValue,
                    "icon":"chrome","title":"职位名称","companyName":"公司2018校招","create_time":Date().timeIntervalSince1970,"currentStatus":ResumeDeliveryStatus.interview.rawValue,"address":["北京","成都","天津"],"business":["建筑","管理","设计","培训","投资"],"historyStatus":[(status:"面试",time:"2017-03-23"),(status:"投递成功",time:"2017-03-19")]])!)
            }
            
            Thread.sleep(forTimeInterval: 3)
            
            DispatchQueue.main.async(execute: {
                
                self?.didFinishloadData()
            })
        }
        
      

    }
}



extension deliveredHistory:UITableViewDataSource, UITableViewDelegate{
    
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
        let height =  table.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: deliveryItemCell.self, contentViewWidth: ScreenW)
        
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

