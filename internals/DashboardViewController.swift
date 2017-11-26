//
//  DashboardViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNSearch
import YNDropDownMenu
import ObjectMapper
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh

class DashboardViewController: UIViewController{

    // image 点击占时逻辑一致？ image 将来改变
    let imageBanners = MAIN_PAGE_IMAGE_BANNERS
    var imagescroller:UIScrollView!
    let page = UIPageControl()
    
    var cnt = 0
    var contentOffset:CGPoint = CGPoint(x: 0, y: 0)
    
    //scrollview  偏移值
    var threshold:CGFloat = -80
    var marginTop:CGFloat = 0

    // searchview
    var searchController:baseSearchViewController!
    var searchBarContainer:UIView!
    var resultTableView:UITableViewController!
    
    let ynsearchData = YNSearch()
    let searchcategory = historyAndCatagoryView()
    
    // 初始化 搜索内容
    var searchString = ""{
        
        willSet{
        }
    }
    
    
    var locate:Citys!
    var jobs:jobCatagory!
    var inters:internshipCondtion!

    var searchLists:[Dictionary<String,String>] = []

    
    
    //  主页跟新城市
    var dashLocateCity = "北京"{
        willSet{
            self.refreshByCity(city: newValue)
        }
        didSet{
            
        }
    
    }
    
    //
    var flag = false
    let  disposebag = DisposeBag.init()
    // table
    @IBOutlet weak var tables: UITableView!
    let sections = 3
    
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
         /**** navigation ****/
        
         self.navigationController?.navigationBar.settranslucent(true)
         self.navigationItem.titleView = searchBarContainer
         self.automaticallyAdjustsScrollViewInsets  = false
        
         /***** table *****/
         self.tables.register(MainPageCatagoryCell.self, forCellReuseIdentifier: "catagory")
         self.tables.register(MainPageRecommandCell.self, forCellReuseIdentifier: "recommand")
         self.tables.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
         self.tables.register(HeaderFoot.self, forHeaderFooterViewReuseIdentifier: "dashheader")
         // 底部距离 50像素，保证滑动到底部cell
         self.tables.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        // 轮播图
        imagescroller =  UIScrollView()
        self.imagescroller.delegate = self
        // 解决navigation 页面跳转后，scrollview content x 偏移差
        self.imagescroller.translatesAutoresizingMaskIntoConstraints = false
        self.tables.tableHeaderView  = imagescroller
        self.tables.tableHeaderView?.frame  = CGRect(x:0 , y:0, width: self.view.frame.width, height: 120)
        self.tables.tableHeaderView?.isHidden  = false
        
        
        
