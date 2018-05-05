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
    case jobDetail = "jobDetail"
}

enum ShowType:Int {
    case keyboard
    case moreView
    case emotion
    case none
}


// 聊天对话 界面
class CommunicationChatView: UIViewController, UINavigationControllerDelegate {

    
    
    private lazy var tableView:UITableView = { [unowned self] in
        
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: ScreenH - NavH - ChatInputBarH),style: .plain)
       
        tb.delegate = self
        tb.dataSource = self
        //tb.estimatedRowHeight = UITableViewAutomaticDimension
        tb.showsHorizontalScrollIndicator = false
        tb.showsVerticalScrollIndicator = true
        tb.tableFooterView = UIView.init()
        tb.register(messageCell.self, forCellReuseIdentifier: messageCell.reuseidentify())
        tb.register(JobMessageCell.self, forCellReuseIdentifier: JobMessageCell.identitiy())
        tb.register(gifCell.self, forCellReuseIdentifier: gifCell.reuseidentify())
        tb.register(PersonCardCell.self, forCellReuseIdentifier: PersonCardCell.reuseidentity())
        tb.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentify())
        tb.register(ChatTimeCell.self, forCellReuseIdentifier: ChatTimeCell.identity())
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.viewBackColor()
        
        // 滑动tableview 影藏键盘
        tb.keyboardDismissMode = .onDrag
        
        return tb
    }()
    
    // 是否drag
    private var isDrag = false
    
    
    // 第一次进入页面tableview滚动到底部
    private var table2Bottom = false
    
    // charbat - bottom
    private lazy var chatBarView:ChatBarView = {
        
        let cbView = ChatBarView()
        cbView.delegate = self
        return cbView
    }()
    
    
    
    // more
    private lazy var moreView:ChatMoreView  = { [unowned self] in
        let moreV = ChatMoreView()
        moreV.delegate = self
        
        return moreV
    }()
    
    // emotion
    private lazy var emotion:ChatEmotionView = {
       let emojView = ChatEmotionView()
       emojView.backgroundColor = UIColor.gray
       emojView.delegate = self
       return emojView
    }()
    
    //replyMessageView
    private lazy var replyView:quickReplyView = {
       let v = quickReplyView.init(frame: CGRect.zero)
       v.delegate = self
       return v
    }()
    
    
    
    //backgroudView
    private lazy var darkView:UIView = { [unowned self] in
        var  v = UIView()
        v.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        v.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        
        v.isUserInteractionEnabled = true // 打开用户交互
        
        let singTap = UITapGestureRecognizer(target: self, action:#selector(handleReplyView)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        v.addGestureRecognizer(singTap)
        return v
        
    }()
    
    
    // mycard
    
    private lazy var cardAlert:UIAlertController = { [unowned self ] in
        let alertView = UIAlertController.init(title: "分享你的个人名片", message: nil, preferredStyle: .alert)
        alertView.addAction(UIAlertAction.init(title: "立刻分享", style: .default, handler: { (action) in
            self.sendPersonCard()
            
        }))
        alertView.addAction(UIAlertAction.init(title: "预览个人名片", style: .default, handler: { (action) in
            self.showPersonCard()
        }))
        alertView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            print(action)
        }))
        
        return alertView
        
        
    }()
    // moreAction
    private lazy var alertView:UIAlertController = { [unowned self] in
        let alertV = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //let actions =
        alertV.addAction(UIAlertAction.init(title: "查看TA的名片", style: UIAlertActionStyle.default, handler: { (action) in
            // MARK
            let pubHR = publisherControllerView()
            
            pubHR.userID = self.hr.userID!
            self.navigationController?.pushViewController(pubHR, animated: true)
        }))
        alertV.addAction(UIAlertAction.init(title: "屏蔽TA", style: .default, handler: { (action) in
            print("屏蔽TA")
            
        }))
        alertV.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            print("取消")
        }))
        
        return alertV
    }()
    
    // showtype
    private var st: ShowType = ShowType.none
    
    // 聊天对象
    private var hr:PersonModel!
    
    // chat message and card info
    private var tableSource:NSMutableArray = []
    
    private var keyboardFrame:CGRect?
    
    private var currentChatBarHright:CGFloat = ChatInputBarH
    
    // 数据库查询
    private lazy var conversationManager:ConversationManager = ConversationManager.shared
    
    private var startMessageIndex:Int = 0
    private var limit:Int = 10
    private var firstLoadView:Bool = true
    
    // image文件操作
    fileprivate let appImageManager = AppFileManager.shared
    
    
    private var currentIndexPath:IndexPath?
    
    init(hr:PersonModel, index:IndexPath? = nil) {
       
        // 父类视图 对话cell 对应的row
        self.currentIndexPath = index
        self.hr = hr
       
        // 父类初始化
        super.init(nibName: nil, bundle: nil)
        self.chatRecordLoad()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        // more view 数据
        moreView.moreDataSource = [
            (name: "照片",icon: #imageLiteral(resourceName: "picture"), type: ChatMoreType.pic),
            (name: "相机",icon: #imageLiteral(resourceName: "camera"), type: ChatMoreType.camera),
            (name: "个人名片",icon: #imageLiteral(resourceName: "mycard"), type: ChatMoreType.mycard),
            (name: "快捷回复",icon: #imageLiteral(resourceName: "autoMessage"), type: ChatMoreType.feedback)
        ]
        
        
        
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
        //self.navigationController?.insertCustomerView()
        self.navigationController?.delegate = self
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        //self.navigationController?.removeCustomerView()

    }
    
   
    
    // remove self when destroied
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

// navigation delegate
extension CommunicationChatView {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 刷新 会话cell
        if let vc = viewController as? messageMain{
            vc.refreshRow(indexPath: self.currentIndexPath!, userID: self.hr.userID!)
            
        }
        // 影藏底部tabbar
        if viewController is messageMain{
            self.tabBarController?.tabBar.isHidden = false
        }else{
            self.tabBarController?.tabBar.isHidden = true
        }
        
    }
}
extension CommunicationChatView {
    
    
    private func setViews(){
        
        self.view.backgroundColor = UIColor.backGroundColor()
        let hrDes = hr.name! + "@" + hr.company!
        self.setupNavigate(title: hrDes)
        
        self.view.addSubview(tableView)
        self.view.addSubview(chatBarView)
        self.view.addSubview(moreView)
        self.view.addSubview(emotion)
        
        
        
        _  = chatBarView.sd_layout().leftEqualToView(self.view)?.yIs(ScreenH - ChatInputBarH)?.rightEqualToView(self.view)?.heightIs(ChatInputBarH)
        
        _ = emotion.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(KEYBOARD_HEIGHT)
        
        // 用约束 动画才能移动subview
        _ = moreView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(KEYBOARD_HEIGHT)
        
        // 监听文本keyborad 变化
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    func setupNavigate(title:String){
        
 
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 50, y: 0, width: 220, height: 44))
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "more"), style: .plain, target: self, action: #selector(moreButton))
    }
    
}


// table
extension CommunicationChatView: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if let message = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            switch message.messageType{
            case .text:
                let cell = tableView.dequeueReusableCell(withIdentifier: messageCell.reuseidentify(), for: indexPath) as! messageCell
                cell.setupMessageCell(messageInfo: message, chatUser: hr)
                return cell
                
            case .smallGif, .bigGif:
                let cell = tableView.dequeueReusableCell(withIdentifier: gifCell.reuseidentify(), for: indexPath) as! gifCell
                cell.setupPictureCell(messageInfo: message , chatUser: hr)
                //cell.useCellFrameCache(with: indexPath, tableView: tableView)
                return cell
                
            case .jobDescribe:
                let cell = tableView.dequeueReusableCell(withIdentifier: JobMessageCell.identitiy(), for: indexPath) as! JobMessageCell
                cell.mode = message
                //cell.useCellFrameCache(with: indexPath, tableView: tableView)
                return cell
            case .personCard:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonCardCell.reuseidentity(), for: indexPath) as! PersonCardCell
                cell.mode = message
                //cell.useCellFrameCache(with: indexPath, tableView: tableView)
                return cell
                
            case .picture:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentify(), for: indexPath) as! ImageCell
                cell.mode = message
                cell.storeImage = storeImageFromCell
                // 缓存图片高度
                //cell.useCellFrameCache(with: indexPath, tableView: tableView)
                return cell
            case .time:
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatTimeCell.identity(), for: indexPath) as! ChatTimeCell
                cell.model = message as? TimeBody
                //cell.useCellFrameCache(with: indexPath, tableView: tableView)
                return cell
            default:
                break
            }
            
        }
     
        return UITableViewCell()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message:MessageBoby  = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            switch message.messageType{
            case .text:
                return messageCell.heightForCell(messageInfo: message)
                
            case .smallGif,.bigGif:
                return gifCell.heightForCell(messageInfo: message)
            case .personCard:
                let message = self.tableSource.object(at: indexPath.row) as! MessageBoby
                return  tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: PersonCardCell.self, contentViewWidth: ScreenW)
            case .picture:
                let message = self.tableSource.object(at: indexPath.row) as! MessageBoby
                 return tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: ImageCell.self, contentViewWidth: ScreenW)
                
            case .jobDescribe:
                let message = self.tableSource.object(at: indexPath.row) as! MessageBoby
                return tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: JobMessageCell.self, contentViewWidth: ScreenW)
                
             case .time:
                return ChatTimeCell.cellHeight()
            default:
                break
            }
        }
        
        return 44.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let mes = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            switch mes.type!{
            case MessgeType.jobDescribe.rawValue:
                showJobView(mes: mes)

            case MessgeType.personCard.rawValue:
                showPersonCard()
                
            case MessgeType.text.rawValue:
                break
            default:
                break
            }
        }
        
    }
    
    // 判断 tableview 加载完成
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row && firstLoadView{
            
            firstLoadView = false
            DispatchQueue.main.async(execute: {
                tableView.scrollToRow(at: IndexPath.init(row: self.tableSource.count - 1, section: 0), at: .bottom, animated: true)

            })
        }
        
        
    }
    
    
    
}

