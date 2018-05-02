//
//  recommendation.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class recommendation: BaseViewController {

    
    private lazy var data:[CompuseRecruiteJobs] = []
    private lazy var detail:JobDetailViewController = JobDetailViewController()
//    private lazy var subscribleView = subscribleItem()
    
    
    
    lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds, style: .plain)
        table.frame  = self.view.frame
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.viewBackColor()
        table.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        return table
    }()
    
    
    // navigation barBtn
    private lazy var btn:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 70, height: 25))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setViews()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title =  "推荐职位"
        self.navigationController?.insertCustomerView()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title =  ""
        self.navigationController?.removeCustomerView()
        
    }

    
    override func setViews() {
        
        setNavigationBtn()
        self.view.addSubview(table)
        self.handleViews.append(table)
        self.handleViews.append(btn)
        super.setViews()
    }
    
    override func didFinishloadData() {
      
        self.table.reloadData()
        super.didFinishloadData()
        
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
}


extension recommendation{
    private func setNavigationBtn(){
        btn.addTarget(self, action: #selector(addSub), for: .touchUpInside)
        btn.setTitle("我的订阅", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem.init(customView: btn)
    }
}

extension recommendation: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  =  table.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as! CommonJobTableCell
        cell.mode = data[indexPath.row]
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        table.deselectRow(at: indexPath, animated: false)
        detail.jobID = data[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = data[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: ScreenW)
    }
}


extension recommendation {
    
    @objc func addSub(){
        
        var subscribleView = subscribleItem()
        self.navigationController?.pushViewController(subscribleView, animated: true)
        
    }
}


extension recommendation{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            self?.data.append(CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"校招"])!)
            self?.data.append(CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"校招"])!)
            self?.data.append(CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","picture":"swift","company":"apple","jobName":"码农","address":"北京","salary":"150-190元/天","create_time":"09-01","education":"本科","type":"校招"])!)
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
                
                // 错误
                //self?.showError()
            })
        }
   
        
        
    }
}
