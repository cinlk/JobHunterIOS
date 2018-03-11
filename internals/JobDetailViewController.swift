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
import SVProgressHUD

//内置分享sdk
import Social


fileprivate let tableViewHeaderH:CGFloat  = 148
fileprivate let sections:Int = 4
fileprivate let sharedViewH:CGFloat = 150
fileprivate let bottomViewH:CGFloat = 50


class JobDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var mode:CompuseRecruiteJobs?{
        didSet{
            jobheader.mode = mode!
        }
    }
    
    
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
    
    
    private var HRname:String = "lucy"
    private var Hricon:String = "sina"
    private var HRposition:String = "hr manager"
    private var HRtime:String = "2小时前"
    
    // 公司界面VC
    private lazy var companyVC:companyscrollTableViewController =  companyscrollTableViewController()
    // 分享界面
    private lazy var shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: sharedViewH))
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
    private lazy var HRVC:publisherControllerView = publisherControllerView()
    
 
    
    private var talkTitle =  "和TA聊聊"
    private var resumeTitle = "投递简历"
    private var isTalked = false
    private var isSendResume = false
    
    let hr:FriendModel = FriendModel.init(name: "hr", avart: "hr", companyName: "霹雳", id: "2")
    
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
        sendResume.isUserInteractionEnabled = !self.isSendResume
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
    
    
    
    // test job id
    var jobID:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.viewBackColor()
        self.addBarItems()
        self.view.addSubview(table)
        self.view.addSubview(bottomView)
        
        if SendResumeJobIds.contains(self.jobID){
            isSendResume = true
        }
        if talkedJobIds.contains(self.jobID){
            isTalked = true
        }
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "职位详情"
        self.tabBarController?.tabBar.isHidden = true
        // 加入背景view
        self.navigationController?.view.insertSubview(nBackView, at: 1)
        self.talkTitle =  isTalked ? "继续聊天" : "和TA聊聊"
        if isSendResume{
            self.resumeTitle = "已经投递"
            sendResumeBtn.setTitle(self.resumeTitle, for: .normal)
            sendResumeBtn.backgroundColor = UIColor.lightGray
            sendResumeBtn.isUserInteractionEnabled = !self.isSendResume
         }
        
        self.talkBtn.setTitle(self.talkTitle, for: .normal)
        
        
        
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nBackView.removeFromSuperview()
        self.navigationItem.title = ""
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.view.willRemoveSubview(nBackView)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = self.table.tableHeaderView?.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)
        
        _ = self.bottomView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)?.heightIs(bottomViewH)
        
        
        
    }
    
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
            
            companyVC.mode = "公司id"
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
                let mode = HRInfo.init(name: HRname, position: HRposition, lastLogin: HRtime, icon: Hricon)
                HRVC.mode = mode
                self.navigationController?.pushViewController(HRVC, animated: true)
            
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
            let mode = HRInfo.init(name: HRname, position: HRposition, lastLogin: HRtime, icon: Hricon)
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
            let mode = HRInfo.init(name: HRname, position: HRposition, lastLogin: HRtime, icon: Hricon)
            cell.mode = mode 
            return cell
        default:
            return  UITableViewCell()
            
        }
        
    }
    

}

extension JobDetailViewController{
    
    // 分享
    @objc func share(){    
    self.navigationController?.view.addSubview(darkView)
    //self.view.addSubview(darkView)
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps.frame = CGRect(x: 0, y: ScreenH - sharedViewH, width: ScreenW, height: sharedViewH)
        }, completion: nil)
        
        
    }
    // 举报
    @objc func warn(){
        let report = JuBaoViewController()
        //self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(report, animated: true)
        
        
    }
   
    @objc func collect(btn:UIButton){
        //TODO 职位收藏，改变收藏状态，界面显示已经收藏
        
       
        btn.isSelected = !btn.isSelected
        // 关注
        if btn.isSelected{
            SVProgressHUD.show(#imageLiteral(resourceName: "checkmark"), status: "收藏成功")
           
            //jobManageRoot.addCollectedItem(item: CompuseRecruiteJobs(JSON: infos!)!)
        }else{
            SVProgressHUD.show(#imageLiteral(resourceName: "checkmark"), status: "取消收藏")
            //jobManageRoot.removeCollectedItem(item: CompuseRecruiteJobs(JSON: infos!)!)
        }
         SVProgressHUD.dismiss(withDelay: 0.5)
        
        
    }
    
    @objc func sendResume(){
        
        SendResumeJobIds.append(self.jobID)
        sendResumeBtn.setTitle("已经投递", for: .normal)
        sendResumeBtn.backgroundColor = UIColor.lightGray
        sendResumeBtn.isUserInteractionEnabled = false
        
    }
    
    @objc func talk(){
        
        
        if !isTalked{
            let Message = MessageBoby.init(content: GreetingMsg, time: Date.init().timeIntervalSince1970, sender: myself, target: hr)
            
            let info = ["icon":"sina","jobName":"产品开发","company":"霹雳火","salary":"面议","tags":"北京|本科|校招"]
            if let  jobDetailMessage = JobDetailMessage.init(infos: info, time: Date.init().timeIntervalSince1970, sender: myself, target: hr){
                Contactlist.shared.addUser(user: hr)
                Contactlist.shared.usersMessage[hr.id]?.addMessageByMes(newMes: jobDetailMessage)
                if IsGreeting{
                        Contactlist.shared.usersMessage[hr.id]?.addMessageByMes(newMes: Message)
                }
                
                talkedJobIds.append(self.jobID)
                
            }
        }
        
        
        let chatView = communication(hr: hr)
        // chatView.chatWith(friend:, jobCard: nil)
        //self.hidesBottomBarWhenPushed = true
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
        
        
    }
}
