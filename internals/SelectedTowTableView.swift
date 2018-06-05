//
//  SelectedTowTableView.swift
//  internals
//
//  Created by ke.liang on 2018/3/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let cellIdentity:String = "cell"
fileprivate let all:String = "不限"

class SelectedTowTableView:UIView,UITableViewDelegate,UITableViewDataSource{
    
    
    private lazy var lefttable:UITableView = { [unowned self] in
        var table = UITableView()
        table.backgroundColor = UIColor.viewBackColor()
        table.tableFooterView = UIView()
        table.isMultipleTouchEnabled  = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        return table
    }()
    
    private lazy var righttable:UITableView = { [unowned self] in
        var table = UITableView()
        table.backgroundColor = UIColor.viewBackColor()
        table.tableFooterView = UIView()
        table.isMultipleTouchEnabled  = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        return table
    }()
    
    
    lazy var title:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW/2)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy  var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.5
        return v
    }()
    
    // 数据回传回调
    var call:((_ name:String,_ value: String, _ row:Int)->Void)?
    
    private var node:nodes?
    
    
    private lazy var first:[component] = []
    private lazy var second:[component] = []
    // MARK: 记录修改值状态数据
    var mode:(name:String,row:Int)?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            guard let   node = SelectItemUtil.shared.getItems(name: mode.name) else {
                return
            }
            
            guard let  firstList = node.getNodeByName(name: mode.name)?.item else {
                return
            }
            self.title.text = mode.name
            
            self.first = firstList
            
            if first.count > 0 {
                // 默认第一个父节点的孩子nodes
                second = first[0].item
                
                for item in first{
                    // 被选中节点的孩子节点
                    if item.selected{
                        second = item.item
                        break
                    }
                }
            }
            
            
            self.lefttable.reloadData()
            self.righttable.reloadData()
        }
    }
    
    private var leftValue:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
    }
    
    
    private func setViews(){
        
        self.backgroundColor = UIColor.white
        let views:[UIView] = [title, line, lefttable, righttable]
        self.sd_addSubviews(views)
        
        
        _ = title.sd_layout().topSpaceToView(self,10)?.centerXEqualToView(self)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(title,5)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        _ = lefttable.sd_layout().leftEqualToView(self)?.topSpaceToView(line,0)?.widthIs(ScreenW / 2 )?.bottomEqualToView(self)
        // MARK  这里如果用rightEqualToView(self) 约束，大小是对的，但是reloadtable 不生效？？ 换成widthIs(ScreenW / 2 ) 有效？
        _ = righttable.sd_layout().leftSpaceToView(lefttable,0)?.topSpaceToView(line,0)?.widthIs(ScreenW / 2)?.bottomEqualToView(self)
        
        title.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
       
        cell.textLabel?.highlightedTextColor  = UIColor.blue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = .none
        
        if tableView  == lefttable{
            let currentNode = first[indexPath.row]
            cell.textLabel?.text  = currentNode.key
            
            cell.textLabel?.isHighlighted = currentNode.selected
            
            
        }else{
            let currentNode = second[indexPath.row]
            cell.textLabel?.text  = currentNode.key
            cell.textLabel?.isHighlighted = currentNode.selected
            cell.accessoryType = currentNode.selected ? .checkmark : .none
        }
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == lefttable ? first.count :  second.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if tableView == lefttable{
            let curretNode = first[indexPath.row]
            cell?.textLabel?.isHighlighted = curretNode.selected
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if tableView  == lefttable{
           
            let currentNode = first[indexPath.row]
            leftValue  =  currentNode.key
            // 返回数据
            if leftValue == all{
                self.call?(title.text!, leftValue, mode!.row)
                return
            }
            cell?.textLabel?.isHighlighted = true
            // 刷新第二个table
            second = currentNode.item
            self.righttable.reloadData()
            
        }else{
            // 取消之前被选中节点状态,包括子节点
            for node in first{
                resetTableItemStatus(node: node)
            }
            let currentNode = second[indexPath.row]
            currentNode.selected = true
            
            // 选中第二个table 中的数据 并返回
            self.call?(title.text!, currentNode.key, mode!.row)
        }
        
    }
    
    private func resetTableItemStatus(node:component){
        if node.selected{
            node.selected = false
            for item in node.item{
                resetTableItemStatus(node: item)
            }
        }
    }
    
}


