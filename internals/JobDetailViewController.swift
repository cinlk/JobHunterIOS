//
//  JobDetailViewController.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MBProgressHUD
import SwiftyJSON
//内置分享sdk
import Social


fileprivate let req:String = """
计算机、通信等相关专业本科及以上学历，熟悉计算机网络体系架构、Unix/Linux操作系统；
熟悉C/C++、python、php、shell等常见语言的一种或多种；
酷爱计算机软/硬件、系统、网络技术，具备强烈的钻研精神和自我学习能力；
乐于尝试新事物，具有迎接挑战、克服困难的勇气；
善于和他人合作，富有集体荣誉感；
具备良好的责任心与服务意识
"""

fileprivate let works:String = "负责如QQ、微信、腾讯云、腾讯游戏等腾讯海量业务的技术支撑和服务。与优秀的工程师一起，通过优秀的IDC机房规划建设、网络规划、CDN加速网络、高性能数据库和云存储管理、高可用高性能主机应用、运维自动化及监控系统建设等解决如：中国及海外互联网用户跨地域、跨运营商等复杂网络下稳定、低延迟的接入及访问我们的产品！高效管理、服务数以十万计的服务器及云端用户，通过架构优化和容错建设保障业务不间断运行！通过立体化监控系统快速发现和处理故障，以及让故障自愈。加盟腾讯技术运营、服务团队，您将亲身参与打造中国最优质的互联网产品平台，与中国最优秀的互联网人才共同成长！"



fileprivate let tableViewHeaderH:CGFloat  = 148
fileprivate let sections:Int = 4
fileprivate let bottomViewH:CGFloat = 50


