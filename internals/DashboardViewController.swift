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


private let tableSection = 3
private let thresholds:CGFloat = -80
private let searchBarH:CGFloat = 30
private let tableBottomInset:CGFloat = 50

protocol UISearchRecordDelegatae : class {
    
    func showHistory()
    func listRecords(word:String)
    
}


class DashboardViewController: UIViewController{

    
    @IBOutlet weak var tables: UITableView!
    
    var contentOffset:CGPoint = CGPoint(x: 0, y: 0)
    
    //scrollview  偏移值
    var marginTop:CGFloat = 0
    var timer:Timer?
    var startContentOffsetX:CGFloat = 0
    var EndContentOffsetX:CGFloat = 0
    var WillEndContentOffsetX:CGFloat = 0
    
    
    // 初始化 搜索内容
    var searchString = ""
    var searchLists:[Dictionary<String,String>] = []
    
    
    
    //  主页定位城市
    var dashLocateCity = "全国"{
        willSet{
            self.refreshByCity(city: newValue)
        }
    }
    
    //
    var flag = false
    let disposebag = DisposeBag.init()
    
    
    //导航栏 背景view
    lazy  var navigationView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        v.backgroundColor = UIColor.init(red: 0.667, green: 0.667, blue: 0.667, alpha: 0)
        return v
    }()
    
    lazy  var imagescroller:UIScrollView = { [unowned self] in
        // 轮播图
        let imagescroller =  UIScrollView()
        imagescroller.delegate = self
        // 解决navigation 页面跳转后，scrollview content x 偏移差
        imagescroller.translatesAutoresizingMaskIntoConstraints = false
        imagescroller.bounces = false
        imagescroller.isPagingEnabled = true
        imagescroller.scrollsToTop = false
        imagescroller.showsHorizontalScrollIndicator = false
        imagescroller.showsVerticalScrollIndicator = false
        imagescroller.isUserInteractionEnabled = true
        return imagescroller
    }()
    
    lazy var  page:UIPageControl = {
        let page = UIPageControl.init()
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.black
        return page
    }()
    
    // searchview
    private weak var searchController:baseSearchViewController?
    
    lazy var searchBarContainer:UIView = {
        // 搜索框
        let searchBarFrame = CGRect(x: 0, y:0, width: self.view.frame.width, height: searchBarH)
        let searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.backgroundColor = UIColor.clear
        return searchBarContainer
        
    }()
    
    
    weak var delegate:UISearchRecordDelegatae?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // init view
        self.setViews()
        // viewmodel
        self.loadViewModel()
        // 加载数据
        self.tables.mj_header.beginRefreshing()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets  = false
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.view.insertSubview(navigationView, at: 1)
        
        
    }
    
    
    
    override func viewWillLayoutSubviews() {
        
            // iso 11 设置位置偏移
            if #available(iOS 11.0, *) {
                self.tables.contentInsetAdjustmentBehavior = .never
                self.imagescroller.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
                
            }
        
        // 底部距离 50像素，保证滑动到底部cell
        self.tables.contentInset = UIEdgeInsetsMake(0, 0, tableBottomInset, 0)
        _ = self.tables.tableHeaderView?.sd_layout().leftEqualToView(self.tables)?.rightEqualToView(self.tables)?.heightIs(180)?.topEqualToView(self.tables)
        
        _ =  searchController?.searchBar.sd_layout().leftSpaceToView(searchBarContainer,10)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,10)
         // 这里设置page，imagescroller 的layout设置生效后
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
        self.tables.register(MainPageCatagoryCell.self, forCellReuseIdentifier: "catagory")
        self.tables.register(MainPageRecommandCell.self, forCellReuseIdentifier: "recommand")
        
        self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        self.tables.tableHeaderView  = imagescroller
        self.tables.tableHeaderView?.isHidden  = false
        self.tables.insertSubview(page, aboveSubview: self.tables.tableHeaderView!)
        
        
        /***** search *****/
        // search 切到到另一个view后，search bar不保留
        self.definesPresentationContext  = true
        searchController  = baseSearchViewController.init(searchResultsController: searchResultController())
        
        //  历史记录代理
        self.delegate = searchController?.serchRecordView
        
        searchController?.searchResultsUpdater = self
        searchController?.delegate =  self
        searchController?.searchBar.delegate = self
     
        searchController?.cityDelegate = self
        searchController?.height = searchBarH
        searchBarContainer.addSubview((searchController?.searchBar)!)
        self.navigationItem.titleView = searchBarContainer
    }
}

