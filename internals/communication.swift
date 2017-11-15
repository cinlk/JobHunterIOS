//
//  communication.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

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
    
    //replyMessageView
    lazy var replyView:ReplyView = {
       let v = ReplyView.init(frame: CGRect.init(x: 50, y: 200, width: 200, height: 200))
       v.delegate = self
       return v
        
    }()
    
    
    
    //backgroudView
    lazy var darkView:UIView = {
        var  v = UIView()
        v.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        v.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        
        v.isUserInteractionEnabled = true // 打开用户交互
        
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        
        singTap.numberOfTouchesRequired = 1
        
        v.addGestureRecognizer(singTap)
        return v
        
    }()
    
    
    // mycard
    
    lazy var cardAlert:UIAlertController = { [unowned self ] in
        let alertView = UIAlertController.init(title: "分享你的个人名片", message: nil, preferredStyle: .alert)
        alertView.addAction(UIAlertAction.init(title: "立刻分享", style: .default, handler: { (action) in
            self.sendPersonCard()
            
        }))
        alertView.addAction(UIAlertAction.init(title: "预览个人名片", style: .default, handler: { (action) in
            print(action)
        }))
        alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            print(action)
        }))
        
        return alertView
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hidden keyboard
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(hiddenKeyboard(sender:)))
        self.tableView.addGestureRecognizer(gest)
        
        
        
        //背景图片
        let backGroudImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "chatBackground"))
        backGroudImageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        //self.view.addSubview(backGroudImageView)
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.clipsToBounds = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(messageCell.self, forCellReuseIdentifier: messageCell.reuseidentify())
        
        self.tableView.register(CellCard.self, forCellReuseIdentifier: CellCard.identify())
        self.tableView.register(gifCell.self, forCellReuseIdentifier: gifCell.reuseidentify())
        self.tableView.register(PersonCardCell.self, forCellReuseIdentifier: PersonCardCell.reuseidentity())
        self.tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentify())
        
        
        
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
            
          
            let message = self.tableSource.object(at: indexPath.row) as! MessageBoby
            
            // MARK  diffrent message
            if message.type == .text{
                let cell = tableView.dequeueReusableCell(withIdentifier: messageCell.reuseidentify(), for: indexPath) as! messageCell
                cell.selectionStyle = .none
                
                cell.setupMessageCell(messageInfo: message, user: myself)
                return cell

            }else if message.type == .gif || message.type == .bigGif{
                let cell = tableView.dequeueReusableCell(withIdentifier: gifCell.reuseidentify(), for: indexPath) as! gifCell
                
                cell.setupPictureCell(messageInfo: message, user: myself)
                cell.selectionStyle = .none
                
                return cell
                
                
            }else{
                
            }
        
            //return cell
        }
        if let personCard = self.tableSource.object(at: indexPath.row) as? PersonCardBody{
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonCardCell.reuseidentity(), for: indexPath) as? PersonCardCell
            cell?.buildCell(name: personCard.name!, image: personCard.image!)
            cell?.selectionStyle = .none
            return cell!
            
        }
        if let imageBody = self.tableSource.object(at: indexPath.row) as? ImageBody{
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentify(), for: indexPath) as? ImageCell
            
            cell?.buildCell(image: imageBody.image, avater: imageBody.avatar!)
            cell?.selectionStyle = .none
            return cell!
        }
        
        return UITableViewCell.init(style: .default, reuseIdentifier: "nil")
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message:MessageBoby  = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            if message.type  == .text{
                return messageCell.heightForCell(messageInfo: message)
            }else if message.type == .gif || message.type == .bigGif{
                return gifCell.heightForCell(messageInfo: message)
            }
        }else if let personCard = self.tableSource.object(at: indexPath.row) as? PersonCardBody{
            return PersonCardCell.heightForCell()
        }else if let _ = self.tableSource.object(at: indexPath.row) as? ImageBody{
            return ImageCell.cellHeight()
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
        else if let personCard = self.tableSource.object(at: indexPath.row) as? PersonCardBody{
            print("show person card View \(personCard)")
            
        }
        return
    }
    

    
    
 

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
        let message1:MessageBoby = MessageBoby.init(content: "测试语句1!", time: "10-12")
        message1.sender = friend
        message1.type = .text
        self.tableSource.add(message1)
        
        let message2:MessageBoby = MessageBoby.init(content: "测试语句2!", time: "10-12")
        message2.sender = friend
        message2.type = .text
        self.tableSource.add(message2)
        
        
        let message3:MessageBoby = MessageBoby.init(content: "测试语句3!✌️", time: "10-13")
        message3.sender = myself
        message3.type = .text
        self.tableSource.add(message3)
        let message4:MessageBoby = MessageBoby.init(content: "重复重复重复😎重复重复重复重复重😎复重复重复重复重复重复重复重复重复重复重复重复重复重复😑重复重复重复😑重复重复重复重复重复重复重复重复!", time: "10-13")
        message4.sender = myself
        message4.type = .text
        self.tableSource.add(message4)
    }
    
    // fake data  starting with job card
    func tmpTableSurce2(_ card:Dictionary<String,String>){
        self.tableSource.add(card)
        let message1:MessageBoby = MessageBoby.init(content: "测试语句4", time: "10-13")
        message1.sender = myself
        message1.type = .text
        self.tableSource.add(message1)
        
        let message2:MessageBoby = MessageBoby.init(content: "测试语句5", time: "10-12")
        message2.sender = friend
        message2.type = .text
        self.tableSource.add(message2)
        
    }
    
    @objc func hiddenKeyboard(sender: UITapGestureRecognizer){
        
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
        messagebody.type = .text
        
        self.tableSource.add(messagebody)
        
        //self.tableView.reloadData()
        //self.tableView.beginUpdates()
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        //self.tableView.insertRows(at: [path as IndexPath], with: .none)
        self.tableView.reloadData()
        //self.tableView.endUpdates()
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
        
    }
    
    
    
    // send gif picture
    func sendGifMessage(emotion: MChatEmotion, type:String){
        
        let messageBody:MessageBoby = MessageBoby.init(content: emotion.imgPath!, time: "10-12")
        if type == "bigGif"{
            messageBody.type = .bigGif
        }else{
            messageBody.type  = .gif
        }
        //messageBody.type  = .picture
        messageBody.sender = myself
        
        self.tableSource.add(messageBody)
        
        //self.tableView.beginUpdates()
        
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        //self.tableView.insertRows(at: [path as IndexPath], with: .none)
         self.tableView.reloadData()
        //self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
        
        
    }
    //
    func sendReply(content:String){
        let messagebody:MessageBoby = MessageBoby.init(content: content, time: "10-13")
        messagebody.sender = myself
        messagebody.type = .text
        
        self.tableSource.add(messagebody)
        
        //self.tableView.reloadData()
        //self.tableView.beginUpdates()
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        //self.tableView.insertRows(at: [path as IndexPath], with: .none)
        self.tableView.reloadData()
        //self.tableView.endUpdates()
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
    }
    //
    
    func sendPersonCard(){
        
        let card:PersonCardBody = PersonCardBody.init(name: myself.name, image: myself.avart)
        self.tableSource.add(card)
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
        
    }
    // send image
    
    func sendImage(image:NSData, avartar:String){
        
        let imageBody:ImageBody = ImageBody.init(image: image, avatar: avartar)
        self.tableSource.add(imageBody)
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
        
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
           
            if self.getPhotoLibraryAuthorization(){
                    //self.present(imgPickerVC, animated: true, completion: nil)
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        //初始化图片控制器
                        let picker = UIImagePickerController()
                        //picker.navigationItem.rightBarButtonItem?.title = "取消"
                        //picker.navigationItem.title = "相机胶卷"
                        
                        //设置代理
                        picker.delegate = self
                        
                        //设置媒体类型
                        //picker.mediaTypes = [kUTTypeImage as String,kUTTypeVideo as String]
                        picker.mediaTypes = [kUTTypeImage as String]
                        //设置允许编辑
                        picker.allowsEditing = true
                        
                        //指定图片控制器类型
                        picker.sourceType = .photoLibrary
                        
                        //弹出控制器,显示界面
                        self.present(picker, animated: true, completion: nil)
                        
                    }else{
                        print("请在iphone的 \"设置-隐私-照片\" 选择中，允许xxx访问你的照片")
                        
                    }
            }else{
                let alert = UIAlertController(title: "温馨提示", message: "没有相册的访问权限，请在应用设置中开启权限", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        } else if type == .feedback {  // 小视频
            self.navigationController?.view.addSubview(self.darkView)
            self.navigationController?.view.addSubview(self.replyView)
          
        } else if type == .camera {  // 相机  只能用真机调试
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                //初始化图片控制器
                let picker = UIImagePickerController()
                
                //设置代理
                picker.delegate = self
                
                //设置媒体类型
                picker.mediaTypes = [kUTTypeImage as String,kUTTypeVideo as String]
                
                //设置来源
                picker.sourceType = UIImagePickerControllerSourceType.camera
                
                //设置镜头 front:前置摄像头  Rear:后置摄像头
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
                    picker.cameraDevice = UIImagePickerControllerCameraDevice.front
                }
                
                //设置闪光灯(On:开、Off:关、Auto:自动)
                picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.on
                
                //允许编辑
                picker.allowsEditing = true
                
                //打开相机
                self.present(picker, animated: true, completion: nil)
            }
            else{
                print("找不到相机")
            }
            
        }else if type == .mycard{
            // show mycard alert
            
          
            self.present(cardAlert, animated: true, completion: nil)
           
         
            
        }
    }

}


