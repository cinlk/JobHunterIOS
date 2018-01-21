//
//  messageMain.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


enum messageItemType:Int {
    case result = 0
    case forum
    case notification
    //case message  = "消息"
    case recommend
    case careertak
    case others
    
    
}

class messageMain: UITableViewController {

    
    
    
    // history message  record items
    lazy var ContactManger = Contactlist.shared
    
    lazy var ChatPeople:[FriendModel]? = {
        return ContactManger.getUsers()
    }()
    
    
    
    fileprivate var showItems:[showitem] = [showitem.init(name: "投递记录", image: "delivery", bubbles: 1),
                                showitem.init(name: "论坛动态", image: "forum", bubbles: 1),
                                showitem.init(name: "系统通知", image: "bell", bubbles: 1),
                                showitem.init(name: "推荐职位", image: "jobs", bubbles: 1),
                                showitem.init(name: "宣讲会", image: "voice", bubbles: 1),
                                showitem.init(name: "", image: "", bubbles: 1)]
    
    
    
    lazy var headerView:MessageMainHeaderView = {
        let v = MessageMainHeaderView.init(frame: CGRect.zero)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "conversationCell", bundle: nil), forCellReuseIdentifier: conversationCell.identity())
        buildStackItemView(items: showItems, ItemRowNumbers: 3, mainStack: headerView.mainStack, itemButtons: &headerView.itemButtons)
        headerView.itemButtons?.forEach { [unowned self] (btn) in
            btn.addTarget(self, action: #selector(chooseSub(btn:)), for: .touchUpInside)
        }
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init("refreshChat"), object: nil)
        
     }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "消息界面"
        self.tabBarController?.tabBar.isHidden = false
        
        
        //self.refresh()
    
        
     }
    override func viewWillDisappear(_ animated: Bool) {
        // 设置为空，不然子view，backbutton显示title
        self.navigationItem.title = ""
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        _ = self.tableView.tableHeaderView?.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.heightIs(150)
        
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChatPeople?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: conversationCell.identity(), for: indexPath) as! conversationCell
        let user = ChatPeople![indexPath.row]
        
        
        cell.touxiang.image = UIImage.init(named: user.avart)
        cell.name.text = user.name + " " + user.companyName
        
        //print(user,ContactManger.usersMessage[user.id]?.messages.count)
        if let messageContent =  ContactManger.getLasteMessageForUser(user: user){
            switch messageContent.type {
            case .bigGif, .smallGif:
                cell.content.text = messageContent.content
                cell.time.text = chatTimeString(with: messageContent.time)
                return cell
            case .picture:
                cell.content.text = "[图片]"
                cell.time.text = chatTimeString(with: messageContent.time)
            // 图文并排
            case .text:
                cell.content.attributedText = GetChatEmotion.shared.findAttrStr(text: messageContent.content, font: UIFont.systemFont(ofSize: 12))
                cell.time.text = chatTimeString(with: messageContent.time)
                return cell
            case .personCard:
                cell.content.text = "[个人名片]"
                cell.time.text = chatTimeString(with: messageContent.time)  
                return cell
                
            default:
                break
            }
        }
        
        return UITableViewCell.init()
       
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return conversationCell.cellHeight()
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let user = ChatPeople![indexPath.row]
        // MARK 从communication 界面返回后刷新？
        let chatView = communication(hr: user,index: indexPath ,parent: self)
        self.tabBarController?.tabBar.isHidden = true
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
            let user = self.ChatPeople![index.row]
            self.ChatPeople?.remove(at: index.row)
            self.ContactManger.removeUser(user: user, index: index.row)
            tableView.deleteRows(at: [index], with: .none)
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
            //TODO: Delete
            let user = self.ChatPeople![indexPath.row]
            self.ChatPeople?.remove(at: indexPath.row)
            self.ContactManger.removeUser(user: user, index: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        })
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "zhiding", handler: { (action, view, completion) in
            //TODO: Edit
            completion(true)
        })
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        // 禁止 full swipe 触发action
        config.performsFirstActionWithFullSwipe = false
        return config
    }

}

extension messageMain{
    
    @objc func chooseSub(btn:UIButton){
        // 影藏底部baritem
        self.tabBarController?.tabBar.isHidden = true
        //self.hidesBottomBarWhenPushed = true
        switch btn.tag {
        case  messageItemType.result.rawValue:
            let view =  deliveredHistory()
            
            self.navigationController?.pushViewController(view, animated: true)
        
        case messageItemType.notification.rawValue:
            let view = SysNotificationController()
            self.navigationController?.pushViewController(view, animated: true)
            
        case messageItemType.forum.rawValue:
            let view = UIViewController.init()
            self.navigationController?.pushViewController(view, animated: true)
        case messageItemType.recommend.rawValue:
            let view = recommendation()
            self.navigationController?.pushViewController(view, animated: true)
            
        default:
            return
        }
        
    }
}

extension messageMain{
    
    @objc private func refresh(){
        ChatPeople = ContactManger.getUsers()
        self.tableView.reloadData()
    }
}



class MessageMainHeaderView: UIView {
    
    
    lazy var mainStack:UIStackView = { [unowned self] in
       let s = UIStackView.init(frame: CGRect.zero)
       s.contentMode = .scaleAspectFit
       s.axis = .vertical
       s.distribution = .fillEqually
       s.tag = 1
       s.spacing = 10
       return s
        
    }()
    
    lazy var bottomView:UIView = {
       let v = UIView.init()
       v.backgroundColor = UIColor.init(r: 234, g: 234, b: 234)
       return v
    }()
    
    var itemButtons:[UIButton]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainStack)
        self.addSubview(bottomView)
        self.itemButtons = []
        self.backgroundColor = UIColor.white
        
        
        _ = bottomView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(10)
        _ = mainStack.sd_layout().leftEqualToView(self)?.bottomSpaceToView(self,10)?.rightEqualToView(self)?.topEqualToView(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
    
}
