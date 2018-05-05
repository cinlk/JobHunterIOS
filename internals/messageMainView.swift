//
//  messageMain.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import PPBadgeViewSwift



fileprivate let iconSize:CGSize = CGSize.init(width: 40, height: 40)
fileprivate let tableHeaderViewH:CGFloat = 100
fileprivate let itemCGSize:CGSize = CGSize.init(width: ScreenW / 3 - 40, height: tableHeaderViewH - 20 )


fileprivate enum messageItemType:String {
    
    case delivery = "投递记录"
    case forum = "论坛动态"
    case invitation = "我的邀约"
    case visitor = "看过我"
    case notification = "通知"
    
}



class messageMain: UITableViewController {

    
    // 数据库
    private lazy var cManager:ConversationManager = ConversationManager.shared
    
    // 和那些人聊天
    private lazy var cModel:[conversationModel] = []
    
    
    // table 头部显示 item
    fileprivate var showItems:[ShareItem] = [
        ShareItem.init(name: "投递记录", image: "delivery", type:nil,bubbles: 1),
        ShareItem.init(name: "我的邀约", image: "bell", type:nil, bubbles: 1),
        ShareItem.init(name: "看过我", image: "jobs", type:nil, bubbles: 1)
    ]
    
    
    
    
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
        self.navigationItem.title = "消息"
        self.navigationController?.insertCustomerView()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
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
// 实现header的代理
extension messageMain: headerCollectionViewDelegate{
    
    func chooseItem(name: String) {
        
        switch name {
            
        case messageItemType.invitation.rawValue:
            
            let view = InvitationViewController()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
            
        case messageItemType.delivery.rawValue:
            let view = deliveredHistory()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)

            
        case messageItemType.forum.rawValue:
            let view = ForumViewController()
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
            
        case messageItemType.visitor.rawValue:
            let view = MyVisitor()
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
    }
    // 刷新某行数据
    func refreshRow(indexPath: IndexPath, userID:String){
        
        if let new = cManager.updateConversationBy(usrID: userID){
            cModel[indexPath.row] = new
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
    }
    
}




// 对话cell
@objcMembers fileprivate class conversationCell: UITableViewCell {
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 120)
        return label
    }()
    
    private lazy var content: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        return label
    }()
    
    private lazy var time: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 120)
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    
    dynamic var mode:conversationModel?{
        didSet{
            
            guard let user = mode?.user else { return }
            guard let mes = mode?.message else { return }
            
            guard let iconData = user.icon else { return }
            
            self.icon.image = UIImage.init(data: iconData) ?? #imageLiteral(resourceName: "default")
            self.name.text =  user.name! + "@" + user.company!
            
            self.content.text = mes.getContent(isConversion: true) as? String
            
            self.time.text =  mes.creat_time?.string()
            self.setupAutoHeight(withBottomViewsArray: [icon,content], bottomMargin: 10)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [name, content, time, icon]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = content.sd_layout().leftEqualToView(name)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        _ = time.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        
        // 圆角是宽度的05倍
        icon.sd_cornerRadiusFromWidthRatio = 0.5
        content.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    class func identity()->String{
        return "conversationCell"
    }
    
    class func cellHeight()->CGFloat {
        return 60.0
    }
    
    
}

