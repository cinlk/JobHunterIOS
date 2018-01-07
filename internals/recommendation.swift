//
//  recommendation.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class recommendation: UIViewController {

    
    private var data:[Dictionary<String,String>]!
    
    lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds, style: .plain)
        table.frame  = self.view.frame
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title =  "推荐职位"

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title =  ""
        
    }

}



extension recommendation: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell  =  table.dequeueReusableCell(withIdentifier: jobdetailCell.identity(), for: indexPath) as? jobdetailCell{
            cell.createCells(items: data[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell.init()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        
        let detail =  JobDetailViewController()
        detail.infos = data[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return jobdetailCell.cellHeight()
    }
}


extension recommendation {
    
    
    private func setViews(){
        
        
        let sub =  UIBarButtonItem.init(title: "我的订阅", style: .plain, target: self, action: #selector(addSub))
        sub.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.blue,
                                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        self.navigationItem.rightBarButtonItem  = sub
        self.view.addSubview(table)
        data = self.loadJobs()
        self.table.reloadData()
        
    }
    
    
    private func loadJobs()->[Dictionary<String,String>]{
        
        let datas = [["picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"社招"],
                     ["picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"社招"],
                     ["picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"社招"],
            
        ]
        
        return datas
    }
    
    @objc func addSub(){
        
        let subscribleView = subscribleItem()
        self.navigationController?.pushViewController(subscribleView, animated: true)
        
    }
}
