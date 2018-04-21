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



fileprivate let tableSection = 6
fileprivate let thresholds:CGFloat = -80
fileprivate let searchBarH:CGFloat = 30
fileprivate let tableBottomInset:CGFloat = 50
fileprivate let tableViewH:CGFloat = 180

//
protocol UISearchRecordDelegatae : class {
    
    func showHistory()
    func listRecords(word:String)
    
}


//  主页面板块
class DashboardViewController: BaseViewController{

    
    
    
    @IBOutlet weak var tables: UITableView!
    
    //scrollview  偏移值
    private var marginTop:CGFloat = 0
    private var timer:Timer?
    private var startContentOffsetX:CGFloat = 0
    private var EndContentOffsetX:CGFloat = 0
    private var WillEndContentOffsetX:CGFloat = 0
    
    
    // 初始化 搜索内容
    private var searchString = ""
    private var searchLists:[Dictionary<String,String>] = []
    
    
    // 搜索控制组件
    private weak var searchController:baseSearchViewController?
    
    
    // 当前城市
    var currentCity = ""{
        didSet{
            self.refreshByCity(city: currentCity)
        }
    }
    
    // 轮播图数据
    private var rotateText:[String] = []
    
    //
    private var flag = false
    // MVVM 释放内存
    private let disposebag = DisposeBag.init()
    // viewModel
    private var vm:mainPageViewMode!
    

    
    //导航栏遮挡背景view，随着滑动透明度可变
    private lazy  var navigationView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    // 轮播图view
    private lazy var imagescroller:UIScrollView = { [unowned self] in
        
        let imagescroller =  UIScrollView()
        imagescroller.delegate = self
        imagescroller.translatesAutoresizingMaskIntoConstraints = false
        imagescroller.bounces = false
        imagescroller.isPagingEnabled = true
        imagescroller.scrollsToTop = false
        imagescroller.showsHorizontalScrollIndicator = false
        imagescroller.showsVerticalScrollIndicator = false
        imagescroller.isUserInteractionEnabled = true
        return imagescroller
    }()
    
    private lazy var  page:UIPageControl = {
        let page = UIPageControl.init()
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.blue
        return page
    }()
    
    
    // 搜索框外部view，滑动影藏搜索框
    private lazy var searchBarContainer:UIView = {
        // 搜索框
        let searchBarFrame = CGRect(x: 0, y:0, width: ScreenW, height: searchBarH)
        let searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.backgroundColor = UIColor.clear
        return searchBarContainer
        
    }()
    

    // 选择城市VC
    private lazy var cityVC:CityViewController = CityViewController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // init view
        self.setViews()
        // viewmodel
        self.loadViewModel()
        // 加载数据
        loadData()
        
