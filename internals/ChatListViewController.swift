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
    private var cModel:[conversationModel] = []
    private var unRead:Bool = false
    
    
    private var deleteRow = 0
    
    private lazy var deleteAlertShow:UIAlertController = {
        let alertVC = UIAlertController.init(title: "请确认", message: "删除后聊天记录不存在", preferredStyle: UIAlertControllerStyle.alert)
        
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            self.deleteMode(row: self.deleteRow)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        return alertVC
        
    }()
    
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
        cell.backgroundColor = user.isUP ? UIColor.init(r: 225, g: 255, b: 255) : UIColor.white
        
        cell.mode = user
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = cModel[indexPath.row]
        
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ChatUsersTableViewCell.self, contentViewWidth: ScreenW)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let conv = cModel[indexPath.row]
        
        //var weakSelf d = sef
        let chatView = CommunicationChatView(hr: conv.user!, row: indexPath.row)
        
        // 清楚 该会话未读消息标记
        if  let _ = conv.unReadCount {
            cManager.clearUnReadMessageBy(userID: (conv.user?.userID)!)
            conv.unReadCount = nil
            // 阅读未读数据后  刷新该行
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        
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
        // 判断是否已近置顶
        let mode = cModel[indexPath.row]
        let status = mode.isUP ? "取消置顶" : "置顶"
        
        let edit = UITableViewRowAction.init(style: .normal, title: status) { (action, index) in
            
            self.cManager.updateConversationUPStatus(userID: (mode.user?.userID)!, isUp: !mode.isUP)
            
            mode.isUP = !mode.isUP
            
            // 置顶的在前面  然后更加时间降序排序
            self.sortMode(datas: &self.cModel)
            
            tableView.reloadData()
            
            
        }
        
        edit.backgroundColor = UIColor.blue
        edit.accessibilityFrame  = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        // 用 normal 状态 自己控制删除cell
        let delete = UITableViewRowAction.init(style: .normal, title: "删除") { [unowned self] (action, index) in
            self.deleteRow = indexPath.row
            self.present(self.deleteAlertShow, animated: true, completion: nil)
            
        }
        delete.backgroundColor = UIColor.red
        delete.accessibilityFrame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        // 删除不能放前面 出现滑动删除效果
        return [edit,delete]
    }
    
    // ios 11  cell swipe 功能
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        // 判断是否已近置顶
        let mode = cModel[indexPath.row]
        let status = mode.isUP ? "取消置顶" : "置顶"
        
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "删除", handler: { (action, view, completion) in
           
            self.deleteRow = indexPath.row
            self.present(self.deleteAlertShow, animated: true, completion: nil)
            
            completion(true)
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: status, handler: { (action, view, completion) in
           
            self.cManager.updateConversationUPStatus(userID: (mode.user?.userID)!, isUp: !mode.isUP)

            mode.isUP = !mode.isUP
            
            // 置顶的在前面  然后更加时间降序排序
            self.sortMode(datas: &self.cModel)

            tableView.reloadData()
            completion(true)
        })
        
        editAction.backgroundColor = UIColor.blue
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
        
        // 对话添加消息后 监听
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRow), name: NSNotification.Name.init("refreshChatRow"), object: nil)
        
    }
    
 
}

extension ChatListViewController{
    
    // 刷新数据
    @objc private func refresh(){
       
        (cModel,unRead) = cManager.getConversaions()
        
        
        //  为读消息 显示提示
//        if  unRead{
//            self.navigationController?.tabBarItem.pp.addDot(color: UIColor.red)
//
//         }
        
        self.tableView.reloadData()
    }
    
    
    
    // 详细聊天界面 输入数据后 返回 刷新某行数据
   @objc private func refreshRow(notify:Notification){
        
        
        guard  let row = notify.userInfo?["row"] as? Int else {
            return
        }
        guard let userID = notify.userInfo?["userID"] as? String else {
            return
        }
        
        
        if let new = cManager.getConversationBy(usrID: userID){
            cModel[row] = new
            
            self.sortMode(datas: &cModel)
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
    // 列表排序
    private func sortMode( datas: inout [conversationModel]){
        guard datas.count > 0 else {
            return
        }
        
        datas.sort { (a, b) -> Bool in
            if  (a.isUP && b.isUP) || (a.isUP == false && b.isUP == false) {
                return a.upTime! >= b.upTime!
                
            }else if a.isUP && b.isUP == false{
                return true
            }else{
                return false
            }
        }
        
        
    }
    
    // 删除某行
    private func deleteMode(row:Int){
        
        let user = self.cModel[row]
        self.cModel.remove(at: row)
        self.cManager.removeConversationBy(userID: (user.user?.userID)!)
        tableView.reloadData()
    }
    
}