extension CommunicationChatView{
    
    // 加载历史聊天记录
    private func chatRecordLoad(){
        //
        let mes = conversationManager.getLatestMessageBy(chatWith: hr, start: startMessageIndex, limit: limit)
        
        //print(mes)
        if mes.count > 0 {
            // 添加time 消息
            let after = addTimeMsg(mes:mes)
            for item in after{
                self.tableSource.add(item)
            }
            
            // start位置偏移量， MARK 上拉查询刷新记录
            startMessageIndex += limit
        }
    }
    
    // 添加时间message
    private func addTimeMsg(mes:[MessageBoby]) -> [MessageBoby]{
        var res = [MessageBoby]()
        for index in 0..<mes.count{
            if index == 0 {
                res.append(createTimeMsg(msg: mes[index]))
            }else{
                // 满足时间间隔 才添加时间 message
                if (LXFChatMsgTimeHelper.shared.needAddMinuteModel(preModel: mes[index - 1], curModel: mes[index])){
                    res.append(createTimeMsg(msg: mes[index]))
                }
            }
            res.append(mes[index])
        }
        return res
    }
    
    // 获取时间 message
    fileprivate func createTimeMsg(msg: MessageBoby) -> TimeBody{
        
        // 时间消息
        let time = TimeBody(JSON: ["type":MessgeType.time.rawValue,"creat_time":msg.creat_time!.timeIntervalSince1970])!
        time.timeStr = LXFChatMsgTimeHelper.shared.chatTimeString(with: time.creat_time?.timeIntervalSince1970)
        return time
        
    }
    
