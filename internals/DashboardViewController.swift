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


fileprivate let tableSection = 6
fileprivate let thresholds:CGFloat = -80
fileprivate let tableBottomInset:CGFloat = 50
fileprivate let tableViewH:CGFloat = 200
fileprivate let JobFiledH:CGFloat = 80
fileprivate let ColumnH:CGFloat = 140



//  主页面板块
class DashboardViewController: BaseViewController{
    
    @IBOutlet weak var tables: UITableView!
    
    //scrollview  偏移值
    private var marginTop:CGFloat = 0
    private var startContentOffsetX:CGFloat = 0
    private var EndContentOffsetX:CGFloat = 0
    private var WillEndContentOffsetX:CGFloat = 0
    
    
    // 搜索控制控件
    private weak var searchController:baseSearchViewController?
    
    // 附近职位btn
    private lazy var  nearBtn:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.init(x: 3, y: 0, width: 60, height: SEARCH_BAR_H))
        
        btn.semanticContentAttribute = .forceLeftToRight
        btn.setImage(#imageLiteral(resourceName: "nearby").changesize(size: CGSize.init(width: 20, height: 20), renderMode: UIImage.RenderingMode.alwaysOriginal), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "nearby").changesize(size: CGSize.init(width: 20, height: 20), renderMode:
            UIImage.RenderingMode.alwaysOriginal), for: .highlighted)

        
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.setTitle(NEARBY, for: .normal)
        btn.contentMode = .center
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.clear
        
        btn.addTarget(self, action: #selector(showNear), for: .touchUpInside)
        
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
    
    
    
    // 搜索框外部view，滑动影藏搜索框
    private lazy var searchBarContainer:UIView = {
        // 搜索框
        let searchBarContainer = UIView(frame: CGRect(x: 0, y:0, width: GlobalConfig.ScreenW, height: SEARCH_BAR_H))
        searchBarContainer.backgroundColor = UIColor.clear
        return searchBarContainer
        
    }()
    
    
    // 轮播图数据
    private var rotateText:[String] = []
    
    // rxswift
    private let disposebag = DisposeBag.init()
    // viewModel
    private var vm:mainPageViewMode!
    
    
    
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
                self.imagescroller.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        
        _ =  searchController?.searchBar.sd_layout().leftSpaceToView(searchBarContainer,0)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationView.removeFromSuperview()
    }
    
    
    override func setViews(){
        /***** table *****/
        // MARK 需要修改 category
        self.tables.register(MainColumnistCell.self, forCellReuseIdentifier: MainColumnistCell.identity())
        // 滚到文章
        self.tables.register(ScrollerNewsCell.self, forCellReuseIdentifier: ScrollerNewsCell.identitiy())
       
        // 热门宣讲会
        self.tables.register(recruitmentMeetCell.self, forCellReuseIdentifier: recruitmentMeetCell.identity())
        // 热门网申
        self.tables.register(applyOnlineCell.self, forCellReuseIdentifier: applyOnlineCell.identity())
        
        // 推荐职位
        self.tables.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        self.tables.register(sectionCellView.self, forCellReuseIdentifier: sectionCellView.identity())
        
        
        
        //self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        self.tables.tableHeaderView  = imagescroller
        
        
        // page 放这里
        self.tables.insertSubview(imagescroller.page, aboveSubview: self.tables.tableHeaderView!)
        self.tables.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableBottomInset, right: 0)
        self.tables.tableFooterView = UIView()
        self.tables.separatorStyle = .singleLine
        
        /***** search *****/
        // searchController 占时新的控制视图时，显示在当前视图上
        self.definesPresentationContext  = true
        
        searchController  = baseSearchViewController.init(searchResultsController: searchResultController())
        
            
        // 主页搜索menu 选项
        searchController?.popMenuView.datas =  [.onlineApply, .graduate, .intern, .meeting, .company]
        
        //searchController?.searchResultsUpdater = self
        searchController?.delegate =  self
        
        searchController?.height = SEARCH_BAR_H
        searchController?.searchType = .company
        
        searchBarContainer.addSubview((searchController?.searchBar)!)
        
        
        searchController?.searchField.addSubview(nearBtn)
        // 调整搜索框偏移
        searchController?.searchBar.setPositionAdjustment(UIOffset.init(horizontal: nearBtn.width, vertical: 0), for: .search)
        
        self.navigationItem.titleView = searchBarContainer
        self.handleViews.append(tables)
        self.handleViews.append(searchBarContainer)
        
        errorView.reload = reload
        
        super.setViews()
    }
    
    
    override func didFinishloadData(){
        
        super.didFinishloadData()
    }
    
    override func showError(){
        super.showError()
    }
    // 再次加载
    override func reload(){
        //
        vm.refreshData.onNext(true)
        super.reload()
    }
    
}


