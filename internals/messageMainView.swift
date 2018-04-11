//
//  messageMain.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import PPBadgeViewSwift




fileprivate let tableHeaderViewH:CGFloat = 160
fileprivate let itemCGSize:CGSize = CGSize.init(width: ScreenW / 3 - 40, height: tableHeaderViewH / 2 - 20)


enum messageItemType:Int {
    case result = 0
    case forum = 1
    case notification = 2
    //case message  = "消息"
    case recommend = 3
    case careertak = 4
    case others
}



class messageMain: UITableViewController {

    
    // 数据库
    private lazy var cManager:ConversationManager = ConversationManager.shared
    
    // 和那些人聊天
    private lazy var cModel:[conversationModel] = []
    
    
    private lazy var navigationBackView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        // naviagtionbar 默认颜色
        v.backgroundColor = UIColor.navigationBarColor()
        
        return v
    }()
    
    // table 头部显示 item
    fileprivate var showItems:[ShareItem] = [ShareItem.init(name: "投递记录", image: "delivery",type:nil, bubbles: 1),
        ShareItem.init(name: "论坛动态", image: "forum", type:nil,bubbles: 1),
        ShareItem.init(name: "系统通知", image: "bell", type:nil, bubbles: 1),
        ShareItem.init(name: "推荐职位", image: "jobs", type:nil, bubbles: 1),
        ShareItem.init(name: "宣讲会", image: "voice", type:nil, bubbles: 1),
        ShareItem.init(name: "", image: "", type:nil,  bubbles: 1)]
    
    
    
    private lazy var headerView:HeaderCollectionView = { [unowned self] in
        let v = HeaderCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderViewH), itemSize: itemCGSize)
        v.delegate = self
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        loadData()
        
    
        
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "消息记录"
        self.navigationController?.view.insertSubview(navigationBackView, at: 1)
        
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        navigationBackView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationBackView)

    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    
    override func viewWillLayoutSubviews() {
       super.viewDidLayoutSubviews()
        
        
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: conversationCell.identity(), for: indexPath) as! conversationCell
        let user = cModel[indexPath.row]
        
        cell.mode = user
        return cell 

       
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = cModel[indexPath.row]
        
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: conversationCell.self, contentViewWidth: ScreenW)
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

extension messageMain {
    
    private func setViews(){
        // 聊天会话cell
        self.tableView.register(conversationCell.self, forCellReuseIdentifier: conversationCell.identity())
        //self.tableView.register(UINib.init(nibName: "conversationCell", bundle: nil), forCellReuseIdentifier: conversationCell.identity())
        // 数据
        headerView.mode = showItems
        self.tableView.tableHeaderView = headerView
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView()
        // set naviagation
        self.navigationController?.navigationBar.settranslucent(true)
        
        // 监听新的对话message
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init("refreshChat"), object: nil)
        
    }
    
    private func loadData(){
       // 历史聊天对象
       cModel = cManager.getConversaions()
        
        
    }
}
// 子界面
extension messageMain: headerCollectionViewDelegate{
    
    func chooseItem(index: Int) {
        
        switch index {
        case  messageItemType.result.rawValue:
            let view =  deliveredHistory()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
            
        case messageItemType.notification.rawValue:
            let view = SysNotificationController()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
            
        case messageItemType.forum.rawValue:
            let view = ForumViewController()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
        case messageItemType.recommend.rawValue:
            let view = recommendation()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
            
        default:
            return
        }
        
    }
    
    
    
  
}

extension messageMain{
    
    // 刷新数据
    @objc private func refresh(){
          
          cModel = cManager.getConversaions()
          self.tableView.reloadData()
//        ChatPeople = ContactManger.getUsers()
//        self.tableView.reloadData()
    }
    // 刷新某行数据
    func refreshRow(indexPath: IndexPath, userID:String){
        
        if let new = cManager.updateConversationBy(usrID: userID){
            cModel[indexPath.row] = new
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
    }
    
}