    // 影藏所有的输入面板
    private func hiddenChatBarView(complete:(()->Void)? = nil ){

       // 影藏textfield的 keyboard
        self.chatBarView.inputText.resignFirstResponder()

        // 影藏 emotion 和 more 输入view
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            self.moveBar(distance: 0, complete: complete)
        }
        
        self.chatBarView.keyboardType = .none
    }
    //
    @objc func moreButton(){
        
        // 隐藏键盘
        self.hiddenChatBarView()
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    // 显示个人名片
    private func showPersonCard(){
        
        
        self.chatBarView.inputText.resignFirstResponder()
        
        // 影藏 emotion 和 more 输入view
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            self.moveBar(distance: 0){
                let personCardview = personCardVC()
                personCardview.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(personCardview, animated: true)
            }
        }
        else{
            let personCardview = personCardVC()
            personCardview.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(personCardview, animated: true)
        }
        
        self.chatBarView.keyboardType = .none
        
        
       
    }
    
    // 显示jod详细界面
    
    private func showJobView(mes:MessageBoby){
        
        self.chatBarView.inputText.resignFirstResponder()
        
        // 影藏 emotion 和 more 输入view
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            self.moveBar(distance: 0){
                let job = JobDetailViewController()
                job.jobID = mes.contentToJson()!["jobID"].string!
                job.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(job, animated: true)
            }
        }
        else{
            let job = JobDetailViewController()
            job.jobID = mes.contentToJson()!["jobID"].string!
            job.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(job, animated: true)
        }
        
        self.chatBarView.keyboardType = .none
        
    }
    
    
}




