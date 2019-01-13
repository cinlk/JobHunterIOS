//
//  CareerTalkInviteViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class CareerTalkInviteViewController: BaseTableViewController {

    
    
    private var datas:[CarrerTalkInviteModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    
    override func setViews() {
        
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.separatorStyle = .none
        
        self.tableView.register( CareerTalkTableViewCell.self, forCellReuseIdentifier: CareerTalkTableViewCell.identity())
        
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkTableViewCell.identity(), for: indexPath) as? CareerTalkTableViewCell{
            cell.mode = datas[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = datas[indexPath.row]
        let height =  tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
        return height + 10
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = datas[indexPath.row]
        let show = CareerTalkShowViewController()
        show.meetingID =  mode.meetingID
        self.navigationController?.pushViewController(show, animated: true)
       
        
    }

}


extension CareerTalkInviteViewController{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 1)

            for _ in 0..<12{
                self?.datas.append(CarrerTalkInviteModel(JSON: ["company":"公司名称","content":"邀请你给参加 xxx 宣讲会","meetingID":"dqwddqwd-432dwa","time":Date().timeIntervalSince1970])!)
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}
