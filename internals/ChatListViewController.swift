//
//  ChatListViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/19.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ChatListViewController: UITableViewController {

    
    // 数据库
    private lazy var cManager:ConversationManager = ConversationManager.shared
    
    // 和那些人聊天
    private lazy var cModel:[conversationModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        refresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatUsersTableViewCell.identity(), for: indexPath) as! ChatUsersTableViewCell
        let user = cModel[indexPath.row]
        
        cell.mode = user
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = cModel[indexPath.row]
        
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ChatUsersTableViewCell.self, contentViewWidth: ScreenW)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let user = cModel[indexPath.row]
        
        //var weakSelf d = sef
        let chatView = CommunicationChatView(hr: user.user!, index: indexPath)
        
        chatView.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction.init(style: .normal, title: "置顶") { (action, index) in
            if index.row == 0 {
                return
            }
            print("置顶")
        }
        
        edit.backgroundColor = UIColor.orange
        edit.accessibilityFrame  = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        let delete = UITableViewRowAction.init(style: .normal, title: "删除") { [unowned self] (action, index) in
            let user = self.cModel[index.row]
            self.cModel.remove(at: index.row)
            
            self.cManager.removeConversationBy(userID: user.userID!)
            tableView.reloadData()
        }
        delete.backgroundColor = UIColor.blue
        delete.accessibilityFrame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        // 删除不能放前面 出现滑动删除效果
        return [edit,delete]
    }
    
    // ios 11  cell swipe 功能
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "delete", handler: { (action, view, completion) in
            //TODO 删除提醒界面！
            let user = self.cModel[indexPath.row]
            self.cModel.remove(at: indexPath.row)
            self.cManager.removeConversationBy(userID: user.userID!)
            tableView.reloadData()
            completion(true)
        })
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "zhiding", handler: { (action, view, completion) in
            //TODO: Edit
            completion(true)
        })
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        // 禁止滑动过多 删除cell
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}




extension ChatListViewController {
    
    private func setViews(){
        // 聊天会话cell
        self.tableView.register(ChatUsersTableViewCell.self, forCellReuseIdentifier: ChatUsersTableViewCell.identity())
        // 数据
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 45, 0)
        
        // 监听新的对话message
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init("refreshChat"), object: nil)
        
    }
    
 
}

extension ChatListViewController{
    
    // 刷新数据
    @objc private func refresh(){
        
        cModel = cManager.getConversaions()
        self.tableView.reloadData()
    }
    // 刷新某行数据
    func refreshRow(indexPath: IndexPath, userID:String){
        
        if let new = cManager.updateConversationBy(usrID: userID){
            cModel[indexPath.row] = new
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
    }
    
}









