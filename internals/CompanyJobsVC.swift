//
//  companyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let headerViewH:CGFloat =  100
fileprivate let sections:Int = 2
fileprivate let sectionHeight:CGFloat = 10

class CompanyJobsVC: BaseViewController {

    private lazy var filterJobs:[CompuseRecruiteJobs]? = []

    var mode:CompanyJoblistModel?
    
    lazy var joblistTable:UITableView = {
        //let tb = UITableView.init(frame: CGRect.init(x: ScreenW, y: 0, width: ScreenW, height: ScreenH))
        let tb = UITableView.init(frame: CGRect.zero)
        
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .singleLine
        //tb.bounces = false
        tb.contentInsetAdjustmentBehavior = .never
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
        tb.register(companyJobCell.self, forCellReuseIdentifier: companyJobCell.identity())
        
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
        
        // Do any additional setup after loading the view.
    }
    
    
    override func setViews() {
        self.view.addSubview(joblistTable)
        _ = joblistTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.handleViews.append(joblistTable)
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
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
            
            Thread.sleep(forTimeInterval: 3)
            self?.mode = CompanyJoblistModel(JSON: ["jobtag":["全部","测试","研发"],"jobs":[
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["研发"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["测试"]],
                ]]
            )
            //print(self?.mode)
            
            DispatchQueue.main.async(execute: {
                
                if let  jobs =  self?.mode?.jobs{
                    self?.filterJobs?.append(contentsOf: jobs)
                }
                
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
                
                if let jobs  = mode?.jobs{
                    self.filterJobs?.append(contentsOf: jobs)
                }
            }else{
                // tag匹配的jobs
                if let json =  mode?.jobs?.filter({ (item) -> Bool in
                    
                    return item.tag.contains(name)
                }){
                    for item in json{
                        self.filterJobs?.append(item)
                    }
                }
                
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
        
        if section == 1{
            return filterJobs?.count ??  0
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
            cell.mode = mode?.jobtag ?? []
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: companyJobCell.identity(), for: indexPath) as! companyJobCell
            cell.mode = filterJobs?[indexPath.row]
            return cell
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
        return sectionHeight
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
       
        switch indexPath.section {
        case 0:
            if let mode =  mode?.jobtag{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobTagsCell.self, contentViewWidth: ScreenW)
            }
        case 1:
            
            if let mode = filterJobs?[indexPath.row]{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: companyJobCell.self, contentViewWidth: ScreenW)
            }
        default:
            break
        }
        
        return 0
        
    }
    
    
    
    //查看job
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1{
            if let info =  filterJobs?[indexPath.row]{
                let jobDetail: JobDetailViewController = JobDetailViewController()
                jobDetail.jobID = info.id!
                self.navigationController?.pushViewController(jobDetail, animated: true)
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
