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




class communication: UIViewController {

    lazy var contactManager:Contactlist = {
        return Contactlist.shared
    }()
    
    
    lazy var tableView:UITableView = { [unowned self] in
        
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: ScreenH - NavH - ChatInputBarH),
                                  style: .plain)
        tb.delegate = self
        tb.dataSource = self
         
        tb.estimatedRowHeight = UITableViewAutomaticDimension
        tb.showsHorizontalScrollIndicator = false
        tb.showsVerticalScrollIndicator = false
        tb.tableFooterView = UIView.init()
        tb.register(messageCell.self, forCellReuseIdentifier: messageCell.reuseidentify())
        tb.register(UINib.init(nibName: "JobMessageCell", bundle: nil), forCellReuseIdentifier: JobMessageCell.identitiy())
        tb.register(gifCell.self, forCellReuseIdentifier: gifCell.reuseidentify())
        tb.register(PersonCardCell.self, forCellReuseIdentifier: PersonCardCell.reuseidentity())
        tb.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentify())
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.lightGray
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(hiddenKeyboard(sender:)))
        tb.addGestureRecognizer(gest)
        return tb
    }()
    
    private var table2Bottom = false
    
    // charbat - bottom
    lazy var chatBarView:ChatBarView = {
        
        let cbView = ChatBarView()
        cbView.delegate = self
        return cbView
    }()
    
    
    
    // more
    lazy var moreView:ChatMoreView  = { [unowned self] in
        let moreV = ChatMoreView()
        moreV.delegate = self
        return moreV
        }()
    
    // emotion
    lazy var emotion:ChatEmotionView = {
       let emojView = ChatEmotionView()
       emojView.backgroundColor = UIColor.gray
       emojView.delegate = self
       return emojView
    }()
    
    //replyMessageView
    lazy var replyView:quickReplyView = {
       let v = quickReplyView.init(frame: CGRect.zero)
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
    
    // showtype
    var st: ShowType = ShowType.none
    
    var hr:FriendModel?
    
    // chat message and card info
    var tableSource:NSMutableArray = []
    
    var keyboardFrame:CGRect?
    
    private var currentChatBarHright:CGFloat = ChatInputBarH
    
    private weak var parentView: UIViewController?
    private var currentIndexPath:IndexPath?
    
    init(hr:FriendModel,index:IndexPath? = nil   ,parent: UIViewController? = nil ) {
        self.currentIndexPath = index
        self.hr = hr
        self.parentView = parent
        super.init(nibName: nil, bundle: nil)
        self.chatRecordLoad()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        self.hidesBottomBarWhenPushed = true

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
        // 刷新cell 的message
        guard let mg = self.parentView as? messageMain else {
            return
        }
        guard let index = self.currentIndexPath else {
            return
        }
       
        mg.tableView.reloadRows(at: [index], with: .none)
        
    }
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 界面显示后 tableview 直接显示底部
        if !table2Bottom{
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.tableSource.count - 1, section: 0), at: .bottom, animated: false)
            }
            table2Bottom = true
        }
    }
    
    // remove self when destroied
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

extension communication {
    
    
    private func setViews(){
        
        self.view.backgroundColor = UIColor.backGroundColor()
        self.setupNavigateTitle(text: (hr?.name)!)
        
        self.view.addSubview(tableView)
        self.view.addSubview(chatBarView)
        self.view.addSubview(moreView)
        self.view.addSubview(emotion)
        
        _  = chatBarView.sd_layout().leftEqualToView(self.view)?.yIs(ScreenH - ChatInputBarH)?.rightEqualToView(self.view)?.heightIs(ChatInputBarH)
        
        _ = emotion.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(KEYBOARD_HEIGHT)
        
        // 用约束 动画才能移动subview
        _ = moreView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.chatBarView,0)?.heightIs(KEYBOARD_HEIGHT)
        
        // 监听keyborad 变化
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    func setupNavigateTitle(text:String){
        
 
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 50, y: 0, width: 220, height: 44))
        titleLabel.text = text
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.navigationItem.titleView = titleLabel
        
    }
}

