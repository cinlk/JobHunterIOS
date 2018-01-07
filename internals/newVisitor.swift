//
//  newVisitor.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class newVisitor: UITableViewController {

    lazy var data:[[String:String]] = {
        var res:[[String:String]] = []
        for i in 0..<10{
            res.append(["avartar":"avartar","comapny_title":"食品保护 HR","visite_time":"2017-12-27","jobName":"销售经理"])
        }
        return res
    }()
    
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
        return self.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: visitorCell.identity(), for: indexPath) as? visitorCell{
            cell.avartar.image = UIImage.init(named: data[indexPath.row]["avartar"]!)
            cell.company_title.text = data[indexPath.row]["comapny_title"]
            cell.visite_time.text = data[indexPath.row]["visite_time"]
            cell.jobName.text = data[indexPath.row]["jobName"]
            return cell
        }
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return visitorCell.cellHeight()
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        // test
        if indexPath.row == 0 {
            let closeView = closedJobView.init(style: .plain)
            self.navigationController?.pushViewController(closeView, animated: true)
            
        }else{
            let jobView = JobDetailViewController()
            jobView.infos = ["picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"社招"]
            self.navigationController?.pushViewController(jobView, animated: true)
        }
    }
    
    

}

extension newVisitor{
    private func loadData(){
        //self.data
    }
    
    private func setView(){
        
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "visitorCell", bundle: nil), forCellReuseIdentifier: visitorCell.identity())
    }
}
