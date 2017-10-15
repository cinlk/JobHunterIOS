//
//  messageMain.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

enum messageItemType:String {
    case result = "求职动态"
    case forum = "论坛动态"
    case relationshp = "新的关注"
    case message  = "消息"
    case recommend = "推荐职位"
}

class messageMain: UITableViewController {

    
    
    var cellItem = [["category":"求职动态","icon":"delivery","desc":"投递记录"],
                    ["category":"论坛动态","icon":"forum","desc":"最新消息"],
                    ["category":"新的关注","icon":"bell","desc":"新消息"],
                    ["category":"消息","icon":"message","desc":"新消息"],
                    ["category":"推荐职位","icon":"jobs","desc":"新的推荐职位"]]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight  = 40
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName:"messageItemCell", bundle:nil), forCellReuseIdentifier: "messageItem")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "messageItem", for: indexPath) as? messageItemCell
        if cell == nil{
            cell =  messageItemCell()
        }
        cell?.category.text  =   cellItem[indexPath.row]["category"]
        cell?.icon.image  = UIImage(named:cellItem[indexPath.row]["icon"]!)
        cell?.desc.text = cellItem[indexPath.row]["desc"]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell  =  tableView.cellForRow(at: indexPath) as? messageItemCell{
            
            // 子视图 返回lable修改为空
            let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            switch (cell.category.text)! {
            case messageItemType.forum.rawValue:
                let fview =  forumView()
                fview.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(fview, animated: true)
                
            
            case messageItemType.result.rawValue:
                let rview =  deliveredHistory()
                rview.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(rview, animated: true)
            case messageItemType.recommend.rawValue:
                let rview = recommendation()
                rview.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(rview, animated: true)
            case messageItemType.relationshp.rawValue:
                let rview = relationship()
                rview.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(rview, animated: true)
            case messageItemType.message.rawValue:
                // 消息好友列表
                let mview = friendsController()
                mview.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(mview, animated: true)
            
            default:
                print("not found item")
            
            }
        }
        
        
        
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)
        
    }

}