        //self.hidesBottomBarWhenPushed = true 
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.view.insertSubview(navigationView, at: 1)
        
    }
    
    
    
    override func viewWillLayoutSubviews() {
        
            // 自动调整布局
            if #available(iOS 11.0, *) {
                self.tables.contentInsetAdjustmentBehavior = .never
                self.imagescroller.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        
        
        _ = self.tables.tableHeaderView?.sd_layout().leftEqualToView(self.tables)?.rightEqualToView(self.tables)?.heightIs(tableViewH)?.topEqualToView(self.tables)
        
        _ =  searchController?.searchBar.sd_layout().leftSpaceToView(searchBarContainer,10)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,10)
         // 这里设置page的
         page.frame = CGRect(x: (self.view.centerX - 60), y: self.imagescroller.frame.height-20, width: 120, height: 10)
        
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationView)
         
        
    }
    
    
    override func setViews(){
        /***** table *****/
        // MARK 需要修改 category
        self.tables.register(MainJobCategoryCell.self, forCellReuseIdentifier: MainJobCategoryCell.identity())
        self.tables.register(MainColumnistCell.self, forCellReuseIdentifier: MainColumnistCell.identity())
        
        // 热门公司
        self.tables.register(ScrollerNewsCell.self, forCellReuseIdentifier: ScrollerNewsCell.identitiy())
        // 推荐职位
        self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        self.tables.register(sectionCellView.self, forCellReuseIdentifier: sectionCellView.identity())
        
        // 热门宣讲会
        self.tables.register(recruitmentMeetCell.self, forCellReuseIdentifier: recruitmentMeetCell.identity())
        // 热门网申
        self.tables.register(applyOnlineCell.self, forCellReuseIdentifier: applyOnlineCell.identity())
        
        
        //self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        self.tables.tableHeaderView  = imagescroller
        self.tables.insertSubview(page, aboveSubview: self.tables.tableHeaderView!)
        self.tables.contentInset = UIEdgeInsetsMake(0, 0, tableBottomInset, 0)
        self.tables.tableFooterView = UIView()
        self.tables.separatorStyle = .none
        
        
        /***** search *****/
        // search 切到到另一个view后，search bar不保留
        self.definesPresentationContext  = true
        
        searchController  = baseSearchViewController.init(searchResultsController: searchResultController())
        // 选择城市回调
        searchController?.chooseCity = { [weak self] in
            
            //self?.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController((self?.cityVC)!, animated: true)
            //self?.hidesBottomBarWhenPushed = false
        }
        
        searchController?.searchResultsUpdater = self
        searchController?.delegate =  self
        searchController?.searchBar.delegate = self
        
        //searchController?.cityDelegate = self
        searchController?.height = searchBarH
        searchBarContainer.addSubview((searchController?.searchBar)!)
        
        self.navigationItem.titleView = searchBarContainer
        

        
        self.handleViews.append(tables)
        self.handleViews.append(searchBarContainer)
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



extension DashboardViewController{
    
    
    // 加载数据
    private func loadData(){
        //
        self.tables.mj_header.beginRefreshing()
        
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
        case 1:
            return 10
        case 2:
            return 10
        case 5:
            return 10
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            print(indexPath)
        }
    }
    
    // cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return ScrollerNewsCell.cellheight()
        }
        
        if indexPath.section == 1 {
            return MainJobCategoryCell.cellHeight()
        }
        else if indexPath.section == 2{
            return MainColumnistCell.cellHeight()
        }
        else if indexPath.section  == 3{
            // 动态计算？？？
            return 280
            //return recruitmentMeetCell.cellHeight()
        }
        else if indexPath.section == 4 {
            return  280
        }
        
        else if indexPath.section == 5 {
            
            return   indexPath.row == 0 ? 30 : 65
        }
        return 0
        //return  jobdetailCell.cellHeight()
    }
    
    

    

     func dataSource() -> RxTableViewSectionedReloadDataSource<MultiSecontions>{
        
        return RxTableViewSectionedReloadDataSource<MultiSecontions>.init(configureCell: { (dataSource, table, idxPath, _) -> UITableViewCell in
            if idxPath.section == 5 && idxPath.row == 0 {
                if let cell = table.dequeueReusableCell(withIdentifier: sectionCellView.identity(), for: idxPath) as? sectionCellView{
                    cell.mode = "推荐职位"
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
                //return UITableViewCell()
                
            case let .catagoryItem(imageNames):
                
                let cell:MainJobCategoryCell = table.dequeueReusableCell(withIdentifier: MainJobCategoryCell.identity()) as! MainJobCategoryCell
                cell.mode = imageNames
                cell.selectedItem = { (btn) in
                    let spe = SpecialJobVC()
                    spe.queryName = btn.titleLabel?.text
                    spe.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(spe, animated: true)
                }
                
                return cell
            case let .recommandItem(imageNames):
                
                let cell:MainColumnistCell = table.dequeueReusableCell(withIdentifier: MainColumnistCell.identity()) as!
                MainColumnistCell
                cell.mode = imageNames
                
                cell.selectedItem = { (btn) in
                    let web = baseWebViewController()
                    web.mode = btn.titleLabel?.text
                    web.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(web, animated: true)
                    
                }
                
                return cell
            case let .recruimentMeet(list: meets):
                let cell = table.dequeueReusableCell(withIdentifier: recruitmentMeetCell.identity()) as! recruitmentMeetCell
                cell.mode = (title:"热门宣讲会",item:meets)
               
                return cell
            case let .applyonline(list: applys):
                let cell = table.dequeueReusableCell(withIdentifier: applyOnlineCell.identity()) as!  applyOnlineCell
                cell.mode = (title:"热门网申", items: applys)
                return cell
            //MARK  不显示 job 数据
            case let .campuseRecruite(jobs):
                
                
                  let cell:jobdetailCell = table.dequeueReusableCell(withIdentifier: jobdetailCell.identity()) as! jobdetailCell
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

// 与searchbar 交换
extension DashboardViewController: UISearchResultsUpdating{
    
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
        if  let text = searchController.searchBar.text, !text.isEmpty{
            
            self.searchController?.serchRecordVC.listRecords(word: text)
        }else{
             self.searchController?.serchRecordVC.showHistory()
        }
        self.searchController?.showRecordView = true

        
    }
    // 搜索框结束输入，开始搜索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 显示搜索resultview
        guard let searchItem = searchBar.text else {
            return
        }
        guard !searchItem.isEmpty else {
            return
        }
        //self.searchController.serchRecordView.view.isHidden = true
        self.searchController?.showRecordView = false
        
        // 查找新的item 然后 重新加载table
        DBFactory.shared.getSearchDB().insertSearch(name: searchItem)
        searchController?.resultDelegate?.startSearch(word: "test")
        
    }
    
    
    
    
}


// searchController delegate
extension DashboardViewController: UISearchControllerDelegate{
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
        if let sc =  (searchController as? baseSearchViewController){
           
            sc.showRecordView = true
//            sc.serchRecordVC.HistoryTable.reloadData()
           
        }
        
        print("willPresentSearchController")
       
        
        self.navigationController?.navigationBar.settranslucent(false)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("didDismissSearchController")
        // 隐藏导航栏
        if searchController is baseSearchViewController{
            let sc =  (searchController as! baseSearchViewController)
 
            sc.showRecordView = false
            
        }

        self.navigationController?.navigationBar.settranslucent(true)
        self.tabBarController?.tabBar.isHidden = false
        

    }

    
}
// searchBar delegate
extension DashboardViewController: UISearchBarDelegate{
    

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    //文本发生改变
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text \(searchText)")
        // text 为空时 显示历史记录
        if searchText.isEmpty{
            self.searchController?.serchRecordVC.showHistory()
        }else{
            self.searchController?.serchRecordVC.listRecords(word: searchText)
        }
        // text 不为空 tableview 显示匹配搜索结果
        
    }
    
    
}



extension DashboardViewController{
    
    
    // 刷新城市
    private func refreshByCity(city:String){
        self.searchController?.changeCityTitle(title: city)
        //MARK refresh table
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
                self.searchBarContainer.alpha = 1
                self.navigationView.backgroundColor  = UIColor.init(r: 249, g: 249, b: 249, alpha: newoffsetY/64)
                    
                
            }
            else if ( newoffsetY > 64){
                self.navigationView.backgroundColor  = UIColor.navigationBarColor()
                
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
                UIView.animate(withDuration: 0.1, animations: {
                    self.navigationView.alpha = 1
                })
            }
            
        }
            
        else if scrollView  == self.imagescroller{
            
            
        }
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.imagescroller{
            startContentOffsetX = scrollView.contentOffset.x
            // 取消轮播
            self.timer?.invalidate()
            //self.timer = nil
            
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
            var animated = true
            //左移动
            if (EndContentOffsetX < WillEndContentOffsetX && WillEndContentOffsetX < startContentOffsetX){
                
                if self.page.currentPage == 0 {
                    animated = false
                    self.page.currentPage = self.page.numberOfPages - 1
                }else{
                    self.page.currentPage -=  1
                }
                
                imagescroller.setContentOffset(CGPoint.init(x: (CGFloat(page.currentPage + 1)) * self.view.size.width,y: 0), animated: animated)
                
                //右移动
            }else if (EndContentOffsetX > WillEndContentOffsetX && WillEndContentOffsetX > startContentOffsetX){
                if self.page.currentPage == self.page.numberOfPages-1{
                    animated = false
                    self.page.currentPage = 0
                    
                }else{
                    self.page.currentPage += 1
                    
                }
                imagescroller.setContentOffset(CGPoint.init(x: (CGFloat(page.currentPage + 1)) * self.view.size.width,y: 0), animated: animated)
                
            }
            //开启timer 轮播
            self.creatTimer()
        }
        
        
    }
    
    
    
    
    //创建轮播图定时器 MARK
    private func creatTimer() {
        // pass value in userinfo (Any)
        
        timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.change), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        
    }
    
    
    //创建定时器管理者
    
    @objc func change(timer:Timer) {
        //设置偏移量
        if page.currentPage == page.numberOfPages - 1 {
            page.currentPage = 0
        } else if page.currentPage < page.numberOfPages - 1 {
            page.currentPage += 1
        }
        imagescroller.setContentOffset(CGPoint.init(x: (CGFloat(page.currentPage + 1)) * self.view.size.width,y: 0), animated: true)
        
    }
    
}