        /***** search *****/
        // search 切到到另一个view后，search bar不保留
        self.definesPresentationContext  = true
        resultTableView = UITableViewController()
        //resultTableView.tableView.delegate = self
        //resultTableView.tableView.dataSource = self
        resultTableView.tableView.tableFooterView = UIView()
        resultTableView.tableView.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        searchController  = baseSearchViewController(searchResultsController: resultTableView)
        searchController.searchResultsUpdater = self
        searchController.delegate =  self
        searchController.searchBar.delegate = self
        // 下拉菜单view
        locate = Citys(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        locate.view.switchDelgate = self
        
        jobs = jobCatagory(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-60))
        jobs.job?.switchcategory = self
        inters = internshipCondtion(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        inters.cond.selections = self
        searchController.createDropDown(menus: ["北京","职位类别","筛选条件"],views: [locate,jobs,inters])
        //searchController.customerBookmark(cname:dashLocateCity)
        // 搜索框
        let searchBarFrame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 30)
        searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.addSubview(searchController.searchBar)
        //searchBarContainer.addSubview(city)
        searchBarContainer.alpha = 0
        
    
 
   
       _ =  searchController.searchBar.sd_layout().leftSpaceToView(searchBarContainer,10)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,10)
        
        
        
       
        
        // mvvm
        self.loadViewModel()
        // 加载数据
        self.tables.mj_header.beginRefreshing()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.automaticallyAdjustsScrollViewInsets  = false
        if searchString != "" && !searchString.isEmpty{            
            self.showSearchResultView()
            self.startSearch(name: searchString)
        }
        searchController.customerBookmark(cname:dashLocateCity)
        if searchController.isActive {
            self.tabBarController?.tabBar.isHidden = true
        }else{
            
            self.navigationController?.navigationBar.backgroundColor = nil
        }
        
    }
    
    // view 会自动调整subview的layout
    override func viewDidLayoutSubviews() {
        
        
        
        
        // 值创建一次
        if flag == false{
            self.createScrollView()
        }
        
        flag = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadViewModel(){
        
        let request = mainPageServer.shareInstance
        let vm = mainPageViewMode.init(request: request)
        
        let dataSource = DashboardViewController.dataSource()
        self.tables.rx.setDelegate(self).addDisposableTo(disposebag)
        
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

        
        self.tables.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            vm.refreshData.onNext(true)
            
        })
        
        self.tables.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            vm.refreshData.onNext(false)
        })
        
        //
        
      
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
        if scrollView  == self.tables{
            
        
        if self.marginTop != scrollView.contentInset.top{
            self.marginTop = scrollView.contentInset.top
        }
        
        let offsetY = scrollView.contentOffset.y
        
         //向下滑动<0 向上滑动>0
        // 实际检测的offset.y 偏移量
        let  newoffsetY = offsetY + self.marginTop
        //向上拖动变透明
        //self.navigationController?.navigationBar.backgroudImage(alpha: CGFloat(1))

        if( newoffsetY > 0  && newoffsetY <= 80){
            self.searchBarContainer.alpha = CGFloat(newoffsetY/80)
            self.navigationController?.navigationBar.backgroudImage(alpha: CGFloat(newoffsetY/80))
            self.navigationController?.navigationBar.alpha = CGFloat(newoffsetY/80)
            
        }else if (newoffsetY > 80){
            self.searchBarContainer.alpha = 1
            self.navigationController?.navigationBar.backgroudImage(alpha: 2)
            // 设置为fasle 导致bar y位置下移动
            //self.navigationController?.navigationBar.isTranslucent = false

            

            
        }
       
        else if (newoffsetY < 0 && newoffsetY >= -80){
            self.searchBarContainer.alpha = 1 - CGFloat(-newoffsetY/80)
            //self.navigationController?.navigationBar.backgroudImage(alpha: CGFloat(1 - CGFloat(-newoffsetY/80)))
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.alpha = 1 - CGFloat(-newoffsetY/80)
            
        }
        else if (newoffsetY < -80){
            self.searchBarContainer.alpha = 0
            self.navigationController?.navigationBar.backgroudImage(alpha: CGFloat(0))
            self.navigationController?.navigationBar.alpha = 0

        }
        else if (newoffsetY == 0){
            self.searchBarContainer.alpha = 1
            self.navigationController?.navigationBar.settranslucent(true)
            self.navigationController?.navigationBar.alpha = 1

        }
            
        }
        else if scrollView  == self.imagescroller{
        }
        
        
    }
    
    
    
    func createScrollView(){
        
        self.imagescroller.creatScrollImages(imageName: imageBanners, height: (self.imagescroller?.frame.height)!, width: self.imagescroller.frame.width)
        
        page.numberOfPages = imageBanners.count
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.black
        page.frame = CGRect(x: (self.view.centerX - 60), y: self.imagescroller.frame.height-20, width: 120, height: 10)
        
        self.tables.insertSubview(page, aboveSubview: self.tables.tableHeaderView!)
        
        self.imagescroller.creatTimer(count: self.imageBanners.count)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.imagescroller{
            print("start scroller")
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView  == self.imagescroller{
            let offsetx = Int(scrollView.contentOffset.x / scrollView.frame.width)
            page.currentPage =  offsetx
        }
        
            
        
    }
    
    private func endScroller(ratio:CGFloat){
        if ratio <= 1{
            
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if scrollView  == self.imagescroller{
            let offsetx = Int(scrollView.contentOffset.x / scrollView.frame.width)
            page.currentPage =  offsetx
        }
        
        
    }
    
    
    
    // choose city
    func chooseCity(){
         let citylist = CityViewController()
        
        
        
        // 影藏bottom item
        
        self.hidesBottomBarWhenPushed = true
        // TODO? use controller?
        self.navigationController?.pushViewController(citylist, animated: true)
        self.hidesBottomBarWhenPushed = false
        
        
    }
   // show details
    func showDetails(jobDetail:[String:String]){
        
        let detail = JobDetailViewController()
        detail.infos = jobDetail
        
        //
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
        self.hidesBottomBarWhenPushed = false
        
        
    }
    
    

}



// table
extension DashboardViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  tableView == self.resultTableView.tableView{
            return self.searchLists.count
        }
        
        switch section {
        case 0,1:
            return 1
        case 2:
            return 0
        default:
            return 0
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.resultTableView.tableView{
            return 1
        }
        
        return self.sections
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
        
        if tableView == self.resultTableView.tableView{
            return 49
        }
        
        if indexPath.section == 0 {
            return 80
        }
        else if indexPath.section == 1{
            return 100
        }
        return 50
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 禁止第二个section 的cell点击响应事件
        if tableView  == self.tables{
            if indexPath.section == 1{
                return
            }
        }
        // 取消选中状态保持
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if tableView.dequeueReusableCell(withIdentifier: jobdetailCell.identity()) is jobdetailCell{
            var info:[String:String] = [:]
//            if indexPath.section == 2{
//                info = self.jobItems[indexPath.row]
//            }else if indexPath.section == 3{
//                info = self.datas[indexPath.row]
//
//            }
//            self.showDetails(jobDetail: info)
            print("show job detail")
            
        }
        
    }
}

