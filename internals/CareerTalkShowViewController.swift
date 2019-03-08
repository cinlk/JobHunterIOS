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
import RxDataSources

fileprivate let viewTitle:String = "宣讲会详情"
fileprivate let collectedStr:[String] = ["取消收藏", "收藏成功"]

class CareerTalkShowViewController: BaseShowJobViewController {

    
    private lazy var headerView:CareerTalkHeaderView = CareerTalkHeaderView()
    
    
    // 根据id 查询数据
    internal var meetingID:String = ""{
        didSet{
           query.onNext(meetingID)
        }
    }
    
    private lazy var apply:UIButton = {
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  GlobalConfig.ScreenW - collectedBtn.width, height: GlobalConfig.toolBarH))
        apply.addTarget(self, action: #selector(addCalendar(_:)), for: .touchUpInside)
        apply.setTitle("添加到日历", for: .normal)
        apply.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        return apply
        
    }()
    
    
    //rxSwift
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    private let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    private var dataSoure:RxTableViewSectionedReloadDataSource<RecruitMeetingSectionModel>!
    private var mode:BehaviorRelay<CareerTalkMeetingModel> = BehaviorRelay<CareerTalkMeetingModel>.init(value: CareerTalkMeetingModel(JSON: [:])!)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
       

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        self.navigationController?.setToolbarHidden(false, animated: true)
        //self.navigationController?.navigationBar.settranslucent(false)
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        self.navigationController?.setToolbarHidden(true, animated: true)
        //elf.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.removeCustomerView()

    }
    
    
    
    override func setViews() {
       
        
        super.setViews()
        //setToolBar()
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
        self.title = viewTitle
        table.register(CompanySimpleCell.self, forCellReuseIdentifier: CompanySimpleCell.identity())
        // 内容cell
        table.register(CareerTalkContentCell.self, forCellReuseIdentifier: CareerTalkContentCell.identity())
        shareapps.delegate = self
       

    }
    
    
    private func didFinishloadData(mode: CareerTalkMeetingModel) {
        super.didFinishloadData()
        
        headerView.mode = mode
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
       
        collectedBtn.isSelected = mode.isCollected ?? false
        self.navigationController?.setToolbarHidden(false, animated: true)

    }
    
    override func reload() {
        super.reload()
        // TODO 出现错误 重新获取序列数据
        query.onNext(self.meetingID)
    }
    
    // 收藏
    override func collected(_ btn:UIButton){
        guard  let IsCollected = mode.value.isCollected else {
            return
        }
        
        if !verifyLogin(){
            return
        }
        
        let str =  IsCollected ? collectedStr[0] : collectedStr[1]
        collectedBtn.isSelected = IsCollected
        self.view.showToast(title: str, customImage: nil, mode: .text)
        //showOnlyTextHub(message: str, view: self.view)
        // 上传到服务器
        mode.value.isCollected = !IsCollected
        
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
        
        table.rx.setDelegate(self).disposed(by: self.dispose)

        
        self.errorView.tap.asDriver().drive(onNext: { _ in
            self.reload()
        }).disposed(by: self.dispose)
        
        
        query.subscribe(onNext: { (id) in
            self.vm.getRecruitMeetingBy(id: id)
            
        }).disposed(by: dispose)
        
        dataSoure = RxTableViewSectionedReloadDataSource<RecruitMeetingSectionModel>.init(configureCell: { (dataSource, table, indexPath, _) -> UITableViewCell in
            switch dataSource[indexPath]{
            case .CompanyItem(let mode):
                let cell = table.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
                cell.mode = mode
                return cell
                
            case .RecruitMeeting(let mode):
                
                let cell = table.dequeueReusableCell(withIdentifier: CareerTalkContentCell.identity(), for: indexPath) as! CareerTalkContentCell
                cell.name.text = "宣讲内容"
                cell.mode = mode
                self.mode.accept(mode)
                
                return cell
                
            }
        })
        
        self.mode.subscribe(onNext: { (mode) in
            guard let _ = mode.id else {
                return
            }
            self.didFinishloadData(mode: mode)
            
            
        }).disposed(by: self.dispose)
           // 错误处理
        self.vm.recruitMeetingMultiSection.asDriver(onErrorJustReturn: []).do(onNext: { (res) in
            if res.isEmpty{
                self.showError()
            }
        }).drive(self.table.rx.items(dataSource: self.dataSoure)).disposed(by: self.dispose)
        
     
       
        
        self.table.rx.itemSelected.subscribe(onNext: { (indexPath) in
            switch self.dataSoure[indexPath]{
            case .CompanyItem(let mode):
                let com = CompanyMainVC()
                com.companyID = mode.companyID
                com.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(com, animated: true)
            default:
                break
            }
        }).disposed(by: self.dispose)
        
        
        
    }
}
extension CareerTalkShowViewController{
    
    
//    private func setToolBar(){
//
//        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        rightSpace.width = 20
//
//
//        self.toolbarItems?.append(rightSpace)
//        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
//        let last = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        last.width = -20
//        self.toolbarItems?.append(last)
//
//    }
    
    @objc private func addCalendar(_ btn:UIButton){
       
        guard let _ = mode.value.id  else {
            return
        }
        
        let store = EKEventStore()
        
        // Request access to calendar first
        store.requestAccess(to: .event, completion: { (granted, error) in
            if granted {
                // create the event object
                let event = EKEvent(eventStore: store)
                
                event.title = self.mode.value.name
                event.startDate = self.mode.value.startTime
                event.endDate = self.mode.value.endTime
                event.location =  (self.mode.value.college ?? "")   + "-" + (self.mode.value.address ?? "")
                
                if let url = self.mode.value.link{
                    event.url = url
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
                self.view.showToast(title: "permit calender", customImage: nil, mode: .text)
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


extension CareerTalkShowViewController: UITableViewDelegate{
    
   
    
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSoure[indexPath] {
            case .CompanyItem(let mode):
                return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanySimpleCell.self, contentViewWidth: GlobalConfig.ScreenW)
            case .RecruitMeeting(let mode):
                return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkContentCell.self, contentViewWidth: GlobalConfig.ScreenW)
        }
    }

}





private class CareerTalkHeaderView:UIView{
    
    
    // 宣讲会名字
    private lazy var name:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
            if let source = mode.reference{
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







