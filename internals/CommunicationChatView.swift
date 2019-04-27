//
//  communication.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import ObjectMapper
import MobileCoreServices
import Photos
import RxCocoa
import RxSwift
// TODO 显示d当前用户地理位置消息
import MapKit



fileprivate let charMoreViewH:CGFloat = 216
fileprivate let popViewCGSize:CGSize = CGSize.init(width: 200, height: 200)
fileprivate let quikReplyTitle:String = "选择回复内容"


protocol chatContentTableViewDelegate: class {
    // 点击cell 显示message 内容代理
    func showContent(mes: MessageBoby)
    func showLocationMap(mes: LocationMessage)
    func storageImage(image:UIImage)
    func resendImageMsg(mes: PicutreMessage, row:Int)
    func beginDragTableView()
}
// 显示聊天内容的table
fileprivate  class chatContentTableView:UITableView{
    
    weak var chatDelegate:chatContentTableViewDelegate?
    // 聊天数据
    var datas:NSMutableArray = []
    internal var hr:HRPersonModel?
    private var firstLoad:Bool = false
    
    
    convenience init(frame: CGRect, style: UITableView.Style,  chatVC:  CommunicationChatView){
        self.init(frame: frame, style: style)
        //self.datas = chatVC.tableSource
        //self.hr = chatVC.hr
        self.firstLoad = chatVC.firstLoad
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
        self.tableFooterView = UIView.init()
        self.separatorStyle = .none
        self.backgroundColor = UIColor.viewBackColor()
        self.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        self.keyboardDismissMode = .onDrag
        
        self.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseidentify())
        self.register(JobMessageCell.self, forCellReuseIdentifier: JobMessageCell.identitiy())
        self.register(GifCell.self, forCellReuseIdentifier: GifCell.reuseidentify())
        self.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentify())
        self.register(ChatTimeCell.self, forCellReuseIdentifier: ChatTimeCell.identity())
        // 地理位置
        self.register(LocationMessageCell.self, forCellReuseIdentifier: LocationMessageCell.identity())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit communicationChatVC \(String.init(describing: self))")
    }
    
    
}


extension chatContentTableView:  UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let message  = self.datas.object(at: indexPath.row) as? MessageBoby{
            
