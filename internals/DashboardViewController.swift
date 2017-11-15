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



class DashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    
    let imageBanners = ["banner1","banner2","banner3","banner4"]
    let menuOneImages = ["volk","swift","car","onedriver","podio"]
    let items = ["finacial","ali","fly","resume"]
    
    // job data
    var jobItems = [["image":"finacial","companyName":"中金","jobname":"分析师","locate":"北京","salary":"100-150元/天","createTime":"08-31","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"],
                    ["image":"dong","companyName":"日立会社","jobname":"工程师","locate":"北京","salary":"200-150元/天","createTime":"08-25","times":"5天/周","time":"3个月","hired":"不可转正","scholar":"专科"],
                    ["image":"volk","companyName":"大众汽车","jobname":"研究员","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"12个月","hired":"可转正","scholar":"硕士"],
                     ["image":"ali","companyName":"阿里巴巴","jobname":"研究员","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"]]
    
    // 内推职位
    var datas = [["image":"swift","companyName":"apple","jobname":"码农","locate":"北京","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"],
                 ["image":"onedriver","companyName":"microsoft","jobname":"AI","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"],
                 ["image":"fly","companyName":"宝骏","jobname":"设计师","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"]
                ]
    
    
    
    let testItem = ["image":"fly","companyName":"宝骏","jobname":"设计师","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"]
    
    var imagescroller:UIScrollView!
    let page = UIPageControl()
    
    var cnt = 0
    var contentOffset:CGPoint = CGPoint(x: 0, y: 0)
    
    
    //scrollview  偏移值
    var threshold:CGFloat = -80
    var marginTop:CGFloat = 0
    //var searchController:UISearchController!
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

    
    
    // test juhua
    var jh:progressHUB?
    
    
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
    
    
    @IBOutlet weak var tables: UITableView!
    // table section设置
    var sections = 4
    

    
 
    
    override func viewDidLoad() {
         super.viewDidLoad()
        print("===dashborad!===")
        self.navigationController?.navigationBar.settranslucent(true)

         self.tables.delegate = self
         self.tables.dataSource = self
         self.tables.register(ScrollerCell.self, forCellReuseIdentifier: "menu1")
         self.tables.register(ScrollerCell2.self, forCellReuseIdentifier: "menu2")
         self.tables.register(jobdetailCell.self, forCellReuseIdentifier: "jobs")
        
         // header
         self.tables.register(HeaderFoot.self, forHeaderFooterViewReuseIdentifier: "dashheader")
         // 距离 bottom view 100像素，保证滑动到底层cell
         self.tables.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        
        //
        self.definesPresentationContext  = true

        resultTableView = UITableViewController()
        resultTableView.tableView.delegate = self
        resultTableView.tableView.dataSource = self
        resultTableView.tableView.tableFooterView = UIView()
        
        resultTableView.tableView.register(jobdetailCell.self, forCellReuseIdentifier: "jobs")
        
        
        
        jh = progressHUB(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        resultTableView.view.addSubview(jh!)
        jh?.center = self.view.center
        jh?.isHidden = true
        jh?.bringSubview(toFront: resultTableView.view)

        
        searchController  = baseSearchViewController(searchResultsController: resultTableView)
        searchController.searchResultsUpdater = self
        searchController.delegate =  self
        searchController.searchBar.delegate = self
    
        
        // dropdown menu
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
        
        
        
        self.navigationItem.titleView = searchBarContainer
        self.automaticallyAdjustsScrollViewInsets  = false
 
   
       _ =  searchController.searchBar.sd_layout().leftSpaceToView(searchBarContainer,10)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,10)
        
        
        // 下拉刷新
        self.tables.refreshControl = UIRefreshControl()
        self.tables.refreshControl?.addTarget(self, action: #selector(refreshdata), for: .valueChanged)
        self.tables.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        
        self.tables.estimatedRowHeight = 100
        self.tables.rowHeight = UITableViewAutomaticDimension
        
        // 轮播图
        imagescroller =  UIScrollView()
        
        
        self.imagescroller.delegate = self
        // 解决navigation 页面跳转后，scrollview content x 偏移差
        self.imagescroller.translatesAutoresizingMaskIntoConstraints = false
        self.tables.tableHeaderView  = imagescroller
        self.tables.tableHeaderView?.frame  = CGRect(x:0 , y:0, width: self.view.frame.width, height: 120)
        self.tables.tableHeaderView?.isHidden  = false
        
        
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
    
    
    // 下拉刷新数据
    @objc func refreshdata(){
        
        print("flush data")
        self.jobItems.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            for _ in 0..<5{
                
                self.jobItems.append(["image":"finacial","companyName":"中金","jobname":"分析师","locate":"北京","salary":"100-150元/天","createTime":"08-31","times":"4天/周"])
                
                
            }
            
            self.tables.reloadData()
            self.tables.refreshControl?.endRefreshing()
        })
        
    }
    

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  tableView == self.resultTableView.tableView{
            return self.searchLists.count
        }
        
        switch section {
        case 0,1:
            return 1
        case 2:
            return self.jobItems.count
        case 3:
            return self.datas.count
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
        case 2,3:
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
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        if tableView == self.resultTableView.tableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "jobs", for: indexPath) as! jobdetailCell
            
            if searchLists.count > indexPath.row{
                cell.createCells(items:searchLists[indexPath.row])
            }
            
            return cell
        }
        
        if indexPath.section == 0 {
            
            let cell  = tableView.dequeueReusableCell(withIdentifier: "menu1", for: indexPath) as! ScrollerCell
            cell.createScroller(images: menuOneImages, width: 80)
            return cell
            
            
        }
        else if indexPath.section == 1{
         
          let cell = tableView.dequeueReusableCell(withIdentifier: "menu2", for: indexPath) as! ScrollerCell2
            
          cell.createScroller(items: items,width: 150)
          return cell
            
        }
        else if indexPath.section == 2{
        
        print(jobItems.count,indexPath.row,indexPath.section)
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobs", for: indexPath) as! jobdetailCell
            
            if jobItems.count > indexPath.row{
                cell.createCells(items:jobItems[indexPath.row])
            }
            
        return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "jobs", for: indexPath) as! jobdetailCell
            
            if datas.count > indexPath.row{
                cell.createCells(items:datas[indexPath.row])
            }
            
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            
        let headerCell = tables.dequeueReusableHeaderFooterView(withIdentifier: "dashheader") as! HeaderFoot
       
        switch section {
        case 1:
             headerCell.categoryName.text = ""
        case 2:
             headerCell.categoryName?.text = "最新职位"
            
        case 3:
              headerCell.categoryName?.text = "内推职位"
        default: break
        }
        
        
        return headerCell
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
        
        
            if tableView.dequeueReusableCell(withIdentifier: "jobs", for: indexPath) is jobdetailCell{
                print("forward to detail view")
                var info:[String:String] = [:]
                if indexPath.section == 2{
                    info = self.jobItems[indexPath.row]
                }else if indexPath.section == 3{
                    info = self.datas[indexPath.row]
                    
                }
                self.showDetails(jobDetail: info)
                
        }
        
    }
    
    //
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
        if scrollView  == self.tables{
            
        
        if self.marginTop != scrollView.contentInset.top{
            self.marginTop = scrollView.contentInset.top
        }
        
        let offsetY = scrollView.contentOffset.y
        
         //向下滑动<0 向上滑动>0
        // 实际检测的offset.y 偏移量
        let  newoffsetY = offsetY + self.marginTop
        print(newoffsetY)
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



extension DashboardViewController: UISearchResultsUpdating{
    
    
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        //TODO 会执行2次？
        print("result search show \(self.resultTableView)")
        
        //self.resultTableView.resignFirstResponder()
        //self.startSearch()
        //self.resultTableView.tableView.reloadData()
        
        
        
        
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
        
        print(self.searchController.isActive, self.searchController.isBeingPresented,
              self.searchController.searchBar.isFocused)



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
        print("start")
        jh?.isHidden = false
        jh?.indicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.searchLists.removeAll()
            for _ in 0..<5{
                
                self.searchLists.append(self.testItem)
                
            }
            self.jh?.isHidden = true
            self.jh?.indicator.stopAnimating()
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
                
                self.searchLists.append(self.testItem)
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
                
                self.searchLists.append(self.testItem)
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
                
                self.searchLists.append(self.testItem)
            }
            self.resultTableView.tableView.reloadData()
            
        }
        
    }
    
}


extension  DashboardViewController{
    
    func refreshByCity(city:String){
        
        self.jobItems.removeAll()
        self.tables.refreshControl?.beginRefreshing()
        // 手动修改table 位移 模拟下拉
        self.tables.contentOffset.y = -64
        self.searchController.searchBar.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            for _ in 0..<5{
                
                self.jobItems.append(["image":"finacial","companyName":"中金","jobname":"分析师","locate":city,"salary":"100-150元/天","createTime":"08-31","times":"4天/周"])
                
            }
            self.tables.reloadData()
            self.tables.refreshControl?.endRefreshing()
            self.tables.contentOffset.y = 0
            self.searchController.searchBar.alpha = 1
            
        })
        
    }
    
}
