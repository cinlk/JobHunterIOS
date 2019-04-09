//
//  JobDetailViewController.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import CoreLocation
import ObjectMapper
import MapKit
import RxSwift
import RxCocoa
import MBProgressHUD
import RxDataSources
//import SwiftyJSON
//内置分享sdk
import Social

fileprivate let tableViewHeaderH:CGFloat  = 148
fileprivate let jobTitle:String = "职位详情"
fileprivate let cellMode:String = "mode"

class JobDetailViewController: BaseShowJobViewController {
    
//    private var mode:CompuseRecruiteJobs?{
//        didSet{
//            didFinishloadData()
//        }
//    }
    
    internal var fromChatVC: Bool = false
    
    internal var job:(String, jobType) = ("", .none){
        didSet{
            query.onNext(job)
        }
    }
    
    
    //数据库记录会话历史
    private let conversationManager = ConversationManager.shared
    
    private lazy var jobheader:JobDetailHeader = { [unowned self] in
        let jh = JobDetailHeader.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableViewHeaderH))
        return jh
        
    }()
    
    
    // 投诉
    private lazy var warnBtn:UIButton  = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        let warnIcon = UIImage.init(named: "warn")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        btn.addTarget(self, action: #selector(warn), for: .touchUpInside)
        btn.clipsToBounds = true
        btn.setImage(warnIcon, for: .normal)
        return btn
    }()
    // 举报vc
 
    // apply
    
    private lazy var apply:UIButton = {
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: GlobalConfig.toolBarH))
   
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle("投递简历", for: .normal)
        //apply.setTitle("已投递简历", for: .selected)
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        apply.titleLabel?.textAlignment = .center
        apply.backgroundColor = UIColor.green
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.setTitleColor(UIColor.lightGray, for: .selected)
        return apply
        
    }()
    
    private lazy var talk:UIButton = {
        // 宽度加上20 填满整个view
        let talk = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW - collectedBtn.width - apply.width + 20, height: GlobalConfig.toolBarH))
        talk.setTitle("和ta聊聊", for: .normal)
        talk.setTitle("继续沟通", for: .selected)
        talk.backgroundColor = UIColor.blue
        talk.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        talk.titleLabel?.textAlignment = .center
        talk.setTitleColor(UIColor.white, for: .normal)
        talk.addTarget(self, action: #selector(talkHR(_:)), for: .touchUpInside)
        
        return talk
    }()
    
    //
    private lazy var warnVC:JuBaoViewController =  JuBaoViewController()
    
    //rxSwift
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    private let query:BehaviorSubject<(String, jobType)> = BehaviorSubject<(String, jobType)>.init(value: ("", jobType.none))
    
    private let mode:BehaviorRelay<CompuseRecruiteJobs> = BehaviorRelay<CompuseRecruiteJobs>.init(value: CompuseRecruiteJobs(JSON: [:])!)
    
    
    private var dataSoure: RxTableViewSectionedReloadDataSource<JobMultiSectionModel>!
    
    // message server
    private let mserver:MessageHttpServer = MessageHttpServer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hidesBottomBarWhenPushed = true
        self.setViews()
        self.setToolBarItems()
        self.setViewModel()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("presented ", self.navigationController?.cont)
        //
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
       
        //self.navigationController?.navigationBar.settranslucent(false)
        self.navigationController?.insertCustomerView()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         //self.showToolBar = false
        //self.navigationController?.setToolbarHidden(true, animated: true)
        //self.navigationController?.navigationBar.settranslucent(true)
        
        self.navigationController?.removeCustomerView()
       
        self.navigationController?.setToolbarHidden(true, animated: true)
        
       

    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
 
        
        
    }
    
    
    override func setViews() {
        
        
        self.hiddenViews.append(warnBtn)
        super.setViews()
        self.title = jobTitle
        
        table.register(CompanySimpleCell.self, forCellReuseIdentifier: CompanySimpleCell.identity())
        table.register(JobDescription.self, forCellReuseIdentifier: JobDescription.identity())
        table.register(WorklocateCell.self, forCellReuseIdentifier: WorklocateCell.identity())
        table.register(RecruiterCell.self, forCellReuseIdentifier: RecruiterCell.identity())
        table.register(SubIconAndTitleCell.self, forCellReuseIdentifier: SubIconAndTitleCell.identity())
        table.backgroundColor = UIColor.viewBackColor()
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        shareapps.delegate = self
        table.rx.setDelegate(self).disposed(by: dispose)
        
        
        
       
    }
    
    
    override func didFinishloadData() {
        
        super.didFinishloadData()
        
        jobheader.mode = mode.value
        jobheader.layoutSubviews()
        self.table.tableHeaderView = jobheader
        // 是否关注
        
        collectedBtn.isSelected =  mode.value.isCollected ?? false
        apply.isSelected = mode.value.isApply  ?? false
        apply.isUserInteractionEnabled = mode.value.isApply == true ? false : true
        talk.setTitle(mode.value.isTalked ?? false ? "继续沟通":"和ta聊聊", for: .normal)
        
        // 控制toolbar 界面加载完成后在显示
        //self.showToolBar = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
    }

    
    override func reload() {
        super.reload()
        self.navigationController?.setToolbarHidden(true, animated: true)
        query.onNext(job)
       
        // TODO 出现错误 如何再刷新？？
    }
    
    
    // 收藏
    override func collected(_ btn:UIButton){
        
        guard let _ = mode.value.id, let collect = mode.value.isCollected else {
            return
        }
        // 判断有效用户
        if !verifyLogin(){
            return
        }
        
        let state = collect ? "取消收藏" : "收藏成功"
        // 服务器更新状态 回调 TODO
        // 改变状态
        collectedBtn.isSelected = !collect
        self.view.showToast(title: state, customImage: nil, mode: .text)
        mode.value.isCollected = collectedBtn.isSelected
        
    }
    
    // 投递简历
    @objc func onlineApply(_ btn:UIButton){
        // 判断有效用户
        guard let _ = mode.value.id, let applyed = mode.value.isApply else {
            return
        }
        if !verifyLogin(){
            return
        }
        
        if applyed{
            return
        }
        
        // 网络请求 投递职位, 成功回调
        apply.isSelected = true
        apply.isUserInteractionEnabled = false
        self.view.showToast(title: "投递简历成功", duration: 5, customImage: UIImageView.init(image: UIImage.init(named: "checkmark")?.withRenderingMode(.alwaysTemplate)), mode: .customView)
        mode.value.isApply = true
        
       
        
        
    }
    
    
    // 和hr 交流该职位
    // TODO 发送消息失败处理
    @objc func talkHR(_ btn:UIButton){
        
        guard  let id  = mode.value.id  else {
            return
        }
        
        //self.mode.value.recruiter?.userID = GlobalConfig.LeanCloudApp.User2
       
        
        // 用户是否登录
        if !verifyLogin(){
            return
        }
        
        // test 假设已经有用户
//        GlobalUserInfo.shared.baseInfo(role: UserRole.role.seeker, token: "token", account: "", pwd: "", lid: lid)
        
        
        guard let recruiteIMid = self.mode.value.recruiter?.leanCloudId else {
            self.view.showToast(title: "can't find im accout for recruiter", duration: 3, customImage: nil, mode: .text)
            return
        }
        
        //
        if  let talked = mode.value.isTalked, let conid = self.mode.value.conversation, talked{
            // 获取conversation
            GlobalUserInfo.shared.openConnected { (sucess, error) in
                if sucess{
                    GlobalUserInfo.shared.buildConversation(conversation: conid, talkWith: recruiteIMid, jobId: id, completed: { (con, error) in
                        if let err = error {
                            print(err)
                            self.view.showToast(title: "获取会话失败", customImage: nil, mode: .text)
                            return
                        }
                        if self.fromChatVC{
                            self.navigationController?.popvc(animated: true)
                            
                            
                            //self.navigationController?.popViewController(animated: true)
                        }else{
                            //  跳转到聊天界面
                            self.navToChatVC(con: con!)
                        }
                       
                        
                    })
                }else{
                    self.view.showToast(title: "\(error)", customImage: nil, mode: .text)
                }
            }
            
            
        }else{
            
           
            // 发送消息 成功后 才切换界面
            GlobalUserInfo.shared.openConnected { (success, error) in
                if success{
                    GlobalUserInfo.shared.buildConversation(conversation: self.mode.value.conversation, talkWith: recruiteIMid, jobId: id, completed: { (cons, error) in
                       // print("build conversation \(cons)")
                         // 发送消息
                        if let err = error {
                            print(err)
                            self.view.showToast(title: "获取会话失败", customImage: nil, mode: .text)
                            
                            return
                        }
                        
                        guard let conData = SingleConversation(JSON: ["conversation_id": cons?.conversationId, "my_id": GlobalUserInfo.shared.getId()!, "recruiter_id": self.mode.value.recruiter?.userID ,"job_id": self.mode.value.id, "recruiter_name": self.mode.value.recruiter?.name,"recruiter_icon_url":self.mode.value.recruiter?.icon?.absoluteString, "created_time": Date.init().timeIntervalSince1970]) else{
                            self.view.showToast(title: "empty conversation id", customImage: nil, mode: .text)
                            
                            return
                        }
                        
                        // 创建conversation 到数据库
                        if self.conversationManager.createConversation(data: conData) == false{
                            self.view.showToast(title: "数据库存储会话失败", customImage: nil, mode: .text)
                            return
                        }
                        // 发送消息
                        // 发送job 类型消息 和 存入数据库
                        guard let jobMsg = JobDescriptionlMessage.init(JSON: [
                        "creat_time":Date.init().timeIntervalSince1970,
                        "type": MessgeType.jobDescribe.describe,
                        "isRead":true,
                        "conversation_id": conData.conversationId,
                        "receiver_id": self.mode.value.recruiter?.userID,
                        "sender_id": GlobalUserInfo.shared.getId()!,
                        "job_id": self.mode.value.id!,
                        "job_type_des": self.mode.value.type,
                        "icon": self.mode.value.iconURL?.absoluteString, "job_name": self.mode.value.name,
                        "company": self.mode.value.company?.name,"salary": self.mode.value.salary ,"tags": self.mode.value.jobtags]) else{
                            
                            self.view.showToast(title: "创建job消息类型失败", customImage: nil, mode: .text)
                            return
                        }
                        
                        
                        var err:Error?
                        
                        let sendJob = AVIMTextMessage.init(text: jobMsg.toJSONString(prettyPrint: true)!, attributes: ["type": MessgeType.jobDescribe.describe])
                        cons?.send(sendJob, callback: { (success, error) in
                            if success{
                                do{
                                    try self.conversationManager.insertMessageItem(items: [jobMsg])
                                }catch{
                                    err = error
                                    //print(error)
                                }
                            }else{
                                err = error
                            }
                            
                        })
                        
                        if err != nil{
                            self.view.showToast(title: "存入消息或发送job消息失败\(err)", customImage: nil, mode: .text)
                            return
                        }
                        guard let helloMsg = Mapper<MessageBoby>().map(JSON: [
                            "content": "你好 对该职位感兴趣!", "type": MessgeType.text.describe,
                            "isRead":true, "creat_time": Date.init().timeIntervalSince1970,
                            "sender_id": GlobalUserInfo.shared.getId(), "receiver_id":
                                self.mode.value.recruiter!.userID, "conversation_id": cons?.conversationId!])else{
                                    self.view.showToast(title: "构建打招呼用语失败", customImage: nil, mode: .text)

                                    return
                        }
                        // 发送打招呼用语消息  和 存入数据库
                        let sendHello = AVIMTextMessage.init(text: "你好 对该职位感兴趣!", attributes: ["type": MessgeType.text.describe])
                        cons?.send(sendHello, callback: { (success, error) in
                            if success{
                                do{
                                    try self.conversationManager.insertMessageItem(items: [helloMsg])
                                    // 执行顺序？？
                                    self.mserver.createConversation(conid: conData.conversationId!, recruiteId: (self.mode.value.recruiter?.userID)!, jobId: self.mode.value.id!).asDriver(onErrorJustReturn: false).drive(onNext: { (success) in
                                        if success{
                                            self.mode.value.isTalked = true
                                            self.talk.setTitle("继续沟通", for: .normal)
                                            // 发送通知给聊天界面
                                            NotificationCenter.default.post(name: NotificationName.refreshChatList, object: nil)
                                            // 跳转到界面
                                            self.navToChatVC(con: cons!)
                                        }else{
                                            self.view.showToast(title: "创建服务器会话失败", duration: 2, customImage: nil, mode: .text)
                                        }
                                        
                                    }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                                    
                                }catch{
                                    err = error
                                }
                                
                            }else{
                                err = error
                            }
                        })
                        if err != nil{
                            self.view.showToast(title: "存入消息或发送hello消息失败\(err)", customImage: nil, mode: .text)
                            return
                        }
        
                        // 创建记录到服务器  如果失败（在查询记录，有则更新记录） TODO
                        // 先存conversation数据库,  成功后， 在http发送请求创建会话, 在构建消息，存入数据库
                        // 有bug TODO
                        

                    })
                }
            }
            
        }
    }
    
        // 创建会话并记录conversation（会话过期 后台检查??）
        // 构建打招呼消息 发送
        
//            let oldConv =  self.imClient？.conversation(forId: "5c88f876fb4ffe00638220a0")
//            oldConv?.join(callback: { (succes, error) in
//                print(success, error)
//            })
            
            
            // 加入conversation
            // 跳转到聊天界面
        
        
//        // 查看数据库， 如果之前没有交流过则发送jobdescribe message
//        if mode.isTalked == false{
//            // 本地自己发送的消息 总是read的
//            // 打招呼消息
//
//            do{
//
//
//                if let  jobDescribeMessage = JobDescriptionlMessage(JSON: ["messageID":getUUID(),"creat_time":Date.init().timeIntervalSince1970,"type":MessgeType.jobDescribe.rawValue,"isRead":true, "receiver": mode.hr!.toJSON(), "sender":myself.toJSON(), "jobID":mode.id, "jobTypeDes":mode.kind?.describe, "icon": "sina", "jobName":"产品开发","company":"公司名称","salary":"薪水面议","tags":["标签1","标签2","标签3","标签4"]]){
//
//
//
//
//                    // 打招呼消息
//                    let greetingMessage = MessageBoby(JSON: ["messageID":getUUID(),"content": GreetingMsg.data(using: String.Encoding.utf8)!.base64EncodedString(),"receiver": mode.hr!.toJSON(), "sender":myself.toJSON(),"isRead":true,"creat_time":Date.init().timeIntervalSince1970,
//                                                             "type":MessgeType.text.rawValue])
//
//                    greetingMessage?.sender = myself
//                    greetingMessage?.receiver = mode.hr!
//
//                    var messages:[MessageBoby] = []
//
//                    //
//                    // 允许带招呼用语
//                    if IsGreeting{
//                        messages.append(jobDescribeMessage)
//                        messages.append(greetingMessage!)
//
//
//                    }else{
//                        messages.append(jobDescribeMessage)
//                    }
//                    conversationManager.firstChatWith(person: mode.hr!, messages: messages)
//
//
//                }
//
//            }catch{
//                print(error)
//                return
//            }
//
//            mode.isTalked = true
//
//
//
//        }
//
//        talk.isSelected = true
//        // 跳转到和hr的聊天界面
//        let chatView = CommunicationChatView(hr: mode.hr!)
//
//        chatView.hidesBottomBarWhenPushed = true
//
//        self.navigationController?.pushViewController(chatView, animated: true)
        
        
    
    
    // 构建消息
    // 确保消息发送成功 TODO
//    private func sendMsg(cons: AVIMConversation?, completed: @escaping (Bool, Error?)->Void){
//
//        var messages:[AVIMTypedMessage] = []
//        messages.append(AVIMTextMessage.init(text: "打招呼用语", attributes: ["type" : "text"]))
//        guard let scon = SingleConversation(JSON: ["conversation_id": cons?.conversationId!, "my_id": GlobalUserInfo.shared.getId()!, "recruiter_id": self.mode.value.recruiter?.userID! ,"job_id": self.mode.value.id!, "recruiter_name": self.mode.value.recruiter?.name!,"recruiter_icon_url":self.mode.value.recruiter?.icon?.absoluteString, "created_time": Date.init().timeIntervalSince1970]) else{
//            print("构建会话错误")
//            // MARK
//            completed(false, NSError.init())
//            return
//        }
//         // 数据库创建会话
//        if self.conversationManager.createConversation(data: scon) == false{
//            self.view.showToast(title: "数据库存储会话失败", customImage: nil, mode: .text)
//            completed(false, NSError.init())
//            return
//        }
//
//        // 发送消息  等待所有消息发送成功 在执行complete TODO
//        //var localMsg:[MessageBoby] = []
//        let group = DispatchGroup.init()
//        var err:Error?
//
//        for (last, msg) in messages.enumerated(){
//            print("send msg \(msg)")
//            group.enter()
//            cons?.send(msg, progressBlock: { (progress) in
//            }, callback: { (success, error) in
//                group.leave()
//                if success{
//                    guard let m = Mapper<MessageBoby>().map(JSON: [
//                        "content": msg.text!, "type": MessgeType.text.describe,
//                        "isRead":true, "creat_time": Date.init().timeIntervalSince1970,
//                        "sender_id": GlobalUserInfo.shared.getId(), "receiver_id":
//                            self.mode.value.recruiter!.userID, "conversation_id": cons?.conversationId!]) else{
//                        return
//                    }
//
//                    // mesg 存入数据库(失败 可以容忍？？ TODO)
//                    //消息存入数据库 (存入失败 TODO)
//                    try? self.conversationManager.insertMessageItem(items: [m])
//                }else{
//                    err = error
//                    print(error)
//                }
//
//            })
//        }
//        // 回调
//        group.notify(queue: DispatchQueue.main) {
//             completed(err == nil ? true : false, err)
//
//        }
//
//    }

    
    private func navToChatVC(con: AVIMConversation){
        guard let rid = self.mode.value.recruiter?.userID else {
            return
        }
        let chatView = CommunicationChatView(recruiterId: rid, conversation: con)
        chatView.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
    }
}