extension CommunicationChatView: ChatMoreViewDelegate{
    
    func chatMoreView(moreView: ChatMoreView, didSelectedType type: ChatMoreType) {
        
        switch type {
        // MARK
        case .pic:
            
            if self.getPhotoLibraryAuthorization(){
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    //初始化图片控制器
                    let picker = UIImagePickerController()
                    
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
        case .feedback:
            // 显示
          
            self.navigationController?.view.addSubview(self.darkView)
            self.navigationController?.view.addSubview(self.replyView)
              _ = replyView.sd_layout().centerXEqualToView(self.view)?.centerYEqualToView(self.view)?.widthIs(230)?.heightIs(300)
            
        case .camera:
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
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
                    picker.cameraDevice = UIImagePickerControllerCameraDevice.rear
                }else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front){
                    picker.cameraDevice = UIImagePickerControllerCameraDevice.front
                }
                
                
                //设置闪光灯(On:开、Off:关、Auto:自动)
                picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.auto
                
                //允许编辑
                picker.allowsEditing = true
                
                //打开相机
                self.present(picker, animated: true, completion: nil)
            }
            else{
                print("找不到相机")
            }
        case .mycard:
            self.present(cardAlert, animated: true, completion: nil)
            
        }
    }

}


extension CommunicationChatView: ChatEmotionViewDelegate{
    
    func chatEmotionGifSend(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion, type:MessgeType) {
        self.sendGifMessage(emotion: emotion, type:type)
        
    }
    
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion) {
        self.chatBarView.inputText.insertEmotion(emotion: emotion)
        
    }
    
    func chatEmotionViewSend(emotionView: ChatEmotionView) {
        self.sendMessage()
    }
   

    func sendMessage(){
        
        // 获取富文本  消息
        var message = self.chatBarView.inputText.getEmotionString()
        
        message = message.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        guard !message.isEmpty else {
            return
        }
        // 清理inputview
        self.chatBarView.inputText.text = ""
        let messagebody:MessageBoby = MessageBoby(JSON: ["messageID":getUUID(), "type":MessgeType.text.rawValue,"content":message.data(using:String.Encoding.utf8)!.base64EncodedString(),"creat_time":Date.init().timeIntervalSince1970,"isRead":true])!
        
        messagebody.sender = myself
        messagebody.receiver = self.hr
        
        
        self.reloads(mes: messagebody)
        
    }
    
    //   gif 图片
    func sendGifMessage(emotion: MChatEmotion, type:MessgeType){
        
        if  let message = MessageBoby(JSON: ["messageID":getUUID(), "type":type.rawValue,"content":emotion.text?.data(using: String.Encoding.utf8, allowLossyConversion: false)?.base64EncodedString() ,"creat_time":Date.init().timeIntervalSince1970,"isRead":true]){
            message.sender = myself
            message.receiver = self.hr
            self.reloads(mes: message)
            
        }
        
    }
    // 快捷回复
    func sendReply(content:String){
        
        if let message = MessageBoby(JSON: ["messageID":getUUID(), "type":MessgeType.text.rawValue,"content":content.data(using:String.Encoding.utf8)!.base64EncodedString(),"creat_time":Date.init().timeIntervalSince1970,"isRead":true]){
            message.sender = myself
            message.receiver = self.hr
            self.reloads(mes: message)
        }
        

    }
    
    // 个人名片
    func sendPersonCard(){
        
        if let message = MessageBoby(JSON: ["messageID":getUUID(), "type": MessgeType.personCard.rawValue,
                                            "creat_time": Date.init().timeIntervalSince1970, "isRead": true]){
            message.sender = myself
            message.receiver = self.hr
            self.reloads(mes: message)
        }

    }

    // 发送照片
    
    func sendImage(Data:Data, imageName: String){
        // 数据发送到服务器
        // 本地存储 占时
        if let message = MessageBoby(JSON: ["messageID":getUUID(),"type":MessgeType.picture.rawValue,
                                            "creat_time":Date.init().timeIntervalSince1970,
                                            "isRead":true,"content":imageName.data(using: String.Encoding.utf8)!.base64EncodedString()]){
            message.sender = myself
            message.receiver = self.hr
            self.reloads(mes: message)
            
        }
        
    }
    
    private func  reloads(mes: MessageBoby){
        
        // 0  刷新table 和 存入数据库,
        // 1 数据要在 tableview，根据网络 判断发送状态（sended??）并刷新显示发送失败状态
        // 2 是否可以删除发送失败的数据？
        do{
            try self.conversationManager.insertMessageItem(items: [mes])
            self.conversationManager.insertConversationItem(messageID: mes.messageID!, userID: self.hr!.userID!)
            
            if LXFChatMsgTimeHelper.shared.needAddMinuteModel(preModel: self.tableSource.lastObject as! MessageBoby, curModel: mes){
                self.tableSource.add(createTimeMsg(msg: mes))
            }
            self.tableSource.add(mes)
            
            self.tableView.reloadData()
            let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
            self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
            //3  数据插入本地数据库 后通知更新 converation 会话界面，显示内容
            
        }catch{
            print(error)
        }
        
        // 存入本地
        //Contactlist.shared.usersMessage[(hr?.id)!]?.addMessageByMes(newMes: mes)
    }
    
    
}

