//
//  CareerTalkShowViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import EventKitUI

class CareerTalkShowViewController: BaseShowJobViewController {

    
    private lazy var headerView:CareerTalkHeaderView = CareerTalkHeaderView()
    
    private var mode:CareerTalkMeetingModel?
    // 根据id 查询数据
    var meetingID:String?{
        didSet{
            self.loadData()
        }
    }
    
    
    
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
        
        self.navigationController?.insertCustomerView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
        self.navigationItem.title = ""
        self.navigationController?.setToolbarHidden(true, animated: false)

    }
    
    
    
    override func setViews() {
       
        
        super.setViews()
        
        table.delegate = self
        table.dataSource = self
        // 公司cell
        table.register(UINib.init(nibName: "CompanySimpleCell", bundle: nil), forCellReuseIdentifier: CompanySimpleCell.identity())
        
        
        // 内容cell
        table.register(TableContentCell.self, forCellReuseIdentifier: TableContentCell.identity())
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
        
        
        self.navigationItem.title = mode!.name ??  mode!.college
        headerView.mode = mode
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
        table.reloadData()
        if mode?.isCollected == true{
            collectedBtn.isSelected = true
        }
        self.navigationController?.setToolbarHidden(false, animated: true)
        
    }
    
    override func reload() {
        super.reload()
        self.loadData()
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
    


}


extension CareerTalkShowViewController {
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            self?.mode = CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq",
                                                                                       "icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false],
                                                       "college":"北京大学","address":"教学室二"
                ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,
                 "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                 "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"])!
            
            
            
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
    

}

extension CareerTalkShowViewController: shareViewDelegate{
    
    func hiddenShareView(view:UIView){
        self.handleSingleTapGesture()
    }
    func handleShareType(type: UMSocialPlatformType) {
    }
}

extension CareerTalkShowViewController{
    @objc private func AddCalendar(_ btn:UIButton){
        let eventStore = EKEventStore()

        let event = EKEvent(eventStore: eventStore)
        
        event.title = "title"
        event.location = "dqw"
        //event.url = url
        event.url = URL.init(string: "http://fqfqw.cn")
        event.notes = ""
        
        let alarm = EKAlarm()
        // 提前2小时通知
        alarm.relativeOffset = -60.0*60*2
        event.addAlarm(alarm)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
      
        let formater = DateFormatter()
        formater.locale = Locale.current
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTime = formater.date(from: "2018-03-23 06:56:00")
        let endTime = formater.date(from: "2018-03-23 09:56:00")
        
        event.startDate = startTime
        event.endDate = endTime
        
        let ekUI = EKEventEditViewController()
       
        ekUI.editViewDelegate = self
        ekUI.event = event
        ekUI.eventStore = eventStore
        self.present(ekUI, animated: true, completion: nil)
        
        
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
        let view = UIView()
        view.backgroundColor = UIColor.viewBackColor()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
            guard let company = mode?.companyModel else { break }
            cell.mode = (image:company.icon ,companyName:company.name!, tags:company.describe!)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableContentCell.identity(), for: indexPath) as! TableContentCell
            cell.name.text = "宣讲内容"
            cell.mode = mode?.content ?? ""
            return cell
        default:
            break
        }
        
        return UITableViewCell()
        
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  CompanySimpleCell.cellHeight()
        }
        
        guard let content = mode?.content else { return 0 }
        return tableView.cellHeight(for: indexPath, model: content, keyPath: "mode", cellClass: TableContentCell.self, contentViewWidth: ScreenW)
    }
    
    
    
    
}









private class CareerTalkHeaderView:UIView{
    
    // 大学图标
    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    // 宣讲会名字
    private lazy var name:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
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
    // 举办时间
    private lazy var time:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
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
            self.icon.image = UIImage.init(named: mode!.icon)
            self.address.text = mode?.address
            self.time.text = mode?.time
            self.source.text = "来源:" +  (mode!.source ?? "")

            self.setupAutoHeight(withBottomViewsArray: [icon,source], bottomMargin: 10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let views:[UIView] = [icon, name, addressIcon, address,timeIcon, time,source]
        self.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(45)?.heightIs(45)
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = addressIcon.sd_layout().topSpaceToView(name,5)?.leftEqualToView(name)?.widthIs(15)?.heightIs(15)
        _ = address.sd_layout().leftSpaceToView(addressIcon,5)?.topEqualToView(addressIcon)?.autoHeightRatio(0)
        _ = timeIcon.sd_layout().topSpaceToView(addressIcon,5)?.leftEqualToView(addressIcon)?.widthIs(15)?.heightIs(15)
        _ = time.sd_layout().leftSpaceToView(timeIcon,5)?.topEqualToView(timeIcon)?.autoHeightRatio(0)
        _ = source.sd_layout().topSpaceToView(time,5)?.leftEqualToView(timeIcon)?.autoHeightRatio(0)
        address.setMaxNumberOfLinesToShow(2)
        source.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







