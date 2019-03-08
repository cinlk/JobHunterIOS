//
//  CompanyCareerTalkVC.swift
//  internals
//
//  Created by ke.liang on 2018/6/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh


class CompanyCareerTalkVC: BaseViewController {

    internal var mode:CompanyModel?{
        didSet{
            guard let m = mode else {
                return
            }
            self.req.companyID = m.id ?? ""
        }
    }
    
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    internal lazy var table:UITableView = {
        let tb = UITableView()
        tb.backgroundColor = UIColor.viewBackColor()
        let hearder = UIView(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH))
        tb.tableHeaderView = hearder
        tb.tableFooterView = UIView()
        tb.contentInsetAdjustmentBehavior = .never
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        tb.rx.setDelegate(self).disposed(by: dispose)
        return tb
    }()

    
    private var headRefreshed:Bool = false
    
    //refresh table
    private lazy var  headRefresh:MJRefreshNormalHeader = { [weak self] in
        
        let h = MJRefreshNormalHeader.init {
            guard let s = self  else {
                return
            }
            s.req.setOffset(offset: 0)
            s.vm.companyRecruitMeetingRefesh.onNext(s.req)
        }
      
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.isHidden = true 
        return h!
    }()
    
    private lazy var  footRefresh:MJRefreshAutoNormalFooter = { [weak self] in
        let f = MJRefreshAutoNormalFooter.init {
            guard let s = self else {
                return
            }
            s.req.setOffset(offset: s.req.offset + s.req.limit)
            s.vm.companyRecruitMeetingRefesh.onNext(s.req)
        }
        f?.isRefreshingTitleHidden = true
        f?.stateLabel.isHidden = true
        return f!
    }()
    
    //rxSwift
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    private var req:CompanyRecruitMeetingFilterModel = CompanyRecruitMeetingFilterModel(JSON: [:])!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.headRefreshed == false{
            self.table.mj_header.beginRefreshing()
            self.headRefreshed = true
        }
    }
    
    override func setViews() {
        
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.topEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hiddenViews.append(table)
        
        self.table.mj_header = headRefresh
        self.table.mj_footer = footRefresh
        
        super.setViews()
        
        
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
    }
    override func reload() {
        super.reload()
        self.req.setOffset(offset: 0)
        self.vm.companyRecruitMeetingRefesh.onNext(self.req)
    }
}

extension CompanyCareerTalkVC {
    
    private func setViewModel(){
        
        self.errorView.tap.asDriver().drive(onNext: { _ in
            self.reload()
        }).disposed(by: self.dispose)
        //
        
        self.vm.companyRecruitMeetingRes.asDriver(onErrorJustReturn: []).drive(self.table.rx.items(cellIdentifier: CareerTalkCell.identity(), cellType: CareerTalkCell.self)){ (row, mode, cell) in
            mode.companyName = self.mode?.name
            cell.mode = mode
            
        }.disposed(by: self.dispose)
        
        
        
        self.vm.companyRecruitMeetingRefeshStatus.share().subscribe(onNext: { (status) in
            switch status{
            case .endHeaderRefresh:
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.resetNoMoreData()
                self.didFinishloadData()
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.view.showToast(title: "err \(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "err \(err)", view: self.view)
                self.showError()
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()
            default:
                break
            }
            
        }).disposed(by: dispose)
        
        //table
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.vm.companyRecruitMeetingRes.value[idx.row]
            let show = CareerTalkShowViewController()
            show.hidesBottomBarWhenPushed = true
            show.meetingID = mode.meetingID ?? ""
            self.navigationController?.pushViewController(show, animated: true)
        }).disposed(by: dispose)
        
    }
}

extension CompanyCareerTalkVC: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.vm.companyRecruitMeetingRes.value[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}


extension CompanyCareerTalkVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        offsetY > 0 ? delegate?.scrollUp(view: self.table, height: offsetY) : delegate?.scrollUp(view: self.table, height: 0)
    }
}