extension DashboardViewController: UITableViewDelegate{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return  tableSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0.0
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
            return JobFiledH
        }
        else if indexPath.section == 2{
            return ColumnH
        }
        else if indexPath.section  == 3{
            
            return 280
        }
        else if indexPath.section == 4 {
            return  280
        }
        else if indexPath.section == 5 {
            
            return  indexPath.row == 0 ? 30 : 75
        }
        return 0
    }
}




//  搜索控件 代理
extension DashboardViewController: UISearchControllerDelegate{
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
        
        self.searchController?.searchBar.setPositionAdjustment(UIOffset.init(horizontal: self.searchController?.chooseTypeBtn.frame.width ?? 60, vertical: 0), for: .search)
        self.searchController?.setSearchBar(open: true)
        nearBtn.isHidden  = true
        self.navigationController?.navigationBar.settranslucent(false)
        self.tabBarController?.tabBar.isHidden = true
        (self.navigationController as? DashboardNavigationVC)?.currentStyle = .default
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        self.searchController?.setSearchBar(open: false)
        self.navigationController?.navigationBar.settranslucent(true)
        self.tabBarController?.tabBar.isHidden = false
        nearBtn.isHidden  = false
        // 调整搜索框偏移
        self.searchController?.searchBar.setPositionAdjustment(UIOffset.init(horizontal: nearBtn.width, vertical: 0), for: .search)
        
        (self.navigationController as? DashboardNavigationVC)?.currentStyle = .lightContent

    }
    
}



// 周边的数据
extension DashboardViewController{
    @objc private func showNear(){
        //TODO 判断定位是否能获取
        // 才跳转
        let show = NearByViewController()
        show.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(show, animated: true)
    }
}


// scroll
extension DashboardViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView  == self.tables{
            
            if self.marginTop != scrollView.contentInset.top{
                self.marginTop = scrollView.contentInset.top
            }
            
            let offsetY = scrollView.contentOffset.y
            let newoffsetY = offsetY + self.marginTop
            //向下滑动 newoffsetY 小于0
            //向上滑动 newoffsetY 大于0
            
            // searchcontiner 透明度
            if (newoffsetY >= 0 && newoffsetY <= 64){
                (self.navigationController as? DashboardNavigationVC)?.currentStyle = .lightContent
                self.searchBarContainer.alpha = 1
                self.navigationView.backgroundColor  = UIColor.init(r: 249, g: 249, b: 249, alpha: newoffsetY/64)
                    
                
            }
            else if ( newoffsetY > 64){
                (self.navigationController as? DashboardNavigationVC)?.currentStyle = .default
                self.navigationView.backgroundColor  = UIColor.init(r: 192, g: 192, b: 192)
                
            }
            else {
                let apl = 0.7 -  (-newoffsetY / 64)
                if apl < 0{
                    self.searchBarContainer.alpha =  0
                }else{
                    self.searchBarContainer.alpha =  apl
                }
                
                self.navigationView.backgroundColor  = UIColor.clear
                
            }
            if newoffsetY < 0 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.navigationView.alpha = 0
                })
            }else{
                //(self.navigationController as? DashboardNavigationVC)?.currentStyle = .default
                UIView.animate(withDuration: 0.1, animations: {
                    self.navigationView.alpha = 1
                })
            }
            
            
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
            
            imagescroller.createTimer()
            
        }
        
        
    }
    
    
    
}


