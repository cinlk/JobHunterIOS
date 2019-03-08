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
import RxDataSources

fileprivate let firstTag = "全部"
class CompanyJobsVC: BaseViewController {

    // 职位
    internal var companyMode: CompanyModel?{
        didSet{
            guard  let mode = companyMode, var tags = mode.jobTags else {
                return
            }
            // 插入默认值
            tags.insert(firstTag, at: 0)
            self.companyTags.accept(tags)
            _ = self.requestBody.companyId = mode.id ?? ""
            _ = self.requestBody.setTag(t: tags.first!)
            
        }
    }

    
    private var firstRefreshead:Bool = false
    
    
    lazy var joblistTable:UITableView = {
        
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        
        //tb.dataSource = self
        tb.separatorStyle = .singleLine
        //tb.bounces = false
        tb.contentInsetAdjustmentBehavior = .never
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
        tb.register(CompanySimpleJobCell.self, forCellReuseIdentifier: CompanySimpleJobCell.identity())
        // 不应该放在这里 网申
        return tb
    }()
    
    
    // table 滑动，其他table保持一致
    weak var delegate:CompanySubTableScrollDelegate?
    
    
    // mjrefresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        
        let h = MJRefreshNormalHeader.init { [weak self] in
            //self?.requestBody.tag = ""
            guard let s = self else {
                return
            }
            s.requestBody.setOffset(offset: 0)
            s.vm.combinationlistRefresh.onNext(s.requestBody)
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.isHidden = true
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let s = self else {
                return
            }
            s.requestBody.setOffset(offset: s.requestBody.offset  + s.requestBody.limit)
            s.vm.combinationlistRefresh.onNext(s.requestBody)

        })
        f?.stateLabel.isHidden = true
        return f!
    }()
    
    
    
    
    private  lazy var requestBody:CompanyTagFilterModel =  CompanyTagFilterModel(JSON: [:])!
    
    //rxSwift
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    private var combine:Driver<[CompanyTagJobSectionModel]>!
    // company tags
    private let companyTags:BehaviorRelay<[String]> = BehaviorRelay<[String]>.init(value: [])
    private var dataSource:RxTableViewSectionedReloadDataSource<CompanyTagJobSectionModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        setViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstRefreshead == false{
            self.joblistTable.mj_header.beginRefreshing()
            self.firstRefreshead = true
        }
       
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = joblistTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    
    override func setViews() {
        
        self.view.addSubview(joblistTable)
        self.hiddenViews.append(joblistTable)
        super.setViews()
        self.joblistTable.mj_header = refreshHeader
        self.joblistTable.mj_footer = refreshFooter
        
    }
    
    override func reload() {
        super.reload()
        self.requestBody.setOffset(offset: 0)
        self.vm.combinationlistRefresh.onNext(self.requestBody)
    }

}



extension CompanyJobsVC{
    
    
    
    private func  setViewModel(){
        //
        (self.errorView as EorrorPageDelegate).tap.drive(onNext: {
            self.reload()
            
        }).disposed(by: self.dispose)
        
        
        self.dataSource = RxTableViewSectionedReloadDataSource<CompanyTagJobSectionModel>.init(configureCell: { (dataSource, table, indexPath, _) -> UITableViewCell in
            switch dataSource[indexPath]{
                case .TagsItem(let mode):
                    let cell = table.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
                    cell.mode = mode
                    return cell
                
                case .JobsItem(let mode):
                    let cell = table.dequeueReusableCell(withIdentifier: CompanySimpleJobCell.identity(), for: indexPath) as! CompanySimpleJobCell
                        cell.mode = mode
                        return cell
                        
            }
        })
        
        self.combine = Driver<[CompanyTagJobSectionModel]>.combineLatest(self.companyTags.asDriver(onErrorJustReturn: []), self.vm.combinationlistRes.asDriver(onErrorJustReturn: []), resultSelector: { (tags, modes)  in
            
            var sections:[CompanyTagJobSectionModel] = []
            if !tags.isEmpty{
                sections.append(CompanyTagJobSectionModel.TagsSection(title: "", items: [CompanyTagJobItem.TagsItem(mode: tags)]))
            }
            for (_, item) in modes.enumerated(){
                
                sections.append(CompanyTagJobSectionModel.JobsSection(title: "", items: [CompanyTagJobItem.JobsItem(mode: item)]))
            }
            
            return sections
        })
        // tag section(不变化的)  jobs section(变化的)
        
        self.combine.drive(self.joblistTable.rx.items(dataSource: self.dataSource)).disposed(by: self.dispose)
    
        
        NotificationCenter.default.rx.notification(NotificationName.jobTag, object: nil).subscribe(onNext: { (notify) in
            
            if let name = notify.object as? String {
                
                if self.requestBody.setTag(t: name){
                    //self.joblistTable.mj_header.beginRefreshing()
                    self.requestBody.setOffset(offset: 0)
                    self.vm.combinationlistRefresh.onNext(self.requestBody)
                    
                }
            }
            
        }).disposed(by: dispose)
        
        self.vm.combinationlistRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
                case .endHeaderRefresh:
                    self.joblistTable.mj_footer.resetNoMoreData()
                    self.joblistTable.mj_header.endRefreshing()
                   // self.hearRefreshed = true
                    self.didFinishloadData()
                case .endFooterRefresh:
                    self.joblistTable.mj_footer.endRefreshing()
                
                case .NoMoreData:
                    self.joblistTable.mj_footer.endRefreshingWithNoMoreData()
                case .error(let err):
                    //self.showError()
                    //self.hearRefreshed = false
                    
                    self.view.showToast(title: "获取数据失败\(err)", customImage: nil, mode: .text)
                    //showOnlyTextHub(message: "获取数据失败\(err)", view: self.view)
                    self.showError()
                    self.joblistTable.mj_header.endRefreshing()
                    self.joblistTable.mj_footer.endRefreshing()
                
                default:
                    break
            }
        }).disposed(by: dispose)
        
        self.joblistTable.rx.itemSelected.subscribe(onNext: { (indexPath) in
            
            self.joblistTable.deselectRow(at: indexPath, animated: true)
            switch self.dataSource[indexPath]{
                case .JobsItem(let mode):
                    let job: JobDetailViewController = JobDetailViewController()
                    job.job = (mode.id ?? "", mode.kind ?? .none)
                    //job.kind = (id: mode.id!, type: mode.kind!)
                    job.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(job, animated: true)
                default:
                    break
            }
        }).disposed(by: self.dispose)
        
    }
}



extension CompanyJobsVC:UITableViewDelegate{
    
    // section 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  self.dataSource[indexPath] {
        case .TagsItem(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobTagsCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .JobsItem(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanySimpleJobCell.self, contentViewWidth: GlobalConfig.ScreenW)
        }
        
    }
    
}


extension CompanyJobsVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        offsetY > 0 ? delegate?.scrollUp(view: self.joblistTable, height: offsetY) : delegate?.scrollUp(view: self.joblistTable, height: 0)
    }

}
