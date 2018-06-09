//
//  JobClasses.swift
//  internals
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu



fileprivate let leftTableH:CGFloat = 140
fileprivate let all:String = "不限"

class DropCarrerClassifyView:YNDropDownView,UITableViewDataSource,UITableViewDelegate{
    
        
    private lazy var  leftTable:UITableView = { [unowned self] in
        let table = UITableView()
        table.backgroundColor = UIColor.viewBackColor()
        table.frame = CGRect(x: 0, y: 0, width: leftTableH, height: frame.height)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.allowsMultipleSelection = false
        return table
        
    }()
    private lazy  var rightTable:UITableView = { [unowned self] in
        
        let table = UITableView()
        table.backgroundColor = UIColor.white
        table.frame = CGRect(x: leftTableH, y: 0, width: self.frame.width-leftTableH, height: frame.height)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        table.separatorStyle = .none
        table.allowsMultipleSelection = false
       
        return table
        
        
    }()
    
    var passData: ((_ cond:String) -> Void)?
    
    
    private var keys:[String] = []
    private var selected = ""
    private var rightTableIndex:Int = 0
    
    private var datas:[String:[String]] = [:]{
        didSet{
            keys = datas.keys.sorted()
            keys.insert(all, at: 0)
            selected = keys[0]
        }
    }
    
    
    
    // 全局的 透明背景view
    internal lazy var backGroundBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 0))
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1
        
        return btn
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addSubview(leftTable)
        self.addSubview(rightTable)
        loadData()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    // 显示 和 关闭 view
    override func dropDownViewOpened() {
        UIApplication.shared.keyWindow?.addSubview(backGroundBtn)
        self.getParentViewController()?.tabBarController?.tabBar.isHidden = true
    }
    
    override func dropDownViewClosed() {
        backGroundBtn.removeFromSuperview()
        self.getParentViewController()?.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTable{
            return keys.count
        }
        else{
            return  selected == all ?  0 :  (datas[selected]?.count ?? 0)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = .none
        
        if tableView == leftTable{
            cell.textLabel?.text = keys[indexPath.row]
            
            cell.backgroundColor = UIColor.viewBackColor()
        }else{
            
            cell.subviews.filter({ (view) -> Bool in
                return view.tag == 101
            }).forEach{
                $0.removeFromSuperview()
            }
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text =  datas[selected]?[indexPath.row]
            
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
        
        
        if tableView == leftTable{
            selected = keys[indexPath.row]
            if selected == all{
                self.hideMenu()
                passData?(selected)
                
            }
            rightTable.reloadData()
            
        }else{
            rightTableIndex = indexPath.row
            cell?.addSubview(lines)
            if let name:String =  datas[selected]?[indexPath.row]{
            
                self.hideMenu()
                passData?(name)
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.black
        if tableView == rightTable{
            cell?.subviews.filter({ (view) -> Bool in
                return view.tag == 101
            })[0].removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
}

extension DropCarrerClassifyView{
    private func loadData(){
        
        datas =   ["IT互联网":["软件及系统开发","算法/大数据","智能硬件","移动开发"],
                    "电子电气":["电子/通信","嵌入式","电气工程"],
                    "人事行政":["人事HR","猎头","行政"],
                    "传媒设计":["广告","编辑","媒体","视频后期"],
                    "杀掉无多哇多无多无多":["数据1","数据2"]]
        
        self.leftTable.reloadData()
        
    }
    
    @objc private func hidden(){
        backGroundBtn.removeFromSuperview()
        self.hideMenu()
    }
    
    
}

