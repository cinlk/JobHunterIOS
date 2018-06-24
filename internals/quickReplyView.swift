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


class quickReplyView: UIView {
 
    private var datasource:[String] =  []
    
    
    // delegate
    weak var delegate:ReplyMessageDelegate?
    
    
    // 顶部 view
    lazy var banner:UIView = {
        var v =  UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.blue
        var label = UILabel.init()
        label.text = "请选择快捷回复"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.setSingleLineAutoResizeWithMaxWidth(120)
        v.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(v)?.centerYEqualToView(v)?.autoHeightRatio(0)
        return v
        
    }()
    
    lazy var replyTable: UITableView = { [unowned self ] in
        var table = UITableView.init()
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView.init()
        table.register(singleTextCell.self, forCellReuseIdentifier: singleTextCell.identity())
        table.showsVerticalScrollIndicator = false
        return table
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(banner)
        self.addSubview(replyTable)
        
        _ = banner.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(40)
        _ = replyTable.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topSpaceToView(banner,0)?.bottomEqualToView(self)
        
        
        loadData()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension quickReplyView{
    private func loadData(){
        
        datasource = ["回复以带我去的群无多无群多无多无群","当前为多无群多无群多无群多无群多无群多","当前为多无群多无群","当前为多无群多无群"]
        self.replyTable.reloadData()
        
    }
}

extension quickReplyView: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelectedMessage(view: tableView, message: datasource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: singleTextCell.identity(), for: indexPath) as! singleTextCell
        cell.mode = datasource[indexPath.row]
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.cellHeight(for: indexPath, model: datasource[indexPath.row], keyPath: "mode", cellClass: singleTextCell.self, contentViewWidth: ScreenW)
    }
    
    
}

@objcMembers private class singleTextCell:UITableViewCell {
    
    
    
    private lazy var content:UILabel = { [unowned self] in
        let lb = UILabel()
        lb.textAlignment = .left
        
        lb.textColor = UIColor.black
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.setSingleLineAutoResizeWithMaxWidth(250 - 30)
        return lb
    }()
    
    
    dynamic var mode:String?{
        didSet{
            
            self.content.text = mode!
            
            self.setupAutoHeight(withBottomView: content, bottomMargin: 5)
        }
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        _ = content.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
        
        content.setMaxNumberOfLinesToShow(3)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "singleTextCell"
    }
    
    
    
}
