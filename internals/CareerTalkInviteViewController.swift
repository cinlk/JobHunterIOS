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
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.separatorStyle = .none
        
        //backHubView.frame = CGRect.init(x: 0, y: NavH + 45, width: ScreenW, height: ScreenH - (NavH + 45))

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
        let height =  tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkTableViewCell.self, contentViewWidth: ScreenW)
        return height + 10
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}


extension CareerTalkInviteViewController{
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            
            for _ in 0..<12{
                self?.datas.append(CarrerTalkInviteModel(JSON: ["company":"公司名称","content":"如今随着流媒体和云端存储越来越成熟，版权内容越来越丰富，我们已经愈发不需要下载视频了。只要有网络，想看什么内容，基本都能找到在线播放。但总有些时候，是你特别想把视频下载下来的——比如网速不给力或者没有网络的时候，再比如想反复揣摩学习某些动作片视频资料的时候。",
                                "meetingID":"dqwddqwd-432dwa","time":Date().timeIntervalSince1970])!)
            }
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}
