//
//  MeetingCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh

//fileprivate let notifiyName:String = "MeetingCollectedVC"


class MeetingCollectedVC: BaseViewController {

    
    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var offset = 0
    private let limit = 10
    
  
    private lazy var datas:[CareerTalkMeetingListModel] = []
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: self.view.frame)
        //tb.dataSource = self
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        //tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
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
            s.vm.collectedCareerTalkReq.onNext((s.offset, s.limit))
            
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
            s.vm.collectedCareerTalkReq.onNext((s.offset, s.limit))
            
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
        //self.loadData()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NotificationName.collecteItem[3], object: nil)
        
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
        //self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
       // self.loadData()
        self.offset = 0
        self.vm.collectedCareerTalkReq.onNext((self.offset, self.limit))
    }
    
   
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit MeetingCollectedVC \(self)")
    }
    
}



extension MeetingCollectedVC{
    private func setViewModel(){
        self.errorView.tap.asDriver().drive(onNext: { [weak self] in
            self?.reload()
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        NotificationCenter.default.rx.notification(NotificationName.collecteItem[3], object: nil).subscribe(onNext: {[weak self]  (notify) in
            self?.operation(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.collectedCareerTalk.share().subscribe(onNext: { [weak self] (modes) in
            self?.datas = modes
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.vm.collectedCareerTalk.share().bind(to: self.table.rx.items(cellIdentifier: CareerTalkCell.identity(), cellType: CareerTalkCell.self)){
            (row, mode, cell) in
            cell.mode = mode
        }.disposed(by: self.dispose)
        
        
        self.vm.careerTalkRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext:  { [weak self] (status) in
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
        
        self.table.rx.itemSelected.subscribe(onNext: {[weak self]  (indexPath) in
            guard let `self` = self else {
                return
            }
            
            if self.table.isEditing{
                return
            }
            self.table.deselectRow(at: indexPath, animated: true)

            let mode = self.datas[indexPath.row]
            let show = CareerTalkShowViewController()
            show.meetingID = mode.meetingID!
            self.navigationController?.pushViewController(show, animated: true)
            
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.refreshHeader.beginRefreshing()
        
    }
}

extension MeetingCollectedVC: UITableViewDelegate{
    
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkCell.identity(), for: indexPath) as! CareerTalkCell
//        let job =  datas[indexPath.row]
//
//        cell.mode = job
//        cell.useCellFrameCache(with: indexPath, tableView: tableView)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let job = datas[indexPath.row]
        return  tableView.cellHeight(for: indexPath, model: job, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.isEditing{
//            return
//        }
//
//        let mode = self.datas[indexPath.row]
//        let show = CareerTalkShowViewController()
//        show.meetingID = mode.meetingID ?? ""
//        self.navigationController?.pushViewController(show, animated: true)
//
//
//
//    }
    
    
    
}


extension MeetingCollectedVC{
    @objc private func operation(_ sender: Notification){
        let info = sender.userInfo as? [String: Any]
        
        if let mode = info?["mode"] as? CareerTalkMeetingListModel{
            self.datas.insert(mode, at: 0)
            self.vm.collectedCareerTalk.accept(self.datas)
            return
        }
        
        
        // 删除数据
        if let mode = info?["remove"] as? CareerTalkMeetingListModel{
            var targetIndex = -1
            for (index, item) in self.datas.enumerated(){
                if item.meetingID! == mode.meetingID!{
                    targetIndex = index
                    break
                }
            }
            if targetIndex >= 0 {
                self.datas.remove(at: targetIndex)
                self.vm.collectedCareerTalk.accept(self.datas)
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
                    var cids:[String] = []
                    selected.forEach { indexPath in
                        deletedRows.append(indexPath.row)
                        if let id = self.datas[indexPath.row].meetingID{
                            cids.append(id)
                        }
                    }
                    self.vm.unCollectedCareerTalk(ids: cids).subscribe(onNext: { [weak self] (res) in
                        guard let `self` = self else {
                            return
                        }
                        guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                             self.table.showToast(title: "删除失败", customImage: nil, mode: .text)
                             return
                        }
                        self.datas.remove(indexes: deletedRows)
                        self.vm.collectedCareerTalk.accept(self.datas)
                        
 
                    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                    
                }
            }
        }
        
    }
}