// table
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
            return 80
        }
        else if indexPath.section == 1{
            return 100
        }
        return jobdetailCell.cellHeight()
    }
    
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultiSecontions>{
        return RxTableViewSectionedReloadDataSource<MultiSecontions>.init(configureCell: { (dataSource, table, idxPath, _) -> UITableViewCell in
           
            switch dataSource[idxPath]{
            case let .catagoryItem(imageNames):
                
                let cell:MainPageCatagoryCell = table.dequeueReusableCell(withIdentifier: "catagory") as! MainPageCatagoryCell
                cell.createScroller(images: imageNames, width: 80)
                
                return cell
            case let .recommandItem(imageNames):
                
                let cell:MainPageRecommandCell = table.dequeueReusableCell(withIdentifier: "recommand") as!
                MainPageRecommandCell
                cell.createScroller(items: imageNames, width: 150)
                return cell
            case let .campuseRecruite(jobs):
                
                let cell:jobdetailCell = table.dequeueReusableCell(withIdentifier: jobdetailCell.identity()) as!
                jobdetailCell
                
                
                cell.createCells(items: jobs.toJSON())
                
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
           
            self.delegate?.listRecords(word: text)
        }else{
             self.delegate?.showHistory()
        }
        self.searchController?.showRecordView = true

        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 显示搜索resultview
        guard let str = searchBar.text else {
            return
        }
        guard !str.isEmpty else {
            return
        }
        //self.searchController.serchRecordView.view.isHidden = true
        self.searchController?.showRecordView = false
        
        // 查找新的item 然后 重新加载table
        localData.shared.appendSearchHistories(value: searchBar.text!)
        let vm = (self.searchController?.searchResultsController as! searchResultController).vm
        vm?.loadData.onNext("test")
        SVProgressHUD.show(withStatus: "加载数据")
        
    }
    
    
    
    
}


// searchController delegate
extension DashboardViewController: UISearchControllerDelegate{
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
        if let sc =  (searchController as? baseSearchViewController){
           
            sc.showRecordView = true
            sc.serchRecordView.HistoryTable.reloadData()
           
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
            self.delegate?.showHistory()
        }else{
            self.delegate?.listRecords(word: searchText)
        }
        // text 不为空 tableview 显示匹配搜索结果
        
    }
    
    
}

extension DashboardViewController: baseSearchDelegate{
    
    // choose city
    func chooseCity(){
        let citylist = CityViewController.init()
        // 影藏bottom item
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(citylist, animated: true)
        self.hidesBottomBarWhenPushed = false
        
        
    }
}


extension DashboardViewController{
    
    
    func refreshByCity(city:String){
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
                self.navigationView.backgroundColor  = UIColor.init(red: 0.667, green: 0.667, blue: 0.667, alpha: newoffsetY/64)
                
            }
            else if ( newoffsetY > 64){
                self.navigationView.backgroundColor  = UIColor.init(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
                
            }
            else {
                let apl = 0.7 -  (-newoffsetY / 64)
                if apl < 0{
                    self.searchBarContainer.alpha =  0
                }else{
                    self.searchBarContainer.alpha =  apl
                }
                
                self.navigationView.backgroundColor  = UIColor.init(red: 0.667, green: 0.667, blue: 0.667, alpha: 0)
                
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
            self.timer = nil
            
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
        
        let dataSource = DashboardViewController.dataSource()
        self.tables.rx.setDelegate(self).disposed(by: disposebag)
        
        self.tables.rx.itemSelected.subscribe(onNext: { (indexpath) in
            if indexpath.section == 1{
                return
            }
            
            self.tables.deselectRow(at: indexpath, animated: true)
            if  let cell = self.tables.cellForRow(at: indexpath) as? jobdetailCell, let data = cell.model{
                self.showDetails(jobDetail: data as! [String:String])
                
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
    private func showDetails(jobDetail:[String:String]){
        
        let detail = JobDetailViewController()
        detail.infos = jobDetail
        //
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
}

