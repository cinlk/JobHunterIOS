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
import RxSwift
import RxCocoa
import MBProgressHUD
import RxDataSources
//import SwiftyJSON
//内置分享sdk
import Social

fileprivate let tableViewHeaderH:CGFloat  = 148

class JobDetailViewController: BaseShowJobViewController {
    
    private var mode:CompuseRecruiteJobs?{
        didSet{
            didFinishloadData()
        }
    }
    
    
    internal var uuid:String = ""{
        didSet{
            query.onNext(uuid)
        }
    }

    
    private var showToolBar:Bool = false{
        didSet{
            self.navigationController?.setToolbarHidden(!showToolBar, animated: true)
        }
    }
    
    // 数据库
    private let conversationManager = ConversationManager.shared
    
    private lazy var jobheader:JobDetailHeader = { [unowned self] in
        let jh = JobDetailHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableViewHeaderH))
        return jh
        
    }()
    
    
    
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
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: TOOLBARH))
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
        let talk = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - collectedBtn.width - apply.width + 20, height: TOOLBARH))
        talk.setTitle("和ta聊聊", for: .normal)
        talk.setTitle("继续沟通", for: .selected)
        talk.backgroundColor = UIColor.blue
        talk.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        talk.titleLabel?.textAlignment = .center
        talk.setTitleColor(UIColor.white, for: .normal)
        talk.addTarget(self, action: #selector(talkHR(_:)), for: .touchUpInside)
        
        return talk
    }()
    
    
    //rxSwift
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    var dataSoure: RxTableViewSectionedReloadDataSource<JobMultiSectionModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        self.setViewModel()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.showToolBar == false{
            self.showToolBar = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.showToolBar = false
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _  = self.table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
 
        
        
    }
    
    
    override func setViews() {
        
        
        self.handleViews.append(warnBtn)
        super.setViews()
        self.title = "职位详情"
        self.errorView.reload = reload
        table.register(CompanySimpleCell.self, forCellReuseIdentifier: CompanySimpleCell.identity())
        table.register(JobDescription.self, forCellReuseIdentifier: JobDescription.identity())
        table.register(worklocateCell.self, forCellReuseIdentifier: worklocateCell.identity())
        table.register(RecruiterCell.self, forCellReuseIdentifier: RecruiterCell.identity())
        table.register(subIconAndTitleCell.self, forCellReuseIdentifier: subIconAndTitleCell.identity())
        table.backgroundColor = UIColor.viewBackColor()
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        shareapps.delegate = self
        table.rx.setDelegate(self).disposed(by: dispose)
        
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
        // 是否关注
        collectedBtn.isSelected =  (mode?.isCollected)!
        apply.isSelected = (mode?.isApply)!
        apply.isUserInteractionEnabled = !(mode?.isApply)!
        talk.isSelected = ( mode?.isTalked)!
        
        // 控制toolbar 界面加载完成后在显示
        self.showToolBar = true
        
    }

    
    override func reload() {
        super.reload()
        query.onNext(uuid)
        // TODO 出现错误 如何再刷新？？
    }
    
    
    // 收藏
    override func collected(_ btn:UIButton){
        let str =  (mode?.isCollected)! ? "取消收藏" : "收藏成功"
        collectedBtn.isSelected = !(mode?.isCollected)!
        self.view.showToast(title: str, customImage: nil, mode: .text)
        //showOnlyTextHub(message: str, view: self.view)
        mode?.isCollected = collectedBtn.isSelected
        
    }
    
    
    @objc func onlineApply(_ btn:UIButton){
        
        if mode?.isApply == false{
            apply.isSelected = true
            apply.isUserInteractionEnabled = false
            self.view.showToast(title: "投递简历成功", duration: 5, customImage: UIImageView.init(image: UIImage.init(named: "checkmark")?.withRenderingMode(.alwaysTemplate)), mode: .customView)
            //showCustomerImageHub(message: "投递简历成功", view: self.view, image: #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate))
            mode?.isApply = true
        }
       
        
        
    }
    
    
    // 和hr 交流该职位
    @objc func talkHR(_ btn:UIButton){
        
        guard  let mode = mode  else {
            return
        }
        // 查看数据库， 如果之前没有交流过则发送jobdescribe message
        if mode.isTalked == false{
            // 本地自己发送的消息 总是read的
            // 打招呼消息
            
            do{
                
                
                if let  jobDescribeMessage = JobDescriptionlMessage(JSON: ["messageID":getUUID(),"creat_time":Date.init().timeIntervalSince1970,"type":MessgeType.jobDescribe.rawValue,"isRead":true, "receiver": mode.hr!.toJSON(), "sender":myself.toJSON(), "jobID":mode.id, "jobTypeDes":mode.kind?.describe, "icon": "sina", "jobName":"产品开发","company":"公司名称","salary":"薪水面议","tags":["标签1","标签2","标签3","标签4"]]){
                    
                
                    
                    
                    // 打招呼消息
                    let greetingMessage = MessageBoby(JSON: ["messageID":getUUID(),"content": GreetingMsg.data(using: String.Encoding.utf8)!.base64EncodedString(),"receiver": mode.hr!.toJSON(), "sender":myself.toJSON(),"isRead":true,"creat_time":Date.init().timeIntervalSince1970,
                                                             "type":MessgeType.text.rawValue])
                    
                    greetingMessage?.sender = myself
                    greetingMessage?.receiver = mode.hr!
                    
                    var messages:[MessageBoby] = []
                    
                    //
                    // 允许带招呼用语
                    if IsGreeting{
                        messages.append(jobDescribeMessage)
                        messages.append(greetingMessage!)
                        
                        
                    }else{
                        messages.append(jobDescribeMessage)
                    }
                    conversationManager.firstChatWith(person: mode.hr!, messages: messages)
                    
                    
                }
                
            }catch{
                print(error)
                return
            }
            
            mode.isTalked = true

            
            
        }
        
        talk.isSelected = true 
        // 跳转到和hr的聊天界面
        let chatView = CommunicationChatView(hr: mode.hr!)
        
        chatView.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatView, animated: true)
        
        
    }
    

}




