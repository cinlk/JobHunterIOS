//
//  OnlineApplyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import RxCocoa
import RxSwift
import MJRefresh


class OnlineApplyViewController: UIViewController {
    // 网申数据
    private var localData:[OnlineApplyModel] = []
    
    private lazy var table:UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.viewBackColor()
        table.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        table.rx.setDelegate(self).disposed(by: dispose)
       
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return table
    }()
    
    
    internal lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 200))
        // 覆盖指定高度
        city.passData = { citys in
            
            
        }
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        return city
    }()
    
    // 行业分类
    internal lazy var industryKind:DropItemIndustrySectorView = {
        let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - 240))
        indus.passData = { kind in
            
        }
        indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + JobHomeVC.titlePageH)
        return indus
    }()
    
    
    // 条件选择下拉菜单view
    lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: DROP_MENU_H), dropDownViews: [cityMenu,industryKind], dropDownViewTitles: ["城市","行业领域"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        
        // 添加手势
        menu.addSwipeGestureToBlurView()
        
    
        return menu
        
    }()
    
    
    // refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            self?.vm.onlineApplyRefresh.onNext(true)
            
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.vm.onlineApplyRefresh.onNext(false)
            
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    
    // rxSwift
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
      
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,DROP_MENU_H)?.bottomEqualToView(self.view)
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if localData.count > 0{
            return
        }
        
        self.table.mj_header.beginRefreshing()
        
    }

}




extension OnlineApplyViewController{
    
    private func setViews() {
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        
    }
    
    private func setViewModel(){
        
          self.vm.onlineApplyRes.share().subscribe(onNext: { (modes) in
                self.localData = modes
          }, onError: { (err) in
            self.localData = []
          }).disposed(by: dispose)
        
        self.vm.onlineApplyRes.share().bind(to: self.table.rx.items(cellIdentifier: OnlineApplyCell.identity(), cellType: OnlineApplyCell.self)) { (row, mode, cell) in
            cell.mode = mode
            
        }.disposed(by: dispose)
        
        
        self.vm.onlineApplyRefreshStatus.asDriver(onErrorJustReturn: mainPageRefreshStatus.none).drive(onNext: { (status) in
            switch status{
                case .endFooterRefresh:
                    self.table.mj_footer.endRefreshing()
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.view.showToast(title: "get error \(err)", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "get error \(err)", view: self.view)
                self.table.mj_header.endRefreshing()
                self.table.mj_footer.endRefreshing()
            default:
                break
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        // table
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.localData[idx.row]
            if  mode.outer{
                guard let urlLink = mode.link else {return}
                //跳转外部连接
                let wbView = BaseWebViewController()
                wbView.mode = urlLink
                wbView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(wbView, animated: true)
                
            }else{
                let show = OnlineApplyShowViewController()
                // 传递id
                guard let id = mode.id else {
                    return
                }
                show.uuid = id
                show.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(show, animated: true)
               
            }
            
        }).disposed(by: dispose)
        
        
        
    }
    
}


extension  OnlineApplyViewController:  UITableViewDelegate{


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mode = self.localData[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: OnlineApplyCell.self, contentViewWidth: GlobalConfig.ScreenW)
    
    }
    
    
}