            if message.isKind(of: GifImageMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: GifCell.reuseidentify(), for: indexPath) as! GifCell
                cell.setupPictureCell(messageInfo: message as! GifImageMessage , chatUser: self.hr)
                return cell
            }else if message.isKind(of: JobDescriptionlMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: JobMessageCell.identitiy(), for: indexPath) as! JobMessageCell
                cell.mode = message as? JobDescriptionlMessage
                return cell
            }else if message.isKind(of: PicutreMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentify(), for: indexPath) as! ImageCell
                cell.mode = message as? PicutreMessage
                cell.hr = self.hr
                //cell.storeImage = storeImageFromCell
                // 导致vc 不释放 内存泄露！！
                //cell.storeImage = chatDelegate?.storageImage
                cell.storeImage = { [weak self]  (image) in
                    self?.chatDelegate?.storageImage(image: image)
                }
                
                cell.resendImage = { [weak self] (msg) in
                    self?.chatDelegate?.resendImageMsg(mes: msg, row: indexPath.row)
                }
                return cell
            }else if message.isKind(of: TimeMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatTimeCell.identity(), for: indexPath) as! ChatTimeCell
                cell.model = message as? TimeMessage
                return cell
            }else if message.isKind(of: LocationMessage.self){
                let cell = tableView.dequeueReusableCell(withIdentifier: LocationMessageCell.identity(), for: indexPath) as! LocationMessageCell
                //cell.mode = message as? LocationMessage
                cell.setCell(mode: message, chatUser: self.hr)
                cell.navigate2Map = { [weak self] mes  in
                    // 跳转到地图
                   self?.chatDelegate?.showLocationMap(mes: mes!)
                }
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseidentify(), for: indexPath) as! MessageCell
                cell.setupMessageCell(messageInfo: message, chatUser: self.hr)
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message:MessageBoby  = self.datas.object(at: indexPath.row) as? MessageBoby{
            
            switch message.messageType{
            case .text:
                return MessageCell.heightForCell(messageInfo: message)
                
            case .smallGif,.bigGif:
                // 计算得到的值
                return message.messageType == .bigGif ? 120 : 80
                
            case .picture:
                let message = self.datas.object(at: indexPath.row) as! PicutreMessage
                return tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: ImageCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .jobDescribe:
                let message = self.datas.object(at: indexPath.row) as! JobDescriptionlMessage
                return tableView.cellHeight(for: indexPath, model: message, keyPath: "mode", cellClass: JobMessageCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .time:
                return ChatTimeCell.cellHeight()
            case .location:
                return 160
            default:
                break
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mes = self.datas.object(at: indexPath.row) as? JobDescriptionlMessage{
            //showJobView(mes: mes)
            chatDelegate?.showContent(mes: mes)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 加载最后可见cell 后，第一次进入view时滚动到最底部的cell
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row && firstLoad{
            UIView.performWithoutAnimation {
                tableView.scrollToRow(at: IndexPath.init(row: self.datas.count - 1, section: 0), at: .bottom, animated: false)
            }
      
            firstLoad = false
            
        }
    }
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.chatDelegate?.beginDragTableView()
    }
    
}

// 聊天对话 界面
class CommunicationChatView: UIViewController {

    // 聊天对象
    fileprivate var hr:HRPersonModel?{
        didSet{
            self.title = (self.hr?.name ?? "") + "@" + (self.hr?.company ?? "")
        }
    }
    // 用户
    private var globalUser:GlobalUserInfo = GlobalUserInfo.shared
    // hr 的id
    private var recruiterId:String?
    //fileprivate var tableSource:NSMutableArray = []
    
    // 记录 device keyboard frame
    private var keyboardFrame:CGRect?
    
    // 记录输入框高度
    private var currentChatBarHright:CGFloat = GlobalConfig.ChatInputBarH
    
    // 会话数据库管理操作
    private lazy var conversationManager:ConversationManager = ConversationManager.shared
    
    // 会话查询开始时间
    private var startMessageIndex:Date = Date.init()
    // 每次获取会话 的个数(每次table 上拉刷新)
    private let limit:Int = 10
    // 第一次加载
    fileprivate var firstLoad:Bool = true
    
    // 本地文件管理
    fileprivate let appImageManager = AppFileManager.shared
    
    // 聊天列表界面跳转来 记录当前行
    private var currentRow:Int?
    
    // 对话实例， 发送消息用，接收消息
    private var conversation:AVIMConversation?
 
    // rxswift
    private let messageHttp:MessageHttpServer = MessageHttpServer.shared
    private lazy var  dispose:DisposeBag = DisposeBag.init()
    
    
    // 聊天内容显示table
    private lazy var tableView:chatContentTableView = { [unowned self] in
        let tb = chatContentTableView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - GlobalConfig.ChatInputBarH),style: .plain, chatVC: self)
        tb.chatDelegate = self
        
        // 顶部刷新
       
        let headerRefresh = UIRefreshControl.init()
        headerRefresh.attributedTitle = NSAttributedString.init(string: "获取历史消息")
        headerRefresh.addTarget(self, action: #selector(historyMsg), for: UIControl.Event.valueChanged)
        tb.refreshControl = headerRefresh
        
        return tb
    }()
    
    
    // 底部聊天输入框
    private lazy var chatBarView:ChatBarView = { [unowned self] in
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
            (name: "快捷回复",icon: #imageLiteral(resourceName: "autoMessage"), type: ChatMoreType.feedback),
            (name: "位置信息", icon: #imageLiteral(resourceName: "nearby"), type: ChatMoreType.location)
        ]
        // TODO 加入其它发送类型
        
        return moreV
    }()
    
    
    // 动态表情界面
    private lazy var emotion:ChatEmotionView = { [unowned self] in
       let emojView = ChatEmotionView()
       emojView.delegate = self
       return emojView
    }()
    
    //快捷回复界面
    private lazy var replyPopView:PopView = { [unowned self] in
       let v = PopView.init(frame: CGRect.init(x: PopView.offsetX, y: (GlobalConfig.ScreenH - popViewCGSize.height)/2, width: popViewCGSize.width, height: popViewCGSize.height))
        
       let replyTable  =  quickReplyView(frame: CGRect.zero)
       replyTable.selecteDelagate  = self
       
       v.setTitleAndView(title: quikReplyTitle, view: replyTable)
       v.layer.masksToBounds = true
       v.layer.cornerRadius = 10
       return v
    }()
    
    
    private lazy var recruiteVC = PublisherControllerView()
    
    private lazy var alertView:UIAlertController = {  [unowned self] in
        let alertV = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alertV.addAction(UIAlertAction.init(title: "查看TA的名片", style: UIAlertAction.Style.default, handler: {  [unowned self] (action) in
           
            // MARK
            guard let hr = self.hr, let id = hr.userID else {
                return
            }
            self.recruiteVC.userID = id
            self.navigationController?.pushViewController(self.recruiteVC, animated: true)
        }))
        alertV.addAction(UIAlertAction.init(title: "屏蔽TA", style: .default, handler: { (action) in
            // 更新conversation    不能发消息
        }))
        alertV.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        return alertV
    }()
    

    
    init(recruiterId:String, row:Int? = nil, conversation:AVIMConversation? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentRow = row
        self.conversation = conversation
        self.recruiterId = recruiterId
        
        // 标记消息已读
        conversation?.readInBackground()
        globalUser.delegate = self 
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit communicationChatView")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setViews()
        self.setViewModel()
        
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
    
    
    
}




extension CommunicationChatView {
    
    
    private func setViews(){
        
        self.navigationController?.delegate = self
        self.view.backgroundColor = UIColor.backGroundColor()
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // 更多baritem按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image:  UIImage.init(named: "more")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(moreButton))
        
        self.view.addSubview(tableView)
        self.view.addSubview(chatBarView)
        self.view.addSubview(moreView)
        self.view.addSubview(emotion)
        
        
        
        _  = chatBarView.sd_layout().leftEqualToView(self.view)?.yIs(GlobalConfig.ScreenH - GlobalConfig.ChatInputBarH)?.rightEqualToView(self.view)?.heightIs(GlobalConfig.ChatInputBarH)
        
        _ = emotion.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(charMoreViewH)
        
        _ = moreView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(charMoreViewH)
        
    }
    
    
    private func setViewModel(){
        
        
    // 获取recruiter
    messageHttp.getRecruiterInfo(userId: self.recruiterId!).subscribe(onNext: { [weak self]  (mode) in
            if let m = mode.body{
                self?.hr = m
                self?.tableView.hr = m
                self?.chatRecordLoad()
            }else{
                // 显示错误界面 TODO
            }
            
        }).disposed(by: self.dispose)
        
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil).subscribe(onNext: {  [weak self] (notify) in
            
            
            guard  let h =  notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            self?.keyboardFrame =  h
            
            
            // 影藏
            self?.emotion.isHidden = true
            self?.moreView.isHidden = true
            self?.moveBar(distance: self?.keyboardFrame?.height ?? 0)
            
        }).disposed(by: self.dispose)
        
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil).subscribe(onNext: {  [weak self] (notify) in
            
            self?.keyboardFrame = CGRect.zero
            
            if self?.chatBarView.keyboardType == .emotion || self?.chatBarView.keyboardType == .more{
                return
            }
            self?.moveBar(distance: 0)
            
            
        }).disposed(by: self.dispose)
        
    }
    
    
    
    // 加载最新聊天记录倒数10条 (未读消息如何处理TODO)
    private func chatRecordLoad(reverse:Bool = false){
        // 任务顺序执行
        //  获取历史消息
        
        //self.startMessageIndex += self.tableView.datas.count
        // 创建时间区分 查询
        let (mes,err) = self.conversationManager.getLatestMessageBy(conversationId: (self.conversation?.conversationId)!, startTime: self.startMessageIndex, limit: self.limit)
        if err != nil{
            self.tableView.showToast(title: "本地获取消息失败\(String(describing: err))", customImage: nil, mode: .text)
            return
        }
        if mes.count > 0 {
            
            self.startMessageIndex = mes.first?.creat_time ?? Date.init()
            
            // 添加time 消息
            let after = self.addTimeMsg(mes:mes)
            // 插入之前的历史消息
            if reverse{
                for (index, item) in  after.enumerated(){
                    self.tableView.datas.insert(item, at: index)
                }
            }else{
                self.tableView.datas.addObjects(from: after)
            }
            
            // start位置偏移量， MARK 上拉查询刷新记录
            //self.startMessageIndex += mes.count
        }
        //print(self.tableView.datas.count)
        // 刷新table
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
       
    }
    
    
    
    
}




