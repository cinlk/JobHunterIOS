//
//  SpecialJobVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class SpecialJobVC: BaseTableViewController {

    
    
    var queryName:String?{
        didSet{
            self.loadData()
            self.navigationItem.title = queryName!
        }
    }
    
    private var items:[CompuseRecruiteJobs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
    }
    
    
    override func setViews() {
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        
        self.handleViews.append(tableView)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: jobdetailCell.identity(), for: indexPath) as? jobdetailCell{
            let mode = items[indexPath.row]
            cell.mode = mode
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = items[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: jobdetailCell.self, contentViewWidth: ScreenW)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // MARK
    }
    
}


extension SpecialJobVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            // 更加名字查询jobs
            self?.items = [CompuseRecruiteJobs(JSON: ["id":"dqw-dqwd","type":"校招","picture":"car","company":"大秦网"
                ,"jobName":"隔热计数","address":"上海","salary":"10-15K","create_time":"2018-03-23","education":"本科","tag":["好","不好"]])!, CompuseRecruiteJobs(JSON: ["id":"dqw-dqwd","type":"校招","picture":"car","company":"大秦网"
                    ,"jobName":"隔热计数","address":"上海","salary":"10-15K","create_time":"2018-03-23","education":"本科","tag":["好","不好"]])!]
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
                
            })
        }
        
    }
}
