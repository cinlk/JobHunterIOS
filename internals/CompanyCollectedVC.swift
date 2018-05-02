//
//  CompanyCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class CompanyCollectedVC: UITableViewController {

    
    // 收藏的公司数据
    private lazy var jobManageRoot:JobManager = JobManager.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorColor = UIColor.black
        self.tableView.separatorStyle = .singleLine
        // 编辑状态下多选
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.register(collectedCompanyCell.self, forCellReuseIdentifier: collectedCompanyCell.identity())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        return jobManageRoot.getCollections(type: .company).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: collectedCompanyCell.identity(), for: indexPath) as! collectedCompanyCell
        let item = jobManageRoot.getCollections(type: .company)[indexPath.row] as! CompanyModel
        cell.mode = item
        return cell
        
    }
    
    // 设置cell样式
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = jobManageRoot.getCollections(type: .company)[indexPath.row] as! CompanyModel
      
        return tableView.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: collectedCompanyCell.self, contentViewWidth: ScreenW)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            return
        }
        let item = jobManageRoot.getCollections(type: .company)[indexPath.row] as! CompanyModel
        // MARK TODO company数据给界面展示
        let vc = CompanyMainVC()
        vc.companyID =  item.id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

   
}




