//
//  communication.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


enum  cellType:String {
    case card = "card"
    case chat = "chat"
    case detail = "detail"
}


class communication: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var coverView:UIView?
    
    var tableView:UITableView = UITableView()
    // chat message and card info
    var tableSource:NSMutableArray = []
    
    //
    var InputBar:FHInputToolbar!
    
    var friend:FriendData = FriendData.init(name: "locky", avart: "avartar")
    let myself:FriendData = FriendData.init(name: "lk", avart: "lk")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hidden keyboard
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(hiddenKeyboard(sender:)))
        self.tableView.addGestureRecognizer(gest)
        
        
        
        //背景图片
        let backGroudImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "chatBackground"))
        backGroudImageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(backGroudImageView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(messageCell.self, forCellReuseIdentifier: messageCell.reuseidentify())
        
        self.tableView.register(CellCard.self, forCellReuseIdentifier: CellCard.identify())
        
        
        let headerView:UIView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 10)
        headerView.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = headerView
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        
        
        // input bar
        self.InputBar = FHInputToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height-44, width: UIScreen.main.bounds.width, height: 44))
        
         self.tableView.frame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 60 - self.InputBar.frame.height)
        
        self.InputBar.delage = self
        self.view.addSubview(InputBar)
        
        //keyboard notification, textfield
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
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
        titleLabel.textColor = UIColor.black
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
        
        if let card:Dictionary<String,String> = self.tableSource.object(at: indexPath.row) as? Dictionary<String,String>{
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellCard.identify(), for: indexPath) as! CellCard
            
            cell.jobname.text = card["jobname"]
            cell.salary.text = card["salary"]
            cell.company.text = card["companyName"]
            cell.desc.text = card["locate"]! + "/" + "其他"
        
            return cell
        }
        
        if let chatmessage:MessageBoby = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            let cell = tableView.dequeueReusableCell(withIdentifier: messageCell.reuseidentify(), for: indexPath) as! messageCell
            cell.selectionStyle = .none
            
            cell.setupMessageCell(messageInfo: self.tableSource.object(at: indexPath.row) as! MessageBoby, user: myself)
        
            return cell
        }
        
        return UITableViewCell.init(style: .default, reuseIdentifier: "nil")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message:MessageBoby  = self.tableSource.object(at: indexPath.row) as? MessageBoby{
        return messageCell.heightForCell(messageInfo: message)
        }
        return CellCard.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cardInfo:Dictionary<String,String>  = self.tableSource.object(at: indexPath.row) as?
            Dictionary<String,String>{
            let detail =  JobDetailViewController()
            detail.infos = cardInfo
            // 子视图 返回lable修改为空
            let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(detail, animated: true)
        }
        return
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.InputBar.textField.resignFirstResponder()
//    }
    
    
 

}

extension communication{
    
    // chat begin by jobcard
    func chatWith(friend:FriendData,jobCard:Dictionary<String,String>?){
        self.friend  = friend
        self.setupNavigationTitle(text: self.friend.name)
        self.tableSource.removeAllObjects()
        if jobCard != nil{
            self.tmpTableSurce2(jobCard!)
        }else{
            self.tmpTableSource()
        }
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
    
    // fake data  starting with job card
    func tmpTableSurce2(_ card:Dictionary<String,String>){
        self.tableSource.add(card)
        let message1:MessageBoby = MessageBoby.init(content: "我是lk", time: "10-13")
        message1.sender = myself
        self.tableSource.add(message1)
        
        let message2:MessageBoby = MessageBoby.init(content: "哦哦哦!", time: "10-12")
        message2.sender = friend
        self.tableSource.add(message2)
        
        
    }
    
    func hiddenKeyboard(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            self.InputBar.textField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
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
            self.tableView.frame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64-self.InputBar.frame.height-keyboardFrame.size.height)
            self.InputBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height-44-keyboardFrame.size.height, width: UIScreen.main.bounds.width, height: 44)
            
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
            self.tableView.frame = CGRect.init(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height-64-self.InputBar.frame.height)
        })
        
        self.InputBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height-44, width: UIScreen.main.bounds.width, height: 44)
    }
    
}



class CellCard:UITableViewCell{
    
    
    var jobname:UILabel!
    var company:UILabel!
    var desc:UILabel!
    var salary:UILabel!
    
    var backgView: UIView?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        jobname = UILabel()
        jobname.font = UIFont.boldSystemFont(ofSize: 15)
        jobname.textAlignment = .left
        jobname.textColor = UIColor.black
        company = UILabel()
        company.font = UIFont.systemFont(ofSize: 12)
        company.textAlignment = .left
        company.textColor = UIColor.black
        desc = UILabel()
        desc.font = UIFont.systemFont(ofSize: 10)
        desc.textAlignment = .left
        desc.textColor = UIColor.lightGray
        salary = UILabel()
        salary.font = UIFont.boldSystemFont(ofSize: 12)
        salary.textAlignment = .center
        salary.textColor = UIColor.red
        backgView = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgView?.backgroundColor = UIColor.white
        
        self.backgView?.addSubview(jobname)
        self.backgView?.addSubview(company)
        self.backgView?.addSubview(desc)
        self.backgView?.addSubview(salary)
        _ = jobname.sd_layout().topSpaceToView(backgView,5)?.leftSpaceToView(backgView,10)?.widthIs(120)?.heightIs(20)
        
        _ = company.sd_layout().topSpaceToView(jobname,5)?.leftSpaceToView(backgView,10)?.widthIs(120)?.heightIs(20)
        
        _ = desc.sd_layout().topSpaceToView(company,5)?.leftSpaceToView(backgView,10)?.widthIs(180)?.heightIs(15)
        
        _ = salary.sd_layout().topSpaceToView(backgView,5)?.rightSpaceToView(backgView,10)?.widthIs(100)?.heightIs(20)
        
        self.backgView?.layer.shadowColor = UIColor.black.cgColor
        self.backgView?.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.backgView?.layer.shadowOpacity = 0.7
        self.backgView?.layer.shadowRadius = 0.8
        //self.backgView?.layer.shadowPath = CGPath.init(rect: self.bounds, transform: nil)
        
        
        self.contentView.addSubview(backgView!)
        _ = backgView?.sd_layout().leftSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    func createCell(info:Dictionary<String,String>){
//
//    }
    
    class func identify()->String{
        return cellType.card.rawValue
    }
    
    class func height()->CGFloat{
        return 85
    }
    
}