// table
extension communication: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if let _:MessageBoby = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            
            let message = self.tableSource.object(at: indexPath.row) as! MessageBoby
            
            switch message.type{
                
            case .text:
                let cell = tableView.dequeueReusableCell(withIdentifier: messageCell.reuseidentify(), for: indexPath) as! messageCell
                cell.setupMessageCell(messageInfo: message, user: myself)
                return cell
                
            case .smallGif, .bigGif:
                let cell = tableView.dequeueReusableCell(withIdentifier: gifCell.reuseidentify(), for: indexPath) as! gifCell
                cell.setupPictureCell(messageInfo: message as! imageMessageBody , user: myself)
                return cell
                
            case .jobDetail:
                let cell = tableView.dequeueReusableCell(withIdentifier: JobMessageCell.identitiy(), for: indexPath) as! JobMessageCell
                let mes = message as! JobDetailMessage
                print(mes)
                cell.info  = (icon: mes.icon,jobName: mes.jobName, company:mes.company, tags:mes.tags , salary:mes.salary)
                return cell
            case .personCard:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonCardCell.reuseidentity(), for: indexPath) as! PersonCardCell
                let mes = message as! PersonCardMessage
                cell.mode = (name: mes.name, image: mes.image)
                return cell
            case .picture:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentify(), for: indexPath) as! ImageCell
                let mes = message as! CameraImageMessage
                cell.buildCell(image: mes.imageData, avater: mes.sender.avart)
                return cell
            default:
                break
            }
            
        }
     
        return UITableViewCell.init(style: .default, reuseIdentifier: "nil")
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message:MessageBoby  = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            switch message.type{
            case .text:
                return messageCell.heightForCell(messageInfo: message)
            case .smallGif,.bigGif:
                return gifCell.heightForCell(messageInfo: message)
            case .personCard:
                return PersonCardCell.heightForCell()
            case .picture:
                 return ImageCell.cellHeight()
            case .jobDetail:
                return JobMessageCell.cellHeight()
            default:
                break
            }
        }
        
        return 44.5
    }
    

    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let mes = self.tableSource.object(at: indexPath.row) as? MessageBoby{
            
            switch mes.type{
            case .jobDetail:
                let job = JobDetailViewController()
                job.infos = (mes as! JobDetailMessage).toDict()
                job.jobID = "1"  // MARK
                self.navigationController?.pushViewController(job, animated: true)

            case .personCard:
                print("show personcard")
            case .text:
                break
            default:
                break
            }
        }
        
    }
}

extension communication{
    
    // 加载历史聊天记录
    private func chatRecordLoad(){
        //record
        if let mes = contactManager.usersMessage[self.hr!.id]?.messages{
            for item in mes{
                
                // 图片路径 Bundle.main.bundlePath 每次会变化
                if item.type == .smallGif || item.type == .bigGif{
                    let mes = item as! imageMessageBody
                   
                    let imageName = mes.imgPath.imageSubString(st: "/")
                    mes.imgPath = Bundle.main.bundlePath + imageName
                    self.tableSource.add(mes)
                    continue
                }
                
                self.tableSource.add(item)
            }
        }
    }
    
    
    
    @objc func hiddenKeyboard(sender: UITapGestureRecognizer){
        
//        if sender.state == .ended{
//           // self.InputBar.textField.resignFirstResponder()
//
//        }
       
        self.chatBarView.inputText.resignFirstResponder()
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            self.moveBar(distance: 0)
            
        }
        self.chatBarView.keyboardType = .none
        sender.cancelsTouchesInView = false
        
    }
    
}


extension communication: ChatMoreViewDelegate{
    
    func chatMoreView(moreView: ChatMoreView, didSelectedType type: ChatMoreType) {
        
        switch type {
        // MARK
        case .pic:
            
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
        case .mycard:
            self.present(cardAlert, animated: true, completion: nil)
            
        default:
            break
        }
    }

}


extension communication: ChatEmotionViewDelegate{
    
