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


fileprivate let charMoreViewH:CGFloat = 216
fileprivate let popViewH:CGFloat = 200
// 聊天对话 界面
class CommunicationChatView: UIViewController, UINavigationControllerDelegate {

    
    
    
    // 聊天对象
    private var hr:PersonModel!
    
    // 聊天对话数据集合
    private var tableSource:NSMutableArray = []
    
    // 记录 device keyboard frame
    private var keyboardFrame:CGRect?
    
    // 记录输入框高度
    private var currentChatBarHright:CGFloat = ChatInputBarH
    
   
    
    
    // 会话数据库管理操作
    private lazy var conversationManager:ConversationManager = ConversationManager.shared
    
    // 会话显示启示位置（0 表示最后一位）
    private var startMessageIndex:Int = 0
    // 每次获取会话 的个数(每次table 上拉刷新)
    private var limit:Int = 10
    
    private var firstLoad:Bool = true
    
    // 本地文件管理
    fileprivate let appImageManager = AppFileManager.shared
    
    
    private var navTitle:String = ""
    
    // 聊天列表界面跳转来 记录行
    private var currentRow:Int?
    
    
    private lazy var tableView:UITableView = { [unowned self] in
        
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - ChatInputBarH),style: .plain)
       
        tb.delegate = self
        tb.dataSource = self
        tb.showsHorizontalScrollIndicator = false
        tb.showsVerticalScrollIndicator = true
        tb.tableFooterView = UIView.init()
        tb.register(messageCell.self, forCellReuseIdentifier: messageCell.reuseidentify())
        tb.register(JobMessageCell.self, forCellReuseIdentifier: JobMessageCell.identitiy())
        tb.register(gifCell.self, forCellReuseIdentifier: gifCell.reuseidentify())
        tb.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentify())
        tb.register(ChatTimeCell.self, forCellReuseIdentifier: ChatTimeCell.identity())
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        // 滑动tableview 影藏键盘
        tb.keyboardDismissMode = .onDrag
        
        return tb
    }()
    
    
    // 底部聊天输入框
    private lazy var chatBarView:ChatBarView = {
        let cbView = ChatBarView()
        cbView.delegate = self
        return cbView
    }()
    
    
    
    // 更多界面(图片,照相,快捷回复)
    private lazy var moreView:ChatMoreView  = { [unowned self] in
        let moreV = ChatMoreView()
        moreV.delegate = self
        
        moreV.moreDataSource = [
            (name: "照片",icon: #imageLiteral(resourceName: "picture"), type: ChatMoreType.pic),
            (name: "相机",icon: #imageLiteral(resourceName: "camera"), type: ChatMoreType.camera),
            (name: "快捷回复",icon: #imageLiteral(resourceName: "autoMessage"), type: ChatMoreType.feedback)
        ]
        
        return moreV
    }()
    
    
    // 动态表情界面
    private lazy var emotion:ChatEmotionView = {
       let emojView = ChatEmotionView()
       emojView.delegate = self
       return emojView
    }()
    
    //快捷回复界面
    private lazy var replyPopView:popView = {
       let v = popView.init(frame: CGRect.init(x: -300, y: (GlobalConfig.ScreenH - 200)/2, width: 200, height: popViewH))
       v.layer.masksToBounds = true
       v.layer.cornerRadius = 10
       return v
    }()
    

    

    
    private lazy var alertView:UIAlertController = { [unowned self] in
        let alertV = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertV.addAction(UIAlertAction.init(title: "查看TA的名片", style: UIAlertAction.Style.default, handler: { (action) in
            // MARK
            let pubHR = publisherControllerView()
            pubHR.userID = self.hr.userID!
            self.navigationController?.pushViewController(pubHR, animated: true)
        }))
        alertV.addAction(UIAlertAction.init(title: "屏蔽TA", style: .default, handler: { (action) in
            print("屏蔽TA")
            // 更新服务器数据
            
            
        }))
        alertV.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        return alertV
    }()
    

    
    init(hr:PersonModel, row:Int? = nil) {
        
        self.currentRow = row
        self.hr = hr
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        self.chatRecordLoad()
        
        self.navigationController?.delegate = self
        
        
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.white)
        UIApplication.shared.keyWindow?.addSubview(replyPopView)
        
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
        replyPopView.removeFromSuperview()

    }
    
   
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}



extension CommunicationChatView {
    
    
    private func setViews(){
        
        self.view.backgroundColor = UIColor.backGroundColor()
        
        navTitle = hr.name! + "@" + hr.company!
        self.title = navTitle
        
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.setupNavigateBtn()
        
        self.view.addSubview(tableView)
        self.view.addSubview(chatBarView)
        self.view.addSubview(moreView)
        self.view.addSubview(emotion)
        
        
        
        _  = chatBarView.sd_layout().leftEqualToView(self.view)?.yIs(GlobalConfig.ScreenH - ChatInputBarH)?.rightEqualToView(self.view)?.heightIs(ChatInputBarH)
        
        _ = emotion.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(charMoreViewH)
        
        _ = moreView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(charMoreViewH)
        
        // 监听keyborad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func setupNavigateBtn(){
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image:  UIImage.init(named: "more")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(moreButton))
    }
    
}