extension JobDetailViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            if scrollView.contentOffset.y > GlobalConfig.NavH{
                self.navigationItem.title = mode.value.name
                
            }else if scrollView.contentOffset.y <= 0 {
                self.navigationItem.title = jobTitle
            }
        }
    }
    
}


extension JobDetailViewController: UITableViewDelegate{
    
    
    // section header 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return  10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch  self.dataSoure[indexPath]{
            
        case .CompanySectionItem(let mode):
            return  tableView.cellHeight(for: indexPath, model: mode, keyPath: cellMode, cellClass: CompanySimpleCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .HRSectionItem(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: cellMode, cellClass: RecruiterCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .JobDescribeSectionItem(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: cellMode, cellClass: JobDescription.self, contentViewWidth: GlobalConfig.ScreenW)
        case .AddressSectionItem(let address):
            return tableView.cellHeight(for: indexPath, model: address, keyPath: cellMode, cellClass: WorklocateCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .EndTimeSectionItem(let time):
            return tableView.cellHeight(for: indexPath, model: time, keyPath: cellMode, cellClass: SubIconAndTitleCell.self, contentViewWidth: GlobalConfig.ScreenW) + 20
        }
        
    }
    
    
    private func  dataSource() -> RxTableViewSectionedReloadDataSource<JobMultiSectionModel>{
        
        return RxTableViewSectionedReloadDataSource<JobMultiSectionModel>.init(configureCell: { (dataSource, table, indexPath, _) -> UITableViewCell in
            
            switch dataSource[indexPath]{
            case .CompanySectionItem(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
                //cell.mode = mode
                cell.mode = mode
                return cell
                
            case .HRSectionItem(let mode):
                let cell = table.dequeueReusableCell(withIdentifier: RecruiterCell.identity(), for: indexPath) as! RecruiterCell
                cell.mode = mode
                return cell
            case .JobDescribeSectionItem(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: JobDescription.identity(), for: indexPath) as! JobDescription
                cell.mode = mode
                // 职位信息
                //self.mode = mode
                self.mode.accept(mode)
                
                return cell
            case .AddressSectionItem(let address):
                let cell = table.dequeueReusableCell(withIdentifier: WorklocateCell.identity(), for: indexPath) as! WorklocateCell
                cell.mode = address
                cell.chooseAddress = { address in
                    
                    let geocoder = CLGeocoder()
                    var place:CLLocationCoordinate2D?
                    
                    geocoder.geocodeAddressString(address) {
                        (placemarks, error) in
                        guard error == nil else {
                            self.view.showToast(title: "获取地址失败\(error)", customImage: nil, mode: .text)
                            return
                        }
                        place = placemarks?.first?.location?.coordinate
                        let alert  =  PazNavigationApp.directionsAlertController(coordinate: place!, name: address, title: "选择地图", message: nil)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                }
                return cell
            case .EndTimeSectionItem(let time):
                let cell =  table.dequeueReusableCell(withIdentifier: SubIconAndTitleCell.identity(), for: indexPath) as! SubIconAndTitleCell
                cell.mode = time
                cell.iconName.text = "截止时间"
                cell.icon.image = #imageLiteral(resourceName: "clock")
                return cell
            }
            
            
        })
    }
}

extension JobDetailViewController {
    
     private func  setToolBarItems(){
        
        // 举报item
        
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem.init(customView: warnBtn))
        // toolbar 添加item
        
//        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        rightSpace.width = 10
//        self.toolbarItems?.append(rightSpace)
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
        self.toolbarItems?.append(UIBarButtonItem.init(customView: talk))
//        let last = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        last.width = -20
//        self.toolbarItems?.append(last)
        
        
    }
    
    private func setViewModel(){
        
        self.dataSoure = self.dataSource()
        
        query.subscribe(onNext: { (id, t) in
            self.vm.getJobById(id: id, type: t)
        }).disposed(by: dispose)
        
        // TODO 错误处理，从新加载数据， 会多次绑定table 错误？？
        self.vm.jobMultiSection.asDriver(onErrorJustReturn: []).do(onNext: { res in
            if res.isEmpty{
                self.showError()
            }
        }).drive(self.table.rx.items(dataSource: self.dataSoure)).disposed(by: dispose)
        
        
        _ = self.mode.share().takeUntil(self.rx.deallocated).subscribe(onNext: { (mode) in
            guard let _ =  mode.id  else {
                return
            }
            self.didFinishloadData()
            
        })
        self.errorView.tap.asDriver().drive(onNext: { _ in
            self.reload()
        }).disposed(by: self.dispose)
        // table
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            if idx.section == 0 {
                let companyVC =  CompanyMainVC()
                companyVC.hidesBottomBarWhenPushed = true
                companyVC.companyID = self.mode.value.company?.companyID
                
                self.navigationController?.pushViewController(companyVC, animated: true)
                
            }else if idx.section == 1{
                let hrvc = PublisherControllerView()
                guard let id = self.mode.value.recruiter?.userID else {
                    return
                }
                hrvc.userID =  id
                hrvc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(hrvc, animated: true)
            }
            
        }).disposed(by: dispose)
    }
}

extension JobDetailViewController: shareViewDelegate{
    
    func handleShareType(type: UMSocialPlatformType, view: UIView) {
        
        switch type {
        case .copyLink:
            self.copyToPasteBoard(text: "这是文本内容")
            
        case .more:
            // 文本
            self.openMore(text: "打开的内容", site: URL.init(string: "http://www.baidu.com"))
            
            
            
        case .wechatTimeLine, .wechatSession, .QQ, .qzone, .sina:
            self.shareToApp(type: type, view: view, title: "分享标题", des: "分享描述", url: "http://www.hangge.com/blog/cache/detail_641.html", image: UIImage.init(named: "chrome"))
            
            
        default:
            break
            
        }
        // 影藏shareview
        shareapps.dismiss()
   
    }
}

extension JobDetailViewController{
    
    // 举报
    @objc func warn(){
        guard let id = mode.value.id else {
            return
        }
        
        warnVC.jobID = id
        warnVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(warnVC, animated: true)
    }
    
}




