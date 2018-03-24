//
//  deliveryCategoryView.swift
//  internals
//
//  Created by ke.liang on 2018/1/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




class deliveryCategoryView: UITableViewController {

    
    fileprivate var ResultDataSet:DeliveredJobsResults?
    
    
    init(style: UITableViewStyle, datas:DeliveredJobsResults) {
        
        super.init(style: style)
        self.ResultDataSet = datas
       
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.register(deliveryItemCell.self, forCellReuseIdentifier: deliveryItemCell.identity())
        self.tableView.tableFooterView = UIView.init()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard  let results = ResultDataSet else {
            return 0
        }
        return results.jobs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard  let mode = ResultDataSet?.jobs?[indexPath.row] else {
            return 0
        }
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: deliveryItemCell.self, contentViewWidth: ScreenW)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let results = ResultDataSet else {
            return UITableViewCell.init()
        }
        
        guard let item = results.jobs?[indexPath.row] else {
            return UITableViewCell.init()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: deliveryItemCell.identity(), for: indexPath)  as? deliveryItemCell{
            cell.mode  = item
            return cell
        }
        return UITableViewCell.init()
    
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! deliveryItemCell
        tableView.deselectRow(at: indexPath, animated: false)
        if let jobInfo = ResultDataSet?.jobs?[indexPath.row] {
            
            let status = jobstatusView()
            status.mode = jobInfo
            self.navigationController?.pushViewController(status, animated: true)
            
            
        }
        
        
        
    }

   

  

}