    func chatEmotionGifSend(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion, type:messgeType) {
        self.sendGifMessage(emotion: emotion, type:type)
        
    }
    
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion) {
        self.chatBarView.inputText.insertEmotion(emotion: emotion)
        
    }
    
    func chatEmotionViewSend(emotionView: ChatEmotionView) {
        self.sendMessage()
    }
   

    func sendMessage(){
        
        // 获取text 消息
        var message = self.chatBarView.inputText.getEmotionString()
        message = message.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        guard !message.isEmpty else {
            return
        }
        // 清理inputview
        self.chatBarView.inputText.text = ""
        let messagebody:MessageBoby = MessageBoby.init(content: message, time: "01-12", sender: myself, target: self.hr!)
        
        self.reloads(mes: messagebody)
        
    }
    
    //   gif 图片
    func sendGifMessage(emotion: MChatEmotion, type:messgeType){
        
        
        let messageBody:imageMessageBody  = imageMessageBody.init(time: "01-23", path: emotion.imgPath!, content: emotion.text!,sender: myself, target: self.hr!, type: type)
        self.reloads(mes: messageBody)
        
        
    }
    // 快捷回复
    func sendReply(content:String){
        
        let messagebody:MessageBoby = MessageBoby.init(content: content, time: "10-13", sender: myself, target: self.hr!)
        self.reloads(mes: messagebody)

    }
    
    // 个人名片
    func sendPersonCard(){
        
        let personCard:PersonCardMessage = PersonCardMessage.init(name: myself.name, image: myself.avart, time: "今天", sender: myself, target: self.hr!)
        self.reloads(mes: personCard)
    }

    // 照片
    func sendImage(image:NSData, avartar:String){
        
        let Cameraimage:CameraImageMessage = CameraImageMessage.init(imageData: image, time: "啊哈", sender: myself, target: self.hr!)
        self.reloads(mes: Cameraimage)
    }
    
    private func  reloads(mes: MessageBoby){
        
        self.tableSource.add(mes)
        self.tableView.reloadData()
        let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
        self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: true)
        // 存入本地
        Contactlist.shared.usersMessage[(hr?.id)!]?.addMessageByMes(newMes: mes)
    }
    
    
}

// show

extension communication: ChatBarViewDelegate{
    
    func showTextKeyboard() {
        
        UIView.animate(withDuration: 0.3) {
        
            self.emotion.isHidden = true
            self.moreView.isHidden = true
        }
        self.moveBar(distance: keyboardFrame?.height ?? 0)
    }
    
    
    func showEmotionKeyboard() {
       
        
        self.emotion.isHidden = false
        self.moreView.isHidden = true
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
        
        var y:CGFloat = ChatKeyBoardH
        if self.chatBarView.keyboardType == .emotion || self.chatBarView.keyboardType == .more{
            y = KEYBOARD_HEIGHT  // 216 高度
        }
        
        if self.currentChatBarHright != height{
            
            _ = self.chatBarView.sd_layout().yIs(ScreenH - y - height)?.heightIs(height)
            
            UIView.animate(withDuration: 0.05, animations: {
              
              
               let path:IndexPath = IndexPath.init(row: self.tableSource.count - 1   , section: 0)
               self.tableView.scrollToRow(at: path, at: .none, animated: true)
               
                // MARK 最底层cell 高度超过 table 底边界？
               _  = self.tableView.sd_layout().bottomSpaceToView(self.chatBarView,0)
                
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
        
       
        UIView.animate(withDuration: 0.3, animations: {
            
            self.tableView.frame = CGRect.init(x: 0, y: NavH, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - NavH - self.currentChatBarHright - distance)
            self.chatBarView.frame  = CGRect.init(x: 0, y: UIScreen.main.bounds.height - distance - self.currentChatBarHright, width: UIScreen.main.bounds.width, height: self.currentChatBarHright)
            //self.view.layoutIfNeeded()
        }) { (Bool) in
            print(Bool)
            self.emotion.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - distance, width: UIScreen.main.bounds.width, height: 216)
            self.moreView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - distance, width: UIScreen.main.bounds.width, height: 216)
            
            
            if distance != 0 {
                
                let path:NSIndexPath = NSIndexPath.init(row: self.tableSource.count-1, section: 0)
                
                self.tableView.scrollToRow(at: path as IndexPath, at: .bottom, animated: false)
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





// reply delegate
extension communication: ReplyMessageDelegate{
    
    func didSelectedMessage(view: UITableView, message: String) {
        self.handleSingleTapGesture()
        self.sendReply(content: message)
    }
}



// camera 照片
extension communication: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        
        
        let image:UIImage!
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        
        print("choose image \(image)")
        self.sendImage(image: UIImageJPEGRepresentation(image, 1.0)! as NSData, avartar: myself.avart)
        
    }
    
}


