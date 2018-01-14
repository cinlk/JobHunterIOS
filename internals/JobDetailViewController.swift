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

//内置分享sdk
import Social

class JobDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var infos:[String:String]?
    
    
    lazy var jobheader:JobDetailHeader = {
       let jh = JobDetailHeader.init(frame: CGRect.zero)
        infos!["类型"] = "社招"
        jh.createInfos(item: infos!)
        return jh
    }()
    lazy var table:UITableView = { [unowned self]  in
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        //自适应cell高度
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 80
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.tableHeaderView = jobheader
        table.backgroundColor = UIColor.lightGray
        table.tableHeaderView?.backgroundColor = UIColor.white
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
        table.showsHorizontalScrollIndicator = false
        table.register(UINib(nibName:"company", bundle:nil), forCellReuseIdentifier: "companycell")
        table.register(UINib(nibName:"JobDescription", bundle:nil), forCellReuseIdentifier: "joninfos")
        table.register(UINib(nibName:"worklocate", bundle:nil), forCellReuseIdentifier: "locate")
        table.register(UINib(nibName:"RecruiterCell", bundle: nil), forCellReuseIdentifier: "recruiter")
        return table
    }()
    
    var sections = 4
   
    
    
    // test string
    var needed =  "1 3年以上互联网产品工作经验，经历过较大体量用户前后端产品项目\n 2 思维活跃，有独立想法，有情怀，喜欢电影行业\n 3 善于业务整体规划、任务模块优先级拆解、能够主导产品生命周期全流程\n 4 具备良好的沟通技巧和团队合作精神，有带团队经验者优先 \n 5 高度执行力，能够独当一面，善于推动团队效率不断提升"
    
    var desc = "1、负责租房频道整体流量运营及制定获客策略，辅助制定租房频道市场营销、推广和渠道合作策略；\n 2、合理的制定目标及市场预算分配 \n 3、负责对外媒体合作和商务拓展活动；\n 4、推动租房频道线上推广及线下活动的策划、组织和执行工作； \n 5、协调运营、产品及技术等团队推动产品优化提升获客效果 \n 6、对市场信息敏感，及时汇报且要做出预判投放解决方案。"
    
    // 分享界面
    lazy var shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 150))
        // 加入最外层窗口
        view.sharedata = self.infos?["jobName"] ?? ""
         UIApplication.shared.windows.last?.addSubview(view)
         return view
     }()
    
    var centerY:CGFloat!
    
    lazy var darkView :UIView = {
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        darkView.isUserInteractionEnabled = true // 打开用户交互
        return darkView
    }()
    
    // navigation 背景view
    lazy var nBackView:UIView = {
       let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
       v.backgroundColor = UIColor.lightGray
       return v
    }()
    
    // bottom viwe
    lazy var bottomView:UIView = {  [unowned self] in
        let v = UIView.init()
        v.backgroundColor = UIColor.white
        v.alpha = 0.95
        let sendResume = UIButton.init()
        sendResume.setTitle("发送简历", for: .normal)
        sendResume.setTitleColor(UIColor.black, for: .normal)
        sendResume.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendResume.layer.borderWidth = 0.5
        sendResume.layer.borderColor = UIColor.green.cgColor
        sendResume.addTarget(self, action: #selector(self.sendResume), for: .touchUpInside)
        let talk = UIButton.init()
        talk.setTitle("和TA聊聊", for: .normal)
        talk.backgroundColor = UIColor.green
        talk.setTitleColor(UIColor.white, for: .normal)
        talk.layer.borderWidth = 0.5
        talk.layer.borderColor = UIColor.clear.cgColor
        talk.addTarget(self, action: #selector(self.talk), for: .touchUpInside)
        v.addSubview(talk)
        v.addSubview(sendResume)
        _ = sendResume.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(100)
        _ = talk.sd_layout().leftSpaceToView(sendResume,10)?.topEqualToView(sendResume)?.bottomEqualToView(sendResume)?.rightSpaceToView(v,10)
        
        return v
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.addBarItems()
        self.view.addSubview(table)
        
        self.view.addSubview(bottomView)
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        self.centerY = shareapps.centerY
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "职位详情"
        // 加入背景view
        self.navigationController?.view.insertSubview(nBackView, at: 1)
        
        print("job detail appear \(self.view)")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nBackView.removeFromSuperview()
        self.navigationItem.title = ""
        self.navigationController?.view.willRemoveSubview(nBackView)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = self.table.tableHeaderView?.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.heightIs(120)
        
        _ = self.bottomView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)?.heightIs(50)
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // section header 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 10))
        view.backgroundColor = UIColor.lightGray
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return  section == 0 ? 0: 10
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.table.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let detail = companyscrollTableViewController()
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detail, animated: true)
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
                let hr = publisherControllerView(style: .plain)
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(hr, animated: true)
            
        default:
            break
        }
       
     
    }
    
    
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return 65
        case 3:
            return RecruiterCell.cellHeight()
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            let cell  = table.dequeueReusableCell(withIdentifier: "companycell", for: indexPath) as! company
            cell.cimage.image = UIImage(named: "camera")
            cell.name.text = "vmware公司"
            cell.infos.text = "上市企业|1万人|不加班"
            return cell
        case 1:
            
            let cell  = table.dequeueReusableCell(withIdentifier: "joninfos", for: indexPath) as! JobDescription
            cell.demandInfo.text  = needed
            cell.workcontent.text  = desc
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "locate", for: indexPath) as! worklocate
            cell.locate.text = "工作地址"
            cell.details.text = "北京海淀区-"+"-北四环-" + "海淀北二街"
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: "recruiter", for: indexPath) as! RecruiterCell
            cell.name.text = "lucky"
            cell.position.text = "hr vice present "
            cell.onlineTime.text = "最近活跃:6小时前"
            cell.icon.image = UIImage.init(named: "chrome")
            cell.selectionStyle = .none
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
            
            self.shareapps.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 150)
        }, completion: nil)
        
        
        
    }
    // 举报
    @objc func warn(){
        let report = JuBaoViewController()
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(report, animated: true)
        
        
    }
   
    @objc func collect(){
        
    }
    
    @objc func sendResume(){
        
    }
    
    @objc func talk(){
        // test
        let hr:FriendModel = FriendModel.init(name: "hr", avart: "hr", companyName: "霹雳", id: "2")
        let messgeBody:MessageBoby = MessageBoby.init(content: "hr 你好，对贵公司该职位感兴趣，希望进一步沟通", time: "2018-01-11", sender: myself, target: hr)
        
        Contactlist.shared.addUser(user: hr)
        Contactlist.shared.usersMessage[hr.id]?.addMessageByMes(newMes: messgeBody)
        let chatView = communication(hr: hr)
        // chatView.chatWith(friend:, jobCard: nil)
        self.hidesBottomBarWhenPushed = true
        NotificationCenter.default.post(name: NSNotification.Name.init("refreshChat"), object: nil)
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        //self.navigationController?.navigationBar.settranslucent(true)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            if scrollView.contentOffset.y > 50.0{
                self.navigationItem.title = infos?["jobName"]
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
            
            self.shareapps.centerY =  self.centerY
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
        
        let collection = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "heart")
        let b3 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b3.addTarget(self, action: #selector(collect), for: .touchUpInside)
        b3.clipsToBounds = true
        b3.setImage(collection, for: .normal)
        self.navigationItem.setRightBarButtonItems([ UIBarButtonItem.init(customView: b3),UIBarButtonItem.init(customView: b1),UIBarButtonItem.init(customView: b2)], animated: false)
        
        
    }
}