extension CommunicationChatView: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 从job 跳转来的，返回后 需要刷新 chatlist
        if self.currentRow == nil, viewController.isKind(of: JobDetailViewController.self){
            NotificationCenter.default.post(name: NSNotification.Name.init("refreshChat"), object: nil)
        }
        
    }
    
}



extension CommunicationChatView: chatContentTableViewDelegate{
    
    func resendImageMsg(mes: PicutreMessage, row: Int) {
        
        guard let imageData = AppFileManager.shared.getImageDataBy(userID: mes.receiveId!, fileName: mes.fileName!) else{
            print("未找到图片文件\(String.init(describing: mes.fileName))")
            return
        }
        
        let indexPath = IndexPath.init(row: row, section: 0)
        
        guard let cell = self.tableView.cellForRow(at: indexPath) as? ImageCell else {
            self.tableView.showToast(title: "未找到image cell", customImage: nil, mode: .text)
            return
        }
        //
        let file = AVFile.init(data: imageData, name: mes.fileName)
        let imgIM = AVIMImageMessage.init(text: "图片消息", file: file, attributes: ["type":"image", "name": mes.fileName!])
        
       
        let option = AVIMMessageOption.init()
        option.priority = AVIMMessagePriority.low
        // 离线推送消息
        option.pushData = ["alert":"未读消息", "sound":"default", "badge":1, "custom-key":"图片消息", "_profile":"dev"]
        
        // 需要回执？
        // option.receipt = false
        
        self.conversation?.send(imgIM, option: option, progressBlock: {  (progress) in
            print("发送图片进度--->  \(String.init(describing: progress))")
            cell.resend.isHidden = true
            // 根据状态刷新 图片进度
            if !cell.activity.isAnimating{
                cell.activity.startAnimating()
            }
        }, callback: { [weak self] (success, error) in
            // 模拟延迟 查看进度状态
            if success{
                // 存入数据库
                try? self?.conversationManager.updateSendedMessage(id: mes.id!, sended: true)
            }
            if error != nil{
                // 刷新图片 失败状态
                self?.tableView.showToast(title: "发送图片失败\n 请重新发送", duration: 5, customImage: nil, mode: .text)
                cell.resend.isHidden = false
            }
            cell.activity.stopAnimating()
           
        })
        
        
        
    }
    
    
    func showContent(mes: MessageBoby) {
        if let jobMsg = mes as? JobDescriptionlMessage{
             self.showJobView(mes: jobMsg)
        }
    }
    
