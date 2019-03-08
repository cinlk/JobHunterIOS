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



fileprivate let dropTitles:[String] = [GlobalConfig.DropMenuTitle.city,
                                       GlobalConfig.DropMenuTitle.businessField]

fileprivate let jobHomeTitleH: CGFloat = JobHomeVC.titleHeight()

fileprivate let dropMenuHeigh:CGFloat = GlobalConfig.ScreenH - 240


class OnlineApplyViewController: UIViewController {
    // 网申数据
    private var localData:[OnlineApplyListModel] = []
    // 请求数据
    private var req:OnlineFilterReqModel = OnlineFilterReqModel(JSON: [:])!

    internal var search:String?{
        didSet{
            req.citys = []
            req.businessField = ""
            req.typeField = search ?? ""
            //self.vm.onlineApplyRefresh.onNext(req)
            self.table.mj_header.beginRefreshing()
            
        }
    }
    
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
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        // 覆盖指定高度
        city.passData = { citys in
            if self.req.setCitys(citys: citys){
                // 刷新数据
                self.table.mj_header.beginRefreshing()
            }
            
        }
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        return city
    }()
    
    // 行业分类
    internal lazy var industryKind:DropItemIndustrySectorView = {
        let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: dropMenuHeigh))
        indus.passData = { kind in
            if self.req.setBusinessField(b: kind){
                // 刷新数据
                self.table.mj_header.beginRefreshing()
            }
        }
        indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH + jobHomeTitleH)
        return indus
    }()
    
    

    // 条件选择下拉菜单view
    lazy var dropMenu: YNDropDownMenu = { [unowned self] in
          let menu = configDropMenu(items: [cityMenu,industryKind], titles: dropTitles, height: GlobalConfig.dropMenuViewHeight, originY: 0)
          menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
          return menu
    }()
    
    
    // refresh
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            guard let s = self else{
                return
            }
            s.req.setOffset(offset: 0)
            s.vm.onlineApplyRefresh.onNext(s.req)
            
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let s = self else{
                return
            }
            s.req.setOffset(offset: s.req.offset + Int64(s.req.limit))
            s.vm.onlineApplyRefresh.onNext(s.req)
            
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
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,GlobalConfig.dropMenuViewHeight)?.bottomEqualToView(self.view)
    }
    
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if localData.count > 0 {
            return
        }
        // 延迟来 判断是有是search 优先
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.search == nil{
                self.table.mj_header.beginRefreshing()
            }
        }
       
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
          }).disposed(by: dispose)
        
        
        self.vm.onlineApplyRes.share().bind(to: self.table.rx.items(cellIdentifier: OnlineApplyCell.identity(), cellType: OnlineApplyCell.self)) { (row, mode, cell) in
            cell.mode = mode
            
        }.disposed(by: dispose)
        
        
        self.vm.onlineApplyRefreshStatus.asDriver(onErrorJustReturn: PageRefreshStatus.none).drive(onNext: { (status) in
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
            
        }).disposed(by: dispose)
        
        // table check
        self.table.rx.itemSelected.subscribe(onNext: { (idx) in
            self.table.deselectRow(at: idx, animated: false)
            let mode = self.localData[idx.row]
            if  mode.outside ?? false{
             
                guard let urlLink = mode.link else {return}
                //跳转外部连接
                let wbView = BaseWebViewController()
                wbView.mode = urlLink.absoluteString
                wbView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(wbView, animated: true)
                
            }else{
                let show = OnlineApplyShowViewController()
                // 传递id
                guard let id = mode.onlineApplyID else {
                    return
                }
                show.uuid = id
                show.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(show, animated: true)
                show.hidesBottomBarWhenPushed = false
               
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




