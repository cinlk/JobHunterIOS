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


class JobDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var mode:CompuseRecruiteJobs?{
        didSet{
            jobheader.mode = mode!
            isCollected = jobTable.isCollectedBy(id: jobID)
            
            
        }
    }
    
    
    // job id
    var jobID:String = ""{
        didSet{
            loadData()
        }
    }
    
    private var isCollected:Bool = false
    
    // job table
    private let jobTable = DBFactory.shared.getJobDB()
    // 数据库
    private let conversationManager = ConversationManager.shared
    
    
    private lazy var jobheader:JobDetailHeader = { [unowned self] in
       let jh = JobDetailHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableViewHeaderH))
        //infos!["类型"] = "社招"
        return jh
    }()
    
    private lazy var table:UITableView = { [unowned self]  in
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.tableHeaderView = jobheader
        table.backgroundColor = UIColor.viewBackColor()
        table.tableHeaderView?.backgroundColor = UIColor.white
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
        table.showsHorizontalScrollIndicator = false
        table.register(UINib(nibName:"companyCell", bundle:nil), forCellReuseIdentifier: "companyCell")
        table.register(JobDescription.self, forCellReuseIdentifier: "JobDescription")
        table.register(worklocateCell.self, forCellReuseIdentifier: "worklocate")
        table.register(RecruiterCell.self, forCellReuseIdentifier: "RecruiterCell")
        return table
    }()
    
   
    
    
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
    
    // 分享界面
    private lazy var shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        // 加入最外层窗口
         UIApplication.shared.windows.last?.addSubview(view)
         ShareOriginY = view.origin.y
         return view
     }()
    
    private var ShareOriginY:CGFloat = 0
    
    private lazy var darkView :UIView = {
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:ScreenW, height:ScreenH)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        darkView.isUserInteractionEnabled = true // 打开用户交互
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        return darkView
    }()
    
    // navigation 背景view
   private lazy var nBackView:UIView = {
       let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: NavH))
       v.backgroundColor = UIColor.navigationBarColor()
       return v
    }()
    // hr VC
    //private lazy var HRVC:publisherControllerView = publisherControllerView()
    
 
    
    private var talkTitle =  "和TA聊聊"
    private var resumeTitle = "投递简历"
   
    
    var hr:PersonModel?
    
    // bottom viwe
    private var sendResumeBtn = UIButton.init(frame: CGRect.zero)
    private var talkBtn = UIButton.init(frame: CGRect.zero)
    
    private lazy var bottomView:UIView = {  [unowned self] in
        let v = UIView.init()
        v.backgroundColor = UIColor.white
        let sendResume = self.sendResumeBtn
        sendResume.setTitle(self.resumeTitle, for: .normal)
        sendResume.setTitleColor(UIColor.black, for: .normal)
        sendResume.backgroundColor = UIColor.white
        sendResume.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendResume.layer.borderWidth = 0.5
        sendResume.tag = 0
        sendResume.isUserInteractionEnabled = true
        sendResume.layer.borderColor = UIColor.green.cgColor
        sendResume.addTarget(self, action: #selector(self.sendResume), for: .touchUpInside)
        let talk = self.talkBtn
        talk.setTitle(self.talkTitle, for: .normal)
        talk.backgroundColor = UIColor.green
        talk.setTitleColor(UIColor.white, for: .normal)
        talk.layer.borderWidth = 0.5
        talk.layer.borderColor = UIColor.clear.cgColor
        talk.tag = 1
        talk.addTarget(self, action: #selector(self.talk), for: .touchUpInside)
        v.addSubview(talk)
        v.addSubview(sendResume)
        _ = sendResume.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(100)
        _ = talk.sd_layout().leftSpaceToView(sendResume,10)?.topEqualToView(sendResume)?.bottomEqualToView(sendResume)?.rightSpaceToView(v,10)
        
        return v
        
    }()
    
    // 举报vc
    private  lazy var WarnViewController = JuBaoViewController()
    
    // navigationBarItems
    private lazy var barBtnitems:[UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.viewBackColor()
        self.setViews()
        
        
        
        // 初始hr信息
        hr = HRPersonModel(JSON: ["userID":HRuserID,"name":HRname,"company":HRCompany,"icon":Hricon.toBase64String(),
                                  "role":HRRole,"isShield":false,"ontime":Date.init().timeIntervalSinceReferenceDate,
                                  "position":HRposition])
        
    }

 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "职位详情"
        self.tabBarController?.tabBar.isHidden = true
        // 加入背景view
        self.navigationController?.view.insertSubview(nBackView, at: 1)
        
        
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nBackView.removeFromSuperview()
        self.navigationItem.title = ""
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.view.willRemoveSubview(nBackView)

    }
    
    
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = self.table.tableHeaderView?.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)
        
        _ = self.bottomView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)?.heightIs(bottomViewH)
        
        
    }
    
    
    override func setViews() {
        self.addBarItems()
        self.view.addSubview(table)
        self.view.addSubview(bottomView)
        self.handleViews.append(table)
        self.handleViews.append(bottomView)
        barBtnitems.forEach{
           self.handleViews.append($0)
        }
        
        
        
        
        super.setViews()
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
        // 是否关注
        barBtnitems.last?.isSelected = isCollected
        // 是否已经投递简历
        self.talkTitle =  jobTable.isTalked(id: jobID) ? "继续聊天" : "和TA聊聊"
        if jobTable.isSendedResume(id: jobID){
            self.resumeTitle = "已经投递"
            sendResumeBtn.setTitle(self.resumeTitle, for: .normal)
            sendResumeBtn.backgroundColor = UIColor.lightGray
            sendResumeBtn.isUserInteractionEnabled =  false
        }
        
        self.talkBtn.setTitle(self.talkTitle, for: .normal)
        
    }
    
