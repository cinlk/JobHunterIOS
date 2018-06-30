//
//  searchResultController.swift
//  internals
//
//  Created by ke.liang on 2017/12/16.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh



class searchResultController: BaseViewController {

 internal lazy var table:UITableView = {
        let tb = UITableView.init()
        // 校招和实习的cell
        tb.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        tb.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        tb.register(CompanyItemCell.self, forCellReuseIdentifier: CompanyItemCell.identity())
        tb.register(listPostItemCell.self, forCellReuseIdentifier: listPostItemCell.identity())
    
        tb.tableFooterView = UIView.init()
        tb.delegate = self
        tb.dataSource = self
    
        return tb
    }()
    
    
   private let disposebag = DisposeBag.init()
    
    //var vm:searchViewModel!
    
    
    // MARK 保留搜索条件
    internal var currentKey = "搜索"
    internal var currentType:searchItem = .none
    internal var datas:[searchItem:[Any]] = [:]

    private lazy var httpServer = mainPageServer.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        
    }

    
    override func viewWillLayoutSubviews() {
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
  
    override func setViews() {
        self.view.addSubview(self.table)
        //self.searchModeView()
        self.handleViews.append(table)
        super.setViews()
    }
    
    override func showError() {
        super.showError()
    }
    
    override func reload() {
        super.reload()
        //
        //self.vm.loadData.onNext(currentKey)
    }
    
    override func didFinishloadData() {
        // 不让hub 从view 中移除
        hub.hide(animated: true)
        self.handleViews.forEach{
            $0.isHidden = false
        }
        errorView.isHidden = true
        
        self.table.reloadData()
        
        
        
        
    }
    



    
}



// table
extension searchResultController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return datas[currentType]?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentType {
        case .onlineApply:
            if   let cell = tableView.dequeueReusableCell(withIdentifier: OnlineApplyCell.identity(), for: indexPath) as?  OnlineApplyCell{
                cell.mode = datas[currentType]?[indexPath.row] as? OnlineApplyModel
                return cell
            }
        case .company:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CompanyItemCell.identity(), for: indexPath) as? CompanyItemCell{
                cell.mode = datas[currentType]?[indexPath.row] as? CompanyModel
                return cell
            }
        case .graduate, .intern:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as? CommonJobTableCell{
                cell.showTag = false
                cell.mode = datas[currentType]?[indexPath.row] as? CompuseRecruiteJobs
                return cell
            }
        case .meeting:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkCell.identity(), for: indexPath) as? CareerTalkCell{
                cell.mode = datas[currentType]?[indexPath.row] as? CareerTalkMeetingModel
                return cell
            }
        // 论坛帖子
        case .forum:
            if let cell = tableView.dequeueReusableCell(withIdentifier: listPostItemCell.identity(), for: indexPath) as? listPostItemCell{
                cell.mode = datas[currentType]?[indexPath.row] as? PostArticleModel
                return cell
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  currentType {
        case .onlineApply:
            if let mode = datas[currentType]?[indexPath.row] as? OnlineApplyModel{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: OnlineApplyCell.self, contentViewWidth: ScreenW)
            }
            
        case .company:
            if let mode = datas[currentType]?[indexPath.row] as? CompanyModel{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanyItemCell.self, contentViewWidth: ScreenW)
            }
        case .intern, .graduate:
            if let mode =  datas[currentType]?[indexPath.row] as? CompuseRecruiteJobs{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: ScreenW)
            }
        case .meeting:
            if let mode = datas[currentType]?[indexPath.row] as? CareerTalkMeetingModel{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: ScreenW)
            }
        case .forum:
            if let mode = datas[currentType]?[indexPath.row] as? PostArticleModel{
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: listPostItemCell.self, contentViewWidth: ScreenW)
            }
            
        default:
            break
        }
        
        return 0
    }
    
   
    
}



//extension searchResultController{
//
//    func searchModeView(){
//
//        self.vm = searchViewModel.init()
//
//        table.rx.setDelegate(self).disposed(by: disposebag)
//        let datasource =
//            RxTableViewSectionedReloadDataSource<searchJobSection>.init(configureCell: {
//                (_,tb,indexpath,element) in
//                let cell = tb.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexpath) as! CommonJobTableCell
//                cell.mode = element
//                return cell
//            })
//
//        //        datasource.titleForFooterInSection = {
//        //            dataSource, sectionindex in
//        //            return datasource[sectionindex].model
//        //        }
//
//        vm.section?.asDriver().drive(table.rx.items(dataSource: datasource)).disposed(by: disposebag)
//
//
//
//        table.mj_footer = MJRefreshAutoNormalFooter.init {
//            print("上拉")
//            self.vm.isRefresh.onNext(true)
//
//        }
//
//
//
//        vm.refreshStatus.asDriver().drive(onNext: { [weak self]  (state) in
//            switch state{
//            case .endFooterRefresh:
//                self?.table.mj_footer.endRefreshing()
//
//            case .NoMoreData:
//                self?.table.mj_footer.endRefreshingWithNoMoreData()
//            case .end:
//                self?.didFinishloadData()
//
//            case .error:
//                self?.showError()
//
//            default:
//
//                print("end ")
//            }
//            //SVProgressHUD.dismiss()
//
//        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
//
//    }
//
//}


extension searchResultController{
    open func startSearch(type: searchItem,word: String,  complete: ((_ bool:Bool)->())?) {
        // MARK test
       
        
        self.handleViews.append(table)
        super.setViews()
        
        self.currentKey = word
        
        self.currentType = type
        switch currentType {
        //如何 下拉刷新
        case .onlineApply:
            _ = httpServer.searchOnlineApply(word: word).subscribe(onNext: { [weak self] modes in
               
                self?.datas[type] = modes
                self?.didFinishloadData()
                complete?(true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)

        case .graduate, .intern:
            _ = httpServer.searchJobsByWord(word: word).subscribe(onNext: { [weak self]  jobs  in
                self?.datas[type] = jobs
                self?.didFinishloadData()
                complete?(true)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            
         
        case .company:
            _ = httpServer.searchCompany(word: word).subscribe(onNext: { [weak self] companys in
                self?.datas[type] = companys
                self?.didFinishloadData()
                complete?(true)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        case .meeting:
            
            _ = httpServer.searchCareerTalk(word: word).subscribe(onNext: { [weak self]  meeting in
                self?.datas[type] = meeting
                
                self?.didFinishloadData()
                complete?(true)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        case .forum:
            var res:[PostArticleModel] = []
            for _ in 0..<10{
                
                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwddqwdd","authorName":"我的名字","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":"jobs","thumbUP":2303,"reply":101]){
                    res.append(data)
                    
                }
            }
            self.datas[type] = res
            self.didFinishloadData()
            complete?(true)
        default:
            break
        }
        
        
        
        
       
       
        
    }
}
