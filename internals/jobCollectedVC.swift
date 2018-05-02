//
//  jobCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class jobCollectedVC: UITableViewController {

    
    
    // MARK: 收藏职位
    
    private lazy var jobManageRoot:JobManager = JobManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorColor = UIColor.black
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //jobTable = DBFactory.shared.getJobDB()
        // 获取服务器数据 根据收藏的jobs
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobManageRoot.getCollections(type: .compus).count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as! CommonJobTableCell
        let job = jobManageRoot.getCollections(type: .compus)[indexPath.row] as! CompuseRecruiteJobs
        
        cell.mode = job
        cell.useCellFrameCache(with: indexPath, tableView: tableView)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let job = jobManageRoot.getCollections(type: .compus)[indexPath.row] as! CompuseRecruiteJobs

        return  tableView.cellHeight(for: indexPath, model: job, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: ScreenW)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 编辑状态 返回
        if tableView.isEditing{
            return
        }
        let JobDetail =  JobDetailViewController()
        let job = jobManageRoot.getCollections(type: .compus)[indexPath.row] as! CompuseRecruiteJobs
       // JobDetail.infos = job.toJSON() as? [String:String]
        
        self.navigationController?.pushViewController(JobDetail, animated: true)
        
        
        
    }

}


