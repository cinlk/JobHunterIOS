//
//  jobCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class jobCollectedVC: UITableViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorColor = UIColor.black
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
   
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
        let cell = tableView.dequeueReusableCell(withIdentifier: jobdetailCell.identity(), for: indexPath) as! jobdetailCell
        let job = jobManageRoot.getCollections(type: .compus)[indexPath.row] as! CompuseRecruiteJobs
        
        cell.createCells(items: job.toJSON())
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  jobdetailCell.cellHeight()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing{
            return
        }
        let JobDetail =  JobDetailViewController()
        let job = jobManageRoot.getCollections(type: .compus)[indexPath.row] as! CompuseRecruiteJobs
        JobDetail.infos = job.toJSON() as? [String:String]
        
        self.navigationController?.pushViewController(JobDetail, animated: true)
        
        
        
    }

}