//    override func showError() {
//        super.showError()
//
//    }
    
    override func reload() {
        super.reload()
        loadData()
    }
    

}


// table

extension JobDetailViewController{
    
    // table
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
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
            return  companyCell.cellHeight()
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
            let cell  = table.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath) as! companyCell
            cell.mode = (image: "sina",companyName: mode?.company ?? "", tags:"上市企业|1万人|不加班")
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
        default:
            return  UITableViewCell()
            
        }
        
    }
}

extension JobDetailViewController{
    
    // 获取数据后 在设置界面
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            
            DispatchQueue.main.async(execute: {
                
                // 这有ui操作
                self?.mode =  CompuseRecruiteJobs(JSON: ["id":self?.jobID,"type":"compuse","tag":["福利好","休息多"],
                                                         "picture":"sina","company":"新浪工商所","jobName":"助理","address":"北京海淀","salary":"10-20K","create_time":Date.init().string(),"education":"本科"])
        
                // 获取数据成功
                self?.didFinishloadData()
                // 获取数据失败
                //self?.showError()
               
            })
        }
        
    }
}



extension JobDetailViewController{
    
    // 分享
    @objc func share(){    
    self.navigationController?.view.addSubview(darkView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.shareapps.frame = CGRect(x: 0, y: ScreenH - shareViewH, width: ScreenW, height: shareViewH)
        }, completion: nil)
        
    }
    // 举报
    @objc func warn(){
        
        self.hidesBottomBarWhenPushed = true
        // test
        WarnViewController.jobId = "dwqdq"
        self.navigationController?.pushViewController(WarnViewController, animated: true)
        
        
    }
   
    
    // 收藏
    @objc func collect(btn:UIButton){
        
       
        // 关注
        if !isCollected{
            
            // 更新服务器数据
            // 本地数据库更新
            
            
            jobTable.collectedJobBy(id: jobID)
            showOnlyTextHub(message: "已经关注", view: self.view)            
            isCollected = true
        }else{
            // 更新服务器数据
           
            // 本地数据库更新
            jobTable.uncollectedJobBy(id: jobID)
            showOnlyTextHub(message: "取消关注", view: self.view)

            isCollected = false
        }
        
         btn.isSelected = isCollected
        
    }
    
    @objc func sendResume(){
        
        // 更新服务器数据
//        DispatchQueue.global(qos: .userInitiated).async {
//
//        }
        jobTable.sendResumeJob(id: jobID)
        
        showCustomerImageHub(message: "投递简历成功", view: self.view, image: #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate))
        
        sendResumeBtn.setTitle("已经投递", for: .normal)
        sendResumeBtn.backgroundColor = UIColor.lightGray
        sendResumeBtn.isUserInteractionEnabled = false
        
    }
    
    
    // 和hr 交流该职位
    @objc func talk(){
        
        // 查看数据库， 如果之前没有交流过则发送jobdescribe message
        if jobTable.isTalked(id: jobID) == false{
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
            
  
        }
        
        // 跳转到和hr的聊天界面
        let chatView = CommunicationChatView(hr: hr!)
        
        chatView.hidesBottomBarWhenPushed = true
        
        // 发送刷新 会话界面 新的消息？
        NotificationCenter.default.post(name: NSNotification.Name.init("refreshChat"), object: nil)
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
        
    }
    

    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            if scrollView.contentOffset.y > 50.0{
                self.navigationItem.title = mode?.jobName
                
            }else{
               self.navigationItem.title = "职位详情"
            }
        }
    }
    
}

extension JobDetailViewController{
   
    
    @objc func handleSingleTapGesture() {
         // 点击移除半透明的View
        darkView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps.origin.y =  self.ShareOriginY
        }, completion: nil)
        
    }
    
    func  addBarItems(){
        
        // 定义customer button 和 调整image
        let size = CGSize.init(width: 25, height: 25)
        
        let shares = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "upload")
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.addTarget(self, action: #selector(share), for: .touchUpInside)
        b1.clipsToBounds = true
        b1.setImage(shares, for: .normal)
        
        
        let wa = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "warn")
        let b2 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b2.addTarget(self, action: #selector(warn), for: .touchUpInside)
        b2.clipsToBounds = true
        b2.setImage(wa, for: .normal)
        
        // 收藏
        let collection = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "heart")
        let b3 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b3.addTarget(self, action: #selector(collect(btn:)), for: .touchUpInside)
        b3.clipsToBounds = true
        b3.setImage(collection, for: .normal)
        let selectedCollected = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "selectedHeart")
        
        b3.setImage(selectedCollected, for: .selected)
        self.navigationItem.setRightBarButtonItems([ UIBarButtonItem.init(customView: b3),UIBarButtonItem.init(customView: b1),UIBarButtonItem.init(customView: b2)], animated: false)
        // btn显示被收藏
        b3.isSelected = isCollected
        
        barBtnitems.append(b1)
        barBtnitems.append(b2)
        barBtnitems.append(b3)
        
        
        
    }
}

