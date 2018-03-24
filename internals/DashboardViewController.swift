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
import SVProgressHUD


fileprivate let tableSection = 3
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
class DashboardViewController: UIViewController{

    
    
    
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
    
    
    // 搜索控制视图
    private weak var searchController:baseSearchViewController!
    
    
    // 当前城市
    var currentCity = ""{
        didSet{
            self.refreshByCity(city: currentCity)
        }
    }
    
    //
    private var flag = false
    // MVVM 释放内存
    let disposebag = DisposeBag.init()
    
    
    //导航栏遮挡背景view
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
    
    // 搜索结果VC
    private lazy var searchResultVC: searchResultController = {
        let s = searchResultController()
        return s
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
        self.tables.mj_header.beginRefreshing()
        
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
    
    
}



extension DashboardViewController{
    
    private func setViews(){
        /***** table *****/
        // MARK 需要修改 category
        self.tables.register(MainPageCatagoryCell.self, forCellReuseIdentifier: MainPageCatagoryCell.identity())
        self.tables.register(MainPageRecommandCell.self, forCellReuseIdentifier: MainPageRecommandCell.identity())
        
        self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        self.tables.tableHeaderView  = imagescroller
        self.tables.insertSubview(page, aboveSubview: self.tables.tableHeaderView!)
        self.tables.contentInset = UIEdgeInsetsMake(0, 0, tableBottomInset, 0)
        
        /***** search *****/
        // search 切到到另一个view后，search bar不保留
        self.definesPresentationContext  = true
        
        searchController  = baseSearchViewController.init(searchResultsController: searchResultVC)
        // 选择城市回调
        searchController.chooseCity = { [weak self] in
            
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
            return 30
        default:
            return 10
        }
    }
    
    // cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return MainPageCatagoryCell.cellHeight()
        }
        else if indexPath.section == 1{
            return MainPageRecommandCell.cellHeight()
        }
        return  jobdetailCell.cellHeight()
    }
    
    

     func dataSource() -> RxTableViewSectionedReloadDataSource<MultiSecontions>{
        
        return RxTableViewSectionedReloadDataSource<MultiSecontions>.init(configureCell: { (dataSource, table, idxPath, _) -> UITableViewCell in
           
            switch dataSource[idxPath]{
            case let .catagoryItem(imageNames):
                
                let cell:MainPageCatagoryCell = table.dequeueReusableCell(withIdentifier: MainPageCatagoryCell.identity()) as! MainPageCatagoryCell
                cell.mode = imageNames
                cell.chooseItem = { (btn) in
                    //print(btn.titleLabel?.text)
                }
                return cell
            case let .recommandItem(imageNames):
                
                let cell:MainPageRecommandCell = table.dequeueReusableCell(withIdentifier: MainPageRecommandCell.identity()) as!
                MainPageRecommandCell
                cell.mode = imageNames
                
                cell.chooseItem = { (btn) in
                    
                    //print(btn.titleLabel?.text)
                }
                
                return cell
            case let .campuseRecruite(jobs):
                
                let cell:jobdetailCell = table.dequeueReusableCell(withIdentifier: jobdetailCell.identity()) as!
                jobdetailCell
                cell.mode = jobs
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
        //localData.shared.appendSearchHistories(value: searchBar.text!)
        //let vm = (self.searchController?.searchResultsController as! searchResultController).vm
        searchResultVC.vm.loadData.onNext("test")
        //vm?.loadData.onNext("test")
        SVProgressHUD.show(withStatus: "加载数据")
        
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
        let vm = mainPageViewMode.init(request: request)
        
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
                self?.tables.mj_footer.resetNoMoreData()
                self?.tables.mj_header.endRefreshing()
            case .beginFooterRefresh:
                self?.tables.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tables.mj_footer.endRefreshing()
            case .NoMoreData:
                self?.tables.mj_footer.endRefreshingWithNoMoreData()
                
            default:
                break
            }
        }).disposed(by: disposebag)
        
        
        
        self.tables.mj_header  = MJRefreshNormalHeader.init {
            vm.refreshData.onNext(true)
        }
        
        (self.tables.mj_header as! MJRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("下拉刷新", for: .idle)
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("开始刷新", for: .pulling)
        (self.tables.mj_header as! MJRefreshNormalHeader).setTitle("刷新 ...", for: .refreshing)
        
        self.tables.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            vm.refreshData.onNext(false)
        })
        
        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("上拉刷新", for: .idle)
        (self.tables.mj_footer as! MJRefreshAutoNormalFooter).setTitle("刷新", for: .refreshing)
        
        
        // 获取轮播数据和图
        _ = request.getImageBanners().debug().drive(onNext: { [unowned self ] (rotates) in
            self.page.numberOfPages = rotates.count
            let width = self.imagescroller.width
            let height = self.imagescroller.height
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
                    
                    let imageView = UIImageView(frame:CGRect(x: CGFloat(n) * width, y: 0, width: width, height: height))
                    //MARK get image from url
                    imageView.image = UIImage.init(named: item.imageURL ?? "banner1")
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    self.imagescroller.addSubview(imageView)
                }
                
                self.imagescroller.contentSize = CGSize.init(width: CGFloat(CGFloat(arrays.count) * width), height: height)
                //第二张开始
                self.imagescroller.contentOffset = CGPoint.init(x: self.view.frame.width, y: 0)
                
            }
            
            }, onCompleted: {
                self.creatTimer()
        }, onDisposed: nil)
        
        
    }
    
    // show details
    private func showDetails(jobModel:CompuseRecruiteJobs){
        
        // test jobid MARK
        let detail = JobDetailViewController()
        detail.mode = jobModel
        //
        //self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
}


