//
//  PostCollectedViewController.swift
//  internals
//
//  Created by ke.liang on 2018/7/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let notifiyName:String = "PostCollectedViewController"


class PostCollectedViewController: BaseViewController {

 
    private lazy var datas:[PostArticleModel] = []
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: self.view.frame)
        tb.dataSource = self
        tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(postCollectedCell.self, forCellReuseIdentifier: postCollectedCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)

        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NSNotification.Name.init(notifiyName), object: nil)
        
    }
    
    
    override func setViews() {
        
        
        self.view.addSubview(table)
          _ = table.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        self.handleViews.append(table)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}


extension PostCollectedViewController{
    @objc private func operation(_ sender: Notification){
        
        let info = sender.userInfo as? [String:String]
        if let action = info?["action"]{
            if action == "edit"{
                self.table.setEditing(true, animated: false)
            }else if action == "cancel"{
                self.table.setEditing(false, animated: false)
            }else if action == "selectAll"{
                for index in 0..<datas.count{
                    self.table.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .bottom)
                }
                
            }else if action == "unselect"{
                self.table.selectRow(at: nil, animated: false, scrollPosition: .top)
            }else if action == "delete"{
                if let selected = self.table.indexPathsForSelectedRows{
                    var deletedRows:[Int] = []
                    selected.forEach { indexPath in
                        deletedRows.append(indexPath.row)
                    }
                    // 扩展 批量删除元素
                    self.datas.remove(indexes: deletedRows)
                    // 服务器删除
                    self.table.reloadData()
                    
                }
            }
        }
        
        
        
    }
}


extension PostCollectedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: postCollectedCell.identity(), for: indexPath) as? postCollectedCell{
            cell.mode = datas[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: postCollectedCell.self, contentViewWidth: ScreenW)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        let post = PostContentViewController()
        let mode = datas[indexPath.row]
        post.mode = (data:mode, row: indexPath.row)
        post.deleteSelf = { row in
            self.datas.remove(at: row)
            self.table.reloadData()
        }
        
        post.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(post, animated: true)
        
    }
    
    
}






extension PostCollectedViewController{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<10{
                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwdwqd","authorName":"我的名字","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":"life","thumbUP":2303,"reply":101]){
                    
                    self?.datas.append(data)
                }
                
            }
            
            for _ in 0..<10{
                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"123456","authorName":"就是我","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":"life","thumbUP":2303,"reply":101]){
                    
                    self?.datas.append(data)
                }
                
            }
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
        
    }
    
}




@objcMembers fileprivate class postCollectedCell: UITableViewCell {
    
    
    private lazy var postName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        name.font = UIFont.boldSystemFont(ofSize: 14)
        name.textAlignment = .left
        return name
    }()
    
    

    private lazy var times:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.lightGray
        return name
    }()
    
    
    
    dynamic var mode:PostArticleModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            self.postName.text = mode.title
            self.times.text = mode.createTimeStr
            
            self.setupAutoHeight(withBottomView: times, bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [postName, times]
        self.accessoryType = .disclosureIndicator
        self.contentView.sd_addSubviews(views)
        _ = postName.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = times.sd_layout().topSpaceToView(postName,10)?.leftEqualToView(postName)?.autoHeightRatio(0)
        
        
        postName.setMaxNumberOfLinesToShow(2)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "postCollectedCell"
    }
    
    // MARK 区分cell 投递 和非
    
    
}