extension communication: ChatEmotionViewDelegate{
    func chatEmotionGifSend(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion, type:String) {
        self.sendGifMessage(emotion: emotion, type:type)
        
        
    }
    
    
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
            //self.emotion.alpha = 0
            //self.moreView.alpha = 0
            self.emotion.isHidden = true
            self.moreView.isHidden = true
        }
        self.moveBar(distance: keyboardFrame?.height ?? 0)
    }
    
    func showVoice() {
        
    }
    
    func showEmotionKeyboard() {
        //self.emotion.alpha  = 1
        //self.moreView.alpha = 0
        self.emotion.isHidden = false
        self.moreView.isHidden = true
        //_ = moreView.sd_layout().topSpaceToView(self.emotion,0)
        _  = moreView.sd_layout().leftEqualToView(self.emotion)?.yIs(self.emotion.bottom)?.widthIs(self.emotion.width)?.heightIs(self.emotion.height)
       
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        self.moveBar(distance: 216)
    }
    
    func showMoreKeyboard() {
       // self.emotion.alpha = 0
        //self.moreView.alpha = 1
        self.emotion.isHidden = true
        self.moreView.isHidden = false
        
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
        //_ = self.chatBarView.sd_layout().bottomSpaceToView(self.view,distance)
        

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
    @objc func keyboardhidden(sender:NSNotification){
        keyboardFrame = CGRect.zero
        if chatBarView.keyboardType == .emotion || chatBarView.keyboardType == .more{
            return
        }
        self.moveBar(distance: 0)
        
    }
    @objc  func keyboardChange(sender:NSNotification){
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

    @objc func handleSingleTapGesture(){
        self.darkView.removeFromSuperview()
        self.replyView.removeFromSuperview()
    }
    // picture 授权  Photos module
    func getPhotoLibraryAuthorization() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            print("已经授权")
            return true
        case .notDetermined:
            print("不确定是否授权")
            // 请求授权
            PHPhotoLibrary.requestAuthorization({ (status) in })
        case .denied:
            print("拒绝授权")
        case .restricted:
            print("限制授权")
            break
        }
        
        return false
    }
    
}



// moresubView delegate
extension communication: ReplyMessageDelegate{
    func didSelectedMessage(view: UITableView, message: String) {
        self.handleSingleTapGesture()
        self.sendReply(content: message)
    }
}


extension communication: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        print(info)
        
        
        let image:UIImage!
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        print("choose image \(image)")
        
        self.sendImage(image: UIImageJPEGRepresentation(image, 1.0) as! NSData, avartar: myself.avart)
        
    }
    
}


