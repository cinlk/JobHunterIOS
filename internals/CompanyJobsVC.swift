//
//  companyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

// 与companyMainVC 一致
fileprivate let headerViewH:CGFloat =  CompanyMainVC.headerViewH
fileprivate let sections:Int = 2
fileprivate let apply:String = "网申"

class CompanyJobsVC: BaseViewController {

    
    // 职位
    internal var companyMode: CompanyModel?
    
    private var jobs:[CompuseRecruiteJobs] = []
    private var onlineApplyJobs:[OnlineApplyModel] = []
    
    // 展示所有职位
    private lazy var filterJobs:[Any]? = []

    private lazy var tags:[String] = ["全部"]

    
    

    
    lazy var joblistTable:UITableView = {
        
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .singleLine
        //tb.bounces = false
        tb.contentInsetAdjustmentBehavior = .never
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
        tb.register(companySimpleJobCell.self, forCellReuseIdentifier: companySimpleJobCell.identity())
        // 网申
        tb.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        // 宣讲会
        //tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        
        return tb
    }()
    
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        //监听job 的tag 变化 刷新第二个table
        NotificationCenter.default.addObserver(self, selector: #selector(filterJoblist(notify:)), name: NSNotification.Name.init("whichTag"), object: nil)
        
    }
    
    
    override func setViews() {
        self.view.addSubview(joblistTable)
        _ = joblistTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.handleViews.append(joblistTable)
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        if self.onlineApplyJobs.count > 0{
            self.tags.append(apply)
        }
        
        
        self.jobs.forEach {
            $0.jobtags.forEach({ (item) in
                if !self.tags.contains(item){
                    self.tags.append(item)
                }
            })
        }
        
        
        self.joblistTable.reloadData()
    }
    
    override func showError() {
        super.showError()
        
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }

}

extension CompanyJobsVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            // job tag TEST
            let testtags = ["研发","实习","测试","销售","运维","CXO"]
            
        
            
            Thread.sleep(forTimeInterval: 1)
          
            
            for i in 0..<12{
                let type:jobType = i%2 == 0 ? .intern : .graduate
                if let data = CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","jobtags":[testtags[i%testtags.count], testtags[(i+1)%testtags.count]],"company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":type.rawValue,"isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000]){
                    
                   
                    self?.jobs.append(data)
                }
            }
            // 站内数据
            for _ in 0..<5{
                if let data = OnlineApplyModel(JSON: ["id":"sdqwd","isValidate":true,"isCollected":false,
                                                      "name":"某某莫小元招聘网申","create_time":Date().timeIntervalSince1970 - TimeInterval(54364),"end_time":Date().timeIntervalSince1970 + TimeInterval(54631),"outer":false,"address":["地点1","地点2"]]){
                    self?.onlineApplyJobs.append(data)
                }
            }
            
            // 站外数据
            for _ in 0..<5{
                if let data = OnlineApplyModel(JSON: ["id":"sdqwd","isValidate":true,"isCollected":false,
                                                      "name":"某某莫小元招聘网申","create_time":Date().timeIntervalSince1970 - TimeInterval(54364),"end_time":Date().timeIntervalSince1970 + TimeInterval(54631),"outer":true,"link":"https://www.xiaoyuanzhao.com/company/xri_y3y4pkvjtj3b?act=zw#1","address":["地点1","地点2"]]) {
                    self?.onlineApplyJobs.append(data)
                }
            }
            
             
            
            
            
            DispatchQueue.main.async(execute: {
                
                self?.filterJobs?.append(contentsOf: self?.jobs ?? [])
                self?.filterJobs?.append(contentsOf: self?.onlineApplyJobs ?? [])
                //self?.filterJobs?.append(contentsOf: self?.meeting ?? [])
 
                self?.didFinishloadData()
            })
            
        }
    }
}

extension CompanyJobsVC{
    
    @objc func filterJoblist(notify: Notification){
        // tag 名字
        if let name = notify.object as? String {
            self.filterJobs?.removeAll()
            if name  == "全部"{
                
                self.filterJobs?.append(contentsOf: self.jobs )
                self.filterJobs?.append(contentsOf: self.onlineApplyJobs )
                
            }else if name == "网申"{
                self.filterJobs?.append(contentsOf: self.onlineApplyJobs)
            }else{
                let targetJobs = jobs.filter { (item) -> Bool in
                    return item.jobtags.contains(name)
                }
                self.filterJobs?.append(contentsOf: targetJobs)

                
            }
            self.joblistTable.reloadSections([1], animationStyle: .none)
            
        }
        
    }
}

extension CompanyJobsVC:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sections
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section ==  0 ?  1 :  filterJobs?.count  ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section{
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
            cell.mode = tags
            return cell
        case 1:
            if let mode = filterJobs?[indexPath.row] as? CompuseRecruiteJobs{
                let cell = tableView.dequeueReusableCell(withIdentifier: companySimpleJobCell.identity(), for: indexPath) as! companySimpleJobCell
                cell.mode = mode
                
                return cell
                
            }else if let mode = filterJobs?[indexPath.row] as? OnlineApplyModel{
                let cell = tableView.dequeueReusableCell(withIdentifier: OnlineApplyCell.identity(), for: indexPath) as!  OnlineApplyCell
                mode.isSimple = true 
                cell.mode = mode
                
                //cell.type.isHidden = false
                return cell
            }
           
        default:
            break
        }
        
        
        return UITableViewCell.init()
        
        
    }
    
    // section 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
       
        switch indexPath.section {
        case 0:
            return tableView.cellHeight(for: indexPath, model: tags, keyPath: "mode", cellClass: JobTagsCell.self, contentViewWidth: ScreenW)
            
        case 1:
            return 55
        default:
            break
        }
        
        return 0
        
    }
    
    
    
    //查看job
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 1{
            
            if let mode =  filterJobs?[indexPath.row] as? CompuseRecruiteJobs{
                
                let job: JobDetailViewController = JobDetailViewController()
                
                job.kind = (id: mode.id!, type: mode.kind!)
                
                job.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(job, animated: true)
            }
            else if let mode = filterJobs?[indexPath.row] as? OnlineApplyModel{
                if mode.outer == true && mode.link != nil{
                    
                    //跳转外部连接
                    let wbView = baseWebViewController()
                    wbView.mode = mode.link
                    wbView.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(wbView, animated: true)
                }else{
                    // 内部网申数据 
                    let show = OnlineApplyShowViewController()
                    // 传递id
                    show.onlineApplyID = mode.id
                    show.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(show, animated: true)
                }
                
                
            }
        }
        
    }
    
    
}


extension CompanyJobsVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0{
            delegate?.scrollUp(view: self.joblistTable, height: offsetY)
        }else{
            delegate?.scrollUp(view: self.joblistTable, height: 0)
        }
    }
    
    
}
