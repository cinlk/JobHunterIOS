//
//  deliveryCategoryView.swift
//  internals
//
//  Created by ke.liang on 2018/1/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




class deliveryCategoryView: UITableViewController {

    
    fileprivate var ResultDataSet:[Dictionary<String,String>]?
    
    
    init(style: UITableViewStyle, datas:[Dictionary<String,String>]?) {
        
        super.init(style: style)
        self.ResultDataSet = datas
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "deliveryItemCell", bundle: nil), forCellReuseIdentifier: deliveryItemCell.identity())
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
        return ResultDataSet?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return deliveryItemCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = ResultDataSet?[indexPath.row] else {
            return UITableViewCell.init()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: deliveryItemCell.identity(), for: indexPath)  as? deliveryItemCell{
            cell.imageView?.image  = UIImage.init(named: item["icon"]!)
            cell.jobName.text = item["jobName"]
            cell.address.text = item["address"]
            cell.company.text = item["company"]
            cell.type.text = item["type"]
            cell.create_time.text = item["create_time"]
            cell.resulte.text = "【" + item["resulte"]! + "】"
            // test color
            cell.icon.pp.addDot(color: UIColor.red)
            return cell
        }
        return UITableViewCell.init()
    
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! deliveryItemCell
        tableView.deselectRow(at: indexPath, animated: false)
        if let jobInfo = ResultDataSet?[indexPath.row] {
            let status = jobstatusView()
            status.jobDetail = ["picture":jobInfo["icon"]!, "jobName":jobInfo["jobName"]!,
                                "company":jobInfo["company"]!,"address":jobInfo["address"]!,
                                "education":"本科","salary":"面议","create_time":jobInfo["create_time"]!
                                ]
            status.current = ["status":"投递成功","response":"没啥东西"]
            let  s =  [["投递成功","2017-9-12: 16:08"],["被查看","2017-9-13: 08:21"],
                  ["待沟通","2017-9-13: 08:25"]]
            
            status.status = s.reversed()
            self.navigationController?.pushViewController(status, animated: true)
            
            
        }
        
        
        
    }

   

  

}
