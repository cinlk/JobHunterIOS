//
//  SelectedThreeTableView.swift
//  internals
//
//  Created by ke.liang on 2018/3/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD


fileprivate let cellIdentity:String = "cell"

class SelectedThreeTableView:UIView{
    
    
    // 选择回调
    var call:((_ name:String,_ values:String,_ row:Int)->Void)?
    
    lazy var title:UILabel = {
        let title = UILabel.init()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.black
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        title.textAlignment = .center
        return title
    }()
    
    private var line:UIView = {
        let v =  UIView()
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.5
        return v
    }()
    
    //
    private lazy var confirm:UIButton = {
        let confirm = UIButton.init()
        confirm.setTitle("确定", for: .normal)
        confirm.addTarget(self, action: #selector(save), for: .touchUpInside)
        confirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        confirm.setTitleColor(UIColor.blue, for: .normal)
        return confirm
    }()
    
    
    
    
    private lazy var table1:UITableView = { [unowned self] in
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.viewBackColor()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        return table
        }()
    
    private lazy var table2:UITableView = {  [unowned self] in
        
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.viewBackColor()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        
        return table
        
        }()
    
    private lazy var table3:UITableView = { [unowned self] in
        
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = true
        table.backgroundColor = UIColor.viewBackColor()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        return table
        
        }()
    
    private lazy var scroller:UIScrollView = { [unowned self] in
        var scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.backgroundColor = UIColor.white
        scroll.bounces = false
        scroll.delegate = self
        scroll.contentSize = CGSize.init(width: ScreenW + ScreenW / 2 , height: self.frame.height - 36)
        return scroll
        }()
    
    // 当前选择的值
    private var leftItem:String = "职位类别"
    private var middleItem:String = ""
    private var rightItem:String = ""
    // 最多5个选择
    private let count = 5
    //最后一层
    private var last:[component] = []
    //中间层
    private var middle:[component] = []
    //第一层
    private var first:[component] = []
    
    private var node:nodes?
    // 返回的数据
    var results:[String] = []
    
    var mode:(name:String, row:Int)?{
        didSet{
            node =  SelectItemUtil.shared.getItems(name: mode!.name)
            first = node?.getNodeByName(name: mode!.name)?.item ?? []
            
            if first.count > 0{
                
                middle =  first[0].item
                // 第一个选中的leftitem
                for item in first{
                    if item.selected{
                        middle = item.item
                        break
                    }
                }
                
            }
            if middle.count > 0{
                last = middle[0].item
                // 第一个被选中的middleItem
                for item in middle{
                    if item.selected{
                        last = item.item
                        break
                    }
                }
                
            }
            self.table1.reloadData()
            self.table2.reloadData()
            self.table3.reloadData()
            self.scroller.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
    }
    private func setViews(){
        
        self.backgroundColor = UIColor.white
        
        let views:[UIView] = [title, line, confirm, scroller]
        self.sd_addSubviews(views)
        scroller.sd_addSubviews([table1,table2,table3])
        
        _ = title.sd_layout().topSpaceToView(self,5)?.centerXEqualToView(self)?.autoHeightRatio(0)
        _ = confirm.sd_layout().rightSpaceToView(self,5)?.centerYEqualToView(title)?.widthIs(50)?.heightIs(20)
        _ = line.sd_layout().topSpaceToView(title,5)?.widthIs(ScreenW)?.heightIs(1)
        
        
        _ = scroller.sd_layout().leftEqualToView(self)?.topSpaceToView(line,0)?.bottomEqualToView(self)?.rightEqualToView(self)
        
        
        _ = table1.sd_layout().leftEqualToView(scroller)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(ScreenW / 2)
        _ = table2.sd_layout().leftSpaceToView(table1,0)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(ScreenW / 2)
        _ = table3.sd_layout().leftSpaceToView(table2,0)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(ScreenW / 2)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 返回数据 用 + 连接的
    @objc private func save(){
        
        if results.isEmpty{
            return
        }
        self.call?(title.text!, results.joined(separator: "+"), mode!.row)
    }
}

extension SelectedThreeTableView: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView  == table1{
            return first.count
        }else if tableView == table2{
            return middle.count
        }else{
            return last.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.highlightedTextColor = UIColor.blue
        if tableView  == table1{
            let currentNode = first[indexPath.row]
            
            if currentNode.selected{
                cell.textLabel?.isHighlighted = true
            }
            cell.textLabel?.text  = currentNode.key
            
        }else if tableView == table2{
            let currentNode = middle[indexPath.row]
            
            if currentNode.selected{
                cell.textLabel?.isHighlighted = true
            }
            
            cell.textLabel?.text = currentNode.key
            
            
            
        }else{
            let currentNode = last[indexPath.row]
            if currentNode.selected{
                cell.textLabel?.isHighlighted = true
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
            cell.textLabel?.text  = currentNode.key
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else{
            return
        }
        if tableView == table1{
            let currentNode = first[indexPath.row]
            if  currentNode.selected == false{
                cell.textLabel?.isHighlighted = false
            }
            
        }else if tableView == table2{
            let currentNode = middle[indexPath.row]
            if currentNode.selected == false{
                cell.textLabel?.isHighlighted = false
            }
        }else{
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let cell = tableView.cellForRow(at: indexPath) else{
            return
        }
        
        
        if tableView == table1{
            cell.textLabel?.isHighlighted = true
            
            let currentNode = first[indexPath.row]
            leftItem  = currentNode.key
            // 第二个table 的数据
            middle = currentNode.item
            //middleItem = ""
            // 刷新第二个table
            table2.reloadData()
            //table3.reloadData()
            
        }else if tableView == table2{
            cell.textLabel?.isHighlighted = true
            
            let currentNode = middle[indexPath.row]
            middleItem = currentNode.key
            // 刷新第三个table
            last = currentNode.item
            table3.reloadData()
            // 滑过第一个table
            scroller.setContentOffset(CGPoint(x:ScreenW / 2,y:0), animated: true)
        }else{
            self.selectedItems(row: indexPath.row, cell: cell)
        }
        
    }
}

extension SelectedThreeTableView{
    
    private func selectedItems(row:Int, cell: UITableViewCell){
        
        let currentNode = last[row]
        // 再次点击取消
        if currentNode.selected == true{
            currentNode.selected = false
            cell.textLabel?.isHighlighted = false
            cell.accessoryType = .none
            if let  index = results.index(of: (cell.textLabel?.text)!){
                results.remove(at: index)
            }
            
            
        }else{
            if results.count >= 5{
                SVProgressHUD.show(#imageLiteral(resourceName: "warn"), status: "最多选择5个")
                SVProgressHUD.dismiss(withDelay: 2)
                return
            }
            
            results.append((cell.textLabel?.text)!)
            // 更新选中状态，更新父节点选中状态
            currentNode.selected = true
            cell.textLabel?.isHighlighted = true
            cell.accessoryType = .checkmark
        }
        
        self.table2.reloadData()
        self.table1.reloadData()
    }
    
    
    
    
}
