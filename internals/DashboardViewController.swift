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
    var jobItems = [["image":"finacial","companyName":"中金","jobname":"分析师","locate":"北京","salary":"100-150元/天","createTime":"08-31","times":"4天/周"],
                    ["image":"dong","companyName":"日立会社","jobname":"工程师","locate":"北京","salary":"200-150元/天","createTime":"08-25","times":"5天/周"],
                    ["image":"volk","companyName":"大众汽车","jobname":"研究员","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"],
                     ["image":"ali","companyName":"阿里巴巴","jobname":"研究员","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"]]
    
    // 内推职位
    var datas = [["image":"swift","companyName":"apple","jobname":"码农","locate":"北京","salary":"150-190元/天","createTime":"09-01","times":"4天/周"],
                 ["image":"onedriver","companyName":"microsoft","jobname":"AI","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"],
                 ["image":"fly","companyName":"宝骏","jobname":"设计师","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"]
                ]
    
    
    
    let testItem = ["image":"fly","companyName":"宝骏","jobname":"设计师","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"]
    
    var imagescroller:UIScrollView!
    let page = UIPageControl()
    
    var timer:Timer!
    
    var cnt = 0
    var contentOffset:CGPoint = CGPoint(x: 0, y: 0)
    
    var locatecity  = "北京"{
        willSet{
            print("change to new \(newValue)")
            self.city.setTitle(newValue, for: .normal)
            self.changeCityData()
        }
        
    }
    
    
    //scrollview  偏移值
    var threshold:CGFloat = -80
    var marginTop:CGFloat = 0
    var searchController:UISearchController!
    var searchBarContainer:UIView!
    var city:UIButton!
    var resultTableView:UITableViewController!
    
    let ynsearchData = YNSearch()
    let searchcategory = historyAndCatagoryView()
    
    
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
    
    
    //
    
    @IBOutlet weak var tables: UITableView!
    // table section设置
    var sections = 4
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
         print(self.view.frame)
         print("===dashborad!===")
         let image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        
        
         let selectImage = UIImage(named: "selectedHome")?.withRenderingMode(.alwaysOriginal)
        
         let tabBarItem = UITabBarItem(title: "首页", image: image, selectedImage: selectImage)
        
         tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)
        
         self.tabBarItem = tabBarItem
         // navigation topbar

         // 隐藏导航栏
         //self.navigationController?.navigationBar.subviews[0].alpha = 0
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
        
        resultTableView = UITableViewController()
        resultTableView.tableView.delegate = self
        resultTableView.tableView.dataSource = self
        resultTableView.tableView.tableFooterView = UIView()
        self.resultTableView.tableView.register(jobdetailCell.self, forCellReuseIdentifier: "jobs")

        
        resultTableView.tableView.backgroundColor = UIColor.red
        
        jh = progressHUB(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        resultTableView.view.addSubview(jh!)
        jh?.center = self.view.center
        jh?.isHidden = true
        jh?.bringSubview(toFront: resultTableView.view)
        
        // 搜索栏
        searchController = UISearchController(searchResultsController: resultTableView)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = ""
        searchController.searchBar.showsSearchResultsButton = true
        searchController.searchBar.showsBookmarkButton = true
        self.definesPresentationContext  = true

        
        // dropdown menu
        
        locate = Citys(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        locate.view.switchDelgate = self
        
        jobs = jobCatagory(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-60))
        jobs.job?.switchcategory = self
        
        inters = internshipCondtion(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        inters.cond.selections = self
        let items:[YNDropDownView] = [locate,jobs,inters]
        let conditions = YNDropDownMenu(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:40) , dropDownViews: items, dropDownViewTitles: ["北京","职位类别","筛选条件"])
        
        
        
        conditions.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_sel"), disabled: UIImage(named: "arrow_dim"))
        conditions.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        conditions.setLabelFontWhen(normal: .systemFont(ofSize: 12), selected: .boldSystemFont(ofSize: 12), disabled: .systemFont(ofSize: 12))
        
        
        conditions.backgroundBlurEnabled = true
        conditions.bottomLine.isHidden = false
        let back = UIView()
        back.backgroundColor = UIColor.black
        conditions.blurEffectView = back
        conditions.blurEffectViewAlpha = 0.7
        conditions.setBackgroundColor(color: UIColor.white)
        
        self.searchController.view.addSubview(conditions)
         _ = resultTableView.tableView.sd_layout().topSpaceToView(conditions,1)?.bottomEqualToView(self.view)?.widthIs(self.view.frame.width)
         //_ = conditions.sd_layout().topSpaceToView(self.navigationController?.navigationBar,1)?.widthIs(self.view.frame.width)?.heightIs(60)
        
        
        
        
        
        //
        
        let searchBarFrame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 30)
        searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.addSubview(searchController.searchBar)
        city = UIButton()
        city.setTitle(self.locatecity, for: .normal)
        city.setTitleColor(UIColor.black, for: .normal)
        city.backgroundColor = UIColor.green
        city.alpha =  0.5
        city.addTarget(self, action: #selector(chooseCity), for: .touchUpInside)
        //searchBarContainer.addSubview(city)
        searchBarContainer.alpha = 0
        searchBarContainer.backgroundColor = UIColor.gray
        
        
        self.navigationItem.titleView = searchBarContainer
        self.automaticallyAdjustsScrollViewInsets  = false
 
       //_ =  city.sd_layout().leftEqualToView(searchBarContainer)?.topSpaceToView(searchBarContainer,5)?.heightIs(30)?.widthIs(40)?.bottomSpaceToView(searchBarContainer,5)
       _ =  searchController.searchBar.sd_layout().leftSpaceToView(searchBarContainer,10)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)?.rightSpaceToView(searchBarContainer,10)
        
        
        // 下拉刷新
        self.tables.refreshControl = UIRefreshControl()
        self.tables.refreshControl?.addTarget(self, action: #selector(refreshdata), for: .valueChanged)
        self.tables.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        
        // 轮播图
        //let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        //headerView.backgroundColor = UIColor.lightGray
        
        
        //self.tables.tableHeaderView = headerView
        //self.tables.tableHeaderView?.isHidden = false
        
        self.tables.estimatedRowHeight = 100
        self.tables.rowHeight = UITableViewAutomaticDimension
        
        imagescroller =  UIScrollView()
        
        
        self.imagescroller.delegate = self
        // 解决navigation 页面跳转后，scrollview content x 偏移差
        self.imagescroller.translatesAutoresizingMaskIntoConstraints = false
        
        self.tables.tableHeaderView  = imagescroller
        self.tables.tableHeaderView?.frame  = CGRect(x:0 , y:0, width: self.view.frame.width, height: 120)
        self.tables.tableHeaderView?.isHidden  = false
        
        print("imagescroll frame \(self.imagescroller)")
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets  = false
        //self.imagescroller.contentOffset = CGPoint(x: 0, y: 0)

        
        //
        if searchString != "" && !searchString.isEmpty{            
            self.showSearchResultView()
            self.startSearch(name: searchString)
        }
        
        
    }
    
    // view 会自动调整subview的layout
    override func viewDidLayoutSubviews() {
       
        self.createScrollView()

        // 调整 scrollview content x 位移
        //self.imagescroller.contentOffset = CGPoint(x: 0, y: 0)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 解决view  y自动下移动64
        self.navigationController?.navigationBar.isTranslucent  = true
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshdata(){
        
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
    
    func changeCityData(){
        print("chage city trigger")
        self.jobItems.removeAll()
        self.tables.refreshControl?.beginRefreshing()
        // 手动修改table 位移 模拟下拉
        self.tables.contentOffset.y = -40
        self.searchBarContainer.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            for _ in 0..<5{
                
                self.jobItems.append(["image":"finacial","companyName":"中金","jobname":"分析师","locate":"北京","salary":"100-150元/天","createTime":"08-31","times":"4天/周"])
                
            }
            self.tables.reloadData()
            self.tables.refreshControl?.endRefreshing()
            self.tables.contentOffset.y = 0
            self.searchBarContainer.alpha  = 1
            
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
            
          cell.createScroller(items: items,width: 100)
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
        case 2:
             headerCell.textLabel?.text = "最新职位"
        case 3:
              headerCell.textLabel?.text = "内推职位"
        default: break
        }
        
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view .isKind(of: HeaderFoot.self){
            let hh = view as! HeaderFoot
            hh.textLabel?.textAlignment = .center
            hh.textLabel?.font = UIFont.boldSystemFont(ofSize: 10)
            hh.textLabel?.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
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
        if( newoffsetY >= 5 && newoffsetY <= 80){
            self.searchBarContainer.alpha = CGFloat(newoffsetY/80)

        }else if (newoffsetY > 80){
            self.searchBarContainer.alpha = 1
        }
       
        else{
            self.searchBarContainer.alpha = 0.5
        }
            
        }
        else if scrollView  == self.imagescroller{
            print(scrollView.contentOffset)
        }
        
        
    }
    
    
    
    func createScrollView(){
        
        self.imagescroller.creatScrollImages(imageName: imageBanners, height: (self.imagescroller?.frame.height)!, width: self.imagescroller.frame.width)
        
        //page.frame = CGRect(x:self.view.frame.width / 2 - 50,y:80,width:100,height:30)
        page.numberOfPages = imageBanners.count
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.black
        page.frame = CGRect(x: (self.view.centerX - 60), y: self.imagescroller.frame.height-20, width: 120, height: 10)
        //将小白点放到scr之上
        
        
        //self.tables.tableHeaderView?.addSubview(self.imagescroller)
        self.tables.insertSubview(page, aboveSubview: self.tables.tableHeaderView!)
//        _ = self.imagescroller.sd_layout().topEqualToView(self.tables.tableHeaderView)?.bottomEqualToView(self.tables.tableHeaderView)?.widthIs(CGFloat(imageBanners.count) * (self.tables.tableHeaderView?.frame.width)!)
        
       // _ = self.page.sd_layout().bottomSpaceToView(self.tables.tableHeaderView,10)?.widthIs(120)?.heightIs(30)
        
        self.creatTimer()
        
        
        
    }
    
    //创建轮播图定时器
    func creatTimer() {
        self.timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerManager), userInfo: nil, repeats: true)
        
        //这句话实现多线程，如果你的ScrollView是作为TableView的headerView的话，在拖动tableView的时候让轮播图仍然能轮播就需要用到这句话
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
    }
    
    
    //创建定时器管理者
    func timerManager() {
        print(self.imagescroller.contentOffset, self.imagescroller.contentSize)
        //设置偏移量
        let offsetx = Int((self.imagescroller.contentOffset.x + self.imagescroller.frame.width) / self.imagescroller.frame.width)
       
        if CGFloat(CGFloat(offsetx) * self.imagescroller.frame.width)  == CGFloat(self.imagescroller.frame.width) * CGFloat(self.imageBanners.count  ){
            self.imagescroller.setContentOffset(CGPoint(x:0, y:0), animated: true) 
        }
        else{
            self.imagescroller.setContentOffset(CGPoint(x: CGFloat(offsetx) * self.imagescroller.frame.width, y:0), animated: true)
        }
        //当偏移量达到最后一张的时候，让偏移量置零
       
        
        
    }
    
    func stopTimer(){
        self.timer.invalidate()
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.imagescroller{
            print("start scroller")
            //self.stopTimer()

        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(" decelerating \(self.imagescroller.contentOffset) \(self.view.frame)")
        if scrollView  == self.imagescroller{
            let offsetx = Int(scrollView.contentOffset.x / scrollView.frame.width)
            page.currentPage =  offsetx
        }
        
            
        
    }
    
    /*
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.imagescroller{
            if decelerate{
                print("end dragging")

                let cpage = self.imagescroller.contentOffset.x / self.view.frame.width
                
                let position = Int(cpage)
                self.imagescroller.setContentOffset(CGPoint(x:self.imagescroller.frame.width * CGFloat(position), y: 0 ), animated: false)

            }
            
        }
    }*/
 
    
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
        let citylist = CitysView()
        citylist.currentCity = self.locatecity
        
        // 影藏bottom item
        self.hidesBottomBarWhenPushed = true
        // TODO? use controller?
        //self.navigationController?.pushViewController(citylist, animated: true)
        self.hidesBottomBarWhenPushed = false

        print("forward to city list")
        
        
        
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
        // 不藏导航栏
        self.navigationController?.navigationBar.settranslucent(false)
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
        
      
        
        
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
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("didDismissSearchController")
        // 隐藏导航栏
        self.navigationController?.navigationBar.settranslucent(true)

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
        
        searchcategory.searchString = self
        self.navigationController?.pushViewController(searchcategory, animated: false)
        
        

        return true
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


