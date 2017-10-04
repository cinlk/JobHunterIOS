//
//  subscribleItem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class subscribleItem: UITableViewController {

    
    // 数据保持在本地(校招,实习)

    var interndata:[Dictionary<String,String>] =  [["test":"value"]]
    var campusdata:[Dictionary<String,String>] = [["test":"value"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName:"subjobitem", bundle:nil), forCellReuseIdentifier: "subjobitems")
        
        //新增加
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem?.imageInsets  = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disspose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        var count  = 0
        if !interndata.isEmpty{
            count  += 1
        }
        if !campusdata.isEmpty{
            count += 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return interndata.count
            
        }
        else{
            return campusdata.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjobitems", for: indexPath) as! subjobitem

        // 校招
        if indexPath.section  == 0 {
            cell.leibie.text = "PHP+.NET"
            cell.locate.text = "北京"
            cell.salary.text = "3K-5K"
            cell.hangye.text = "网络游戏"
            cell.shixiday.isHidden = true
            cell.shixidaylog.isHidden = true
            
        }else{
            cell.leibie.text = "PHP+.NET"
            cell.locate.text = "北京"
            cell.salary.text = "300/天"
            cell.hangye.text = "网络游戏"
            cell.shixiday.text = "5天/周"
            cell.shixiday.isHidden = false
            cell.shixidaylog.isHidden = false
            
        }
        
        
        // Configure the cell...

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 10)
        label.frame = CGRect(x: 5, y: 2, width: 50, height: 10)
        label.textAlignment = .left
        let view =  UITableViewHeaderFooterView.init()
        view.backgroundColor = UIColor.lightGray
        if section == 0 {
                label.text  = "校招"
            
        }else{
            label.text  = "实习"
        }
        view.addSubview(label)
        return view
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  15
    }
    
    // cell 编辑
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // 自定义cell 编辑方法
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blue
        
        return [share, favorite, more]
    }
    
   
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
 
    
}

extension subscribleItem{
    
    func addItem(){
        let condition =  subconditions()
        self.present(condition, animated: true, completion: nil)
        
    }
}
