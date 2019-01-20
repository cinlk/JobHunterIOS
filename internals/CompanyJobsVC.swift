//
//  companyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

// 与companyMainVC 一致
fileprivate let sections:Int = 2
fileprivate let applyTag:String = "网申"

class CompanyJobsVC: BaseViewController {

    // 职位
    internal var companyMode: CompanyModel?

    // 界面初始进入 获取所有tags 的职位
    private lazy var allTags:[String] = []
    // 刷新当前的tag 职位
    private var currentTag:String = ""
    
    // tagClass table datasource
    private var tagDatas:[String:[Any]] = [:]
    
    private var hearRefreshed:Bool = false{
        didSet{
            self.joblistTable.mj_header.isHidden = hearRefreshed
            
        }
    }
    
    
    
    lazy var joblistTable:UITableView = {
        
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .singleLine
        //tb.bounces = false
        tb.contentInsetAdjustmentBehavior = .never
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
        tb.register(companySimpleJobCell.self, forCellReuseIdentifier: companySimpleJobCell.identity())
        // 网申
        tb.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        return tb
    }()
    
    
    // table 滑动，其他table保持一致
    weak var delegate:CompanySubTableScrollDelegate?
    
    
    // mjrefresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        
        let h = MJRefreshNormalHeader.init { [weak self] in
            self?.requestBody.isPullDown = true
            self?.requestBody.tag = "all"
            self?.vm.combinationlistRefresh.onNext((self?.requestBody)!)
        }
        
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.requestBody.isPullDown = false
            self?.requestBody.tag = (self?.currentTag)!
           
            // 当前下拉的tag
            if let offset = self?.requestBody.tagsOffset[(self?.currentTag)!]{
                self?.requestBody.tagsOffset[(self?.currentTag)!] = offset + 1
            }
            
            self?.vm.combinationlistRefresh.onNext((self?.requestBody)!)

        })
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    
    private  lazy var requestBody:TagsDataItem = {
        return TagsDataItem(JSON: ["tag":"all","tag_offset":[:],"company_id":self.companyMode!.id,"is_pull_down":true])!
    }()
    
    
    //rxSwift
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        setViewModel()
        
        
        //self.loadData()
        //监听job 的tag 变化 刷新第二个table
       
        NotificationCenter.default.rx.notification(Notification.Name.init(rawValue: JOBTAG_NAME), object: nil).subscribe(onNext: { (notify) in
            
            if let name = notify.object as? String {
                if self.currentTag == name{
                    return
                }
                self.joblistTable.mj_footer.resetNoMoreData()
                self.currentTag = name
                self.joblistTable.reloadSections([1], animationStyle: .none)
            }
            
        }).disposed(by: dispose)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // view显示时头部只刷新一次
        if self.tagDatas.isEmpty && self.hearRefreshed == false{
            self.joblistTable.mj_header.beginRefreshing()
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = joblistTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    
    override func setViews() {
        
        self.view.addSubview(joblistTable)
        self.handleViews.append(joblistTable)
        super.setViews()
        self.joblistTable.mj_header = refreshHeader
        self.joblistTable.mj_footer = refreshFooter
        
        
    }
    
    override func didFinishloadData() {
        
        super.didFinishloadData()
        // 默认选中第一个tag 或网申
        self.joblistTable.reloadData()
    }
    
    override func showError() {
        super.showError()
        
    }
    
    override func reload() {
        super.reload()
    }

}



extension CompanyJobsVC{
    
