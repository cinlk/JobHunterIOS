//
//  InternJobsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import YNDropDownMenu



class InternJobsViewController: UIViewController {
    
    private var datas:[CompuseRecruiteJobs] = []
    
    
    
    private lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 200))
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + JobHomeVC.titlePageH)
        
        city.passData = { citys in
            self.table.mj_header.beginRefreshing()
        }
        
        return city
    }()

    private lazy var kind:DropCarrerClassifyView = {
        let k = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        k.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + JobHomeVC.titlePageH)
        k.passData = { s in
            self.table.mj_header.beginRefreshing()
            
        }
        return k
    }()
    
    private lazy var intern:DropInternCondtionView = {
        let intern = DropInternCondtionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 200))
        intern.backGroundBtn.frame =  CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + JobHomeVC.titlePageH)
        intern.passData = {  condition in
            self.table.mj_header.beginRefreshing()
        }
        return intern
    }()
    
    
    lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: DROP_MENU_H), dropDownViews: [cityMenu,kind,intern], dropDownViewTitles: ["城市","行业分类","实习条件"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        
        menu.addSwipeGestureToBlurView()
        return menu
        
        
    }()
    
    
    private lazy var table:UITableView = {
        let table = UITableView()
        
        table.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        table.tableFooterView = UIView()
        table.rx.setDelegate(self).disposed(by: dispose)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return table
    }()
    
    //refresh
    
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            
            self?.vm.internRefresh.onNext(true)
            
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
              self?.vm.internRefresh.onNext(false)
            
        })
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
       
        // Do any additional setup after loading the view.
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.datas.count > 0{
            return
        }
        self.table.mj_header.beginRefreshing()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,DROP_MENU_H)?.bottomEqualToView(self.view)
        
    }
    
}



extension InternJobsViewController{
    
    
    private func  setViews(){
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        
    }
    
    private func setViewModel(){
        self.vm.internRes.share().subscribe(onNext: { (interns) in
            self.datas = interns
        }, onError: { (err) in
            self.datas = []
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        self.vm.internRes.share().catchError { (err) -> Observable<[CompuseRecruiteJobs]> in
            print("err \(err)")
            return Observable<[CompuseRecruiteJobs]>.just([])
            }.observeOn(MainScheduler.instance).bind(to: self.table.rx.items(cellIdentifier: CommonJobTableCell.identity(), cellType: CommonJobTableCell.self)){ (row, mode, cell) in
                cell.showTag = false
                cell.mode = mode
                
        }.disposed(by: dispose)
        
        
        self.vm.internRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { (status) in
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
        
        
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.datas[idx.row]
            let internJob = JobDetailViewController()
            internJob.uuid = mode.id!
            
            internJob.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(internJob, animated: true)
            
            
        }).disposed(by: dispose)
        
    }
}


extension InternJobsViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: ScreenW)
        
    }
    
}