extension CommunicationChatView{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 从job 跳转来的，返回后 需要刷新 chatlist
        if self.currentRow == nil, viewController.isKind(of: JobDetailViewController.self){
            NotificationCenter.default.post(name: NSNotification.Name.init("refreshChat"), object: nil)
        }
        
        
        
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
        
        
        if let message  = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            if message.isKind(of: GigImageMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: gifCell.reuseidentify(), for: indexPath) as! gifCell
                cell.setupPictureCell(messageInfo: message as! GigImageMessage , chatUser: hr)
                return cell
            }else if message.isKind(of: JobDescriptionlMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: JobMessageCell.identitiy(), for: indexPath) as! JobMessageCell
                cell.mode = message as? JobDescriptionlMessage
                return cell
            }else if message.isKind(of: PicutreMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentify(), for: indexPath) as! ImageCell
                cell.mode = message as? PicutreMessage
                cell.storeImage = storeImageFromCell
                return cell
            }else if message.isKind(of: TimeMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatTimeCell.identity(), for: indexPath) as! ChatTimeCell
                cell.model = message as? TimeMessage
                return cell
                
            // 文本数据
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: messageCell.reuseidentify(), for: indexPath) as! messageCell
                cell.setupMessageCell(messageInfo: message, chatUser: hr)
                return cell
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
                // 计算得到的值
                return message.messageType == .bigGif ? 120 : 80
                
            case .picture:
                let message = self.tableSource.object(at: indexPath.row) as! PicutreMessage
                 return tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: ImageCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .jobDescribe:
                let message = self.tableSource.object(at: indexPath.row) as! JobDescriptionlMessage
                return tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: JobMessageCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
             case .time:
                return ChatTimeCell.cellHeight()
            default:
                break
            }
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let mes = self.tableSource.object(at: indexPath.row) as? JobDescriptionlMessage{
            showJobView(mes: mes)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 加载最后可见cell 后，第一次进入view时滚动到最底部的cell
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row && firstLoad{
            tableView.scrollToRow(at: IndexPath.init(row: self.tableSource.count - 1, section: 0), at: .bottom, animated: true)
            firstLoad = false
            
        }
    }
    
    
    
}

extension CommunicationChatView{
    
    // 加载历史聊天记录
    private func chatRecordLoad(){
        //
        let mes = conversationManager.getLatestMessageBy(chatWith: hr, start: startMessageIndex, limit: limit)
        
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
                // 2个消息间隔时间超过指定时间 才添加时间
                if (LXFChatMsgTimeHelper.shared.needAddMinuteModel(preModel: mes[index - 1], curModel: mes[index])){
                    res.append(createTimeMsg(msg: mes[index]))
                }
            }
            res.append(mes[index])
        }
        return res
    }
    
    // 获取时间 message
    fileprivate func createTimeMsg(msg: MessageBoby) -> TimeMessage{
        
        // 时间消息
        let time = TimeMessage(JSON: ["messageID":getUUID(), "type":MessgeType.time.rawValue,"creat_time":msg.creat_time!.timeIntervalSince1970])!
        time.timeStr = LXFChatMsgTimeHelper.shared.chatTimeString(with: time.creat_time?.timeIntervalSince1970)
        return time
        
    }
    
    // 影藏所有的输入面板
    private func hiddenChatBarView(complete:(()->Void)? = nil ){

       // 影藏textfield的 keyboard
        self.chatBarView.inputText.resignFirstResponder()

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
    
    
    
    // 显示jod详细界面
    
    private func showJobView(mes:JobDescriptionlMessage){
        
        self.chatBarView.inputText.resignFirstResponder()
        
        // 影藏 emotion 和 more 输入view
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            // 先改变view 后 在显示vc
            self.moveBar(distance: 0){
                let job = JobDetailViewController()
                job.uuid = mes.jobID!
                self.navigationController?.pushViewController(job, animated: true)
            }
        }else{
    
            let job = JobDetailViewController()
            job.uuid = mes.jobID!
            self.navigationController?.pushViewController(job, animated: true)
            
        }
        self.chatBarView.keyboardType = .none
        
    }
    
}




