//
//  DashboardViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import ObjectMapper
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh
import MBProgressHUD
import Kingfisher


fileprivate let tableBottomInset:CGFloat = 50
fileprivate let tableViewH:CGFloat = 200
//fileprivate let JobFiledH:CGFloat = 80
//fileprivate let ColumnH:CGFloat = 140
fileprivate let nearBy = "周边"

//  主页面板块
class DashboardViewController: BaseViewController, UISearchControllerDelegate, UITableViewDelegate{
    
    @IBOutlet weak var tables: UITableView!
    
    //scrollview  偏移值
    //private var marginTop:CGFloat = 0
    private var startContentOffsetX:CGFloat = 0
    private var EndContentOffsetX:CGFloat = 0
    private var WillEndContentOffsetX:CGFloat = 0
    
    
    // 搜索控制控件
    private lazy var searchController:BaseSearchViewController? = {
        let sc = BaseSearchViewController.init(searchResultsController: SearchResultController())
        sc.delegate = self
        sc.searchType = .company
        //sc.popMenuView.datas = [.onlineApply, .graduate, .intern, .meeting, .company]
        sc.searchField.addSubview(self.nearBtn)
        
        _ = self.nearBtn.sd_layout()?.leftSpaceToView(sc.searchField,5)?.centerYEqualToView(sc.searchField)?.widthIs(60)?.heightRatioToView(sc.searchField,1)
    
        return sc
    }()
    
    //
    private var presentSearchControllFlag:Bool = false {
        willSet{
            self.searchController?.setSearchBar(open: newValue)
            nearBtn.isHidden  = newValue
            self.navigationController?.navigationBar.settranslucent(!newValue)
            self.tabBarController?.tabBar.isHidden = newValue
            (self.navigationController as? DashboardNavigationVC)?.currentStyle =  newValue ? .default : .lightContent
            
        }
    }
    // 附近职位btn
    private lazy var  nearBtn:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.zero)
        
        btn.semanticContentAttribute = .forceLeftToRight
        btn.setImage(#imageLiteral(resourceName: "nearby").changesize(size: CGSize.init(width: 20, height: 20),
            renderMode: UIImage.RenderingMode.alwaysOriginal), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "nearby").changesize(size: CGSize.init(width: 20, height: 20), renderMode:
            UIImage.RenderingMode.alwaysOriginal), for: .highlighted)

        
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.setTitle(nearBy, for: .normal)
        btn.contentMode = .center
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.clear
        
        return btn
    }()
 
 
    //导航栏遮挡背景view，随着滑动透明度可变
    private lazy  var navigationView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH))
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    // 轮播图view
    private lazy var imagescroller:ImageScrollerView = { [unowned self] in
        let imagescroller =  ImageScrollerView(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableViewH))
        imagescroller.delegate = self
        return imagescroller
    }()
    
    
    // 包裹searchbar 的view, 来限制高度，不然navibar 自适应高度为56
    private lazy var wrapBar:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.searchBarH))
        v.backgroundColor = UIColor.clear
        v.addSubview(self.searchController?.searchBar ?? UIView())
        return v
    }()
    
    
    
    
//    // 搜索框外部view，滑动影藏搜索框
//    private lazy var searchBarContainer:UIView = {
//        // 搜索框
//        let searchBarContainer = UIView(frame: CGRect(x: 0, y:0, width: GlobalConfig.ScreenW, height: SEARCH_BAR_H))
//        searchBarContainer.backgroundColor = UIColor.clear
//        return searchBarContainer
//
//    }()
    
    
    // 轮播图数据
//      private var rotateText:[String] = []
    
    // rxswift
    private let disposebag = DisposeBag.init()
    // viewModel
    private var vm:MainPageViewMode!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        // viewmodel
        self.loadViewModel()
        
        self.tableRefresh()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.view.insertSubview(navigationView, at: 1)
        //print("root viewController", UIApplication.shared.keyWindow?.rootViewController)
 
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
        
            super.viewWillLayoutSubviews()
        
            // offset 自动调整
            if #available(iOS 11.0, *) {
                self.tables.contentInsetAdjustmentBehavior = .never
               // self.imagescroller.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        
           _ = self.searchController?.searchBar.sd_layout()?.topEqualToView(wrapBar)?.bottomEqualToView(wrapBar)?.leftEqualToView(wrapBar)?.rightEqualToView(wrapBar)
            self.wrapBar.layoutSubviews()
            self.searchController?.searchField.layer.cornerRadius = self.searchController!.searchBar.height/2
        