class JobDetailViewController: BaseShowJobViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var mode:CompuseRecruiteJobs?
    
    var kind:(id:String, type:jobType)?{
        didSet{
            guard  let kind = kind  else {
                return
            }
            self.id = kind.id
            self.jobType = kind.type
            loadData(id: kind.id, type: kind.type)
            
        }
    }
    private lazy var id:String = ""
    private lazy var jobType:jobType = .none
    
    
    private var HRModel:HRPersonModel?
    
    private var firstLoad:Bool = false
    
    // 记录当前颜色
    private var navTintColor:UIColor = UIColor.clear
    
    // job table
    private let jobTable = DBFactory.shared.getJobDB()
    // 数据库
    private let conversationManager = ConversationManager.shared
    
    
    private lazy var jobheader:JobDetailHeader = { [unowned self] in
        
        let jh = JobDetailHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableViewHeaderH))
        
        return jh
    }()
    
    
    private lazy var warnBtn:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))


    
    
    
    // 举报vc
    private  lazy var WarnViewController = JuBaoViewController()
    
    // apply
    
    private lazy var apply:UIButton = {
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: toolBarHeight))
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle("投递简历", for: .normal)
        apply.setTitle("已投递简历", for: .selected)
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        apply.titleLabel?.textAlignment = .center
        apply.backgroundColor = UIColor.green
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.setTitleColor(UIColor.lightGray, for: .selected)
        return apply
        
    }()
    
    private lazy var talk:UIButton = {
        // 宽度加上20 填满整个view
        let talk = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - collectedBtn.width - apply.width + 20, height: toolBarHeight))
        talk.setTitle("和ta聊聊", for: .normal)
        talk.setTitle("继续沟通", for: .selected)
        talk.backgroundColor = UIColor.blue
        talk.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        talk.titleLabel?.textAlignment = .center
        talk.setTitleColor(UIColor.white, for: .normal)
        
        talk.addTarget(self, action: #selector(talkHR(_:)), for: .touchUpInside)
        
        return talk
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        if let color = self.navigationController?.navigationBar.tintColor{
            navTintColor = color
        }

        
 
        
    }

 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.navigationController?.setToolbarHidden(!firstLoad , animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.black


        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         self.navigationController?.setToolbarHidden(true, animated: false)
        firstLoad = true
        self.navigationController?.navigationBar.tintColor = navTintColor


    }
    
    
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
 
        
        
    }
    
    
    override func setViews() {
        
        
        
        self.handleViews.append(warnBtn)
        super.setViews()
        self.title = "职位详情"
        // 设置table
        table.delegate = self
        table.register(UINib(nibName:"CompanySimpleCell", bundle:nil), forCellReuseIdentifier: CompanySimpleCell.identity())
        table.register(JobDescription.self, forCellReuseIdentifier: JobDescription.identity())
        table.register(worklocateCell.self, forCellReuseIdentifier: worklocateCell.identity())
        table.register(RecruiterCell.self, forCellReuseIdentifier: RecruiterCell.identity())
        table.register(subIconAndTitleCell.self, forCellReuseIdentifier: subIconAndTitleCell.identity())
        table.backgroundColor = UIColor.viewBackColor()
        table.contentInset = UIEdgeInsetsMake(0, 0, 15, 0)
        
        shareapps.delegate = self
        
        table.dataSource = self
        
        
        self.addBarItems()
        
       
    }
    
    
    override func didFinishloadData() {
        
       
        super.didFinishloadData()
        
        
        // 获取数据失败怎么办
        guard mode != nil else {
            return
        }
        
        jobheader.mode = mode
        jobheader.layoutSubviews()
        
        
        
        self.table.tableHeaderView = jobheader
        self.table.reloadData()
        // 是否关注
        collectedBtn.isSelected =  (mode?.isCollected)!
        apply.isSelected = (mode?.isApply)!
        apply.isUserInteractionEnabled = !(mode?.isApply)!
        talk.isSelected = ( mode?.isTalked)!
        
        // 控制toolbar 界面加载完成后在显示
        self.navigationController?.setToolbarHidden(firstLoad, animated: true)

        
    }

    
    override func reload() {
        super.reload()
        loadData(id: id, type: jobType)

    }
    
    
    // 收藏
    override func collected(_ btn:UIButton){
        let str =  (mode?.isCollected)! ? "取消收藏" : "收藏成功"
        collectedBtn.isSelected = !(mode?.isCollected)!
        showOnlyTextHub(message: str, view: self.view)
        mode?.isCollected = collectedBtn.isSelected
        
    }
    
    
    @objc func onlineApply(_ btn:UIButton){
        
        // 更新服务器数据
        //        DispatchQueue.global(qos: .userInitiated).async {
        //
        //        }
        //jobTable.sendResumeJob(id: jobID)
        if mode?.isApply == false{
            
            apply.isSelected = true
            apply.isUserInteractionEnabled = false
            showCustomerImageHub(message: "投递简历成功", view: self.view, image: #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate))
            mode?.isApply = true
        }
       
        
        
    }
    
    
    // 和hr 交流该职位
    @objc func talkHR(_ btn:UIButton){
        
        // 查看数据库， 如果之前没有交流过则发送jobdescribe message
        if mode?.isTalked == false{
            // 本地自己发送的消息 总是read的
            // 打招呼消息
            
            do{
                
                
                if let  jobDescribeMessage = JobDescriptionlMessage(JSON: ["messageID":getUUID(),"creat_time":Date.init().timeIntervalSince1970,"type":MessgeType.jobDescribe.rawValue,"isRead":true, "receiver": HRModel!.toJSON(), "sender":myself.toJSON(), "jobID":id,"jobTypeDes":jobType.rawValue, "icon": "sina" ,"jobName":"产品开发","company":"公司名称","salary":"薪水面议","tags":["标签1","标签2","标签3","标签4"]]){
                    
                
                    
                    
                    // 打招呼消息
                    let greetingMessage = MessageBoby(JSON: ["messageID":getUUID(),"content": GreetingMsg.data(using: String.Encoding.utf8)!.base64EncodedString(),"receiver": HRModel!.toJSON(), "sender":myself.toJSON(),"isRead":true,"creat_time":Date.init().timeIntervalSince1970,
                                                             "type":MessgeType.text.rawValue])
                    
                    greetingMessage?.sender = myself
                    greetingMessage?.receiver = HRModel!
                    
                    var messages:[MessageBoby] = []
                    
                    //
                    // 允许带招呼用语
                    if IsGreeting{
                        messages.append(jobDescribeMessage)
                        messages.append(greetingMessage!)
                        
                        
                    }else{
                        messages.append(jobDescribeMessage)
                    }
                    conversationManager.firstChatWith(person: HRModel!, messages: messages)
                    jobTable.talkedBy(id: id)
                    
                }
                
            }catch{
                print(error)
                return
            }
            
            mode?.isTalked = true

            
            
        }
        
        talk.isSelected = true 
        // 跳转到和hr的聊天界面
        let chatView = CommunicationChatView(hr: HRModel!)
        
        chatView.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
        
    }
    

}




