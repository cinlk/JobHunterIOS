//
//  SelectedOneTableView.swift
//  internals
//
//  Created by ke.liang on 2018/3/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let cellIdentity = "cell"
fileprivate let cellH: CGFloat = 45

class SelectedOneTablView:UIView,UITableViewDelegate,UITableViewDataSource{
    
    
    // 回调传值
    var call:((_ value:String, _ row:Int)->Void)?
    
    
    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.viewBackColor()
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        table.separatorStyle = .singleLine
        return table
        
    }()
    private  lazy var title:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textAlignment = .center
        title.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        return title
    }()
    
    private lazy var line:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.black
        line.alpha = 0.5
        return line
    }()
    // 数据
    private var dataList:[component] = []
    
    var mode:(name:String,row:Int)?{
        didSet{
            guard let mode = mode else {
                return
            }
            guard  let node = SelectItemUtil.shared.getItems(name: mode.name) else {
                return
            }
            
            guard let  list = node.getNodeByName(name: mode.name)?.item else {
                return
            }
            self.dataList = list
            
            self.title.text = mode.name
            
            self.table.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
        
        
    }
    
    
    private func setViews(){
        self.backgroundColor  = UIColor.white
        let views:[UIView] = [title, line, table]
        self.sd_addSubviews(views)
        
        _ = title.sd_layout().topSpaceToView(self,5)?.centerXEqualToView(self)?.autoHeightRatio(0)
        
        _ = line.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topSpaceToView(title,5)?.heightIs(1)
        _ = table.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topSpaceToView(line,0)
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentity)
        cell.textLabel?.font  = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.highlightedTextColor = UIColor.blue
        // 节点被选中
        let currentNode = dataList[indexPath.row]
        cell.textLabel?.text = currentNode.key
        cell.textLabel?.isHighlighted =  currentNode.selected
        cell.accessoryType = currentNode.selected ? .checkmark : .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        resetTableItemStatus(data: dataList)
        // 被选中节点
        let currentNode = dataList[indexPath.row]
        currentNode.selected = true
        self.call?(currentNode.key, mode!.row)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    private func resetTableItemStatus(data: [component]){
        // 去掉其他被选中的节点
        for item in data{
            item.selected = false
        }
    }
    
}