//        _ =  searchController?.searchBar.sd_layout().leftSpaceToView(searchBarContainer,0)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationView.removeFromSuperview()
 
    }
    
  
    
    override func setViews(){
        
        // MARK 切换到其他tab 在回来也会影藏tabbar !
        //self.hidesBottomBarWhenPushed = true
        /***** table *****/
        // 分类职位 和  热门板块
        self.tables.register(MainColumnistCell.self, forCellReuseIdentifier: MainColumnistCell.identity())
        // 滚到文章
        self.tables.register(ScrollerNewsCell.self, forCellReuseIdentifier: ScrollerNewsCell.identitiy())
       
        // 热门宣讲会
        self.tables.register(RecruitmentMeetCell.self, forCellReuseIdentifier: RecruitmentMeetCell.identity())
        // 热门网申
        self.tables.register(ApplyOnlineCell.self, forCellReuseIdentifier: ApplyOnlineCell.identity())
        
        // 推荐职位
        self.tables.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        // 描述cell
        self.tables.register(SectionCellView.self, forCellReuseIdentifier: SectionCellView.identity())
        
        
        
        //self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        self.tables.tableHeaderView  = imagescroller
        // page 放这里
        imagescroller.setPagePosition(view: self.tables)
        
        
        //self.tables.insertSubview(imagescroller.page, aboveSubview: self.tables.tableHeaderView!)
        self.tables.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableBottomInset, right: 0)
        self.tables.tableFooterView = UIView()
        self.tables.separatorStyle = .singleLine
        
        
        /***** search *****/
        // searchController 占时新的控制视图时，显示在当前视图上
        self.definesPresentationContext  = true
        
//        searchController = BaseSearchViewController.init(searchResultsController: searchResultController())
        
            
        // 主页搜索menu 选项
//        searchController?.popMenuView.datas =  [.onlineApply, .graduate, .intern, .meeting, .company]
//
//        searchController?.delegate =  self
//
//        searchController?.height = SEARCH_BAR_H
//        searchController?.searchType = .company
//
//        searchBarContainer.addSubview((searchController?.searchBar)!)
//
//
//        searchController?.searchField.addSubview(nearBtn)
        // 调整搜索框偏移
        //searchController?.searchBar.setPositionAdjustment(UIOffset.init(horizontal: nearBtn.width, vertical: 0), for: .search)
        
        //self.navigationItem.titleView = searchBarContainer
        
      
       
     
        self.navigationItem.titleView =  wrapBar
        
        if let sc = self.searchController?.searchBar{
            self.hiddenViews.append(sc)
        }
        self.hiddenViews.append(self.tables)
        //self.hiddenViews.append(searchBarContainer)
        
        
        super.setViews()
    }
    
    
    // 再次加载
    override func reload(){
        
        // 使用begin  refresh 不能触发加载 TODO
        vm.refreshData.onNext(true)
        //self.tables.mj_header.beginRefreshing()
        super.reload()
        
    }
    
    

    
    
}






//  搜索控件 代理
//extension DashboardViewController: UISearchControllerDelegate{
//
//    func willPresentSearchController(_ searchController: UISearchController) {
//
//        //self.searchController?.rx.willPresent
//
//        //self.searchController?.searchBar.setPositionAdjustment(UIOffset.init(horizontal: self.searchController?.chooseTypeBtn.frame.width ?? 60, vertical: 0), for: .search)
//
//        self.searchController?.setSearchBar(open: true)
//        nearBtn.isHidden  = true
//        self.navigationController?.navigationBar.settranslucent(false)
//        self.tabBarController?.tabBar.isHidden = true
//        (self.navigationController as? DashboardNavigationVC)?.currentStyle = .default
//
//    }
//
//    func didDismissSearchController(_ searchController: UISearchController) {
//
//        self.searchController?.setSearchBar(open: false)
//        self.navigationController?.navigationBar.settranslucent(true)
//        self.tabBarController?.tabBar.isHidden = false
//        nearBtn.isHidden  = false
//        // 调整搜索框偏移
//        //self.searchController?.searchBar.setPositionAdjustment(UIOffset.init(horizontal: nearBtn.width, vertical: 0), for: .search)
//
//        (self.navigationController as? DashboardNavigationVC)?.currentStyle = .lightContent
//
//    }
//
//}






