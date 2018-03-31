//
//  Reply.swift
//  internals
//
//  Created by ke.liang on 2017/10/28.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


// 快捷恢复代理
protocol ReplyMessageDelegate: class {
    func didSelectedMessage(view:UITableView, message:String)
    
}


fileprivate let sourceFileName = "replylist"

class quickReplyView: UIView {
 
    lazy var datasource:[String] = {
        
        return ChatEmotionHelper.getAllReplyMessages(fileName: sourceFileName)
        
    }()
    
    
    // delegate
    weak var delegate:ReplyMessageDelegate?
    
    
    // 顶部 view
    lazy var banner:UIView = {
        var v =  UIView.init(frame: CGRect.zero)
        
        v.backgroundColor = UIColor.blue
        var label = UILabel.init()
        label.text = "请选择快捷回复"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.setSingleLineAutoResizeWithMaxWidth(120)
        v.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(v)?.centerYEqualToView(v)?.autoHeightRatio(0)
        return v
        
    }()
    
    lazy var replyTable: UITableView = { [unowned self ] in
        var table = UITableView.init()
        table.backgroundColor = UIColor.viewBackColor()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView.init()
        table.showsVerticalScrollIndicator = false
        return table
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(banner)
        self.addSubview(replyTable)
        
        _ = banner.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(45)
        _ = replyTable.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topSpaceToView(banner,0)?.bottomEqualToView(self)
        
      
    }
    
}


extension quickReplyView: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        delegate?.didSelectedMessage(view: tableView, message: datasource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.editingAccessoryType = .none
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.text = datasource[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
}
