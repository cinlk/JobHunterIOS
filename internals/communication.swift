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

enum ShowType:Int {
    case keyboard
    case moreView
    case emotion
    case none
}


class communication: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // showtype
    var st: ShowType = ShowType.none
    
    var coverView:UIView?
    
    var tableView:UITableView = UITableView()
    // chat message and card info
    var tableSource:NSMutableArray = []
    
    //
    //var InputBar:FHInputToolbar!
    var chatBarView:ChatBarView!
    
    
    var friend:FriendData = FriendData.init(name: "locky", avart: "avartar")
    let myself:FriendData = FriendData.init(name: "lk", avart: "lk")
    
    
    //
    var keyboardFrame:CGRect?
 
    var currentChatBarHright:CGFloat = 0
    
    // more
    lazy var moreView:ChatMoreView  = { [unowned self] in
        let moreV = ChatMoreView()
        moreV.delegate = self
        return moreV
        }()
    
    
    // emotion
    lazy var emotion:ChatEmotionView = {
       let v = ChatEmotionView()
       v.backgroundColor = UIColor.gray
       v.delegate = self
       return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hidden keyboard
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(hiddenKeyboard(sender:)))
        self.tableView.addGestureRecognizer(gest)
        
        
        
        //背景图片
        let backGroudImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "chatBackground"))
        backGroudImageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(backGroudImageView)
        
        self.tableView.clipsToBounds = true
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
//        self.InputBar = FHInputToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height-44, width: UIScreen.main.bounds.width, height: 44))
        chatBarView = ChatBarView()
        chatBarView.delegate = self
        self.view.addSubview(chatBarView)
        
        _  = chatBarView.sd_layout().leftEqualToView(self.view)?.yIs(UIScreen.main.bounds.height - 45)?.rightEqualToView(self.view)?.heightIs(45)
        

         self.tableView.frame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 60 - 45)
        
        self.currentChatBarHright = 45
        
//        self.InputBar.delage = self
//        self.view.addSubview(InputBar)
        
        //keyboard notification, textfield
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.view.addSubview(moreView)
       // 用约束 动画才能移动subview
        _ = moreView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(216)
        
        self.setupNavigationTitle(text: friend.name)
        
        self.view.addSubview(emotion)
        _ = emotion.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(216)
        
        
        
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
        
        if let _:MessageBoby = self.tableSource.object(at: indexPath.row) as? MessageBoby{
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
        print("tab ")
        
        if sender.state == .ended{
           // self.InputBar.textField.resignFirstResponder()
            self.chatBarView.inputText.resignFirstResponder()
        }
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            self.moveBar(distance: 0)
            
        }
        self.chatBarView.keyboardType = .none
        sender.cancelsTouchesInView = false
        
    }
    
    
    func sendMessage(){
        let message = self.chatBarView.inputText.getEmotionString()
        
        self.chatBarView.inputText.text = ""
        let messagebody:MessageBoby = MessageBoby.init(content: message, time: "10-13")
        messagebody.sender = myself
        self.tableSource.add(messagebody)
        
        self.tableView.reloadData()
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
    }
   
}


//extension communication:FHInputToolbarDelegate{
//
//
//
//    func onInputBtnTapped(text: String) {
//        if (text.isEmpty){
//            return
//        }
//
//        //MARK connected back server
//
//        let _:MessageBoby = self.tableSource.lastObject as! MessageBoby
//
//        let message:MessageBoby = MessageBoby.init(content: text, time: "10-14")
//        message.sender = myself
//
//        self.tableSource.add(message)
//        self.tableView.reloadData()
//        // 滚动效果
//        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
//
//        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
//
//    }
//
//    func onleftBtnTapped(text: String) {
//
//    }
//
//
//
//
//}



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

extension communication: ChatMoreViewDelegate{
    