// scroll
extension DashboardViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView  == self.tables{
            
//            if self.marginTop != scrollView.contentInset.top{
//                self.marginTop = scrollView.contentInset.top
//            }
//
            
            let offsetY = scrollView.contentOffset.y
           // let newoffsetY = offsetY + self.marginTop
            //向下滑动 newoffsetY 小于0
            //向上滑动 newoffsetY 大于0
            
            // searchcontiner 透明度
            if (offsetY > 0 && offsetY <= 64){
                (self.navigationController as? DashboardNavigationVC)?.currentStyle = .lightContent
                //self.searchBarContainer.alpha = 1
                self.searchController?.searchBar.alpha = 1
                
                self.navigationView.backgroundColor  = UIColor.init(r: 129, g: 129, b: 129, alpha: offsetY/64)
              
                
            }
            else if ( offsetY > 64){
                (self.navigationController as? DashboardNavigationVC)?.currentStyle = .default
                //self.navigationView.backgroundColor  = UIColor.init(r: 249, g: 249, b: 249, alpha: 1)
                self.navigationView.backgroundColor  = UIColor.init(r: 129, g: 129, b: 129, alpha: 1)

                
                
                
            }
            else {
                let apl = 1.0 -  (-offsetY / 64)
                
                self.searchController?.searchBar.alpha = apl < 0 ?  0 :   apl
//                if apl < 0{
//                     self.searchController?.searchBar.alpha = 0
//                    //self.searchBarContainer.alpha =  0
//                }else{
//                    self.searchController?.searchBar.alpha = apl
//                   // self.searchBarContainer.alpha =  apl
//                }
                
                self.navigationView.backgroundColor  = UIColor.clear
                
                
            }
            
//            if offsetY < 0 {
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.navigationView.alpha = 0
//                })
//            }else{
//                //(self.navigationController as? DashboardNavigationVC)?.currentStyle = .default
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.navigationView.alpha = 1
//                })
//            }
            
            
        }
        
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.imagescroller{
            startContentOffsetX = scrollView.contentOffset.x
            imagescroller.stopAutoScroller()
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.imagescroller{
            WillEndContentOffsetX = scrollView.contentOffset.x
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // MARK 判断滑动方向
        if (scrollView  == self.imagescroller) {
            EndContentOffsetX = scrollView.contentOffset.x
           
            //左移动
            if (EndContentOffsetX < WillEndContentOffsetX && WillEndContentOffsetX < startContentOffsetX){
                imagescroller.moveToLeft()
               
                
                //右移动
            }else if (EndContentOffsetX > WillEndContentOffsetX && WillEndContentOffsetX > startContentOffsetX){
              
                imagescroller.moveToRight()
            }
            
            imagescroller.startScroller()
            
        }
        
        
    }
    
    
    
}


