//
//  ChatListViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/19.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UserNotifications

fileprivate let deleteTitle:String = "删除"

class ChatListViewController: BaseTableViewController {

    // 用户
    private var user:GlobalUserInfo = GlobalUserInfo.shared
    
    
    // 数据库
    private lazy var cManager:ConversationManager = ConversationManager.shared
    
    // 和那些人聊天
    private var cModel:[ChatListModel] = []
    //private var unRead:Bool = false
    private var deleteRow = 0
    
    private lazy var deleteAlertShow:UIAlertController = {
        
        let alertVC = UIAlertController.init(title: "请确认", message: "删除后聊天记录不存在", preferredStyle: UIAlertController.Style.alert)
        
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [unowned self] (action) in
            self.deleteMode(row: self.deleteRow)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        return alertVC
        
    }()
    
    private let httpServer:MessageHttpServer = MessageHttpServer.shared
    private lazy var  dispose:DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadMessage()
        //self.tableView.refreshControl?
        
        // test 本地消息通知
        //creating the notification content
//        let content = UNMutableNotificationContent()
//
//        //adding title, subtitle, body and badge
//        content.title = "local notify"
//        content.subtitle = "测试"
//        content.body = "通知内容"
//        content.badge = 1
//
//        //getting the notification trigger
//        //it will be called after 5 seconds
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//
//        //getting the notification request
//        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

        
    }
    
    
    override  func setViews(){
        
        //
        user.updateDelegate = self
        // 聊天会话cell
        self.tableView.register(ChatUsersTableViewCell.self, forCellReuseIdentifier: ChatUsersTableViewCell.identity())
        // 数据
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
        
        //self.tableView.contentInsetAdjustmentBehavior = .never
        
        // 设置h下拉刷新d事件
        self.tableView.refreshControl = UIRefreshControl.init()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        // 刷新聊天对象列表
        NotificationCenter.default.rx.notification(NotificationName.refreshChatList).subscribe(onNext:  {  [weak self] (notify) in
            self?.loadMessage()
        
        }).disposed(by: self.dispose)
        // 刷新某行聊天数据
        NotificationCenter.default.rx.notification(NotificationName.refreshChatRow, object: nil).subscribe(onNext: { [weak self] (notify) in
            
            guard  let row = notify.userInfo?["row"] as? Int else {
                return
            }
            guard let conid = notify.userInfo?["conversationId"] as? String else {
                return
            }
            
            
            if let new = self?.cManager.getConversationBy(conversationId: conid), let `self` = self{
                self.cModel[row] = new
                self.sortMode(datas: &self.cModel)
                self.tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
                
            }
        }).disposed(by: self.dispose)
//        // 监听新的对话message
//        NotificationCenter.default.addObserver(self, selector: #selector(addMessage), name: NSNotification.Name.init("refreshChat"), object: nil)
//
//
//        // 对话添加消息后 监听
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshRow), name: NSNotification.Name.init("refreshChatRow"), object: nil)
//
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    
    
   
    
    deinit {
        print("deinit chatlistvc")
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
        let m = cModel[indexPath.row]
        cell.backgroundColor = m.isUp ? UIColor.init(r: 225, g: 255, b: 255) : UIColor.white
        cell.mode = m
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = cModel[indexPath.row]
        
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ChatUsersTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let conv = cModel[indexPath.row]
        
        // 获取hr 信息
        //conv.recruiterId
    
 
        GlobalUserInfo.shared.buildConversation(conversation: conv.conversationId, talkWith: conv.recruiterId!, jobId: conv.jobId!, completed: { [weak self] (con, error) in
            if error != nil {
                //print(err)
                self?.view.showToast(title: "获取会话失败", customImage: nil, mode: .text)
                return
            }
            //  跳转到聊天界面
            let chatVC = CommunicationChatView.init(recruiterId: conv.recruiterId!, row: indexPath.row, conversation: con)
            
            chatVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(chatVC, animated: true)
            
            // 清楚已读消息数
            try? self?.cManager.clearUnReadCountBy(conversationId: conv.conversationId!)
            self?.cModel[indexPath.row].unreadCount = 0
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            
//            SingletoneClass.shared.setMessageBadge(conversationId: (con?.conversationId)!, count: 0)
//            if let cell = tableView.cellForRow(at: indexPath) as? ChatUsersTableViewCell{
//                cell.icon.pp.addBadge(number: 0)
//            }
            
        })
        
        
        
        
      
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 判断是否已近置顶
        let mode = cModel[indexPath.row]
        let status = mode.isUp ? "取消置顶" : "置顶"
        
        let edit = UITableViewRowAction.init(style: .normal, title: status) { [unowned self] (action, index) in
            
            if self.cManager.setUpConversation(conversationId: mode.conversationId!, isUp: !mode.isUp){
                mode.isUp = !mode.isUp
                // 置顶的在前面  然后更加时间降序排序
                self.sortMode(datas: &self.cModel)
                
                tableView.reloadData()
            }
           
            
            
        }
        
        edit.backgroundColor = UIColor.blue
        edit.accessibilityFrame  = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        // 用 normal 状态 自己控制删除cell
        let delete = UITableViewRowAction.init(style: .normal, title: deleteTitle) { [unowned self] (action, index) in
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
        let status = mode.isUp ? "取消置顶" : "置顶"
        
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "删除", handler: { [unowned self] (action, view, completion) in
           
            self.deleteRow = indexPath.row
            self.present(self.deleteAlertShow, animated: true, completion: nil)
            
            completion(true)
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: status, handler: { [unowned self] (action, view, completion) in
           
            if self.cManager.setUpConversation(conversationId: mode.conversationId!, isUp: !mode.isUp){
                mode.isUp = !mode.isUp
                
                // 置顶的在前面  然后更加时间降序排序
                self.sortMode(datas: &self.cModel)
                
                tableView.reloadData()
                completion(true)
            }
        })
        
        editAction.backgroundColor = UIColor.blue
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        // 禁止滑动过多 删除cell
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}






extension ChatListViewController{
    
    // 刷新
    @objc private func refresh(){
        self.tableView.refreshControl?.beginRefreshing()
        self.loadMessage()
        self.tableView.refreshControl?.endRefreshing()
        
    }
    // 本地加入新的h聊天记录
    @objc private func addMessage(){
        
    }
    
    // 获取本地历史消息 和 远程服务器最新消息
    private func loadMessage(){
        // 登录的用户
        if GlobalUserInfo.shared.isLogin == false {
            self.didFinishloadData()
            return
        }
//        guard let userId = GlobalUserInfo.shared.getAccount() else {
//            return
//        }

        // 获取历史 cconversation list
        cModel =  cManager.getConversaions()
 
        self.didFinishloadData()
        
    }
    
    // 列表排序
    private func sortMode( datas: inout [ChatListModel]){
        guard datas.count > 0 else {
            return
        }
        
        datas.sort { (a, b) -> Bool in
            if  a.isUp && b.isUp {
                let atime = a.upTime ?? Date.init(timeIntervalSince1970: 0)
                let btime = b.upTime ?? Date.init(timeIntervalSince1970: 0)
                
                return atime >= btime
                
            }else if a.isUp && b.isUp == false{
                return true
            }else if  a.isUp == false && b.isUp == false  {
                let atime = a.createdTime ?? Date.init(timeIntervalSince1970: 0)
                let btime = b.createdTime ?? Date.init(timeIntervalSince1970: 0)
                
                return atime >= btime
            }else{
                return false
            }
        }
        
        
    }
    
    // 删除某行
    private func deleteMode(row:Int){
        
        let c = self.cModel[row]
        guard  let conid = c.conversationId else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // 服务器数据删除 TODO
            // 本地数据删除
            self?.cManager.removeConversationBy(id: conid) { bool, error in
                
                
                if bool{
                    DispatchQueue.main.async {
                        self?.cModel.remove(at: row)
                        self?.tableView.deleteRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
                    }
                }else{
                    //print(error)
                    
                }
            }
        }
      
       
    }
    
}