extension CommunicationChatView: chatMoreViewDelegate{
    
    func selectetType(moreView: ChatMoreView, didSelectedType type: ChatMoreType) {
        
        switch type {
        // MARK
        case .pic:
            
            
            if self.getPhotoLibraryAuthorization() == false{
                
                let alert = UIAlertController(title: "温馨提示", message: "没有相册的访问权限，请在应用设置中开启权限", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
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
                
            }
            
            
        case .feedback:
            // 显示
            showReplyPopView()
            
        // 模拟器相机不能用
        case .camera:
            if self.getPhotoLibraryAuthorization() == false{
                
                let alert = UIAlertController(title: "温馨提示", message: "没有相册的访问权限，请在应用设置中开启权限", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
             
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                //初始化图片控制器
                let picker = UIImagePickerController()
                
                //设置代理
                picker.delegate = self
                
                //设置媒体类型
                picker.mediaTypes = [kUTTypeImage as String,kUTTypeVideo as String]
                
                //设置来源
                picker.sourceType = .camera
                
                //设置镜头 front:前置摄像头  Rear:后置摄像头
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                    picker.cameraDevice = UIImagePickerController.CameraDevice.rear
                }else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
                    picker.cameraDevice = UIImagePickerController.CameraDevice.front
                }
                
                //设置闪光灯(On:开、Off:关、Auto:自动)
                picker.cameraFlashMode = UIImagePickerController.CameraFlashMode.auto
                //允许编辑
                picker.allowsEditing = true
                //打开相机
                self.present(picker, animated: true, completion: nil)
            }
            
        default:
            break
     
        }
    }

}


extension CommunicationChatView: ChatEmotionViewDelegate{
    
    func chatEmotionGifSend(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion, type:MessgeType) {
        self.sendGifMessage(emotion: emotion, type:type)
        
    }
    
    // 插入表情
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion) {
        self.chatBarView.inputText.insertEmotion(emotion: emotion)
        
    }
    
    func chatEmotionViewSend(emotionView: ChatEmotionView) {
        self.sendMessage()
    }
   

    func sendMessage(){
        
        // 获取富文本  消息
        var message = self.chatBarView.inputText.getEmotionString()
        
        // 恢复 chatbarView 输入框高度
        self.chatBarUpdateHeight(height: 0)
        self.chatBarView.inputText.frame = CGRect.init(x: 5, y: 5, width: GlobalConfig.ScreenW - 60 - 20, height: 35)
        
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
    
    //   gif 图片路径
    func sendGifMessage(emotion: MChatEmotion, type:MessgeType){
        
        guard let path = emotion.text else {
            return
        }
        if  let message = GigImageMessage(JSON: ["messageID":getUUID(), "type":type.rawValue,"localGifPath":path,"creat_time":Date.init().timeIntervalSince1970,"isRead":true]){
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
    

    
    func sendImage(Data:Data, imageName: String){
        if let message = PicutreMessage(JSON: ["messageID":getUUID(),"type":MessgeType.picture.rawValue,
                                            "creat_time":Date.init().timeIntervalSince1970,
                                            "isRead":true,"imageFileName": imageName]){
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
            try SqliteManager.shared.db?.transaction(block: {
                
                try self.conversationManager.insertMessageItem(items: [mes])
                self.conversationManager.updateConversationMessageID(messageID: mes.messageID!, userID: self.hr!.userID!, date: mes.creat_time!)
                
            })
            
            // 判断时间间隔
            if LXFChatMsgTimeHelper.shared.needAddMinuteModel(preModel: self.tableSource.lastObject as! MessageBoby, curModel: mes){
                self.tableSource.add(createTimeMsg(msg: mes))
            }
            
            self.tableSource.add(mes)
            
            self.tableView.reloadData()
            let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
            self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
            //3  数据插入本地数据库 后通知更新 converation 会话界面，显示内容
            
            if let row = currentRow{
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshChatRow"), object: nil, userInfo: ["row":row,"userID":hr.userID!])
            }
            
        }catch{
            print(error)
        }
        
    }
    
    
}

// chatbar代理 切换视图

extension CommunicationChatView: ChatBarViewDelegate{

    func showEmotionKeyboard() {
       
        self.emotion.isHidden = false
        self.moreView.isHidden = true
        self.moveBar(distance: charMoreViewH)
    }
    
    func showMoreKeyboard() {
        
        self.emotion.isHidden = true
        self.moreView.isHidden = false
        self.moveBar(distance: charMoreViewH)
    }
    
    func chatBarUpdateHeight(height: CGFloat) {
        var y:CGFloat = 0
        
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            y = charMoreViewH  // 216 高度
        }else{
            y = keyboardFrame?.height ?? 0
        }
        let height = ChatInputBarH + height
        _ = self.chatBarView.sd_layout().yIs(GlobalConfig.ScreenH - y - height)?.heightIs(height)
        self.tableView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - height - y)
        let row = IndexPath.init(row: self.tableSource.count - 1   , section: 0)
        self.tableView.scrollToRow(at: row, at: .none, animated: true)
        self.currentChatBarHright =  height
        
    }
    
    func chatBarSendMessage() {
        self.sendMessage()
    }
    
    
}