    private func  setViewModel(){
        //
        self.vm.combinationlistRes.share().subscribe(onNext: { (mode) in
           
            if self.requestBody.isPullDown{
                if mode.tagJobs.isEmpty && mode.onlineAppys.isEmpty{
                    self.view.showToast(title: "no data", customImage: nil, mode: .text)
                    //showOnlyTextHub(message: "no data", view: self.view)
                    super.didFinishloadData()
                    // 显示没有数据界面
                    return
                }
                
                // job 的tag 和职位
                mode.tagJobs.forEach({ (key,jobs) in
                    
                    self.tagDatas[key] = jobs
                    if !self.allTags.contains(key){
                        self.allTags.append(key)
                        self.requestBody.tagsOffset[key] = 1
                    }
                })
                // 网申职位
                if mode.onlineAppys.count > 0{
                    self.tagDatas[applyTag] = mode.onlineAppys
                    if !self.allTags.contains(applyTag){
                        self.allTags.append(applyTag)
                        self.requestBody.tagsOffset[applyTag] = 1
                    }
                }
                // 默认选中第一个tag
                if self.allTags.count > 0{
                     self.currentTag = self.allTags[0]
                }
               
                
            // 获取某个 tag 的职位列表
            }else{
                
                if self.currentTag == applyTag{
                    self.tagDatas[applyTag] =  mode.onlineAppys
                }else{
                    if let  jobs = mode.tagJobs[self.currentTag]{
                        self.tagDatas[self.currentTag] =  jobs
                    }
                }
                
            }
        
            self.didFinishloadData()
            
            
            
        }, onError: { (err) in
            self.showError()
            print("quey list err \(err)")
            //super.didFinishloadData()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        self.vm.combinationlistRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
            case .endHeaderRefresh:
                self.joblistTable.mj_footer.resetNoMoreData()
                self.joblistTable.mj_header.endRefreshing()
                self.hearRefreshed = true
            case .endFooterRefresh:
                self.joblistTable.mj_footer.endRefreshing()
                
            case .NoMoreData:
                self.joblistTable.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                //self.showError()
                self.hearRefreshed = false
                print("refresh error \(err)")
                self.view.showToast(title: "获取数据失败\(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "获取数据失败\(err)", view: self.view)
                super.didFinishloadData()
                self.joblistTable.mj_header.endRefreshing()
                self.joblistTable.mj_footer.endRefreshing()
                
            default:
                break
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        //
        
    }
}



extension CompanyJobsVC:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.allTags.count > 0 ? sections: 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section ==  0 ?   (self.allTags.count > 0 ? 1 : 0) :  (self.tagDatas[self.currentTag]?.count  ?? 0)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section{
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
            cell.mode = self.allTags
            return cell
        case 1:
            if let mode = self.tagDatas[self.currentTag]?[indexPath.row] as? CompuseRecruiteJobs{
                let cell = tableView.dequeueReusableCell(withIdentifier: companySimpleJobCell.identity(), for: indexPath) as! companySimpleJobCell
                cell.mode = mode
                return cell
                
            }else if let mode = self.tagDatas[self.currentTag]?[indexPath.row] as? OnlineApplyModel{
                let cell = tableView.dequeueReusableCell(withIdentifier: OnlineApplyCell.identity(), for: indexPath) as!  OnlineApplyCell
                mode.isSimple = true 
                cell.mode = mode
                return cell
            }
           
        default:
            break
        }
        
        
        return UITableViewCell.init()
        
        
    }
    
    // section 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
       
        switch indexPath.section {
        case 0:
            return tableView.cellHeight(for: indexPath, model: self.allTags, keyPath: "mode", cellClass: JobTagsCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        case 1:
            return 55
        default:
            break
        }
        
        return 0
        
    }
    
    
    
    //查看job
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 1{
            
            if let mode =  self.tagDatas[self.currentTag]?[indexPath.row] as? CompuseRecruiteJobs{
                
                let job: JobDetailViewController = JobDetailViewController()
                job.uuid = mode.id!
                //job.kind = (id: mode.id!, type: mode.kind!)
                
                job.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(job, animated: true)
            }
            else if let mode = self.tagDatas[self.currentTag]?[indexPath.row] as? OnlineApplyModel{
                if mode.outer == true && mode.link != nil{
                    
                    //跳转外部连接
                    let wbView = BaseWebViewController()
                    wbView.mode = mode.link
                    wbView.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(wbView, animated: true)
                }else{
                    // 内部网申数据 
                    let show = OnlineApplyShowViewController()
                    // 传递id
                    show.uuid = "dqwdqwd"
                    //show.onlineApplyID = mode.id
                    show.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(show, animated: true)
                }
                
                
            }
        }
        
    }
    
    
}


extension CompanyJobsVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0{
            delegate?.scrollUp(view: self.joblistTable, height: offsetY)
        }else{
            delegate?.scrollUp(view: self.joblistTable, height: 0)
        }
    }
    
    
}
