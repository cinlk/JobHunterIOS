//
//  newVisitor.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh


class MyVisitor: BaseTableViewController {

    private var mode:[MyVisitors] = []
    private var vm: MessageViewModel = MessageViewModel.shared
    private lazy var dispose = DisposeBag.init()
    private lazy var req: HttpVisitorReq = HttpVisitorReq.init()
    
    
    private lazy var refreshHeader: MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.req.offset = 0
            self.vm.refreshVisitor.onNext(self.req)
        })
        
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        return h!
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.req.offset +=  self.req.limit
            self.vm.refreshVisitor.onNext(self.req)
        })
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        self.setViewMode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
    }
    
    
    override func setViews(){
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(VisitorCell.self, forCellReuseIdentifier: VisitorCell.identity())
        self.tableView.mj_header = refreshHeader
        self.tableView.mj_footer = refreshFooter
        
        super.setViews()
    }
    
    override func didFinishloadData(){
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    override func showError(){
       super.showError()
    }
    
    override func reload(){
        
    
        // 使用begin  refresh 不能触发加载 TODO
        self.req.offset = 0
        vm.refreshVisitor.onNext(self.req)
        //self.tables.mj_header.beginRefreshing()
        super.reload()
        
    }
    
    
    
    deinit {
        print("deinit myvisitor \(String.init(describing: self))")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.mode.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VisitorCell.identity(), for: indexPath) as? VisitorCell{
            cell.mode = mode[indexPath.row]
            return cell
        }
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height =  tableView.cellHeight(for: indexPath, model: mode[indexPath.row], keyPath: "mode", cellClass: VisitorCell.self, contentViewWidth: GlobalConfig.ScreenW)
        return height + 10
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = PublisherControllerView()
        vc.userID = mode[indexPath.row].recruiterId!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        // 更新该visitor 已经查看过
        self.vm.updateVisitor.accept((vc.userID ,GlobalUserInfo.shared.getId()!))
        mode[indexPath.row].checked = true
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        
        
    }
    
    

}


extension MyVisitor{
    
    
    private func setViewMode(){
        
        guard  let userId = GlobalUserInfo.shared.getId() else {
            return
        }
        
        self.errorView.tap.drive(onNext: {  [weak self] in
            self?.reload()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.vm.visitorRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { [weak self] (status) in
            guard let `self` = self else {
                return
            }
            switch status{
            case .endHeaderRefresh:
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
            case .endFooterRefresh:
                self.tableView.mj_footer.endRefreshing()
            case .NoMoreData:
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.endRefreshing()
                self.view.showToast(title: "err \(err)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "err \(err)", view: self.view)
            default:
                break
            }


            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
        self.vm.visitors.share().subscribe(onNext: { [weak self] (modes) in
            self?.mode = modes
            self?.didFinishloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        NotificationCenter.default.rx.notification(NotificationName.visitor, object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.tableView.mj_header.beginRefreshing()
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.req.userId = userId
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    
 
}
