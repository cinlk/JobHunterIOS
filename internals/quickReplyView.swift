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

class quickReplyView: UITableView {
 
    private var datasource:[String] =  []
    
    weak var selecteDelagate:ReplyMessageDelegate?
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setView()
        loadData()
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension quickReplyView{
    
    
    private func setView(){
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView.init()
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    private func loadData(){
        
        datasource = ["回复以带我去的群无多无群多无多无群","当前为多无群多无群多无群多无群多无群多","当前为多无群多无群","当前为多无群多无群","当前的群当前为多群多群无当前为多群无多无群当前为多群无当前为多群无多群当前为多群无多", "当前为多群无dqwdqw","当前为多无群多群无dqwdqwdqw"]
        self.reloadData()
        
    }
}

extension quickReplyView: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selecteDelagate?.didSelectedMessage(view: tableView, message: datasource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text  = datasource[indexPath.row]
        cell.textLabel?.textAlignment = .left
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = datasource[indexPath.row]
        let size = UILabel.sizeOfString(string: str as NSString, font: UIFont.systemFont(ofSize: 14), maxWidth: self.bounds.width - 10)
        return size.height + 10
        
    }
    
    
}