    func chatMoreView(moreView: ChatMoreView, didSelectedType type: ChatMoreType) {
        if type == .pic {   // 图片
           
            //self.present(imgPickerVC, animated: true, completion: nil)
        } else if type == .feedback {  // 小视频
          
//            videoVC.startAnimation(with: .small)
          
        } else if type == .camera {  // 视频聊天
//            let sheet = LXFActionSheet(delegate: self, cancelTitle: "取消", otherTitles: ["直播聊天"])
//            sheet.show()
//            // 隐藏chatBarView
//            let chatVC = self.delegate as! LXFChatController
//            chatVC.resetChatBarFrame()
        }
    }

}


extension communication: ChatEmotionViewDelegate{
    
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion) {
        self.chatBarView.inputText.insertEmotion(emotion: emotion)
        
    }
    
    func chatEmotionViewSend(emotionView: ChatEmotionView) {
        self.sendMessage()
        // MARK sdk sendmessage

    }
    
    
}

// show

extension communication: ChatBarViewDelegate{
    func showTextKeyboard() {
        
        UIView.animate(withDuration: 0.3) {
            self.emotion.alpha = 0
            self.moreView.alpha = 0
        }
        self.moveBar(distance: keyboardFrame?.height ?? 0)
    }
    
    func showVoice() {
        
    }
    
    func showEmotionKeyboard() {
         print("show emotion")
        self.emotion.alpha  = 1
        self.moreView.alpha = 0
        //_ = moreView.sd_layout().topSpaceToView(self.emotion,0)
        _  = moreView.sd_layout().leftEqualToView(self.emotion)?.yIs(self.emotion.bottom)?.widthIs(self.emotion.width)?.heightIs(self.emotion.height)
       
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        self.moveBar(distance: 216)
    }
    
    func showMoreKeyboard() {
        self.emotion.alpha = 0
        self.moreView.alpha = 1
        //_ = moreView.sd_layout().topSpaceToView(self.emotion,-216)
        _ = moreView.sd_layout().leftEqualToView(self.emotion)?.yIs(self.emotion.bottom - 216)?.widthIs(self.emotion.width)?.heightIs(self.emotion.height)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        self.moveBar(distance: 216)
    }
    
    func chatBarUpdateHeight(height: CGFloat) {
        var y:CGFloat = 270
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            y = 307
        }
        
        if self.currentChatBarHright != height{
            UIView.animate(withDuration: 0.05, animations: {
               _ = self.chatBarView.sd_layout().heightIs(height)?.yIs(y  - height + 45)

               _  = self.tableView.sd_layout().bottomSpaceToView(self.chatBarView,0)
               let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
                
               self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
                
            }, completion: nil)
        }
        
        self.currentChatBarHright =  height
        
    }
    
    func chatBarSendMessage() {
        self.sendMessage()
        // MARK sdk sendmessage

        
    }
    
    
    
    
}

extension communication{
    func moveBar(distance: CGFloat) {
        print("movr bar")
        //_ = self.chatBarView.sd_layout().bottomSpaceToView(self.view,distance)
        
       
        print(self.chatBarView,self.emotion)
        

        UIView.animate(withDuration: 0.3, animations: {
            
            self.tableView.frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64 - self.currentChatBarHright - distance)
            self.chatBarView.frame  = CGRect.init(x: 0, y: UIScreen.main.bounds.height - distance - self.currentChatBarHright, width: UIScreen.main.bounds.width, height: self.currentChatBarHright)
            self.view.layoutIfNeeded()
        }) { (Bool) in
            self.emotion.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - distance, width: UIScreen.main.bounds.width, height: 216)
            self.moreView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - distance, width: UIScreen.main.bounds.width, height: 216)
            
            if distance != 0 {
                
                let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
                
                self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
            }
            
        }
       
        
    }
    func keyboardhidden(sender:NSNotification){
         print("hidden")
        keyboardFrame = CGRect.zero
        if chatBarView.keyboardType == .emotion || chatBarView.keyboardType == .more{
            return
        }
        self.moveBar(distance: 0)
        
    }
    func keyboardChange(sender:NSNotification){
        keyboardFrame = sender.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect
        if chatBarView.keyboardType == .emotion || chatBarView.keyboardType == .more{
            return
        }
        self.moveBar(distance: keyboardFrame?.height ?? 0)
        
    }
    func hiddens(){
        self.emotion.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 216)
        self.moreView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 216)
    }

}
