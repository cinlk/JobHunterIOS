//
//  JobInviteViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class JobInviteViewController: BaseTableViewController {

    private var datas:[JobInviteModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setViews() {
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.separatorStyle = .none
        self.tableView.register(JobInviteTableViewCell.self, forCellReuseIdentifier: JobInviteTableViewCell.identity())
        // 调整状态背景view 高度
        //backHubView.frame = CGRect.init(x: 0, y: NavH + 45, width: ScreenW, height: ScreenH - (NavH + 45))
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
    
    
    
    // table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: JobInviteTableViewCell.identity(), for: indexPath) as? JobInviteTableViewCell{
            cell.mode = datas[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = datas[indexPath.row]
        let height =  tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobInviteTableViewCell.self, contentViewWidth: ScreenW)
        return height + 10
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }


}


extension JobInviteViewController{
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            
            for _ in 0..<12{
                self?.datas.append(JobInviteModel(JSON: ["hr":"hr名字","content":"邀请投递网申",
                    "jobID":"dqwddqwd-432dwa","time":Date().timeIntervalSince1970,"jobtype":jobType.onlineApply.rawValue])!)
                
            }
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}
