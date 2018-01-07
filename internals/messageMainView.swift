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
    var records:[String] = ["人1","人2","人3"]
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
     }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "消息界面"
        self.tabBarController?.tabBar.isHidden = false
        
     }
    override func viewWillDisappear(_ animated: Bool) {
        // 设置为空，不然子view，backbutton显示title
        self.navigationItem.title = ""
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
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: conversationCell.identity(), for: indexPath) as! conversationCell
        cell.touxiang.image = UIImage.init(named: "avartar")
        cell.name.text = "测试  公司"
        cell.content.text = "最后一条消息"
        cell.time.text = "2018-01-01"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return conversationCell.cellHeight()
    }
    
   
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if let cell  =  tableView.cellForRow(at: indexPath) as? messageItemCell{
//
//            // 子视图 返回lable修改为空
//            let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
//            self.navigationItem.backBarButtonItem = backButton
//
//            switch (cell.category.text)! {
//            case messageItemType.forum.rawValue:
//                let fview =  forumView()
//                fview.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(fview, animated: true)
//
//
//            case messageItemType.result.rawValue:
//                let rview =  deliveredHistory()
//                rview.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(rview, animated: true)
//            case messageItemType.recommend.rawValue:
//                let rview = recommendation()
//                rview.hidesBottomBarWhenPushed = true
//
//                self.navigationController?.pushViewController(rview, animated: true)
//            case messageItemType.relationshp.rawValue:
//                let rview = relationship()
//                rview.hidesBottomBarWhenPushed = true
//
//                self.navigationController?.pushViewController(rview, animated: true)
//            case messageItemType.message.rawValue:
//                // 消息好友列表
//                let mview = friendsController()
//                mview.hidesBottomBarWhenPushed = true
//
//                self.navigationController?.pushViewController(mview, animated: true)
//
//            default:
//                print("not found item")
//
//            }
//        }
        
        
        
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
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




private let ItemRowNumbers = 3
private let ItemviewW = ScreenW / 3

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