// viewmodel
extension DashboardViewController{
    
    private func loadViewModel(){
        
        let request = mainPageServer.shareInstance
        
        vm = mainPageViewMode.init(request: request)
        
        let dataSource = self.dataSource()
        self.tables.rx.setDelegate(self).disposed(by: disposebag)
        
        self.tables.rx.itemSelected.subscribe(onNext: { (indexpath) in
            if indexpath.section == 1{
                return
            }
            
            self.tables.deselectRow(at: indexpath, animated: true)
            if  let cell = self.tables.cellForRow(at: indexpath) as? jobdetailCell, let data = cell.mode{
                
                self.showDetails(jobModel: data )
                
            }
            
        }, onError: { (error) in
            print("select item \(error)")
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        //view to VM
        
        
        
        // VM to view
        vm.sections.asDriver().drive(self.tables.rx.items(dataSource: dataSource)).disposed(by: disposebag)
        
        vm.refreshStatus.asObservable().subscribe(onNext: {
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
        
        
        
        self.tables.mj_header  = MJRefreshNormalHeader.init { [weak self] in
            print(" 下拉刷新 -----")
            self?.vm.refreshData.onNext(true)
        }
        
        (self.tables.mj_header as! MJRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("下拉刷新", for: .idle)
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("开始刷新", for: .pulling)
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("刷新 ...", for: .refreshing)
        
        // 上拉刷新
        self.tables.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.vm.refreshData.onNext(false)
        })

        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("上拉刷新", for: .idle)
        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("刷新", for: .refreshing)

        
        
        vm.driveBanner.debug().drive(onNext: { [unowned self]  (rotates) in
            self.page.numberOfPages = rotates.count
            let width = self.imagescroller.width
            let height = self.imagescroller.height
            // 存储iamge 的 body
            rotates.forEach{
                self.rotateText.append($0.body!)
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
                    
                    guard  item.imageURL != nil, item.body != nil else { continue }
                    
                    
                    let imageView = UIImageView(frame:CGRect(x: CGFloat(n) * width, y: 0, width: width, height: height))
                    // 记录tag
                    imageView.tag = n - 1
                    imageView.isUserInteractionEnabled = true
                    let guest = UITapGestureRecognizer()
                    guest.addTarget(self, action: #selector(self.selectBanner(_:)))
                    imageView.addGestureRecognizer(guest)
                    
                    
                    //MARK get image from url
                    imageView.image = UIImage.init(named: item.imageURL ?? "banner1")
                    imageView.contentMode = .scaleToFill
                    imageView.clipsToBounds = true
                    self.imagescroller.addSubview(imageView)
                }
                
                self.imagescroller.contentSize = CGSize.init(width: CGFloat(CGFloat(arrays.count) * width), height: height)
                //第二张开始
                self.imagescroller.contentOffset = CGPoint.init(x: self.view.frame.width, y: 0)
                
            }
            
            }, onCompleted: {
                self.creatTimer()
        }, onDisposed: nil).disposed(by: disposebag)
        // 获取轮播数据和图
    
        
        
    }
    
    // show details
    private func showDetails(jobModel:CompuseRecruiteJobs){
        
        // 传递jobid  查询job 具体信息
        let detail = JobDetailViewController()
        detail.jobID = jobModel.id!
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
}

// 点击banner
extension DashboardViewController{
    @objc private func selectBanner(_ tap:UITapGestureRecognizer){
        guard  let image = tap.view as? UIImageView else {
            return
        }
        if image.tag < rotateText.count && image.tag >= 0{
            print(rotateText[image.tag])
            //
            let webView = baseWebViewController()
            webView.mode = rotateText[image.tag]
            webView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webView, animated: true)
        }
    }
}

