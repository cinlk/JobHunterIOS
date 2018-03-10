//
//  JobClasses.swift
//  internals
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu



fileprivate let leftTableH:CGFloat = 100


class JobArea:YNDropDownView,UITableViewDataSource,UITableViewDelegate{
    
        
    private var table1:UITableView?
    private var table2:UITableView?
    
    var passData: ((_ cond:[String:String]?) -> Void)?
    
    
    private var first = ["全部","IT互联网","电子电气","人事行政","传媒设计","杀掉无多哇多无多无多"]
    private var selected = "全部"
    private var all = ["全部"]
    private var seconds = ["IT互联网":["全部","软件及系统开发","算法/大数据","智能硬件","移动开发"],
                   "电子电气":["全部","电子/通信","嵌入式","电气工程"],
                   "人事行政":["全部","人事HR","猎头","行政"],
                   "传媒设计":["全部","广告","编辑","媒体","视频后期"],
                   "杀掉无多哇多无多无多":[]]
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        table1 = UITableView()
        table1?.backgroundColor = UIColor.lightGray
        table1?.frame = CGRect(x: 0, y: 0, width: leftTableH, height: frame.height)
        table1?.delegate = self
        table1?.dataSource = self
        table1?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table1?.separatorStyle = .none
        table1?.allowsMultipleSelection = false
        
        
        table2 = UITableView()
        table2?.backgroundColor = UIColor.viewBackColor()
        table2?.frame = CGRect(x: leftTableH, y: 0, width: self.frame.width-leftTableH, height: frame.height)
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
            return  selected == "全部" ?  1 : (seconds[selected]?.count)!
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.selectionStyle = .none
        
        if tableView == table1{
            cell.textLabel?.text = first[indexPath.row]
            
            cell.backgroundColor = UIColor.lightGray
        }else{
            
            cell.subviews.filter({ (view) -> Bool in
                return view.tag == 101
            }).forEach{
                $0.removeFromSuperview()
            }
            cell.backgroundColor = UIColor.viewBackColor()
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text =  selected == "全部" ? "全部" : seconds[selected]?[indexPath.row]
            
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
            let name:String = selected == "全部" ? "全部" : (seconds[selected]?[indexPath.row])!
            self.hideMenu()
            if let pass = passData{
                pass(["行业领域":name])
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.black
        if tableView == table2{
            cell?.subviews.filter({ (view) -> Bool in
                return view.tag == 101
            })[0].removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
}