extension ChatListViewController{
    private func buildLocalMessage(con:AVIMConversation, msg: AVIMMessage){
        
        switch msg.mediaType{
            
        case .text:
            let textMsg = msg as! AVIMTextMessage
            
            // 判断attribute
            if let type = textMsg.attributes?["type"] as? String, let mtype =  MessgeType.init(rawValue: type){
                print("receive text messga \(String(describing: textMsg.text)) from \(String(describing: textMsg.clientId)) with attribute \(String.init(describing: textMsg.attributes))" )
                switch mtype{
                case .text:
                    // 刷新table
                    if let m = MessageBoby.init(JSON: [
                        "conversation_id": con.conversationId!,
                        "type": MessgeType.text.describe,
                        "content": textMsg.text!,
                        "creat_time": Date.init().timeIntervalSince1970,
                        "is_read": true,
                        "sender_id": textMsg.clientId!,
                        "receiver_id": self.user.getId()!
                        ]){
                        try? self.cManager.insertMessageItem(items: [m])
                        
                    }
                case .bigGif, .smallGif:
                    if let m = GifImageMessage.init(JSON: [
                        "conversation_id": con.conversationId!,
                        "type": mtype.describe,
                        "creat_time": Date.init().timeIntervalSince1970,
                        "is_read": true,
                        "sender_id": textMsg.clientId!,
                        "receiver_id": self.user.getId()!,
                        "local_gif_name": (textMsg.attributes?["name"] as! String)
                        ]){
                        try? self.cManager.insertMessageItem(items: [m])
                    }
                default:
                    print("unkown message type")
                }
            }
        case .image:
            let imageMsg = msg as! AVIMImageMessage
            
            
            print("receive location messga \(String(describing: imageMsg.text)) from \(String(describing: imageMsg.clientId)) with attribute \(String.init(describing: imageMsg.attributes)) \(String.init(describing:  imageMsg.file?.url()))")
            
            if let m  = PicutreMessage.init(JSON: [
                "conversation_id": con.conversationId!,
                "type": MessgeType.picture.describe,
                "content": (imageMsg.file?.url())!,
                //"fileName": imageName,
                "fileUrl": (imageMsg.file?.url())!,
                "creat_time": Date.init().timeIntervalSince1970,
                "is_read": true,
                "sender_id": imageMsg.clientId!,
                "receiver_id": self.user.getId()!,
                "sended": true,
                ]){
                try? self.cManager.insertMessageItem(items: [m])
            }
            
            
        case .location:
            
            let locationMsg = msg as! AVIMLocationMessage
            
            print("receive location messga \(String(describing: locationMsg.text)) from \(String(describing: locationMsg.clientId)) with attribute \(String.init(describing: locationMsg.attributes))")
            
            if let m = LocationMessage.init(JSON: [
                "conversation_id": con.conversationId!,
                "type": MessgeType.location.describe,
                "creat_time": Date.init().timeIntervalSince1970,
                "is_read": true,
                "sender_id": locationMsg.clientId!,
                "receiver_id": (self.user.getId())!,
                "latitude":  Double(locationMsg.latitude),
                "longitude": Double(locationMsg.longitude),
                "address":  (locationMsg.attributes?["address"] as! String)
                ]){
                try? self.cManager.insertMessageItem(items: [m])
            }
        default:
            break
            
        }
    
    }
}