// rx  table datasource
extension DashboardViewController{
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        default:
            return 10
        }
    }
    
    
    
    // cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return ScrollerNewsCell.cellheight()
        }
        
        if indexPath.section == 1 {
            return MainColumnistCell.cellHeight()
        }
        else if indexPath.section == 2{
            return MainColumnistCell.cellHeight() +  60
        }
        else if indexPath.section  == 3{
            
            return RecruitmentMeetCell.cellHeight()
        }
        else if indexPath.section == 4 {
            return ApplyOnlineCell.cellHeight()
        }
        else if indexPath.section == 5 {
            
            return  indexPath.row == 0 ? 30 : 75
        }
        return 0
    }
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<MultiSecontions>{
        
        ///RxTableViewSectionedAnimatedDataSource
        return RxTableViewSectionedReloadDataSource<MultiSecontions>.init(configureCell: { (dataSource, table, idxPath, _) -> UITableViewCell in
            // 推荐职位cell
            if idxPath.section == 5 && idxPath.row == 0 {
                if let cell = table.dequeueReusableCell(withIdentifier: SectionCellView.identity(), for: idxPath) as? SectionCellView{
                    cell.mode = "推荐职位"
                    cell.rightBtn.setTitle("我的订阅", for: .normal)
                    cell.SectionTitle.font = UIFont.systemFont(ofSize: 16)
                    
                    
                    cell.action = {
                        let subscribleView = subscribleItem()
                        //subscribleView.hidesBottomBarWhenPushed = true
                        
                        //self.navigationController?.pushViewController(subscribleView, animated: true)
                        self.navigateTo(vc: subscribleView)
                    }
                    cell.contentView.backgroundColor = UIColor.white
                    return cell
                }
            }
            
            switch dataSource[idxPath]{
            case let  .newItem(news):
                
                let cell:ScrollerNewsCell = table.dequeueReusableCell(withIdentifier: ScrollerNewsCell.identitiy()) as! ScrollerNewsCell
                cell.mode = news
            
                return cell
            // 特别职位
            case let .jobFieldItem(fields):
                
//                var res:[String:String] = [:]
//                fields.forEach({ f in
//                    res[f.ImageUrl ?? ""] = f.Title ?? ""
//                })
                
                let cell:MainColumnistCell = table.dequeueReusableCell(withIdentifier: MainColumnistCell.identity()) as! MainColumnistCell
                
                cell.hiddenTitleView()
                // cell self height  TODO
                //cell.setItems(width: GlobalConfig.ScreenW/4, height: JobFiledH, items: fields)
               cell.setItems(width: GlobalConfig.ScreenW/4, items: fields)
                
               cell.selectedItem = { (btn) in
                    let spe = SpecialJobVC.init(kind: btn.titleLabel?.text ?? "")
                    //spe.queryName = btn.titleLabel?.text
                    //spe.hidesBottomBarWhenPushed = true
                    //self.navigationController?.pushViewController(spe, animated: true)
                    self.navigateTo(vc: spe)
                }
                
                return cell
            case let .columnItem(columnes):
                
//                var res:[String:String] = [:]
//                columnes.forEach({ c in
//                    res[c.ImageUrl ?? ""] = c.Title ?? ""
//                })
                
                let cell:MainColumnistCell = table.dequeueReusableCell(withIdentifier: MainColumnistCell.identity()) as!
                MainColumnistCell
                
                //cell.setItems(width: GlobalConfig.ScreenW/3 - 20, height: ColumnH, items: columnes)
                cell.setItems(width: GlobalConfig.ScreenW/3 - 20, items: columnes)
                
                cell.selectedItem = { (btn) in
                    let web = BaseWebViewController()
                    web.mode = columnes[btn.tag].Link
                    //web.hidesBottomBarWhenPushed = true
                    //self.navigationController?.pushViewController(web, animated: true)
                    self.navigateTo(vc: web)
                    
                }
                
                return cell
            case let .recruimentMeet(list: meets):
                
                let cell = table.dequeueReusableCell(withIdentifier: RecruitmentMeetCell.identity()) as! RecruitmentMeetCell
               
                cell.mode = (title:"热门宣讲会",item:meets)
                // 查看所有热门宣讲会
                cell.selectedIndex = {
                    self.tabBarController?.selectedIndex = 1
                    //self.tabBarController?.viewControllers[1]
                    self.perform(#selector(self.moveToCareerTalk), with: nil, afterDelay: TimeInterval(0.5))
                   
                }
                // 查看具体的宣讲会
                cell.selectItem = { mode in
                    let talkShow = CareerTalkShowViewController()
                    talkShow.meetingID = mode.meetingID!
                    self.navigateTo(vc: talkShow)
                }
                
                
                return cell
            case let .applyonline(list: applys):
            
                let cell = table.dequeueReusableCell(withIdentifier: ApplyOnlineCell.identity()) as!  ApplyOnlineCell
                cell.mode = (title:"热门网申", items: applys)
                
               // cell.sel
                cell.selectedIndex = { name in
                    // 切换tab 的item
                    self.tabBarController?.selectedIndex = 1
                    self.perform(#selector(self.showOnlineApply), with: name, afterDelay: TimeInterval(0.5))
                }
                return cell
            //MARK  不显示 job 数据
            case let .campuseRecruite(jobs):
                
                let cell:CommonJobTableCell = table.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity()) as! CommonJobTableCell
                cell.showTag = true
                cell.mode =  jobs
                return cell
            }
            
        },
            titleForHeaderInSection: {
                dataSource ,index in
                let section = dataSource[index]
                return section.title
                
        }
        )
    }
    
}