extension JobDetailViewController: UITableViewDelegate{
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            if scrollView.contentOffset.y > NavH{
                self.navigationItem.title = mode?.name
                
            }else if scrollView.contentOffset.y <= 0 {
                self.navigationItem.title = "职位详情"
            }
        }
    }
    
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
            return  tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanySimpleCell.self, contentViewWidth: ScreenW)
        case .HRSectionItem(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: RecruiterCell.self, contentViewWidth: ScreenW)
        case .JobDescribeSectionItem(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobDescription.self, contentViewWidth: ScreenW)
        case .AddressSectionItem(let address):
            return tableView.cellHeight(for: indexPath, model: address, keyPath: "mode", cellClass: worklocateCell.self, contentViewWidth: ScreenW)
        case .EndTimeSectionItem(let time):
            return tableView.cellHeight(for: indexPath, model: time, keyPath: "mode", cellClass: subIconAndTitleCell.self, contentViewWidth: ScreenW) + 20
        }
        
    }
    
    
    private func  dataSource() -> RxTableViewSectionedReloadDataSource<JobMultiSectionModel>{
        
        return RxTableViewSectionedReloadDataSource<JobMultiSectionModel>.init(configureCell: { (dataSource, table, indexPath, _) -> UITableViewCell in
            
            switch dataSource[indexPath]{
            case .CompanySectionItem(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
                cell.mode = mode
                return cell
                
            case .HRSectionItem(let mode):
                let cell = table.dequeueReusableCell(withIdentifier: RecruiterCell.identity(), for: indexPath) as! RecruiterCell
                cell.mode = mode
                return cell
            case .JobDescribeSectionItem(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: JobDescription.identity(), for: indexPath) as! JobDescription
                cell.mode = mode
                self.mode = mode 
                
                return cell
            case .AddressSectionItem(let address):
                let cell = table.dequeueReusableCell(withIdentifier: worklocateCell.identity(), for: indexPath) as! worklocateCell
                cell.mode = address
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
            case .EndTimeSectionItem(let time):
                let cell =  table.dequeueReusableCell(withIdentifier: subIconAndTitleCell.identity(), for: indexPath) as! subIconAndTitleCell
                cell.mode = time
                cell.iconName.text = "截止时间"
                cell.icon.image = #imageLiteral(resourceName: "clock")
                return cell
            }
            
            
        })
    }
}

extension JobDetailViewController {
    
     private func  addBarItems(){
        
        // 举报item
        
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
    
    private func setViewModel(){
        
        self.dataSoure = self.dataSource()
        
        query.debug().asDriver(onErrorJustReturn: "").drive(onNext: { (id) in
            self.vm.getJobById(id: id)
        }).disposed(by: dispose)
        
        // TODO 错误处理，从新加载数据， 会多次绑定table 错误？？
        self.vm.jobMultiSection.debug().drive(self.table.rx.items(dataSource: self.dataSoure)).disposed(by: dispose)
        
        
        self.vm.jobMultiSection.drive(onNext: { (mode) in
            if mode.isEmpty{
                self.showError()
            }else{
                //self.mode =  mode[2].items as? CompuseRecruiteJobs
            }
        }).disposed(by: dispose)
        
        
        // table
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            if idx.section == 0 {
                let companyVC =  CompanyMainVC()
                companyVC.hidesBottomBarWhenPushed = true
                companyVC.companyID = self.mode?.company?.id
                
                self.navigationController?.pushViewController(companyVC, animated: true)
                
            }else if idx.section == 1{
                let hrvc = publisherControllerView()
                hrvc.hidesBottomBarWhenPushed = true
                guard let id = self.mode?.hr?.userID else {
                    return
                }
                hrvc.userID =  id
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
        let warnVC = JuBaoViewController()
        warnVC.jobID = mode?.id
        
        warnVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(warnVC, animated: true)
    }
    
}




