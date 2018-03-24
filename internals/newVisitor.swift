//
//  newVisitor.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class newVisitor: UITableViewController {

    var mode:[VisitorHRModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.mode.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: visitorCell.identity(), for: indexPath) as? visitorCell{
            cell.mode = mode[indexPath.row]
            return cell
        }
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.cellHeight(for: indexPath, model: mode[indexPath.row], keyPath: "mode", cellClass: visitorCell.self, contentViewWidth: ScreenW)
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let hrVC = publisherControllerView()
        //hrVC.mode = 
    }
    
    

}

extension newVisitor{
    
    private func loadData(){
        //self.data
        
        for _ in 0..<10{
            mode.append(VisitorHRModel(JSON: ["iconURL":"avartar","company":"小公司","position":"HRBP","visit_time":"2017-12-27","jobName":"销售经理","tag":"招聘"])!)
        }
        
    }
    
    private func setView(){
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(visitorCell.self, forCellReuseIdentifier: visitorCell.identity())
    }
}