extension DashboardViewController {
    
    @objc  private func moveToCareerTalk(){
        if let nav = self.tabBarController?.viewControllers?[1] as?  UINavigationController, let target = nav.viewControllers[0] as? JobHomeVC{
            target.scrollToCareerTalk = true
        }
    }
    
    @objc private func showOnlineApply(name:String){
        
        if let nav = self.tabBarController?.viewControllers?[1] as?  UINavigationController, let target = nav.viewControllers[0] as? JobHomeVC{
          
            
            if let vc = target.children[0] as? OnlineApplyViewController{
                //d查找指定name的数据 TODO
                vc.search = name
            }
            target.scrollToOnlineAppy = true
            
            
        }
        
    }
}

// viewmodel
extension DashboardViewController{
    
    private func loadViewModel(){
        
        // 错误界面触发 重新加载数据
        self.errorView.tap.drive(onNext: { _ in
            self.reload()
        }).disposed(by: self.disposebag)
        
        // 周边按钮
        self.nearBtn.rx.tap.asDriver().drive(onNext: { _ in
            //  地址位置授权判断 TODO
            //let map = testMapViewController()
            //self.navigationController?.pushViewController(map, animated: true)
            let near = NearByViewController()
            
            //self.navigationController?.pushViewController(near, animated: true)
            self.navigateTo(vc: near)
//            if  let _ = SingletoneClass.shared.getAddress(){
//                let show = NearByViewController()
//                //show.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(show, animated: true)
//            }else{
//                UserLocationManager.shared.getLocation()
//            }
            
        }).disposed(by: self.disposebag)
        
        // 搜索vc 显示
       _ =  self.searchController?.rx.willPresent.takeUntil(self.rx.deallocated).subscribe(onNext: {
                self.presentSearchControllFlag = true
        })
       _ = self.searchController?.rx.didDismiss.takeUntil(self.rx.deallocated).subscribe(onNext: {
                self.presentSearchControllFlag = false
        })
        
        //
        vm = MainPageViewMode.init()
        
        self.tables.rx.setDelegate(self).disposed(by: disposebag)
        
        self.tables.rx.itemSelected.subscribe(onNext: { (indexpath) in
            self.tables.deselectRow(at: indexpath, animated: true)
            if indexpath.section == 0{
                
                //  新闻专栏标题  不超过4个 TODO
                if let cell = self.tables.cellForRow(at: indexpath) as? ScrollerNewsCell, let titles = cell.mode{
                    let news = MagazMainViewController()
                    news.titles = titles
                    //news
                    //self.navigationController?.pushViewController(news, animated: true)
                    self.navigateTo(vc: news)
                }
                
                
            }
            
            else if indexpath.section == 1{
                return
            }
            else if  let cell = self.tables.cellForRow(at: indexpath) as? CommonJobTableCell, let data = cell.mode{
                
                let detail = JobDetailViewController()
                detail.job = (data.jobId ?? "", data.kind ?? .none)
                //detail.hidesBottomBarWhenPushed = true
                //detail.jobID = jobModel.id!
                //detail.kind = (id: jobModel.id!, type: jobModel.kind!)
                //self.navigationController?.pushViewController(detail, animated: true)
                self.navigateTo(vc: detail)
            }
            
        }).disposed(by: disposebag)
        
        
        
        
        // section data bind to tableDatasource
        vm.sections.asDriver().drive(self.tables.rx.items(dataSource: self.dataSource())).disposed(by: disposebag)
        
        vm.refreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext: {
            [weak self] status in
            
            switch status{
            case .beginHeaderRefrsh:
                self?.tables.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                // 重置下拉刷新状态
                self?.tables.mj_footer.resetNoMoreData()
                //正常结束刷新后，显示界面
                self?.tables.mj_header.endRefreshing(completionBlock: {
                    self?.didFinishloadData()
                })
               
            
            case .beginFooterRefresh:
                self?.tables.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tables.mj_footer.endRefreshing()
            case .NoMoreData:
                self?.tables.mj_footer.endRefreshingWithNoMoreData()
            case .error:
                // 加载错误 TODO
                // 网络没信号 TODO
                self?.showError()
                
            default:
                break
            }
        }).disposed(by: disposebag)
        
        
    
