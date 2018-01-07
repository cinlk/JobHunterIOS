//
//  XiaoMi.swift
//  internals
//
//  Created by ke.liang on 2018/1/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class XiaoMi: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "xiaomiTableCell", bundle: nil), forCellReuseIdentifier: xiaomiTableCell.identity())
     
    }

  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: xiaomiTableCell.identity(), for: indexPath) as? xiaomiTableCell{
            
            return cell
        }
        return xiaomiTableCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return xiaomiTableCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let detailView = detailWebViewController()
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    


}