    func storageImage(image: UIImage) {
        self.storeImageFromCell(image: image)
    }
    
    func beginDragTableView() {
        if self.chatBarView.keyboardType != .none{
            self.hiddenChatBarView()
        }
    }
    
    func showLocationMap(mes: LocationMessage) {
        
        let place = CLLocation.init(latitude: mes.latitude!, longitude: mes.longitude!).coordinate
        let alert  =  PazNavigationApp.directionsAlertController(coordinate: place, name: mes.address ?? "", title: "选择地图", message: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension CommunicationChatView{
    
    @objc private func historyMsg(){
        
        self.chatRecordLoad(reverse: true)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    // 添加时间message
    private func addTimeMsg(mes:[MessageBoby]) -> [MessageBoby]{
        var res = [MessageBoby]()
        for index in 0..<mes.count{
            if index == 0 {
                res.append(createTimeMsg(msg: mes[index]))
            }else{
                // 2个消息间隔时间超过指定时间 才添加时间
                if (ChatMsgTimeHelper.shared.needAddMinuteModel(preModel: mes[index - 1], curModel: mes[index])){
                    res.append(createTimeMsg(msg: mes[index]))
                }
            }
            res.append(mes[index])
        }
        return res
    }
    
    // 获取时间 message
    private func createTimeMsg(msg: MessageBoby) -> TimeMessage{
        // 时间消息
        let time = TimeMessage(JSON: ["type":MessgeType.time.describe,
                                      "creat_time":msg.creat_time!.timeIntervalSince1970,
                                      "receiver_id": msg.receiveId!,
                                      "sender_id": msg.senderId!,
                                      "conversation_id": msg.conversayionId!
            ])!
        
        
        time.timeStr = ChatMsgTimeHelper.shared.chatTimeString(with: time.creat_time?.timeIntervalSince1970)
        
        
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
            self.moveBar(distance: 0){ [weak self] in
                self?.showJobVC(mes: mes)
            }
        }else{
            self.showJobVC(mes: mes)
        }
        self.chatBarView.keyboardType = .none
    }
    
    
    private func showJobVC(mes: JobDescriptionlMessage){
        
        let job = JobDetailViewController()
        job.job = (mes.jobID!, mes.jobtype)
        job.fromChatVC = true
        self.navigationController?.pushViewController(job, animated: true)
    }
}


extension CommunicationChatView: chatMoreViewDelegate{
    
    
    private func picturType(type: ChatMoreType){
        guard type == .pic || type == .camera  else {
            return
        }
        
        if Utils.PhotoLibraryAuthorization() == false{
            let warnMsg = type == .pic ? "没有相册的访问权限，请在应用设置中开启权限" : "没有相机的访问权限，请在应用设置中开启权限"
            self.tableView.presentAlert(type: UIAlertController.Style.alert, title: "温馨提示", message: warnMsg, items: [], target: self) { _  in }
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            
            //设置代理
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = type == .pic ? .photoLibrary : .camera
            picker.mediaTypes = type == .pic ? [kUTTypeImage as String] : [kUTTypeImage as String,kUTTypeVideo as String]
            
            if type == .camera{
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                    picker.cameraDevice = UIImagePickerController.CameraDevice.rear
                }else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
                    picker.cameraDevice = UIImagePickerController.CameraDevice.front
                }
                
                //设置闪光灯(On:开、Off:关、Auto:自动)
                picker.cameraFlashMode = UIImagePickerController.CameraFlashMode.auto
                
            }
            
            
            self.present(picker, animated: true, completion: nil)
            
        }
        
    
    }
    
    func selectetType(moreView: ChatMoreView, didSelectedType type: ChatMoreType) {
        
        switch type {
        // MARK
        case .pic:
            self.picturType(type: .pic)
            
//            if Utils.PhotoLibraryAuthorization() == false{
//
//                self.view.presentAlert(type: UIAlertController.Style.alert, title: "温馨提示", message: "没有相册的访问权限，请在应用设置中开启权限", items: [], target: self) { _  in }
//                return
//            }
//
//
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//                //初始化图片控制器
//                let picker = UIImagePickerController()
//
//                //设置代理
//                picker.delegate = self
//
//                //设置媒体类型
//                //picker.mediaTypes = [kUTTypeImage as String,kUTTypeVideo as String]
//                picker.mediaTypes = [kUTTypeImage as String]
//
//                //设置允许编辑
//                picker.allowsEditing = true
//
//                //指定图片控制器类型
//                picker.sourceType = .photoLibrary
//
//                //弹出控制器,显示界面
//                self.present(picker, animated: true, completion: nil)
//
//            }
            
            
        case .feedback:
            // 显示
            replyPopView.showPop(height: popViewCGSize.height)
            
        // 模拟器相机不能用
        case .camera:
            self.picturType(type: .camera)
//            if Utils.PhotoLibraryAuthorization() == false{
//
//                self.view.presentAlert(type: UIAlertController.Style.alert, title: "温馨提示", message: "没有相册的访问权限，请在应用设置中开启权限", items: [], target: self) { _  in }
//                return
//            }
//
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                //初始化图片控制器
//                let picker = UIImagePickerController()
//
//                //设置代理
//                picker.delegate = self
//
//                //设置媒体类型
//                picker.mediaTypes = [kUTTypeImage as String,kUTTypeVideo as String]
//
//                //设置来源
//                picker.sourceType = .camera
//
//                //设置镜头 front:前置摄像头  Rear:后置摄像头
//                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
//                    picker.cameraDevice = UIImagePickerController.CameraDevice.rear
//                }else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
//                    picker.cameraDevice = UIImagePickerController.CameraDevice.front
//                }
//
//                //设置闪光灯(On:开、Off:关、Auto:自动)
//                picker.cameraFlashMode = UIImagePickerController.CameraFlashMode.auto
//                //允许编辑
//                picker.allowsEditing = true
//                //打开相机
//                self.present(picker, animated: true, completion: nil)
//            }
            
        case .location:
            // 判断是否授权地理位置信息
            if  UserLocationManager.shared.getLocation() == false {
                self.tableView.showToast(title: "地理位置不可用", customImage: nil, mode: .text)
                return
            }
            
            // 获取地址位置
            let cclocation =  SingletoneClass.shared.getLocation()
            guard let address = SingletoneClass.shared.getAddress() else {
                return
            }
            
            // 发送地址位置消息
            let locationIM = AVIMLocationMessage.init(text: "我的位置", latitude: CGFloat(cclocation.coordinate.latitude), longitude: CGFloat(cclocation.coordinate.longitude), attributes: ["type":"location", "address": address])
           
            self.buildMsgThenSend(mtype: .location, msg: locationIM)
            
//            self.conversation?.send(locationIM, callback: {  [weak self] (success, error) in
//                if success{
//                    if let msg = Mapper<LocationMessage>.init().map(JSON: [
//                        "conversation_id": (self?.conversation?.conversationId)!,
//                        "type": MessgeType.location.describe,
//                        "creat_time": Date.init().timeIntervalSince1970,
//                        "is_read": true,
//                        "sender_id": self?.globalUser.getId()!,
//                        "receiver_id": (self?.hr?.userID)!,
//                        "latitude": cclocation.coordinate.latitude,
//                        "longitude": cclocation.coordinate.longitude,
//                        "address": address
//                        ]){
//                        try? self?.conversationManager.insertMessageItem(items: [msg])
//                        self?.reloads(mes: msg)
//                    }
//
//
//                    return
//                }
//                if error != nil{
//                    self?.tableView.showToast(title: "发送地理位置消息失败\(String(describing: error))", customImage: nil, mode: .text)
//                }
//            })
           
            
           // print("my location and address")
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
   

    private func sendMessage(){
        
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
        
        // 构建消息发送  和 存入数据库 流程 session ?
        
        let textIM = AVIMTextMessage.init(text: message, attributes: ["type": MessgeType.text.describe])
        self.buildMsgThenSend(mtype: .text, msg: textIM)
        
//        self.conversation?.send(textIM, callback: {  [weak self] (success, error) in
//            if success{
//                // 插入数据库
//                if let msg = Mapper<MessageBoby>.init().map(JSON: [
//                    "conversation_id": (self?.conversation?.conversationId)!,
//                    "type": MessgeType.text.describe,
//                    "content": (textIM.text)!,
//                    "creat_time": Date.init().timeIntervalSince1970,
//                    "is_read": true,
//                    "sender_id": self?.globalUser.getId()!,
//                    "receiver_id": (self?.hr?.userID)!
//                    ]){
//                    try? self?.conversationManager.insertMessageItem(items: [msg])
//                    self?.reloads(mes: msg)
//                }
//
//                return
//            }
//
//            if error != nil{
//                self?.tableView.showToast(title: "发送消息失败\(String.init(describing: error))", customImage: nil, mode: .text)
//            }
//        })
        
        
        
        
    }
    
   
    private func sendGifMessage(emotion: MChatEmotion, type:MessgeType){
        // gif 名字
        guard let name = emotion.text else {
            return
        }
        // 发送text消息 注意类型
        // 存入数据库
        // 刷新table
        let textIM = AVIMTextMessage.init(text: "gif 消息", attributes: ["type": type.describe, "name": name])
        self.buildMsgThenSend(mtype: type, msg: textIM)
        
//        self.conversation?.send(textIM, callback: {  [weak self] (success, error) in
//            if success{
//                //let msg = GigImageMessage
//                if let gifMsg = Mapper<GifImageMessage>.init().map(JSON: [
//                    "conversation_id": (self?.conversation?.conversationId)!,
//                    "type": type.describe,
//                    "creat_time": Date.init().timeIntervalSince1970,
//                    "is_read": true,
//                    "sender_id": self?.globalUser.getId()!,
//                    "receiver_id": (self?.hr?.userID)!,
//                    "local_gif_name": name]){
//
//                    try? self?.conversationManager.insertMessageItem(items: [gifMsg])
//                    self?.reloads(mes: gifMsg)
//                }
//                return
//            }
//            if error != nil{
//                self?.tableView.showToast(title: "发送gif失败\(String(describing: error))", customImage: nil, mode: .text)
//            }
//        })
        
       
        
    }
    // 发送快捷回复 消息
    private func sendReply(content:String){
        
        let textIM = AVIMTextMessage.init(text: content, attributes: ["type": MessgeType.text.describe])
        
        self.buildMsgThenSend(mtype: .text, msg: textIM)
//        self.conversation?.send(textIM, callback: {  [weak self] (success, error) in
//            if success{
//                // 插入数据库
//                if let msg = Mapper<MessageBoby>.init().map(JSON: [
//                    "conversation_id": (self?.conversation?.conversationId)!,
//                    "type": MessgeType.text.describe,
//                    "content": textIM.text!,
//                    "creat_time": Date.init().timeIntervalSince1970,
//                    "is_read": true,
//                    "sender_id": self?.globalUser.getId()!,
//                    "receiver_id": (self?.hr?.userID)!
//                    ]){
//                    try? self?.conversationManager.insertMessageItem(items: [msg])
//                    self?.reloads(mes: msg)
//                }
//
//                return
//            }
//
//            if error != nil{
//                self?.tableView.showToast(title: "发送消息失败\(String(describing: error))", customImage: nil, mode: .text)
//            }
//        })
        
    }
    

    
   private func sendImage(data:Data, imageName: String){
        let file = AVFile.init(data: data, name: imageName)
        let imgIM = AVIMImageMessage.init(text: "图片消息", file: file, attributes: ["type":"image", "name": imageName])
    
        guard let msg = Mapper<PicutreMessage>.init().map(JSON: [
            "conversation_id": (self.conversation?.conversationId)!,
            "type": MessgeType.picture.describe,
            "content": imageName,
            "fileName": imageName,
            "creat_time": Date.init().timeIntervalSince1970,
            "is_read": true,
            "sender_id": globalUser.getId()!,
            "receiver_id": (self.hr?.userID)!,
            "sended": true,
            ])else{
            self.tableView.showToast(title: "创建消息失败", customImage: nil, mode: .text)
            return
        }
        // 先把图片加入tableview
        self.reloads(mes: msg)
        // 图片cell
        let imageRow = self.tableView.datas.count - 1
        let indexPath = IndexPath.init(row: imageRow, section: 0)
    
        guard let cell = self.tableView.cellForRow(at: indexPath) as? ImageCell else {
            self.tableView.showToast(title: "未找到image cell", customImage: nil, mode: .text)
            return
        }
        let option = AVIMMessageOption.init()
        option.priority = AVIMMessagePriority.low
        self.conversation?.send(imgIM, option: option, progressBlock: {  (progress) in
            print("发送图片进度--->  \(String.init(describing: progress))")
            // 根据状态刷新 图片进度
            if !cell.activity.isAnimating{
                cell.activity.startAnimating()
            }
        }, callback: { [weak self] (success, error) in
            // 模拟延迟 查看进度状态
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                if success{
                    // 存入数据库
                    try? self?.conversationManager.insertMessageItem(items: [msg])
                    // 更新 聊天list 列表
                    if let row = self?.currentRow{
                        NotificationCenter.default.post(name: NotificationName.refreshChatRow, object: nil, userInfo: ["row":row, "conversationId": msg.conversayionId!])
                    }
                }
                if error != nil{
                    msg.sended = false
                    try? self?.conversationManager.insertMessageItem(items: [msg])
                    // 刷新图片 失败状态
                    self?.tableView.showToast(title: "发送图片失败\n 请重新发送", duration: 5, customImage: nil, mode: .text)
                    cell.resend.isHidden = false
                }
                cell.activity.stopAnimating()
            })
        })

    
    }
    
    private func  reloads(mes: MessageBoby){
        
        // 判断时间间隔(前一条消息)
        // 重新修改时间消息数据
        self.tableView.datas.forEach { (msg) in
            if let tmsg = msg as? TimeMessage{
                tmsg.timeStr = ChatMsgTimeHelper.shared.chatTimeString(with: tmsg.creat_time?.timeIntervalSince1970)
            }
        }
        if  let msg = self.tableView.datas.lastObject as? MessageBoby, ChatMsgTimeHelper.shared.needAddMinuteModel(preModel: msg, curModel: mes){
            //self.tableSource.add(createTimeMsg(msg: mes))
             self.tableView.datas.add(createTimeMsg(msg: mes))
            
        }else{
            // 之前没有消息，添加time
            self.tableView.datas.add(createTimeMsg(msg: mes))
        }
        
        self.tableView.datas.add(mes)
        // 阻止cell 奇怪的动画效果
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
            if self.tableView.datas.count > 0{
                let path:NSIndexPath = NSIndexPath.init(row: self.tableView.datas.count-1, section: 0)
                self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: false)
            }
        }
       
