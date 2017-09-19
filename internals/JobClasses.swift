//
//  JobClasses.swift
//  internals
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu


// protocol

protocol swichjobCatagory {
    func searchCategory(category:String)
}



class JobClasses:UIView,UITableViewDataSource,UITableViewDelegate{
    
    
    var switchcategory: swichjobCatagory?
    
    var table1:UITableView?
    var table2:UITableView?
    
    var stack:UIStackView?
    
    var first = ["全部","IT互联网","电子电气","人事行政","传媒设计","杀掉无多哇多无多无多"]
    var selected = "全部"
    var all = ["全部"]
    var seconds = ["IT互联网":["全部","软件及系统开发","算法/大数据","智能硬件","移动开发"],
                   "电子电气":["全部","电子/通信","嵌入式","电气工程"],
                   "人事行政":["全部","人事HR","猎头","行政"],
                   "传媒设计":["全部","广告","编辑","媒体","视频后期"],
                   "杀掉无多哇多无多无多":[]]
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        table1 = UITableView()
        table1?.backgroundColor = UIColor.gray
        table1?.frame = CGRect(x: 0, y: 0, width: 100, height: self.frame.height)
        table1?.delegate = self
        table1?.dataSource = self
        table1?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table1?.separatorStyle = .none
        table1?.allowsMultipleSelection = false
        
        
        table2 = UITableView()
        table2?.backgroundColor = UIColor.white
        table2?.frame = CGRect(x: 100, y: 0, width: self.frame.width-100, height: self.frame.height)
        table2?.delegate = self
        table2?.dataSource = self
        table2?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        table2?.separatorStyle = .none
        table2?.allowsMultipleSelection = false
        
        
        self.addSubview(table1!)
        self.addSubview(table2!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table1{
            return first.count
        }
        else{
            if selected == "全部"{
                return all.count
            }else{
                return (seconds[selected]?.count)!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.selectionStyle = .none
        
        if tableView == table1{
            cell.textLabel?.text = first[indexPath.row]
            
            cell.backgroundColor = UIColor.gray
        }else{
            
            for i in (cell.subviews){
                if i.tag == 101{
                    i.removeFromSuperview()
                }
            }
            
            cell.textLabel?.textColor = UIColor.black
            if  selected == "全部"{
                cell.textLabel?.text = "全部"
            }else{
                cell.textLabel?.text = seconds[selected]?[indexPath.row]
            }
            
        }
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        //添加下滑线
        let lines = UIView()
        lines.tag = 101
        lines.frame = CGRect(x: 60, y: (cell?.frame.height)!-1, width: (cell?.frame.width)!-120, height: 1.0)
        lines.backgroundColor = UIColor.orange
        cell?.textLabel?.textColor = UIColor.orange
        
        
        if tableView == table1{
            
            selected = first[indexPath.row]
            table2?.reloadData()
            
        }else{
            cell?.addSubview(lines)
            var name = ""
            if selected == "全部"{
                name = "全部"
                return
            }
            name = (seconds[selected]?[indexPath.row])!
            self.switchcategory?.searchCategory(category: name)
            (self.superview as! YNDropDownView).hideMenu()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.black
        if tableView == table2{
            for i in (cell?.subviews)!{
                if i.tag == 101{
                    i.removeFromSuperview()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
}