// rx datasource
extension DashboardViewController{
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<MultiSecontions>{
        
        return RxTableViewSectionedReloadDataSource<MultiSecontions>.init(configureCell: { (dataSource, table, idxPath, _) -> UITableViewCell in
            // 推荐职位cell
            if idxPath.section == 5 && idxPath.row == 0 {
                if let cell = table.dequeueReusableCell(withIdentifier: sectionCellView.identity(), for: idxPath) as? sectionCellView{
                    cell.mode = "推荐职位"
                    cell.rightBtn.setTitle("我的订阅", for: .normal)
                    cell.SectionTitle.font = UIFont.systemFont(ofSize: 16)
                    
                    
                    cell.action = {
                        let subscribleView = subscribleItem()
                        subscribleView.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(subscribleView, animated: true)
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
                var res:[String:String] = [:]
                fields.forEach({ f in
                    res[f.ImageUrl ?? ""] = f.Title ?? ""
                })
                
                let cell:MainColumnistCell = table.dequeueReusableCell(withIdentifier: MainColumnistCell.identity()) as! MainColumnistCell
                
                cell.topViewH = 0
                cell.setItems(width: GlobalConfig.ScreenW/4, height: JobFiledH, items: res)
               
                
                cell.selectedItem = { (btn) in
                    let spe = SpecialJobVC()
                    spe.queryName = btn.titleLabel?.text
                    spe.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(spe, animated: true)
                }
                
                return cell
            case let .columnItem(columnes):
                
                var res:[String:String] = [:]
                columnes.forEach({ c in
                    res[c.ImageUrl ?? ""] = c.Title ?? ""
                })
                
                let cell:MainColumnistCell = table.dequeueReusableCell(withIdentifier: MainColumnistCell.identity()) as!
                MainColumnistCell
                
                cell.setItems(width: GlobalConfig.ScreenW/3 - 20, height: ColumnH, items: res)
                
                cell.selectedItem = { (btn) in
                    let web = BaseWebViewController()
                    web.mode = columnes[btn.tag].Link
                    web.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(web, animated: true)
                    
                }
                
                return cell
            case let .recruimentMeet(list: meets):
                
                let cell = table.dequeueReusableCell(withIdentifier: recruitmentMeetCell.identity()) as! recruitmentMeetCell
                cell.mode = (title:"热门宣讲会",item:meets)
                // 查看所有热门宣讲会
                cell.selectedIndex = {
                    self.tabBarController?.selectedIndex = 1
                    //self.tabBarController?.viewControllers[1]
                    if let nav = self.tabBarController?.viewControllers?[1] as?  UINavigationController, let target = nav.viewControllers[0] as? JobHomeVC{
                        target.scrollToCareerTalk = true
                    }
                    
                }
                // 查看具体的宣讲会
                cell.selectItem = { mode in
                    let talkShow = CareerTalkShowViewController()
                    talkShow.meetingID = mode.id
                    talkShow.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(talkShow, animated: true)
                    
                }
                
                
                return cell
            case let .applyonline(list: applys):
                
                let cell = table.dequeueReusableCell(withIdentifier: applyOnlineCell.identity()) as!  applyOnlineCell
                cell.mode = (title:"热门网申", items: applys)
                
                cell.selectedIndex = { name in
                    // 切换tab 的item
                    self.tabBarController?.selectedIndex = 1
                    if let nav = self.tabBarController?.viewControllers?[1] as?  UINavigationController, let target = nav.viewControllers[0] as? JobHomeVC{
                        
                        //perform(#selecto, with: <#T##Any?#>, afterDelay: <#T##TimeInterval#>)
                        // 登录jobhome 加载完后 才有chidlvc
                        target.scrollToOnlineAppy = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            // 查询某个行业的数据
                            
                            if !name.isEmpty, let vc = target.childVC[0] as? OnlineApplyViewController {
                                //vc.type = name
                            }
                        })
                        
                    }
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
// viewmodel
extension DashboardViewController{
    
    private func loadViewModel(){
        
        vm = mainPageViewMode.init()
        
        self.tables.rx.setDelegate(self).disposed(by: disposebag)
        
        self.tables.rx.itemSelected.subscribe(onNext: { (indexpath) in
            self.tables.deselectRow(at: indexpath, animated: true)
            if indexpath.section == 0{
                self.showNewsList()
            }
            
            else if indexpath.section == 1{
                return
            }
            else if  let cell = self.tables.cellForRow(at: indexpath) as? CommonJobTableCell, let data = cell.mode{
                self.showDetails(jobModel: data )
            }
            
        }, onError: { (error) in
            print("select item \(error)")
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
        
        
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
                self?.showError()
                
            default:
                break
            }
        }).disposed(by: disposebag)
        
        
    
        // 轮播图
        vm.banners.asDriver(onErrorJustReturn: []).debug().drive(onNext: { [unowned self]  (rotates) in
            //self.page.numberOfPages = rotates.count
            
            
            let width = self.imagescroller.width
            let height = self.imagescroller.height
            // 存储iamge 的 body
            rotates.forEach{
                self.rotateText.append($0.link ?? "")
            }
            
            
            if rotates.isEmpty{
                return
            }else{
                _ = self.imagescroller.subviews.map{
                    $0.removeFromSuperview()
                }
                // 前置最后一张图，后置第一张图，滑动时显示正确的图
                let last = rotates[rotates.count - 1 ]
                let first = rotates[0]
                var  arrays = rotates
                arrays.append(first)
                arrays.insert(last, at: 0)
                
                for (n,item) in arrays.enumerated(){
                    
                    guard  item.imageURL != nil, item.link != nil else { continue }
                    
                    
                    let imageView = UIImageView(frame:CGRect(x: CGFloat(n) * width, y: 0, width: width, height: height))
                    // 记录tag
                    imageView.tag = n - 1
                    imageView.isUserInteractionEnabled = true
                    let guest = UITapGestureRecognizer()
                    guest.addTarget(self, action: #selector(self.selectBanner(_:)))
                    imageView.addGestureRecognizer(guest)
                    
                    
                    //(TODO) get image from url
                    let url = URL.init(string: item.imageURL ?? "")
                    
                    //imageView.image = UIImage.init(named: item.imageURL ?? ROTATE_IMA)
                    imageView.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "banner3"), options: nil, progressBlock: nil, completionHandler: nil)
                    imageView.contentMode = .scaleToFill
                    imageView.clipsToBounds = true
                    self.imagescroller.addSubview(imageView)
                }
                
                self.imagescroller.contentSize = CGSize.init(width: CGFloat(CGFloat(arrays.count) * width), height: height)
                //第二张开始
                self.imagescroller.contentOffset = CGPoint.init(x: self.view.frame.width, y: 0)
                
                //
                self.imagescroller.createTimer()
                self.imagescroller.pageCount = rotates.count
                
            }
            
            }, onCompleted: {
               
        }, onDisposed: nil).disposed(by: disposebag)
        // 获取轮播数据和图
        
       
        // searchController rx
        self.searchController?.rx.willPresent.asDriver(onErrorJustReturn: ()).drive(onNext: {
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        

        
    }
    
    // show details
    private func showDetails(jobModel:CompuseRecruiteJobs){
        
        // 传递jobid  查询job 具体信息
        let detail = JobDetailViewController()
        detail.hidesBottomBarWhenPushed = true 
        //detail.jobID = jobModel.id!
        //detail.kind = (id: jobModel.id!, type: jobModel.kind!)
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    private func showNewsList(){
        // 显示专栏 文章界面
        let news = MagazMainViewController()
        news.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(news, animated: true)
    }
    
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
extension DashboardViewController{
    @objc private func selectBanner(_ tap:UITapGestureRecognizer){
        guard  let image = tap.view as? UIImageView else {
            return
        }
        if image.tag < rotateText.count && image.tag >= 0{
            //
            let webView = BaseWebViewController()
            webView.mode = rotateText[image.tag]
            webView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webView, animated: true)
        }
    }
}



