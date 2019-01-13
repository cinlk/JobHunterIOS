//
//  SpecialJobVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper


class SpecialJobVC: BaseTableViewController {

    // 查询条件
    var queryName:String?{
        didSet{
            self.loadData()
            self.title = queryName!
        }
    }
    
    private var items:[CompuseRecruiteJobs] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 背景颜色
        self.navigationController?.insertCustomerView(UIColor.orange)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
    }
    
    
    override func setViews() {
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    override func showError() {
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as? CommonJobTableCell{
            let mode = items[indexPath.row]
            cell.mode = mode
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = items[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = items[indexPath.row]
        let detail = JobDetailViewController()
        detail.uuid = mode.id!
        //detail.kind = (id: mode.id!, type: mode.kind!)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
}


extension SpecialJobVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            // 更加名字查询jobs
            self?.items = [Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000])!]
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
                
            })
        }
        
    }
}