        //3  数据插入本地数据库 后通知更新 converation 会话界面，显示内容
        
        if let row = currentRow{
            NotificationCenter.default.post(name: NotificationName.refreshChatRow, object: nil, userInfo: ["row":row, "conversationId": mes.conversayionId!])
        }
            
        
    }
    
    
    private func buildMsgThenSend(mtype: MessgeType, msg:AVIMMessage){
        var m: MessageBoby?
        
        switch  mtype {
        case .location:
            
            guard let locationMsg = msg as? AVIMLocationMessage else { return }
            
            m = Mapper<LocationMessage>.init().map(JSON: [
                "conversation_id": (self.conversation?.conversationId)!,
                "type": MessgeType.location.describe,
                "creat_time": Date.init().timeIntervalSince1970,
                "is_read": true,
                "sender_id": (self.globalUser.getId())!,
                "receiver_id": (self.hr?.userID)!,
                "latitude":  Double(locationMsg.latitude),
                "longitude": Double(locationMsg.longitude),
                "address":  (locationMsg.attributes?["address"] as! String)
                ])

        case .text:
            
            guard let textMsg =  msg as? AVIMTextMessage else { return }
            
            m = Mapper<MessageBoby>.init().map(JSON: [
                "conversation_id": (self.conversation?.conversationId)!,
                "type": MessgeType.text.describe,
                "content": (textMsg.text)!,
                "creat_time": Date.init().timeIntervalSince1970,
                "is_read": true,
                "sender_id": (self.globalUser.getId())!,
                "receiver_id": (self.hr?.userID)!
                ])
            
        case .smallGif, .bigGif:
            guard let textMsg = msg as? AVIMTextMessage else { return }
            m = Mapper<GifImageMessage>.init().map(JSON: [
                "conversation_id": (self.conversation?.conversationId)!,
                "type": mtype.describe,
                "creat_time": Date.init().timeIntervalSince1970,
                "is_read": true,
                "sender_id": self.globalUser.getId()!,
                "receiver_id": (self.hr?.userID)!,
                "local_gif_name": (textMsg.attributes?["name"] as! String)
                ])
        default:
            break
        }
        
        
        // send msg
        if m != nil{
            let option = AVIMMessageOption.init()
            option.priority = .high
            option.pushData = ["alert":"未读消息", "sound":"default", "badge":1, "custom-key":"文本消息", "_profile":"dev"]
            self.conversation?.send(msg, callback: { [weak self] (success, error) in
                if success{
                    try? self?.conversationManager.insertMessageItem(items: [m!])
                    self?.reloads(mes: m!)
                }
                
                if error != nil{
                    self?.tableView.showToast(title: "发送消息失败\(String(describing: error))", customImage: nil, mode: .text)
                }
            })
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
        let height = GlobalConfig.ChatInputBarH + height
        _ = self.chatBarView.sd_layout().yIs(GlobalConfig.ScreenH - y - height)?.heightIs(height)
        self.tableView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - height - y)
        if self.tableView.datas.count > 0{
            let row = IndexPath.init(row: self.tableView.datas.count - 1   , section: 0)
            UIView.performWithoutAnimation {
                self.tableView.scrollToRow(at: row, at: .none, animated: false)
            }
        }
       
        self.currentChatBarHright =  height
        
    }
    
    func chatBarSendMessage() {
        self.sendMessage()
    }
    
    
}

