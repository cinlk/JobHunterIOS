//
//  newVisitor.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class MyVisitor: BaseTableViewController {

    private var mode:[HRVisitorModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
        self.navigationItem.title = "谁看过我"

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()

        
    }
    
    
    override func setViews(){
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(visitorCell.self, forCellReuseIdentifier: visitorCell.identity())
        
        self.handleViews.append(tableView)
        super.setViews()
    }
    
    override func didFinishloadData(){
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    override func showError(){
       super.showError()
    }
    
    override func reload(){
        super.reload()
        self.loadData()
        
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
        
        let height =  tableView.cellHeight(for: indexPath, model: mode[indexPath.row], keyPath: "mode", cellClass: visitorCell.self, contentViewWidth: ScreenW)
        return height + 10
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        _ = publisherControllerView()
        //hrVC.mode =
        
    }
    
    

}


extension MyVisitor{
    
    private func loadData(){
        //self.data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            for _ in 0..<10{
                self?.mode.append(HRVisitorModel(JSON: ["userID":"dqw-4234-dqwd-dqwd","icon":"chicken","company":"小公司","name":"大u云", "position":"HRBP","visitTime":Date().timeIntervalSince1970,"companyID":"dqw-dqwfq-dqwd"])!)
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
            
        }
       
        
    }
    
 
}