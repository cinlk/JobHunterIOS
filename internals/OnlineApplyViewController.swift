//
//  OnlineApplyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import ObjectMapper


class OnlineApplyViewController: BasePositionItemViewController {

    
    // 网申数据
    private var datas:[OnlineApplyModel] = []
    
    internal var type:String = ""{
        didSet{
            // 取消当前的http查询进程，如果有，用新的查询
            loadData(type)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func setViews() {
        
        table.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        table.dataSource = self
        table.delegate = self
        
        super.setViews()
        
        // 条件刷新
        industryKind.passData = { name in
           
            self.dropMenu.changeMenu(title: name, at: 1)
        }
        
        cityMenu.passData = { city in
            //print(city)
            
        }
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
        
    }
    
    
    override func reload() {
        super.reload()
        loadData()
    }
    
    
    override func sendRequest(){
        
        //
        self.datas.removeAll()
        self.table.reloadData()
    }
    
    

}



extension  OnlineApplyViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: OnlineApplyCell.identity(), for: indexPath) as! OnlineApplyCell
        cell.mode = datas[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: OnlineApplyCell.self, contentViewWidth: ScreenW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mode = datas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        
        if mode.outer == true{
            
            guard let urlLink = mode.link else {return}
            //跳转外部连接
            let wbView = baseWebViewController()
            wbView.mode = urlLink
            wbView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wbView, animated: true)
        }else{
            // 内部网申
            let show = OnlineApplyShowViewController()
            // 传递id
            show.onlineApplyID = mode.id
            
            show.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(show, animated: true)
        }
        
    }
    
    
    
}



extension OnlineApplyViewController{
    
    // 查询不同类型数据
    private func loadData(_ type:String = ""){
        
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 3)
            // 站外数据
            for _ in 0..<10{
               
                
                guard let data =  OnlineApplyModel(JSON: ["id":"sdqwd","isValidate":true,"isCollected":false,
                                                          "name":"某某莫小元招聘网申","create_time":Date().timeIntervalSince1970 - TimeInterval(54364),"end_time":Date().timeIntervalSince1970 + TimeInterval(54631),"outer":true,"link":"https://www.xiaoyuanzhao.com/company/xri_y3y4pkvjtj3b?act=zw#1","address":["地点1","地点2"]])  else {
                    continue
                }
                self?.datas.append(data)
      
                
            }
            
            // 站内数据
            for _ in 0..<10{
                guard let data = OnlineApplyModel(JSON: ["id":"sdqwd","isValidate":true,"isCollected":false,
                                                         "name":"某某莫小元招聘网申","create_time":Date().timeIntervalSince1970 - TimeInterval(54364),"end_time":Date().timeIntervalSince1970 + TimeInterval(54631),"outer":false,"address":["地点1","地点2"]]) else {
                    continue
                }
                self?.datas.append(data)
            }
            
            
            
            DispatchQueue.main.async {
                
                self?.didFinishloadData()
            }
        }
    }
}