extension JobDetailViewController {
    
    func  addBarItems(){
        
        
        
        
        // 举报item
        let warnIcon = UIImage.init(named: "warn")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        warnBtn.addTarget(self, action: #selector(warn), for: .touchUpInside)
        warnBtn.clipsToBounds = true
        warnBtn.setImage(warnIcon, for: .normal)
        
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem.init(customView: warnBtn))
        
        // toolbar 添加item
        
        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        rightSpace.width = 10
        self.toolbarItems?.append(rightSpace)
        
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
        self.toolbarItems?.append(UIBarButtonItem.init(customView: talk))
        
        
        
        let last = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        last.width = -20
        self.toolbarItems?.append(last)
        
        
    }
    
    
}

// table

extension JobDetailViewController{
    
    // table
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let time = mode?.endTime else { return sections }
        
        return time.isEmpty ? sections : sections + 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // section header 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return  10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
        case 0:
            
            // MARK 临时给 jobid
            let companyVC =  CompanyMainVC()
            companyVC.hidesBottomBarWhenPushed = true 
            companyVC.companyID = mode?.company?.id
            
            self.navigationController?.pushViewController(companyVC, animated: true)
        
            
        case 1:
            // mode 修改 MARK
            let hrvc = publisherControllerView()
            hrvc.hidesBottomBarWhenPushed = true
            guard let id = mode?.hr?.userID else {
                return
            }
            hrvc.userID =  id 
            
            
            self.navigationController?.pushViewController(hrvc, animated: true)
        default:
            break
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return  CompanySimpleCell.cellHeight()
        case 1:
            
            return tableView.cellHeight(for: indexPath, model: mode?.hr, keyPath: "mode", cellClass: RecruiterCell.self, contentViewWidth: ScreenW)
            
        case 2:
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobDescription.self, contentViewWidth: ScreenW)
        case 3:
             return tableView.cellHeight(for: indexPath, model: mode?.address, keyPath: "mode", cellClass: worklocateCell.self, contentViewWidth: ScreenW)
        case 4:
            
            return tableView.cellHeight(for: indexPath, model: mode?.endTime, keyPath: "mode", cellClass: subIconAndTitleCell.self, contentViewWidth: ScreenW) + 20
            
        default:
            return 45
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        // MARK: - 数据替换
        case 0:
            let cell  = table.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
            cell.mode = mode?.company
            
            return cell
            
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: RecruiterCell.identity(), for: indexPath) as! RecruiterCell
            cell.mode = mode?.hr
            return cell
            
        case 2:
            
            let cell  = table.dequeueReusableCell(withIdentifier: JobDescription.identity(), for: indexPath) as! JobDescription
            cell.mode = mode
            
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: worklocateCell.identity(), for: indexPath) as! worklocateCell
            cell.mode = mode?.address
            cell.chooseAddress = { address in
                
                let geocoder = CLGeocoder()
                var place:CLLocationCoordinate2D?
                
                geocoder.geocodeAddressString(address) {
                    (placemarks, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    place = placemarks?.first?.location?.coordinate
                    let alert  =  PazNavigationApp.directionsAlertController(coordinate: place!, name: address, title: "选择地图", message: nil)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            return cell
        
        // 截止时间
        case 4:
            let cell =  tableView.dequeueReusableCell(withIdentifier: subIconAndTitleCell.identity(), for: indexPath) as! subIconAndTitleCell
            cell.mode = mode?.endTime
            cell.iconName.text = "截止时间"
            cell.icon.image = #imageLiteral(resourceName: "clock")
            return cell
            
            
        default:
            return  UITableViewCell()
            
        }
        
    }
}