// 实现代理

extension CommunicationChatView: ChatBarViewDelegate{

    
    func showEmotionKeyboard() {
       
        
        self.emotion.isHidden = false
        self.moreView.isHidden = true
        self.moveBar(distance: 216)
    }
    
    func showMoreKeyboard() {
        self.emotion.isHidden = true
        self.moreView.isHidden = false
        
        self.moveBar(distance: 216)
    }
    
    func chatBarUpdateHeight(height: CGFloat) {
        
        var y:CGFloat = ChatKeyBoardH
        
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            y = KEYBOARD_HEIGHT  // 216 高度
        }
        
        if self.currentChatBarHright != height{
            
            // 调整chatBarview frame 和 缩小 tableview frame 高度
            _ = self.chatBarView.sd_layout().yIs(ScreenH - y - height)?.heightIs(height)
            
            self.tableView.frame = CGRect.init(x: 0, y: NavH, width: ScreenW, height: ScreenH - NavH - height - y)
            
            let row = IndexPath.init(row: self.tableSource.count - 1   , section: 0)
            self.tableView.scrollToRow(at: row, at: .none, animated: true)
        }
        
        self.currentChatBarHright =  height
        
    }

    
    func chatBarSendMessage() {
        self.sendMessage()
        // MARK sdk sendmessage
        
    }
    
    
}

extension CommunicationChatView{
    
    // 
    func moveBar(distance: CGFloat, complete:(()->Void)? = nil ) {
        
        //一起移动 inputview 和emotion 和 moreview 和 tableview 的位置

        UIView.animate(withDuration: 0.3, animations: {
            // 改变table 大小
            self.tableView.frame = CGRect.init(x: 0, y: NavH, width: ScreenW, height: ScreenH - NavH - self.currentChatBarHright - distance)
            //改变 chatbar 位置和大小
            self.chatBarView.frame  = CGRect.init(x: 0, y: ScreenH - distance - self.currentChatBarHright, width: ScreenW, height: self.currentChatBarHright)
            
            self.emotion.frame = CGRect.init(x: 0, y: ScreenH - distance, width: ScreenW, height: 216)
            self.moreView.frame = CGRect.init(x: 0, y: ScreenH - distance, width: ScreenW, height: 216)
            
            
            // 点击了输入view 把tableview滑动到底部
            if distance != 0 {
                let path = IndexPath.init(row: self.tableSource.count-1, section: 0)
                self.tableView.scrollToRow(at: path, at: .bottom, animated: true)
            }
 
        }, completion: {  bool in
             complete?()
        })
        
    
        
    }
    
    
    
    
    @objc func keyboardhidden(sender:NSNotification){
        
        keyboardFrame = CGRect.zero
        
        if chatBarView.keyboardType == .emotion || chatBarView.keyboardType == .more{
            return
        }
        self.moveBar(distance: 0)
        
    }
    // 显示文本输入框
    @objc  func keyboardShow(sender:NSNotification){
        
        keyboardFrame = sender.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect
        if chatBarView.keyboardType == .emotion || chatBarView.keyboardType == .more{
            return
        }
        // 影藏
        self.emotion.isHidden = true
        self.moreView.isHidden = true
        
        self.moveBar(distance: keyboardFrame?.height ?? 0)
        
    }
    