extension DashboardViewController: UISearchResultsUpdating{
    
    
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        //TODO 会执行2次？
        print("result search show \(self.resultTableView)")
        
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button click")
        
    }
    
    
}


extension DashboardViewController: UISearchControllerDelegate{
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 搜索栏 清空
        ynsearchData.setShareSearchName(value: "")
        searchString = ""
        searchcategory.ynSearchView.ynSearchListView.ynSearchTextFieldText = ""
        
        
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        print("presentSearchController")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        
        self.tabBarController?.tabBar.isHidden = true
        // 不藏导航栏
        self.navigationController?.navigationBar.settranslucent(false)
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
        print(self.searchController.isActive, self.searchController.isBeingPresented,
              self.searchController.searchBar.isFocused)

        
      
        
        
    }
    
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
        // 清楚搜索结果
        DispatchQueue.main.async{
            self.searchLists.removeAll()
            self.resultTableView.tableView.reloadData()
            // 重置被选择的item TODO
            for i in self.inters.cond.condtions.visibleCells{
                print(i.isSelected,i)
            }
        }
        self.inters.hideMenu()
        self.locate.hideMenu()
        self.jobs.hideMenu()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("didDismissSearchController")
        // 隐藏导航栏
        self.navigationController?.navigationBar.settranslucent(true)
        self.tabBarController?.tabBar.isHidden = false
        

    }

    
}

extension DashboardViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("bar begin  forward to ynsearchview")
        // 清楚搜索结果
        DispatchQueue.main.async{
            self.searchLists.removeAll()
            self.resultTableView.tableView.reloadData()
           
        }
        self.hidesBottomBarWhenPushed = true
        searchcategory.searchString = self
        self.navigationController?.pushViewController(searchcategory, animated: false)
        self.hidesBottomBarWhenPushed = false
        

        return true
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.chooseCity()
    }
}


extension DashboardViewController{
    
    func showSearchResultView(){
        searchController.isActive = true
        self.searchController.searchResultsController?.becomeFirstResponder()
        searchController.searchBar.text = self.searchString
        
    }
    func startSearch(name:String){
        // 子线程查询
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.searchLists.removeAll()
            for _ in 0..<5{
                
                //self.searchLists.append(self.testItem)
                
            }
            self.resultTableView.tableView.reloadData()
            
        }
    }

    
}




// extension protocol
extension DashboardViewController: valueDelegate{
    func valuePass(string: String) {
        self.searchString = string
        
    }
}

extension DashboardViewController: switchCity{
    
    func cityforsearch(city:String){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.searchLists.removeAll()
            for _ in 0..<5{
                
                //self.searchLists.append(self.testItem)
            }
            self.resultTableView.tableView.reloadData()
            
        }
        
    }
    
    
}

extension DashboardViewController: swichjobCatagory{
    
    func searchCategory(category:String){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.searchLists.removeAll()
            for _ in 0..<5{
                
                //self.searchLists.append(self.testItem)
            }
            self.resultTableView.tableView.reloadData()
            
        }
        
    }
}


extension DashboardViewController: internSelection{
    func selected(days:Int, salary:String,month:Int,scholarship:String,staff:Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.searchLists.removeAll()
            for _ in 0..<5{
                //self.searchLists.append()
            }
            self.resultTableView.tableView.reloadData()
            
        }
        
    }
    
}


extension  DashboardViewController{
    
    func refreshByCity(city:String){
        
        
    }
    
}
