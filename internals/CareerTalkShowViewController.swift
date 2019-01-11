//
//  CareerTalkShowViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import EventKitUI
import RxSwift
import RxCocoa

fileprivate let viewTitle:String = "宣讲会详情"

class CareerTalkShowViewController: BaseShowJobViewController {

    
    private lazy var headerView:CareerTalkHeaderView = CareerTalkHeaderView()
    
    private var mode:CareerTalkMeetingModel?{
        didSet{
            self.didFinishloadData()
        }
    }
    
    // 根据id 查询数据
    var meetingID:String?{
        didSet{
           query.onNext(meetingID!)
        }
    }
    
    private var showTooBar:Bool = false{
        didSet{
            self.navigationController?.setToolbarHidden(!showTooBar, animated: false)

        }
    }
    
    
    private lazy var apply:UIButton = {
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  ScreenW - collectedBtn.width + 20, height: TOOLBARH))
        apply.addTarget(self, action: #selector(AddCalendar(_:)), for: .touchUpInside)
        apply.setTitle("添加到日历", for: .normal)
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        return apply
        
    }()
    
    
    //rxSwift
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
       

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView()
        // 第一次加载 为false，不显示 直到获取数据后 设置为true 显示
        if self.showTooBar == false{
            self.showTooBar = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        self.showTooBar = false
    }
    
    
    
    override func setViews() {
       
        
        super.setViews()
        setToolBar()
        self.errorView.reload = reload
        self.title = viewTitle
        table.delegate = self
        table.dataSource = self
        table.register(CompanySimpleCell.self, forCellReuseIdentifier: CompanySimpleCell.identity())
        // 内容cell
        table.register(CareerTalkContentCell.self, forCellReuseIdentifier: CareerTalkContentCell.identity())
        shareapps.delegate = self
       

    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        headerView.mode = mode
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
        table.reloadData()
        collectedBtn.isSelected = (mode?.isCollected)!
        self.showTooBar = true
    }
    
    override func reload() {
        super.reload()
        // TODO 出现错误 重新获取序列数据
    }
    
    // 收藏
    override func collected(_ btn:UIButton){
        
        let str =  (mode?.isCollected)! ? "取消收藏" : "收藏成功"
        collectedBtn.isSelected = !(mode?.isCollected)!
        self.view.showToast(title: str, customImage: nil, mode: .text)
        //showOnlyTextHub(message: str, view: self.view)
        mode?.isCollected = !(mode?.isCollected)!
        
    }

}


extension CareerTalkShowViewController: shareViewDelegate{
    

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


extension CareerTalkShowViewController{
    
    private func setViewModel(){
        
        query.asDriver(onErrorJustReturn: "").drive(onNext: { (id) in
            self.vm.getRecruitMeetingBy(id: id).share().subscribe(onNext: { (mode) in
                self.mode = mode
            }, onError: { (err) in
                self.showError()
                self.view.showLoading(title: "query get error \(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "query get error \(err)", view: self.view)
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
    }
}
extension CareerTalkShowViewController{
    
    
    private func setToolBar(){
        
        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        rightSpace.width = 20
        
        
        self.toolbarItems?.append(rightSpace)
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
        let last = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        last.width = -20
        self.toolbarItems?.append(last)
        
    }
    
    @objc private func AddCalendar(_ btn:UIButton){
       
        guard let mode = mode  else {
            return
        }
        
        let store = EKEventStore()
        
        // Request access to calendar first
        store.requestAccess(to: .event, completion: { (granted, error) in
            if granted {
                print("calendar allowed")
                
                
                // create the event object
                let event = EKEvent(eventStore: store)
                
                event.title = mode.name
                event.startDate = mode.start_time
                event.endDate = mode.end_time
                event.location =  mode.college!   + "-" + mode.address!
                
                if let url = mode.link{
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkContentCell.identity(), for: indexPath) as! CareerTalkContentCell
            cell.name.text = "宣讲内容"
            cell.mode = mode
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
            //return  CompanySimpleCell.cellHeight()
            return table.cellHeight(for: indexPath, model: mode?.companyModel, keyPath: "mode", cellClass: CompanySimpleCell.self, contentViewWidth: ScreenW)
        }
        
        guard let mode = mode else { return 0 }
        
        
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkContentCell.self, contentViewWidth: ScreenW)
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
            self.time.text =   "举办时间: " + mode.startTimeStr
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