extension CommunicationChatView{
    

    func moveBar(distance: CGFloat, complete:(()->Void)? = nil ) {
        
        //一起移动 inputview 和emotion 和 moreview 和 tableview 的位置

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // 改变table 大小
            self.tableView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - self.currentChatBarHright - distance)
            //改变 chatbar 位置和大小
            self.chatBarView.frame  = CGRect.init(x: 0, y: GlobalConfig.ScreenH - distance - self.currentChatBarHright, width: GlobalConfig.ScreenW, height: self.currentChatBarHright)
            
            // tableview滑动到底部
            if distance != 0 {
                let path = IndexPath.init(row: self.tableSource.count-1, section: 0)
                self.tableView.scrollToRow(at: path, at: .bottom, animated: true)
            }
        }) { bool in
            complete?()
        }
        
        
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
        
        guard  let h =  sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        keyboardFrame =  h
    
        
        // 影藏
        self.emotion.isHidden = true
        self.moreView.isHidden = true
        self.moveBar(distance: keyboardFrame?.height ?? 0)
        
    }
    


   
    
    
    // 相册使用权判断
   private  func getPhotoLibraryAuthorization() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            print("已经授权")
            return true
        case .notDetermined:
            print("不确定是否授权")
            // 请求授权
            PHPhotoLibrary.requestAuthorization { status in
                 return status == .authorized
            }
        default:
            break
        }
    
    
        return false
    }
    
}


extension CommunicationChatView {
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if self.chatBarView.keyboardType != .none{
            self.hiddenChatBarView()
        }
    }
    
    private func showReplyPopView(){
        let replyTable  =  quickReplyView(frame: CGRect.zero)
        replyTable.selecteDelagate  = self
        replyPopView.setTitleAndView(title: "选择回复内容", view: replyTable)
        replyPopView.showPop(height: popViewH)
    }
    
    
}

// 手势代理
extension CommunicationChatView: UIGestureRecognizerDelegate{
    

    // 允许 tableview 上多个手势执行
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.view?.isKind(of: UITableView.self))!{
            return true
        }
        return false
    }
    
}


// 快捷回复 delegate
extension CommunicationChatView: ReplyMessageDelegate{
    
    func didSelectedMessage(view: UITableView, message: String) {
        self.replyPopView.dismiss()
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
        
        var selectedImage:UIImage?
        
        
        if let originImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage{
                selectedImage = originImage
        }else if let editImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage{
                selectedImage = editImage
        }
        
        if let image = selectedImage{
            //picker.dismiss(animated: true, completion: nil)
            if picker.sourceType == .camera{
                // 照相的照片 默认是jpeg 格式
                // 生成时间戳 和 扩展名的 图片名称
               
                let DateFormat = DateFormatter.init()
                // 
                DateFormat.dateFormat = "yyyy-MM-dd HH.mm.ss"
                imageName = DateFormat.string(from: Date()) + ".jpeg"
                imageData =  image.jpegData(compressionQuality: 0)
                
                
            }else if picker.sourceType == .photoLibrary{
                // 照片库
                // 获取名称
                imagePathURL = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL
                imageName = imagePathURL!.lastPathComponent
                // 文件扩展类型
                let fileType =  imageName.components(separatedBy: ".").last!
                if fileType.lowercased() == "jpeg"{
                    imageData = image.jpegData(compressionQuality: 0)
                }else{
                    imageData = image.pngData()
                }
               
            }
            
            do{
                // 图片存在聊天对象 本地文件夹
                try  appImageManager.createImageFile(userID: self.hr.userID!,fileName: imageName, image: imageData!)
                self.sendImage(Data: imageData!, imageName: imageName)
                
            }catch{
                print(error)
                return
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
}


// 保存图片 alert

extension CommunicationChatView{
    
    private func  storeImageFromCell(image:UIImage){
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
        
        let hint = error != nil ? "保存失败" : "保存成功"
        self.tableView.showToast(title: hint, customImage: nil, mode: .text)
    
    }
}
