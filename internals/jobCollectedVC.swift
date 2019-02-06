//
//  jobCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper


fileprivate let notifiyName:String = "jobCollectedVC"


class jobCollectedVC: BaseViewController {


    
    private lazy var datas:[CompuseRecruiteJobs] = []
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: CGRect.zero)
        tb.dataSource = self
        tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(jobCollectedCell.self, forCellReuseIdentifier: jobCollectedCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NSNotification.Name.init(notifiyName), object: nil)
        
        
   
    }
    
    
    
    override func setViews() {
        
    
        self.view.addSubview(table)
        _ = table.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        self.hiddenViews.append(table)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}


extension jobCollectedVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: jobCollectedCell.identity(), for: indexPath) as! jobCollectedCell
        let job =  datas[indexPath.row]
        
        cell.mode = job
        cell.useCellFrameCache(with: indexPath, tableView: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let job = datas[indexPath.row]
        return  tableView.cellHeight(for: indexPath, model: job, keyPath: "mode", cellClass: jobCollectedCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            return
        }
        
        let mode = datas[indexPath.row]
        
        let JobDetail =  JobDetailViewController()
        JobDetail.uuid = mode.id!
        //JobDetail.kind = (id:  mode.id!, type: mode.kind!)
        self.navigationController?.pushViewController(JobDetail, animated: true)
        
        
    }
    

    
    
}


extension jobCollectedVC{
    @objc private func operation(_ sender: Notification){
        let info = sender.userInfo as? [String:String]
        if let action = info?["action"]{
            if action == "edit"{
                self.table.setEditing(true, animated: false)
            }else if action == "cancel"{
                self.table.setEditing(false, animated: false)
            }else if action == "selectAll"{
                for index in 0..<datas.count{
                    self.table.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .bottom)
                }
                
            }else if action == "unselect"{
                self.table.selectRow(at: nil, animated: false, scrollPosition: .top)
            }else if action == "delete"{
                if let selected = self.table.indexPathsForSelectedRows{
                    var deletedRows:[Int] = []
                    selected.forEach { indexPath in
                        deletedRows.append(indexPath.row)
                    }
                    // 扩展 批量删除元素
                    self.datas.remove(indexes: deletedRows)
                    // 服务器删除
                    self.table.reloadData()
                    
                }
            }
        }
        
    }
}

extension jobCollectedVC{
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 1)
            for _ in 0..<10{
                
                if let data = Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":true,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000]){
                    self?.datas.append(data)
                    
                }
                
            }
            
            for _ in 0..<10{
                 self?.datas.append(Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":true,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"hr":["userID":"dqwd","name":"我是hr","position":"HRBP","ontime": Date().timeIntervalSince1970 - TimeInterval(6514),"icon": #imageLiteral(resourceName: "jing").toBase64String()],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"graduate","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000])!)
            }
            
            
            
            DispatchQueue.main.async {
                
                self?.didFinishloadData()
            }
        }

    }
}






@objcMembers fileprivate class jobCollectedCell: UITableViewCell {
    
    
    private lazy var icon:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    
    private lazy var companyName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textAlignment = .left
        return name
    }()
    
    private lazy var position:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        name.font = UIFont.systemFont(ofSize: 14)
        name.textAlignment = .left
        return name
    }()
    
    
    private lazy var address:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 120)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.lightGray
        return name
    }()
    
    private lazy var jobtype:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(100)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.lightGray
        return name
    }()
    
    // 时间
    private lazy var times:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(100)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.blue
        return name
    }()
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
         
            guard  let mode = mode  else {
                return
            }
            self.icon.image = UIImage.init(named: mode.icon)
            self.companyName.text = mode.company?.name
            self.position.text = mode.name
            self.address.text = mode.addressStr
            self.jobtype.text = " | " + (mode.kind?.describe ?? "")
            self.times.text  = mode.creatTimeStr
            self.setupAutoHeight(withBottomViewsArray: [jobtype,address], bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, companyName, position, address, jobtype, times]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(45)?.heightIs(45)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = position.sd_layout().topSpaceToView(companyName,5)?.leftEqualToView(companyName)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(position)?.topSpaceToView(position,5)?.autoHeightRatio(0)
        _ = jobtype.sd_layout().leftSpaceToView(address,5)?.topEqualToView(address)?.autoHeightRatio(0)
        
        _ = times.sd_layout().topEqualToView(companyName)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        companyName.setMaxNumberOfLinesToShow(1)
        position.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "jobCollectedCell"
    }
    
    // MARK 区分cell 投递 和非
    
    
}