// 收到消息更新界面
extension ChatListViewController: UpdateChatlistDelegate{
    
    func updateChatList(con: AVIMConversation, messages: [AVIMMessage]) {
        
        // 转换为 messageBody 存入数据库
        // 未读消息个数
        //try? self.cManager.updateUnreadedMessageCount(conversationId: con.conversationId!, count: messages.count)
        // 某个消息插入失败怎么办??
        
        
        messages.forEach { [weak self] (msg) in
            self?.buildLocalMessage(con: con, msg: msg)
        }
        
        
        // 更新存在的conversation 未读消息
        for (index, item) in self.cModel.enumerated(){
            if item.conversationId == con.conversationId{
                if let new = self.cManager.getConversationBy(conversationId: item.conversationId!){
                    self.cModel[index] = new
                    self.sortMode(datas: &self.cModel)
                    self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                    
                }
                
                
//                if let con = self.cManager.getConversationBy(conversationId: item.conversationId!),  let unreadCount = con.unreadCount{
//                    self.cModel[index].unreadCount = unreadCount
//
//
//                }
//                let  (lastMsg, _) = self.cManager.getLasteMessageBy(conversationId: item.conversationId!)
//                if lastMsg != nil{
//                    self.cModel[index].lastMessage = lastMsg
//
//                }
//
//
//                 self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.none)
                
                
            }
        }

    }
    
    
}