        // 轮播图
        vm.banners.asDriver(onErrorJustReturn: []).debug().drive(onNext: { [unowned self]  (rotates) in
            //self.page.numberOfPages = rotates.count
            //RotateCategory
            var copy =  rotates as [ImageBanner]
            self.imagescroller.buildImages(banners: &copy)
//
//            let width = self.imagescroller.width
//            let height = self.imagescroller.height
            // 存储iamge 的 body
//            rotates.forEach{
//                self.rotateText.append($0.link ?? "")
//            }
            
            
//            if rotates.isEmpty{
//                return
//            }else{
//                _ = self.imagescroller.subviews.map{
//                    $0.removeFromSuperview()
//                }
//                // 前置最后一张图，后置第一张图，滑动时显示正确的图
//                let last = rotates[rotates.count - 1 ]
//                let first = rotates[0]
//                var  arrays = rotates
//                arrays.append(first)
//                arrays.insert(last, at: 0)
            
//                for (n,item) in arrays.enumerated(){
//
//                    guard  item.imageURL != nil, item.link != nil else { continue }
//
//
//                    let imageView = UIImageView(frame:CGRect(x: CGFloat(n) * width, y: 0, width: width, height: height))
//                    // 记录tag
//                    imageView.tag = n - 1
//                    imageView.isUserInteractionEnabled = true
//
//                    let guest = UITapGestureRecognizer()
//                    guest.addTarget(self, action: #selector(self.selectBanner(_:)))
//                    imageView.addGestureRecognizer(guest)
//
//
//                    //(TODO) get image from url
//                    let url = URL.init(string: item.imageURL ?? "")
//
//                    //imageView.image = UIImage.init(named: item.imageURL ?? ROTATE_IMA)
//                    imageView.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "banner3"), options: nil, progressBlock: nil, completionHandler: nil)
//                    imageView.contentMode = .scaleToFill
//                    imageView.clipsToBounds = true
//                    self.imagescroller.addSubview(imageView)
//                }
//
//                self.imagescroller.contentSize = CGSize.init(width: CGFloat(CGFloat(arrays.count) * width), height: height)
//                //第二张开始
//                self.imagescroller.contentOffset = CGPoint.init(x: self.view.frame.width, y: 0)
//
                //
                //self.imagescroller.createTimer()
//                self.imagescroller.startScroller()
//                self.imagescroller.pageCount = rotates.count
                
            }).disposed(by: disposebag)
        
    }
    
    
    private func navigateTo(vc:UIViewController){
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    // show details
//    private func showDetails(jobModel:CompuseRecruiteJobs){
//
//        // 传递jobid  查询job 具体信息
//        let detail = JobDetailViewController()
//        //detail.hidesBottomBarWhenPushed = true
//        //detail.jobID = jobModel.id!
//        //detail.kind = (id: jobModel.id!, type: jobModel.kind!)
//        self.navigationController?.pushViewController(detail, animated: true)
//
//    }
    
//    private func showNewsList(){
//        // 显示专栏 文章界面
//        let news = MagazMainViewController()
//        //news.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(news, animated: true)
//    }
//
}

extension DashboardViewController{
    
 
    
    private func tableRefresh(){
       
        self.tables.mj_header  = MJRefreshNormalHeader.init { [weak self] in
            
            self?.imagescroller.stopAutoScroller()
            self?.vm.refreshData.onNext(true)
            
        }
        
        
        
        (self.tables.mj_header as! MJRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("刷新结束", for: .idle)
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("开始刷新", for: .pulling)
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("刷新 ...", for: .refreshing)
        
        // 上拉刷新
        self.tables.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.vm.refreshData.onNext(false)
        })
        
        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("上拉刷新", for: .idle)
        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("刷新", for: .refreshing)
        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("没有数据", for: .noMoreData)
        
        // 开始加载数据
        self.tables.mj_header.beginRefreshing()
        
    }
}

// 点击banner
//extension DashboardViewController{
//
//    @objc private func selectBanner(_ tap:UITapGestureRecognizer){
//        guard  let image = tap.view as? UIImageView else {
//            return
//        }
//        if image.tag < rotateText.count && image.tag >= 0{
//            //
//            let webView = BaseWebViewController()
//            webView.mode = rotateText[image.tag]
//            webView.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(webView, animated: true)
//        }
//    }
//}



