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

    internal var mode:CompanyModel?
    
    private var datas:[CareerTalkMeetingModel] = []
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    internal lazy var table:UITableView = {
        let tb = UITableView()
        tb.backgroundColor = UIColor.viewBackColor()
        let hearder = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: CompanyMainVC.headerViewH))
        tb.tableHeaderView = hearder
        tb.tableFooterView = UIView()
        tb.contentInsetAdjustmentBehavior = .never
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        tb.rx.setDelegate(self).disposed(by: dispose)
        return tb
    }()

    
    private var headRefreshed:Bool = false{
        didSet{
            self.table.mj_header.isHidden = headRefreshed
        }
    }
    
    //refresh table
    private lazy var  headRefresh:MJRefreshNormalHeader = { [unowned self] in
        
        let h = MJRefreshNormalHeader.init {
            self.vm.companyRecruitMeetingRefesh.onNext((true,(self.mode?.id)!))
        }
        
        h?.lastUpdatedTimeLabel.isHidden = true
        return h!
    }()
    
    private lazy var  footRefresh:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init {
    
            self.vm.companyRecruitMeetingRefesh.onNext((false,(self.mode?.id)!))
        }
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        return f!
    }()
    
    //rxSwift
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.headRefreshed == false && self.datas.isEmpty{
            self.table.mj_header.beginRefreshing()
        }
    }
    
    override func setViews() {
        
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.topEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        self.handleViews.append(table)
        
        self.table.mj_header = headRefresh
        self.table.mj_footer = footRefresh
        
        super.setViews()
        
        
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
    }
    override func reload() {
        super.reload()
    }
}

extension CompanyCareerTalkVC {
    
    private func setViewModel(){
        
        //
        self.vm.recruitMeetingRes.asDriver(onErrorJustReturn: []).drive(onNext: { (meetings) in
            self.datas = meetings
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        self.vm.recruitMeetingRes.share().catchErrorJustReturn([]).bind(to: self.table.rx.items(cellIdentifier: CareerTalkCell.identity(), cellType: CareerTalkCell.self)){ (row, mode, cell) in
            cell.mode = mode
            
        }.disposed(by: dispose)
        
        
        self.vm.recruitMeetingRefreshStatus.share().subscribe(onNext: { (status) in
            switch status{
            case .endHeaderRefresh:
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.resetNoMoreData()
                self.headRefreshed = true
                self.didFinishloadData()
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.headRefreshed = false
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
            let mode = self.datas[idx.row]
            let show = CareerTalkShowViewController()
            show.hidesBottomBarWhenPushed = true
            show.meetingID = mode.id
            self.navigationController?.pushViewController(show, animated: true)
        }).disposed(by: dispose)
        
    }
}

extension CompanyCareerTalkVC: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: ScreenW)
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
        if offsetY > 0{
            delegate?.scrollUp(view: self.table, height: offsetY)
        }else{
            delegate?.scrollUp(view: self.table, height: 0)
        }
    }
}

