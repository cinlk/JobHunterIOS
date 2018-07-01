//
//  BaseSingleItemDropView.swift
//  internals
//
//  Created by ke.liang on 2018/4/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu

fileprivate let cellIdentity:String = "cell"


class BaseSingleItemDropView: YNDropDownView {

    // test data
    internal  var datas:[String] = []{
        didSet{
            self.table.reloadData()
        }
    }
    
    
    internal var showTabBar:Bool = true
    
    
    internal var passData: ((_ cond:String) -> Void)?
    // currentSelected index
    private var index:IndexPath?
    
    
    internal lazy var table:UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.viewBackColor()
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        return table
        
    }()
    
    
    // 全局的 透明背景view
    internal lazy var backGroundBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 0))
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1
        
        return btn
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    // 显示 和 关闭 view
    override func dropDownViewOpened() {
        
        UIApplication.shared.keyWindow?.addSubview(backGroundBtn)
        // 设置为true 才有下拉展开效果
        self.superview?.clipsToBounds = false
        if showTabBar {
            self.getParentViewController()?.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func dropDownViewClosed() {
        backGroundBtn.removeFromSuperview()
        self.superview?.clipsToBounds = true
        if showTabBar{
            self.getParentViewController()?.tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    
    
}


extension BaseSingleItemDropView{
    private func chooseItem(name:String){
        self.passData?(name)
        
        self.hideMenu()
    }
    
    @objc private func hidden(){
        backGroundBtn.removeFromSuperview()
        self.hideMenu()
    }
}


extension BaseSingleItemDropView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        
        cell.textLabel?.text = datas[indexPath.row]
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.blue
        cell?.accessoryType = .checkmark
        index = indexPath
        
        if let name = cell?.textLabel?.text{
            chooseItem(name:name)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.black
        cell?.accessoryType = .none
        cell?.accessoryView?.tintColor = UIColor.black
    }
    

}

extension BaseSingleItemDropView{
    func clearSelected(){
        guard  let index = index  else {
            return
        }
        let cell = table.cellForRow(at: index)
        cell?.isSelected = false
        self.table.reloadData()
    }
}