extension JobDetailViewController{
    
    // 更加id  和 类型 获取job 信息
    private func loadData(id:String,type:jobType){
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 1)
            
            
            DispatchQueue.main.async(execute: {
                
                if type == .graduate{
                // 这有ui操作
                  if let data = CompuseRecruiteJobs(JSON: ["id":id,"type":type.rawValue,"benefits":"六险一金,鹅肠大神,海外手游扥等扥",
                    "name":"助理","address":["北京玉渊潭公园","北京市丰台区丰台路丰管路16号院8号楼","北京融科资讯中心A座"],"create_time":Date().timeIntervalSince1970 - TimeInterval(2423),"applyEndTime":Date().timeIntervalSince1970,"requirement": req,"works":works,"education":"本科","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false, "company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"hr":["userID":getUUID(),"name":"我是hr带我去的大青蛙","position":"HRBP","role":"招聘者","ontime": Date().timeIntervalSince1970 - TimeInterval(6514),"icon": #imageLiteral(resourceName: "jing").toBase64String(),"company":"公司名称"]]){
                    
                      self?.mode =  data
                    }
                    
                }else if type == .intern{
                    if let data = CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","requirement":req,"works":works,"applyEndTime":Date().timeIntervalSince1970,"perDay":"5天/周","months":"3个月","salary":"100元/天","company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000,"hr":["userID":getUUID(),"name":"我是hr带我去的大青蛙","position":"HRBP","role":"招聘者","ontime": Date().timeIntervalSince1970 - TimeInterval(6514),"icon": #imageLiteral(resourceName: "jing").toBase64String(),"company":"公司名称"]]
                        ){
                        self?.mode = data
                        
                    }
                    
                }
                
                self?.HRModel = self?.mode?.hr
                
        
                // 获取数据成功
                self?.didFinishloadData()
                // 获取数据失败 重新刷新
                //self?.showError()
               
            })
        }
        
    }
}


extension JobDetailViewController: shareViewDelegate{
    func hiddenShareView(view:UIView){
        self.handleSingleTapGesture()
    }
    
    func handleShareType(type: UMSocialPlatformType) {
        // 影藏分享界面
        self.handleSingleTapGesture()
        
        //开始分享
        if type.rawValue  == 1001{
            
            return
        }
        
        if type.rawValue == 1002{
            let activiController = UIActivityViewController.init(activityItems: ["dwdwqd"], applicationActivities: nil)
            activiController.excludedActivityTypes = [UIActivityType.postToTencentWeibo, UIActivityType.postToWeibo]
            self.present(activiController, animated: true, completion: nil)
            return
        }
        
        
        // 网页分享消息
        let mesObj = UMSocialMessageObject.init()
        mesObj.text = "友盟网页分享测试"
        let sharedObj = UMShareWebpageObject.init()
        sharedObj.title = "设置标题"
        sharedObj.descr = "xxx的个人名片"
        sharedObj.thumbImage = UIImage.init(named: "default")
        sharedObj.webpageUrl = "http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"
        mesObj.shareObject = sharedObj
        
        // 分享到不同的平台
        
        UMSocialManager.default().share(to: type, messageObject: mesObj, currentViewController: self) { (res, error) in
            if error != nil{
                print("分享失败 \(String(describing: error))")
            }else{
                self.shareapps.getUserInfo(platformType: type, vc: self)
            }
        }
    
        
    }
    
    
  
    
}

extension JobDetailViewController{
    
    // 举报
    @objc func warn(){
        
        WarnViewController.hidesBottomBarWhenPushed = true
        // test
        WarnViewController.target = kind
        self.navigationController?.pushViewController(WarnViewController, animated: true)
    }
    
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            if scrollView.contentOffset.y > 50.0{
                self.navigationItem.title = mode?.name
                
            }else{
               self.navigationItem.title = "职位详情"
            }
        }
    }
    
}