extension CommunicationChatView{
    

    private func moveBar(distance: CGFloat, complete: (()->Void)? = nil ) {
        
        //一起移动 inputview 和emotion 和 moreview 和 tableview 的位置

    
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // 改变table 大小
            self.tableView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - self.currentChatBarHright - distance)
            //改变 chatbar 位置和大小
            self.chatBarView.frame  = CGRect.init(x: 0, y: GlobalConfig.ScreenH - distance - self.currentChatBarHright, width: GlobalConfig.ScreenW, height: self.currentChatBarHright)
            
           
        }) { bool in
            
            // tableview滑动到底部
            if bool &&  distance != 0 && self.tableView.datas.count > 0 {
                let path = IndexPath.init(row: self.tableView.datas.count-1, section: 0)
                UIView.performWithoutAnimation {
                    self.tableView.scrollToRow(at: path, at: .bottom, animated: false)
                }
            }
            
            complete?()
        }
        
        
    }
    
    
}



// 手势代理 ???
//extension CommunicationChatView: UIGestureRecognizerDelegate{
//
//
//    // 允许 tableview 上多个手势执行
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (otherGestureRecognizer.view?.isKind(of: UITableView.self))!{
//            return true
//        }
//        return false
//    }
//
//}


// 快捷回复 delegate
extension CommunicationChatView: ReplyMessageDelegate{
    
    func didSelectedMessage(view: UITableView, message: String) {
        self.replyPopView.dismiss()
        // 影藏更多内容
        self.hiddenChatBarView()
        self.sendReply(content: message)
    }
}

//   照片代理
extension CommunicationChatView: UIImagePickerControllerDelegate{
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        //查看info对象
        var imageData:Data?
        var imageName = ""
        var imagePathURL:URL?
        
        var selectedImage:UIImage?
        
        
        if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                selectedImage = originImage
        }else if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                selectedImage = editImage
        }
        
        if let image = selectedImage{
            // 缩小图片 0.5 倍
            // cell 显示缩略图，查看显示正常图且可以下载 TODO
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
                imagePathURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
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
                try  appImageManager.createImageFile(userID:  (self.hr?.userID)!, fileName: imageName, image: imageData!){ [weak self]  (success, err) in
                    if success{
                         self?.sendImage(data: imageData!, imageName: imageName)
                    }
                }
               
                
            }catch{
                self.tableView.showToast(title: "存储图片到本地失败\(error)", customImage: nil, mode: .text)
                print(error)
                //return
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
    
   
    
    //保存图片消息 方法必须是这样
    @objc  private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        
        let hint = error != nil ? "保存失败" : "保存成功"
        self.tableView.showToast(title: hint, customImage: nil, mode: .text)
    
    }
}



 


