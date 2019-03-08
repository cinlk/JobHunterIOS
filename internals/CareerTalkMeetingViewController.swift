//
//  CareerTalkMeetingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh
import YNDropDownMenu


fileprivate let dropMenuTitles:[String] = [GlobalConfig.DropMenuTitle.college,
                                           GlobalConfig.DropMenuTitle.businessField,
                                           GlobalConfig.DropMenuTitle.meetingTime]

fileprivate let dropMenuHeight:CGFloat = GlobalConfig.ScreenH - 240
fileprivate let jobHomeTitleH: CGFloat = JobHomeVC.titleHeight()


class CareerTalkMeetingViewController: UIViewController {

    
    private var datas:[CareerTalkMeetingListModel] = []
    private var req:CareerTalkFilterModel = CareerTalkFilterModel(JSON: [:])!
   
    
    internal lazy var industry:DropItemIndustrySectorView = {
        let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
        
        indus.passData = { b in
            if self.req.setBusinessField(b: b){
                self.table.mj_header.beginRefreshing()
            }
        }
        indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        
        return indus
        
    }()
    
    internal lazy var colleges: DropCollegeItemView = {
        let college = DropCollegeItemView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeight))
      
        college.passData = { c in
            if let first = c.first{
                if first.value.contains("不限"){
                    if self.req.setCitys(city: first.key){
                        self.table.mj_header.beginRefreshing()
                    }
                }else{
                    if self.req.setCollege(colleges:  first.value){
                        self.table.mj_header.beginRefreshing()
                    }
                }
            }
        }
        college.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        
        
        return college
    }()
    
    internal lazy var meetingTime:DropValidTimeView = {  [unowned self] in
        
        let v1 = DropValidTimeView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 45*3))
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        v1.passData = { t in
            if self.req.setTime(t: t){
                self.table.mj_header.beginRefreshing()
            }
        }
        return v1
    }()

    

    // 自定义条件选择下拉菜单view
    lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = configDropMenu(items: [colleges, industry, meetingTime], titles: dropMenuTitles, height: GlobalConfig.dropMenuViewHeight, originY: 0)
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        return menu
    }()
    
    
    private lazy var table:UITableView = {
        let tb = UITableView()
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        tb.tableFooterView = UIView()
        tb.tableHeaderView = UIView()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tb.rx.setDelegate(self).disposed(by: dispose)
        return tb
    }()
    
    
    
    
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        
        let h = MJRefreshNormalHeader.init { [weak self] in
            guard let s = self else {
                return
            }
            s.req.setOffset(offset: 0)
            s.vm.recruitMeetingRefresh.onNext(s.req)
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
            s.req.setOffset(offset: s.req.offset + Int64(s.req.limit))
            s.vm.recruitMeetingRefresh.onNext(s.req)
        })
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    //rxSwift
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,GlobalConfig.dropMenuViewHeight)?.bottomEqualToView(self.view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.datas.count > 0{
            return
        }
        
        self.table.mj_header.beginRefreshing()
        
    }

}


extension CareerTalkMeetingViewController{
    
    private func setViews(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        
        table.mj_header = refreshHeader
        table.mj_footer = refreshFooter
        
    }
    
    private func setViewModel(){
        
        
        //rxSwift
        self.vm.recruitMeetingRes.share().subscribe(onNext: { (meetings) in
            self.datas = meetings
        }).disposed(by: dispose)
        
        self.vm.recruitMeetingRes.share().bind(to: self.table.rx.items(cellIdentifier: CareerTalkCell.identity(), cellType: CareerTalkCell.self)){ (row, mode, cell) in
                cell.mode = mode
        }.disposed(by: dispose)
        
        
        self.vm.recruitMeetingRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
            switch status{
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
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
            
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        // table
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.datas[idx.row]
            let show = CareerTalkShowViewController()
            show.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(show, animated: true)
            show.meetingID = mode.meetingID ?? ""
            
            
        }).disposed(by: dispose)
    }
}


extension CareerTalkMeetingViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    
}


