//
//  communication.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class communication: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var coverView:UIView?
    
    var tableView:UITableView = UITableView()
    
    var tableSource:NSMutableArray = []
    
    //
    var InputBar:FHInputToolbar!
    
    var friend:FriendData = FriendData.init(name: "locky", avart: "avartar")
    let myself:FriendData = FriendData.init(name: "lk", avart: "lk")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hidden keyboard
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(hiddenKeyboard))
        gest.numberOfTapsRequired = 1
        self.tableView.addGestureRecognizer(gest)
        
        // load fake data
        self.tmpTableSource()
        
        
        //背景图片
        let backGroudImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "chatBackground"))
        backGroudImageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(backGroudImageView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(messageCell.self, forCellReuseIdentifier: messageCell.reuseidentify())
       
        
        let headerView:UIView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 10)
        headerView.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = headerView
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        
        
        // input bar
        self.InputBar = FHInputToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height-44, width: UIScreen.main.bounds.width, height: 44))
        
         self.tableView.frame = CGRect.init(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60 - self.InputBar.frame.height)
        
        self.InputBar.delage = self
        self.view.addSubview(InputBar)
        
        //keyboard notification, textfield
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        
        
        
        
        self.setupNavigationTitle(text: friend.name)
        
        
       
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // remove self when destroied
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNavigationTitle(text:String){
        
        let title = text.components(separatedBy: "@")[0]
        
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 50, y: 0, width: 220, height: 44))
        
        titleLabel.text = title
        titleLabel.textColor = UIColor.yellow
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        //self.navigationItem.title = title
        self.navigationItem.titleView = titleLabel
        
        
        
        
        
    }
    
    
    // tablevew delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCell.reuseidentify()) as! messageCell
        
        cell.selectionStyle = .none
        cell.setupMessageCell(messageInfo: self.tableSource.object(at: indexPath.row) as! MessageBoby, user: myself)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageCell.heightForCell(messageInfo: self.tableSource.object(at: indexPath.row) as! MessageBoby)
        
        
        
        
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.InputBar.textField.resignFirstResponder()
//    }
    
    
 

}

extension communication{
    
    func chatWith(friend:FriendData){
        self.friend  = friend
        self.setupNavigationTitle(text: self.friend.name)
        self.tableSource.removeAllObjects()
        self.tmpTableSource()
        self.tableView.reloadData()
        
        
    }
    // fake data source
    func tmpTableSource(){
        let message1:MessageBoby = MessageBoby.init(content: "你好啊!", time: "10-12")
        message1.sender = friend
        self.tableSource.add(message1)
        
        let message2:MessageBoby = MessageBoby.init(content: "你的名字?", time: "10-12")
        message2.sender = friend
        self.tableSource.add(message2)
        
        
        let message3:MessageBoby = MessageBoby.init(content: "我是lk", time: "10-13")
        message3.sender = myself
        self.tableSource.add(message3)
        let message4:MessageBoby = MessageBoby.init(content: "吊袜带挖达瓦大文的哇达瓦达瓦大文件的骄傲我达瓦大就按我的骄傲我大家洼达瓦大文大无大无多无大无大无多哇大无多无", time: "10-13")
        message4.sender = myself
        self.tableSource.add(message4)
        
        
        
        
        
    }
    
    func hiddenKeyboard(){
        self.InputBar.textField.resignFirstResponder()
    }
}


extension communication:FHInputToolbarDelegate{
    func onInputBtnTapped(text: String) {
        if (text.isEmpty){
            return
        }
        
        //MARK connected back server
        
        
        let lastMessage:MessageBoby = self.tableSource.lastObject as! MessageBoby
        
        let message:MessageBoby = MessageBoby.init(content: text, time: "10-14")
        message.sender = myself
        
        self.tableSource.add(message)
        self.tableView.reloadData()
        // 滚动效果
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
        
        
        
    }
    
    func onleftBtnTapped(text: String) {
        
    }
    
    func keyboardChange(notify:Notification){
        let userinfo = notify.userInfo
        
        let duration = userinfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        let keyboardFrame = (userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: duration, animations: {
            self.tableView.frame = CGRect.init(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height-60-self.InputBar.frame.height-keyboardFrame.height)
            self.InputBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height-44-keyboardFrame.height, width: UIScreen.main.bounds.width, height: 44)
            
        }) { (Bool) in
            let path:IndexPath = IndexPath.init(row: self.tableSource.count-1, section: 0)
            self.tableView.scrollToRow(at: path, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
        
    }
    
    func keyboardhidden(notify:Notification){
        print("triger keyborad hidden")
        let userinfo = notify.userInfo
        
        let duration = userinfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration, animations: {
            self.tableView.frame = CGRect.init(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height-60-self.InputBar.frame.height)
        })
        
        self.InputBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height-44, width: UIScreen.main.bounds.width, height: 44)
    }
    
}
