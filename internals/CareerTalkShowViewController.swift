//
//  CareerTalkShowViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import EventKitUI


fileprivate let viewTitle:String = "宣讲会详情"

class CareerTalkShowViewController: BaseShowJobViewController {

    
    private lazy var headerView:CareerTalkHeaderView = CareerTalkHeaderView()
    
    private var mode:CareerTalkMeetingModel?
    // 根据id 查询数据
    var meetingID:String?{
        didSet{
            self.loadData()
        }
    }
    
    
    private lazy var firstLoad:Bool = false
    
    
    private lazy var apply:UIButton = {
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  ScreenW - collectedBtn.width + 20, height: (self.navigationController?.toolbar.height)!))
        
        
        apply.addTarget(self, action: #selector(AddCalendar(_:)), for: .touchUpInside)
        apply.setTitle("添加到日历", for: .normal)
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        return apply
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()

       

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = viewTitle
        self.navigationController?.insertCustomerView()
        self.navigationController?.setToolbarHidden(firstLoad == false, animated: false)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
        //self.navigationItem.title = ""
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    
    
    override func setViews() {
       
        
        super.setViews()
        self.title = viewTitle
        table.delegate = self
        table.dataSource = self
        // 公司cell
        table.register(UINib.init(nibName: "CompanySimpleCell", bundle: nil), forCellReuseIdentifier: CompanySimpleCell.identity())
        
        
        // 内容cell
        table.register(applyJobsCell.self, forCellReuseIdentifier: applyJobsCell.identity())
        shareapps.delegate = self
        
        // 设置toolbar btn
        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        rightSpace.width = 20
        
        
        self.toolbarItems?.append(rightSpace)
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
        let last = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        last.width = -20
        self.toolbarItems?.append(last)
        // 筛选回调
        

    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        headerView.mode = mode
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
        table.reloadData()
        
        collectedBtn.isSelected = (mode?.isCollected)!
        firstLoad = true
        self.navigationController?.setToolbarHidden(!firstLoad, animated: false)

        
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    // 收藏
    override func collected(_ btn:UIButton){
        
        let str =  (mode?.isCollected)! ? "取消收藏" : "收藏成功"
        collectedBtn.isSelected = !(mode?.isCollected)!
        showOnlyTextHub(message: str, view: self.view)
        mode?.isCollected = !(mode?.isCollected)!
        
    }

}


extension CareerTalkShowViewController {
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 1)
            // 判断数据
            self?.mode = CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq","icon":"sina","name":"公司名字","address":["城市1","城市2"],"industry":["行业1","行业2"],"staffs":"10000人以上", "isValidate":true,"isCollected":false],"college":"北京大学","address":"教学室二"
                ,"isValidate":true,"isCollected":false,"url":"https://dwqd/xjh/dwq67","icon":"car","start_time":Date().timeIntervalSince1970,"end_time":Date().timeIntervalSince1970 + TimeInterval(3600*2),
                 "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                 "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"])!
            
            
            
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
    

}

extension CareerTalkShowViewController: shareViewDelegate{
    

    func handleShareType(type: UMSocialPlatformType) {
    }
}

extension CareerTalkShowViewController{
    @objc private func AddCalendar(_ btn:UIButton){
       
        guard let mode = mode  else {
            return
        }
        
        let store = EKEventStore()
        
        // Request access to calendar first
        store.requestAccess(to: .event, completion: { (granted, error) in
            if granted {
                print("calendar allowed")
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormat.locale =  Locale(identifier: "zh_CN")
                
                
                // create the event object
                let event = EKEvent(eventStore: store)
                
                event.title = mode.name
                event.startDate = dateFormat.date(from:  (mode.start_time?.string())!)
                event.endDate =   dateFormat.date(from:  (mode.end_time?.string())!)
                event.location =  mode.college!   + "-" + mode.address!
                
                if let url = mode.url{
                    event.url = URL.init(string: url)
                }
                
                
                
                let alarm = EKAlarm()
                alarm.relativeOffset = -60.0*60*2
                event.addAlarm(alarm)
                
                event.calendar = store.defaultCalendarForNewEvents
                
                
                
                let controller = EKEventEditViewController()
                controller.event = event
                controller.eventStore = store
                controller.editViewDelegate = self
                
                self.present(controller, animated: true)
            }
            else
            {
                print("calendar not allowed")
            }
        })
        

        
    }
}

extension CareerTalkShowViewController: EKEventEditViewDelegate{
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.setToolbarHidden(false, animated: true)

    }
    
   
    
   
    
    
    
}


extension CareerTalkShowViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
            cell.mode = mode?.companyModel
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: applyJobsCell.identity(), for: indexPath) as! applyJobsCell
            cell.name.text = "宣讲正文"
            cell.mode = mode?.content ?? ""
            return cell
        default:
            break
        }
        
        return UITableViewCell()
        
       
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let com = CompanyMainVC()
            com.companyID = mode?.companyModel?.id
            com.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(com, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  CompanySimpleCell.cellHeight()
        }
        
        guard let content = mode?.content else { return 0 }
        return tableView.cellHeight(for: indexPath, model: content, keyPath: "mode", cellClass: applyJobsCell.self, contentViewWidth: ScreenW)
    }
    
    
    
    
}





private class CareerTalkHeaderView:UIView{
    
    
    // 宣讲会名字
    private lazy var name:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var addressIcon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "marker")
        return img
    }()
    // 会议室地址
    private lazy var address:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var timeIcon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "month")
        return img
    }()
    // 举办时间范围
    private lazy var time:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    private lazy var sourceIcon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "onedriver")
        return img
    }()
    // 标注信息来源
    private lazy var source:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    
    var mode:CareerTalkMeetingModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            
            
            self.name.text = mode.name
            self.address.text = "举办地点: " + mode.college! + " " +  mode.address!
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:MM"
            self.time.text =   "举办时间: " + dateFormat.string(from: mode.start_time!)
            if let source = mode.source{
            self.source.text = "来源: " +  source
            }else{
                self.source.isHidden = true
                self.sourceIcon.isHidden = true
            }

            self.setupAutoHeight(withBottomViewsArray: [time,source], bottomMargin: 10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let views:[UIView] = [name, addressIcon, address,timeIcon, time, sourceIcon, source]
        self.sd_addSubviews(views)
        
        _ = name.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.autoHeightRatio(0)
        _ = addressIcon.sd_layout().topSpaceToView(name,5)?.leftEqualToView(name)?.widthIs(15)?.heightIs(15)
        _ = address.sd_layout().leftSpaceToView(addressIcon,10)?.topEqualToView(addressIcon)?.autoHeightRatio(0)
        _ = timeIcon.sd_layout().topSpaceToView(addressIcon,5)?.leftEqualToView(addressIcon)?.widthRatioToView(addressIcon,1)?.heightRatioToView(addressIcon,1)
        _ = time.sd_layout().leftSpaceToView(timeIcon,10)?.topEqualToView(timeIcon)?.autoHeightRatio(0)
        _ = sourceIcon.sd_layout().topSpaceToView(timeIcon,5)?.leftEqualToView(timeIcon)?.widthRatioToView(addressIcon,1)?.heightRatioToView(addressIcon,1)
        _ = source.sd_layout().topEqualToView(sourceIcon)?.leftSpaceToView(sourceIcon,10)?.autoHeightRatio(0)
        
        name.setMaxNumberOfLinesToShow(2)
        address.setMaxNumberOfLinesToShow(2)
        source.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







