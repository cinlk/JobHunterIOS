//
//  jobCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import RxDataSources
import Kingfisher

//fileprivate let notifiyName:String = "jobCollectedVC"


class InternJobCollectedVC: BaseViewController {


    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    private lazy var datas:[CollectedInternJobModel] = []
    
    private var offset = 0
    private var limit = 10
    
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: CGRect.zero)
        //tb.dataSource = self
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        //tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(jobCollectedCell.self, forCellReuseIdentifier: jobCollectedCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        return tb
    }()
    
    
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            guard let s = self else {
                return
            }
            s.offset = 0
            s.vm.collectedInternJobsReq.onNext((s.offset, s.limit))
            
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let s = self else {
                return
            }
            s.offset += s.limit
            s.vm.collectedInternJobsReq.onNext((s.offset, s.limit))
            
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        setViewModel()
        
   
    }
    
    
    
    override func setViews() {
        
    
        self.view.addSubview(table)
        _ = table.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        self.hiddenViews.append(table)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
    }
    
    override func reload() {
        super.reload()
        //self.loadData()
        self.offset = 0
        self.vm.collectedInternJobsReq.onNext((self.offset, self.limit))
    }
    
  
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit internCollectedVC \(self)")
    }


}


extension InternJobCollectedVC{
    private func setViewModel(){
        
        self.errorView.tap.asDriver().drive(onNext: { [weak self] in
                self?.reload()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        NotificationCenter.default.rx.notification(NotificationName.collecteItem[1], object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.operation(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.collectedInternJobs.share().subscribe(onNext: { [weak self] (modes) in
            self?.datas = modes
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.collectedInternJobs.share().bind(to: self.table.rx.items(cellIdentifier: jobCollectedCell.identity(), cellType: jobCollectedCell.self)){ (row, mode, cell) in
            cell.mode = mode
        }.disposed(by: self.dispose)
        
        
        self.vm.internRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext:  { [weak self] (status) in
            guard let `self` = self else {
                return
            }
            switch status{
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
                self.didFinishloadData()
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()
                self.view.showToast(title: "err \(err)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "err \(err)", view: self.view)
            default:
                break
            }
            
        }).disposed(by: dispose)
        
        self.table.rx.itemSelected.subscribe(onNext: {  [weak self] (indexPath) in
            guard let `self` =  self else {
                return
            }
            
            if self.table.isEditing{
                return
            }
            
            self.table.deselectRow(at: indexPath, animated: true)
            let mode = self.datas[indexPath.row]
            
            let JobDetail =  JobDetailViewController()
            JobDetail.job = (mode.jobId!, .intern)
            self.navigationController?.pushViewController(JobDetail, animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.refreshHeader.beginRefreshing()
    }
}

extension InternJobCollectedVC: UITableViewDelegate{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return datas.count
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: jobCollectedCell.identity(), for: indexPath) as! jobCollectedCell
//        let job =  datas[indexPath.row]
//
//        cell.mode = job
//        //cell.useCellFrameCache(with: indexPath, tableView: tableView)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let job = datas[indexPath.row]
        return  tableView.cellHeight(for: indexPath, model: job, keyPath: "mode", cellClass: jobCollectedCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.isEditing{
//            return
//        }
//
//        let mode = datas[indexPath.row]
//
//        let JobDetail =  JobDetailViewController()
//        JobDetail.job = (mode.id!, mode.kind ?? .none)
//        //JobDetail.kind = (id:  mode.id!, type: mode.kind!)
//        self.navigationController?.pushViewController(JobDetail, animated: true)
//
//
//    }
    

    
    
}


extension InternJobCollectedVC{
    
    private func operation(_ sender: Notification){
        let info = sender.userInfo as? [String: Any]
        // 添加数据
        if let mode = info?["mode"] as? CollectedInternJobModel{
            self.datas.insert(mode, at: 0)
            self.vm.collectedInternJobs.accept(self.datas)
            return
        }
        // 删除数据
        if let mode = info?["remove"] as? CollectedInternJobModel{
            var targetIndex = -1
            for (index, item) in self.datas.enumerated(){
                if item.jobId! == mode.jobId!{
                    targetIndex = index
                    break
                }
            }
            if targetIndex >= 0 {
                self.datas.remove(at: targetIndex)
                self.vm.collectedInternJobs.accept(self.datas)
            }
            
            return
        }
        
        
        if let action = info?["action"] as? String{
            if action == "edit"{
                self.table.setEditing(true, animated: false)
            }else if action == "cancel"{
                self.table.setEditing(false, animated: false)
            }else if action == "selectAll"{
                for index in 0..<datas.count{
                    self.table.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .bottom)
                }
                
            }else if action == "unselect"{
                self.table.selectRow(at: nil, animated: false, scrollPosition: .top)
            }else if action == "delete"{
                if let selected = self.table.indexPathsForSelectedRows{
                    var deletedRows:[Int] = []
                    var jids:[String] = []
                    selected.forEach { [weak self] indexPath in
                        deletedRows.append(indexPath.row)
                        if let id = self?.datas[indexPath.row].jobId{
                            jids.append(id)
                        }
                    }
                    
                    // 请求服务器 TODO
                    // 扩展 批量删除元素
                    self.vm.unCollectedJobs(type: .intern, ids: jids).subscribe(onNext: { [weak self] (res) in
                        guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                            self?.table.showToast(title: "删除失败", customImage: nil, mode: .text)
                            return
                        }
                        guard let `self` = self else {
                            return
                        }
                        self.datas.remove(indexes: deletedRows)
                        self.vm.collectedInternJobs.accept(self.datas)
                        
                        
                    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                    
                }
            }
        }
        
    }
}

//extension InternJobCollectedVC{
//    private func loadData(){
//
//        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
//            Thread.sleep(forTimeInterval: 1)
//            for _ in 0..<10{
//
//                if let data = Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":true,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000]){
//                    self?.datas.append(data)
//
//                }
//
//            }
//
//            for _ in 0..<10{
//                 self?.datas.append(Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":true,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"hr":["userID":"dqwd","name":"我是hr","position":"HRBP","ontime": Date().timeIntervalSince1970 - TimeInterval(6514),"icon": #imageLiteral(resourceName: "jing").toBase64String()],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"graduate","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000])!)
//            }
//
//
//
//            DispatchQueue.main.async {
//
//                self?.didFinishloadData()
//            }
//        }
//
//    }
//}






@objcMembers fileprivate class jobCollectedCell: UITableViewCell {
    
    
    private lazy var icon:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    
    private lazy var companyName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textAlignment = .left
        return name
    }()
    
    private lazy var positionName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        name.font = UIFont.systemFont(ofSize: 14)
        name.textAlignment = .left
        return name
    }()

    
//    private lazy var jobtype:UILabel = {
//        let name = UILabel()
//        name.setSingleLineAutoResizeWithMaxWidth(100)
//        name.font = UIFont.systemFont(ofSize: 12)
//        name.textAlignment = .left
//        name.textColor = UIColor.lightGray
//        return name
//    }()
    
    // 时间
    private lazy var times:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(100)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.blue
        return name
    }()
    
    dynamic var mode:CollectedInternJobModel?{
        didSet{
         
            guard  let mode = mode  else {
                return
            }
            if let url = mode.iconUrl{
                self.icon.kf.setImage(with: Source.network(url), placeholder: UIImage.init(named: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                self.icon.image = #imageLiteral(resourceName: "ali")
            }
            self.companyName.text = mode.companyName
            self.positionName.text = mode.name
            //self.address.text = mode.addressStr
           // self.jobtype.text = " | " + mode.kind.rawValue
            self.times.text  = mode.createdTimeStr
            self.setupAutoHeight(withBottomViewsArray: [icon,  positionName], bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, companyName, positionName, times]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(45)?.heightIs(45)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = positionName.sd_layout().topSpaceToView(companyName,5)?.leftEqualToView(companyName)?.autoHeightRatio(0)
        _ = times.sd_layout().topEqualToView(companyName)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        companyName.setMaxNumberOfLinesToShow(1)
        positionName.setMaxNumberOfLinesToShow(1)
        //address.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "jobCollectedCell"
    }
    
    // MARK 区分cell 投递 和非
    
    
}