    @objc func handleReplyView(){
        self.darkView.removeFromSuperview()
        self.replyView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(darkView)
        self.navigationController?.view.willRemoveSubview(replyView)
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


extension CommunicationChatView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if self.chatBarView.keyboardType != .none{
            self.hiddenChatBarView()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
}

// 手势代理
extension CommunicationChatView: UIGestureRecognizerDelegate{
    
    // cell 点击不拦截，但是效果不明显
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
//            return false
//        }
//        return true
//    }

    // 允许 tableview 上多个手势执行
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.view?.isKind(of: UITableView.self))!{
            return true
        }
        return false
    }
    
    
    
}


// reply delegate
extension CommunicationChatView: ReplyMessageDelegate{
    
    func didSelectedMessage(view: UITableView, message: String) {
        self.handleReplyView()
        self.sendReply(content: message)
    }
}



// camera 照片
extension CommunicationChatView: UIImagePickerControllerDelegate{
    
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        
        var imageData:Data?
        var imageName = ""
        var imagePathURL:URL?
        
        
        if let image:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            if picker.sourceType == .camera{
                // 照相的照片 默认是jpeg 格式
                // 生成时间戳 和 扩展名的 图片名称
               
                let DateFormat = DateFormatter.init()
                // 
                DateFormat.dateFormat = "yyyy-MM-dd HH.mm.ss"
                imageName = DateFormat.string(from: Date()) + ".jpeg"
                imageData = UIImageJPEGRepresentation(image, 0)
                
                
            }else if picker.sourceType == .photoLibrary{
                // 照片库
                // 获取名称
                imagePathURL = info[UIImagePickerControllerImageURL] as? URL
                imageName = imagePathURL!.lastPathComponent
                // 文件扩展类型
                let fileType =  imageName.components(separatedBy: ".").last!
                if fileType.lowercased() == "jpeg"{
                    imageData = UIImageJPEGRepresentation(image, 0)
                }else{
                    imageData = UIImagePNGRepresentation(image)
                }
               
            }
            
            do{
                // 交谈得对象 创建对应images目录
                try  appImageManager.createImageFile(userID: self.hr.userID!,fileName: imageName, image: imageData!)
                self.sendImage(Data: imageData!, imageName: imageName)
                
            }catch{
                print(error)
                return
            }
            
            
        }
        
        
        
    }
    
}


// 保存图片 alert

extension CommunicationChatView{
    
    func  storeImageFromCell(image:UIImage){
        let AlertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let store = UIAlertAction.init(title: "保存", style: .default) { (action) in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        AlertVC.addAction(cancel)
        AlertVC.addAction(store)
        
        
        self.present(AlertVC, animated: true, completion: nil)
        
    }
    
    // 方法必须是这样
    @objc  private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error != nil{
              showOnlyTextHub(message: "保存失败", view: self.tableView)
//            SVProgressHUD.showError(withStatus: "保存失败")
//            SVProgressHUD.setDefaultMaskType(.black)
//            SVProgressHUD.dismiss(withDelay: 1)
        }else{
            showOnlyTextHub(message: "保存成功", view: self.tableView)

//            SVProgressHUD.showSuccess(withStatus: "保存成功")
//            SVProgressHUD.setDefaultMaskType(.black)
//            SVProgressHUD.dismiss(withDelay: 1)
        }
    }
}
