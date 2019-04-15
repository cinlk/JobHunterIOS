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
    
    private lazy var jobheader:JobDetailHeader = { 
        let jh = JobDetailHeader.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableViewHeaderH))
        return jh
        
    }()
    
    
    // 投诉
    private lazy var warnBtn:UIButton  = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        let warnIcon = UIImage.init(named: "warn")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        btn.addTarget(self, action: #selector(warn), for: .touchUpInside)
        btn.clipsToBounds = true
        btn.setImage(warnIcon, for: .normal)
        return btn
    }()
    // 举报vc
 
    // apply
    
    private lazy var apply:UIButton = { [unowned self] in 
        
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
    
    private lazy var talk:UIButton = { [unowned self] in
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
    
    
    deinit {
        print("deinit jobdetailVC \(String.init(describing: self))")
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
        guard let recruiteIMid = self.mode.value.recruiter?.leanCloudId else {
            self.view.showToast(title: "can't find im accout for recruiter", duration: 3, customImage: nil, mode: .text)
            return
        }
        // 用户是否登录
        if !verifyLogin(){
            return
        }
    
        
        // 获取conversation
        self.getAVIConversation(conid: self.mode.value.conversation, recruiterId: recruiteIMid, jobId: id) { [weak self] (con, error) in
            guard let `self` = self else{
                return
            }
            
            guard let con = con, let conid = con.conversationId, error == nil else {
                self.view.showToast(title: "获取会话失败", customImage: nil, mode: .text)
                return
            }
            
            if let talked = self.mode.value.isTalked, talked{
                self.continuChat(con: con)
            }else{
                // 第一次聊天
                // 先创建conversation 到数据库
                guard self.createConversation(con: con) != nil else{
                    self.view.showToast(title: "存储会话失败", customImage: nil, mode: .text)
                    return
                }
                
                // 发送job 消息， 成功后在发送打招呼消息
                if let jobMsg = self.buildMsg(msgType: .jobDescribe, conid: conid) as? JobDescriptionlMessage {
                    let jobIMmsg = AVIMTextMessage.init(text: jobMsg.toJSONString(prettyPrint: true)!, attributes: ["type": jobMsg.type!])
                    
                    self.sendMsg(con: con, msg: jobIMmsg, completed: { [weak self] (success, error) in
                        if success{
                            // 插入数据库
                            do{
                                try self?.conversationManager.insertMessageItem(items: [jobMsg])
                                // 然后发送第二条数据
                                if let hiMsg = self?.buildMsg(msgType: .text, conid: conid){
                                    let hiIMmsg = AVIMTextMessage.init(text: "你好 对该职位感兴趣!", attributes: ["type": hiMsg.type!])
                                    self?.sendMsg(con: con, msg: hiIMmsg, completed: {  [weak self] (success, error) in
                                        if success{
                                            // 插入数据库
                                            try? self?.conversationManager.insertMessageItem(items: [hiMsg])
                                             // 最后服务器数据 并跳转(会显示job 和hi 消息)
                                            // 用户uuid
                                            self?.httpCreateConversation(con: con, recuiterId: self?.mode.value.recruiter?.userID ?? "", jobId: id)
                                            
                                            return
                                        }
                                    })

                                }else{
                                     // 最后服务器数据 并跳转 (目前只有job消息)
                                    self?.httpCreateConversation(con: con, recuiterId: recruiteIMid, jobId: id)
                                }
                                
                    
                                
                            }catch{
                                self?.view.showToast(title: "job消息插入数据库失败", customImage: nil, mode: .text)
                            }
                        
                            return
                        }
                        self?.view.showToast(title: "发送job消息失败\(String(describing: error))", customImage: nil, mode: .text)
                        
                    })
                    
                }
            }
        }
    }
    
    
    
    // 获取会话
    private func getAVIConversation(conid:String?, recruiterId:String, jobId:String,completed:@escaping (_ con:AVIMConversation?, _ error:Error?)->Void){
        GlobalUserInfo.shared.openConnected { (success, error) in
            if success{
                GlobalUserInfo.shared.buildConversation(conversation: conid, talkWith: recruiterId, jobId: jobId, completed: { (con, error) in
                    completed(con, error)
                })
                return
            }
            completed(nil, error)
            
        }
        
    }
    // 发送消息
    private  func sendMsg(con: AVIMConversation,msg:AVIMTextMessage, completed:@escaping (_ success:Bool, _ error:Error?)->Void){
        let option = AVIMMessageOption.init()
        option.priority = AVIMMessagePriority.high
        con.send(msg, option: option) { (success, error) in
            completed(success, error)
        }
        
    }
    
    // 非首次聊天 直接进入聊天
    private func continuChat(con: AVIMConversation){
        
        if self.fromChatVC{
            self.navigationController?.popvc(animated: true)
        }else{
            // 删除app 后，重新安装，需要重建conversation
            guard  self.createConversation(con: con) != nil else{
                return
            }
            //  跳转到聊天界面
            self.navToChatVC(con: con)
        }
    }
    
    // 创建conversation
    private func createConversation(con: AVIMConversation?) -> SingleConversation?{
        
        guard let conData = SingleConversation(JSON: [
            "conversation_id": (con?.conversationId)!,
            "my_id": GlobalUserInfo.shared.getId()!,
            "recruiter_id": (self.mode.value.recruiter?.userID)! ,
            "job_id": (self.mode.value.id)!,
            "recruiter_name": self.mode.value.recruiter?.name ?? "",
            "recruiter_icon_url":self.mode.value.recruiter?.icon?.absoluteString ?? "default",
            "created_time": Date.init().timeIntervalSince1970]) else{
                
            self.view.showToast(title: "empty conversation id", customImage: nil, mode: .text)
            
            return nil
        }
        
        // 创建conversation 到数据库
        if self.conversationManager.createConversation(data: conData) == false{
            self.view.showToast(title: "数据库存储会话失败", customImage: nil, mode: .text)
            return nil
        }
        
        return  conData
    }
    
    
    private func navToChatVC(con: AVIMConversation){
        guard let rid = self.mode.value.recruiter?.userID else {
            return
        }
        let chatView = CommunicationChatView(recruiterId: rid, conversation: con)
        chatView.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
    }
    // 存储会话到服务端
    private func httpCreateConversation(con:AVIMConversation,  recuiterId:String, jobId:String){
        
        self.mserver.createConversation(conid: con.conversationId!, recruiteId: recuiterId, jobId: jobId).asDriver(onErrorJustReturn: false).drive(onNext: { [weak self] (success) in
            guard let `self` = self else{
                return
            }
            if success{
                self.mode.value.conversation = con.conversationId!
                self.mode.value.isTalked = true
                self.talk.setTitle("继续沟通", for: .normal)
                // 发送通知给聊天界面
                NotificationCenter.default.post(name: NotificationName.refreshChatList, object: nil)
                // 跳转到界面
                self.navToChatVC(con: con)
            }else{
                self.view.showToast(title: "创建服务器会话失败", duration: 2, customImage: nil, mode: .text)
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
    // 构建 消息
    private func buildMsg(msgType: MessgeType, conid:String) -> MessageBoby?{
        switch msgType {
        case .jobDescribe:
            return Mapper<JobDescriptionlMessage>().map(JSON: [
                "creat_time":Date.init().timeIntervalSince1970,
                "type": msgType.describe,
                "is_read":true,
                "conversation_id": conid ,
                "receiver_id": (self.mode.value.recruiter?.userID)!,
                "sender_id": GlobalUserInfo.shared.getId()!,
                "job_id": self.mode.value.id!,
                "job_type_des": self.mode.value.type ?? "none",
                "icon": self.mode.value.iconURL?.absoluteString ?? "default",
                "job_name": self.mode.value.name ?? "",
                "company": self.mode.value.company?.name ?? "",
                "salary": self.mode.value.salary ,
                "tags": self.mode.value.jobtags])
            
        case .text:
            return Mapper<MessageBoby>().map(JSON: [
                "content": "你好 对该职位感兴趣!",
                "type": msgType.describe,
                "is_read":true,
                "creat_time": Date.init().timeIntervalSince1970,
                "sender_id": GlobalUserInfo.shared.getId()!,
                "receiver_id": (self.mode.value.recruiter?.userID)!,
                "conversation_id": conid
                ])
        default:
            break
        }
        
        return nil
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
        
        return RxTableViewSectionedReloadDataSource<JobMultiSectionModel>.init(configureCell: { [weak self] (dataSource, table, indexPath, _) -> UITableViewCell in
            
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
                self?.mode.accept(mode)
                
                return cell
            case .AddressSectionItem(let address):
                let cell = table.dequeueReusableCell(withIdentifier: WorklocateCell.identity(), for: indexPath) as! WorklocateCell
                cell.mode = address
                cell.chooseAddress = { [weak self] address in
                    
                    let geocoder = CLGeocoder()
                    var place:CLLocationCoordinate2D?
                    
                    geocoder.geocodeAddressString(address) { [weak self]
                        (placemarks, error) in
                        guard error == nil else {
                            self?.view.showToast(title: "获取地址失败\(String(describing: error))", customImage: nil, mode: .text)
                            return
                        }
                        place = placemarks?.first?.location?.coordinate
                        let alert  =  PazNavigationApp.directionsAlertController(coordinate: place!, name: address, title: "选择地图", message: nil)
                        self?.present(alert, animated: true, completion: nil)
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
        
        query.subscribe(onNext: {  [weak self] (id, t) in
            self?.vm.getJobById(id: id, type: t)
        }).disposed(by: dispose)
        
        // TODO 错误处理，从新加载数据， 会多次绑定table 错误？？
        self.vm.jobMultiSection.asDriver(onErrorJustReturn: []).do(onNext: {  [weak self] res in
            if res.isEmpty{
                self?.showError()
            }
        }).drive(self.table.rx.items(dataSource: self.dataSoure)).disposed(by: dispose)
        
        
        _ = self.mode.share().takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (mode) in
            guard let _ =  mode.id  else {
                return
            }
            self?.didFinishloadData()
            
        })
        self.errorView.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.reload()
        }).disposed(by: self.dispose)
        // table
        self.table.rx.itemSelected.subscribe(onNext: { [weak self] (idx) in
            guard let `self` = self else{
                return
            }
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




