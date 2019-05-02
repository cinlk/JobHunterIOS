//
//  ForumMessageVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SystemMessageViewController: UIViewController {

    
    private lazy var dispose = DisposeBag.init()
    private lazy var vm: MessageViewModel = MessageViewModel.init()
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        tb.tableFooterView = UIView()
        tb.separatorStyle = .singleLine
        tb.backgroundColor = UIColor.viewBackColor()
        tb.register(itemCell.self, forCellReuseIdentifier: itemCell.identity())
        return tb
    }()
    
    
    private lazy var modes:[(UIImage, String, Bool)] = [( #imageLiteral(resourceName: "systemNotify") ,"系统通知", false),(#imageLiteral(resourceName: "selectedthumbup"),"赞", false),(#imageLiteral(resourceName: "commentMessage"),"回复我的", false),(#imageLiteral(resourceName: "commentMessage"),"我的回复", false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modes[0].2 = HasNewSystemMessage.has
        self.modes[1].2 = HasNewThumbUpMessage.has
        self.modes[2].2 = HasForumReply2Me.has
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
        
        setViewModel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("deinit forumMessageVC \(String.init(describing: self))")
    }
    

}

extension SystemMessageViewController{
    private func setViewModel(){
        
        
        
        NotificationCenter.default.rx.notification(NotificationName.systemMessage, object: nil).subscribe(onNext: { [weak self] (notify) in
            if  let exist = notify.userInfo?["system"] as? Bool, exist{
                // 更新cell
                self?.modes[0].2 = true
                self?.table.reloadData()
            }
            if let exist = notify.userInfo?["thumbUp"] as? Bool, exist{
                self?.modes[1].2 = true
                self?.table.reloadData()
                
            }
            if let exist = notify.userInfo?["reply"] as? Bool, exist{
                self?.modes[2].2 = true
                self?.table.reloadData()
                
            }
            
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
}

extension SystemMessageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: itemCell.identity(), for: indexPath) as? itemCell{
            cell.mode = modes[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return itemCell.cellHeight()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        guard  let userId = GlobalUserInfo.shared.getId() else { return}
        
        self.modes[indexPath.row].2 = false
        table.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        
        
        switch indexPath.row {
            case 0:
                let vc = UIViewController.init()
                vc.view.backgroundColor = UIColor.lightText
                self.navigationController?.pushViewController(vc, animated: true)
                self.vm.updateNewSystemMessageTime.onNext(userId)
                HasNewSystemMessage.has = false
            case 1:
                let thumb = ThumbUPVC()
                thumb.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(thumb, animated: true)
                HasNewThumbUpMessage.has = false
                self.vm.updateThumbUpMessageTime.onNext(userId)
            case 2:
                let mycomment = ReplyToMeVC()
                mycomment.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(mycomment, animated: true)
                HasForumReply2Me.has = false
                self.vm.updateReply2MeTime.onNext(userId)
            case 3:
                let replyMe = MyCommentVC()
                replyMe.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(replyMe, animated: true)
            default:
                break
        }
        
    }
    
    
    
}

// 图片的文本cell

fileprivate class itemCell:IconWithTitleTableViewCell{
    
    
    internal var mode:(image:UIImage, name:String, badge:Bool)?{
        didSet{
            guard let mode = mode  else {
                return
            }
            
            if mode.badge{
                //self.wrapperIcon.pp.setBadge(height: 10)
                self.wrapperIcon.pp.moveBadge(x: 0, y: 5)
                self.wrapperIcon.pp.setBadge(height: 10)
                self.wrapperIcon.pp.addDot(color: UIColor.red)
            }else{
                self.wrapperIcon.pp.hiddenBadge()
            }
            self.icon.image = mode.image
            self.iconName.text = mode.name
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.line.isHidden = true
        wrapperIcon.sd_resetNewLayout()
        iconName.sd_resetNewLayout()
        
        _ = wrapperIcon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(40)?.heightIs(40)
        _ = iconName.sd_layout().leftSpaceToView(wrapperIcon,10)?.centerYEqualToView(wrapperIcon)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "itemCell"
    }
    
    class func cellHeight()->CGFloat{
        return 50
    }
}