// 接收消息处理
extension CommunicationChatView: ReceiveMsgDelegate{
    
    func receiveMsg(con:AVIMConversation, msg:AVIMMessage) -> Bool {
        
        
        // 判断conversation 是否一致
        // 不一致返回false
        // 一致就处理消息
        
        if con.conversationId == self.conversation?.conversationId {
            // 标记消息已读
            con.readInBackground()
            
            // 清楚badge
            try? DBFactory.shared.getConversationDB().updateUnreadCount(conversationId: con.conversationId!, count: 0)
            
            
            switch msg.mediaType{
                
            case .text:
                let textMsg = msg as! AVIMTextMessage
                // 判断attribute
                if let type = textMsg.attributes?["type"] as? String, let mtype =  MessgeType.init(rawValue: type){
                    print("receive text messga \(String(describing: textMsg.text)) from \(String(describing: textMsg.clientId)) with attribute \(String.init(describing: textMsg.attributes))" )
                    switch mtype{
                        case .text:
                            // 刷新table
                            if let m = MessageBoby.init(JSON: [
                                "conversation_id": con.conversationId!,
                                "type": MessgeType.text.describe,
                                "content": textMsg.text!,
                                "creat_time": Date.init().timeIntervalSince1970,
                                "is_read": true,
                                "sender_id": textMsg.clientId!,
                                "receiver_id": self.globalUser.getId()!
                                ]){
                                
                                try? self.conversationManager.insertMessageItem(items: [m])
                                self.reloads(mes: m)
                                
                            }
                        case .bigGif, .smallGif:
                            if let m = GifImageMessage.init(JSON: [
                                "conversation_id": con.conversationId!,
                                "type": mtype.describe,
                                "creat_time": Date.init().timeIntervalSince1970,
                                "is_read": true,
                                "sender_id": textMsg.clientId!,
                                "receiver_id": self.globalUser.getId()!,
                                "local_gif_name": (textMsg.attributes?["name"] as! String)
                                
                            ]){
                                //try? self.conversationManager.insertMessageItem(items: [m])
                                self.reloads(mes: m)
                        }
                        default:
                            print("unkown message type")
                    }
                }
            case .image:
                let imageMsg = msg as! AVIMImageMessage
                
                
                print("receive location messga \(String(describing: imageMsg.text)) from \(String(describing: imageMsg.clientId)) with attribute \(String.init(describing: imageMsg.attributes)) \(String.init(describing:  imageMsg.file?.url()))")
                
                
                if let m  = PicutreMessage.init(JSON: [
                    "conversation_id": con.conversationId!,
                    "type": MessgeType.picture.describe,
                    "content": (imageMsg.file?.url())!,
                    //"fileName": imageName,
                    "fileUrl": (imageMsg.file?.url())!,
                    "creat_time": Date.init().timeIntervalSince1970,
                    "is_read": true,
                    "sender_id": imageMsg.clientId!,
                    "receiver_id": globalUser.getId()!,
                    "sended": true,
                    ]){
                        //try? self.conversationManager.insertMessageItem(items: [m])
                        self.reloads(mes: m)
                }
                
                
            case .location:
               
                let locationMsg = msg as! AVIMLocationMessage
                
                 print("receive location messga \(String(describing: locationMsg.text)) from \(String(describing: locationMsg.clientId)) with attribute \(String.init(describing: locationMsg.attributes))")
                
                if let m = LocationMessage.init(JSON: [
                    "conversation_id": con.conversationId!,
                    "type": MessgeType.location.describe,
                    "creat_time": Date.init().timeIntervalSince1970,
                    "is_read": true,
                    "sender_id": locationMsg.clientId!,
                    "receiver_id": (self.globalUser.getId())!,
                    "latitude":  Double(locationMsg.latitude),
                    "longitude": Double(locationMsg.longitude),
                    "address":  (locationMsg.attributes?["address"] as! String)
                ]){
                    //try? self.conversationManager.insertMessageItem(items: [m])
                    self.reloads(mes: m)
                }
            default:
                return false
                
            }
            
            return true
        }
        
        return false
        
    }
    
    
}
