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


fileprivate let tableViewHeaderH:CGFloat  = 148
fileprivate let sections:Int = 4
fileprivate let bottomViewH:CGFloat = 50


class JobDetailViewController: BaseShowJobViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var mode:CompuseRecruiteJobs?{
        didSet{
            jobheader.mode = mode!
            isCollected = jobTable.isCollectedBy(id: jobID)
            jobheader.layoutSubviews()
        }
    }
    
    
    
    // 校招job id
    var jobID:String = ""{
        didSet{
            loadData(type:"graduate")
            jobType = "graduate"
        }
    }
    var internJobID:String = ""{
        didSet{
            loadData(type:"intern")
            jobType = "intern"
        }
    }
    
    private var companyModel:CompanyModel?
    
    private var jobType:String = ""
    
    
    
    
    private var isCollected:Bool = false
    
    // job table
    private let jobTable = DBFactory.shared.getJobDB()
    // 数据库
    private let conversationManager = ConversationManager.shared
    
    
    private lazy var jobheader:JobDetailHeader = { [unowned self] in
        
       let jh = JobDetailHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableViewHeaderH))
        //infos!["类型"] = "社招"
        jh.backgroundColor = UIColor.white
        
        return jh
    }()
    
    
    private lazy var warnBtn:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))

    
    // test string
    private var needed =  "1 3年以上互联网产品工作经验，经历过较大体量用户前后端产品项目\n 2 思维活跃，有独立想法，有情怀，喜欢电影行业\n 3 善于业务整体规划、任务模块优先级拆解、能够主导产品生命周期全流程\n 4 具备良好的沟通技巧和团队合作精神，有带团队经验者优先 \n 5 高度执行力，能够独当一面，善于推动团队效率不断提升"
    
    private var desc = "1、负责租房频道整体流量运营及制定获客策略，辅助制定租房频道市场营销、推广和渠道合作策略；\n 2、合理的制定目标及市场预算分配 \n 3、负责对外媒体合作和商务拓展活动；\n 4、推动租房频道线上推广及线下活动的策划、组织和执行工作； \n 5、协调运营、产品及技术等团队推动产品优化提升获客效果 \n 6、对市场信息敏感，及时汇报且要做出预判投放解决方案。"
    
    private var address = "北京海淀区-"+"-北四环-" + "海淀北二街"
    
    
    // 获取hr 信息
    private var HRuserID:String = "654321"
    private var HRname:String = "lucy"
    private var Hricon:UIImage = #imageLiteral(resourceName: "sina")
    private var HRposition:String = "hr manager"
    private var HRtime:String = "2小时前"
    private var HRCompany:String = "㝵橘"
    private var HRRole:String = "admin"

   
    
    var hr:PersonModel?
    
    // 第一次加载
    private lazy var firstLoad = true
    
    
    // 举报vc
    private  lazy var WarnViewController = JuBaoViewController()
    
    // apply
    
    private lazy var apply:UIButton = {
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: (self.navigationController?.toolbar.height)!))
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle("投递简历", for: .normal)
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        apply.titleLabel?.textAlignment = .center
        apply.backgroundColor = UIColor.green
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.setTitleColor(UIColor.lightGray, for: .selected)
        return apply
        
    }()
    
    private lazy var talk:UIButton = {
        let talk = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - collectedBtn.width - apply.width + 20, height: (self.navigationController?.toolbar.height)!))
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
        
        
        
        // 初始hr信息
        hr = HRPersonModel(JSON: ["userID":HRuserID,"name":HRname,"company":HRCompany,"icon":Hricon.toBase64String(),
                                  "role":HRRole,"isShield":false,"ontime":Date.init().timeIntervalSinceReferenceDate,
                                  "position":HRposition])
        
    }

 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "职位详情"
        self.navigationController?.insertCustomerView()
        self.navigationController?.setToolbarHidden(firstLoad, animated: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        self.navigationController?.setToolbarHidden(true, animated: false)
        firstLoad = false


    }
    
    
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = self.table.tableHeaderView?.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)
        
        
        
    }
    
    
    override func setViews() {
        
        
        
        self.handleViews.append(warnBtn)
        
        super.setViews()
    
        // 设置table
        table.delegate = self
        table.register(UINib(nibName:"CompanySimpleCell", bundle:nil), forCellReuseIdentifier: "companyCell")
        table.register(JobDescription.self, forCellReuseIdentifier: "JobDescription")
        table.register(worklocateCell.self, forCellReuseIdentifier: "worklocate")
        table.register(RecruiterCell.self, forCellReuseIdentifier: "RecruiterCell")
        table.backgroundColor = UIColor.viewBackColor()
        
        shareapps.delegate = self
        
        table.dataSource = self
        
        
        self.addBarItems()
        
       
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        
        self.table.tableHeaderView = jobheader
        self.table.reloadData()
        // 是否关注
        if mode?.isCollected == true {
            collectedBtn.isSelected = true
        }
        if mode?.isApply == true {
            apply.isSelected = true
            apply.isUserInteractionEnabled = false
            
        }
        
        if mode?.isTalked == true{
            talk.isSelected = true
        }
        
        self.navigationController?.setToolbarHidden(false, animated: true)

        
    }

    
    override func reload() {
        super.reload()
        loadData(type: jobType)
    }
    
    
    // 收藏
    override func collected(_ btn:UIButton){
        if mode?.isCollected == true{
            // 更新服务器数据
            collectedBtn.isSelected = false
            
            showOnlyTextHub(message: "取消收藏", view: self.view)
        }else{
            // 更新服务器数据
            collectedBtn.isSelected = true
            
            showOnlyTextHub(message: "收藏成功", view: self.view)
        }
        mode?.isCollected = !(mode?.isCollected)!
        
        
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
            mode?.isApply == true
        }
       
        
        
    }
    
    
    // 和hr 交流该职位
    @objc func talkHR(_ btn:UIButton){
        
        // 查看数据库， 如果之前没有交流过则发送jobdescribe message
        if mode?.isTalked == false{
            // 本地自己发送的消息 总是read的
            // 打招呼消息
            
            do{
                
                let contentData = try  JSON.init(["jobID":getUUID(),"icon": #imageLiteral(resourceName: "sina").toBase64String() ,"jobName":"产品开发","company":"霹雳火","salary":"面议","tags":["北京","本科","校招","户口"]]).rawData().base64EncodedString()
                
                if let  jobDescribeMessage = JobDescriptionlMessage(JSON: ["messageID":getUUID(),"creat_time":Date.init().timeIntervalSince1970,"type":MessgeType.jobDescribe.rawValue,"sender":myself,"receiver":hr!,"content":contentData,"isRead":true]){
                    jobDescribeMessage.sender = myself
                    jobDescribeMessage.receiver = hr
                    
                    
                    // 打招呼消息
                    let greetingMessage = MessageBoby(JSON: ["messageID":getUUID(),"content": GreetingMsg.data(using: String.Encoding.utf8)?.base64EncodedString(),
                                                             "isRead":true,"creat_time":Date.init().timeIntervalSince1970,
                                                             "type":MessgeType.text.rawValue,"sender":myself,"receiver":hr!])
                    
                    greetingMessage?.sender = myself
                    greetingMessage?.receiver = hr
                    
                    var messages:[MessageBoby] = []
                    
                    //
                    // 允许带招呼用语
                    if IsGreeting{
                        messages.append(jobDescribeMessage)
                        messages.append(greetingMessage!)
                        
                        
                    }else{
                        messages.append(jobDescribeMessage)
                    }
                    conversationManager.firstChatWith(person: hr!, messages: messages)
                    jobTable.talkedBy(id: jobID)
                    
                }
                
            }catch{
                print(error)
                return
            }
            
            mode?.isTalked = true

            
            
        }
        talk.isSelected = true 
        // 跳转到和hr的聊天界面
        let chatView = CommunicationChatView(hr: hr!)
        
        chatView.hidesBottomBarWhenPushed = true
        
        // 发送刷新 会话界面 新的消息？
        NotificationCenter.default.post(name: NSNotification.Name.init("refreshChat"), object: nil)
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
        
    }
    

}




extension JobDetailViewController {
    
    func  addBarItems(){
        
        
        let size = CGSize.init(width: 25, height: 25)
        
        
        
        // 举报item
        let warnIcon = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "warn")
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
        
        return  section == 0 ? 0: 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
        case 0:
            
            // MARK 临时给 jobid
            let companyVC =  CompanyMainVC()
            companyVC.hidesBottomBarWhenPushed = true 
            companyVC.companyID = jobID
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        case 2:
            let address = "北京市融科资讯中心"
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
            
        case 3:
            // mode 修改 MARK
            let hrvc = publisherControllerView()
            hrvc.hidesBottomBarWhenPushed = true 
            //let mode = HRInfo.init(name: HRname, position: HRposition, lastLogin: HRtime, icon: "sina")
            hrvc.userID  = "test-23123"
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
            let mode = jobDetails.init(jobDescribe: desc, jobCondition: needed, address: address)
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobDescription.self, contentViewWidth: ScreenW)
            
        case 2:
            let mode = jobDetails.init(jobDescribe: desc, jobCondition: needed, address: address)
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: worklocateCell.self, contentViewWidth: ScreenW)
        case 3:
            let mode = HRInfo.init(name: HRname, position: HRposition, lastLogin: HRtime, icon: "sina")
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: RecruiterCell.self, contentViewWidth: ScreenW)
            
        default:
            return 45
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        // MARK: - 数据替换
        case 0:
            let cell  = table.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath) as! CompanySimpleCell
            cell.mode = (image: "sina",companyName: "测试公司" ?? "", tags:"上市企业|1万人|不加班")
            return cell
            
        case 1:
            
            let cell  = table.dequeueReusableCell(withIdentifier: "JobDescription", for: indexPath) as! JobDescription
            let mode = jobDetails.init(jobDescribe: desc, jobCondition: needed, address: address)
            cell.mode = mode
            
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "worklocate", for: indexPath) as! worklocateCell
            let mode = jobDetails.init(jobDescribe: desc, jobCondition: needed, address: address)
            cell.mode = mode
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: "RecruiterCell", for: indexPath) as! RecruiterCell
            let mode = HRInfo.init(name: HRname, position: HRposition, lastLogin: HRtime, icon: "sina")
            cell.mode = mode
            return cell
        
        // 截止时间
        case 4:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            
            cell.textLabel?.text = "截止时间: "
            cell.detailTextLabel?.text = mode!.endTime
            
            return cell
            
            
        default:
            return  UITableViewCell()
            
        }
        
    }
}

extension JobDetailViewController{
    
    // 获取数据后 在设置界面
    private func loadData(type:String){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            
            DispatchQueue.main.async(execute: {
                
                if type == "graduate"{
                // 这有ui操作
                    self?.mode =  CompuseRecruiteJobs(JSON: ["id":self?.jobID,"type":type,"tag":["福利好","休息多"],
                                                         "icon":"sina","companyID":"dqw-dqwdq4-124","name":"助理","address":"北京海淀","salary":"10-20K","create_time":Date.init().string(),"education":"本科","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false])
                }else{
                    
                    self?.mode = CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dq-434-dqwdqw","name":"码农","address":"北京","salary":"150-190元/天","create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern"
                        ,"applyEndTime":Date().timeIntervalSince1970,"perDay":"4天/周","months":"5个月","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false])!
                }
        
                // 获取数据成功
                self?.didFinishloadData()
                // 获取数据失败
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
                print("分享失败 \(error)")
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
        WarnViewController.jobId = "dwqdq"
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




