//
//  DashboardViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,
                UISearchResultsUpdating,UISearchBarDelegate{

    
    var datas = ["数据1","数据2","数据3"]
    
    
    let imageBanners = ["banner1","banner2","banner3","banner4"]
    let menuOneImages = ["volk","swift","car","onedriver","podio"]
    let items = ["finacial","ali","fly","resume"]
    
    // job data
    var jobItems = [["image":"finacial","companyName":"中金","jobname":"分析师","locate":"北京","salary":"100-150元/天","createTime":"08-31","times":"4天/周"],
                    ["image":"dong","companyName":"日立会社","jobname":"工程师","locate":"北京","salary":"200-150元/天","createTime":"08-25","times":"5天/周"],
                    ["image":"volk","companyName":"大众汽车","jobname":"研究员","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"],
                     ["image":"ali","companyName":"阿里巴巴","jobname":"研究员","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周"]]
    
    
    var imagescroller:imageScroll!
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
    
    
    
    @IBOutlet weak var tables: UITableView!
    // table 设置
    var sections = 3
    
    override func viewDidLoad() {
        
         print("===dashborad!===")
         let image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        
        
         let selectImage = UIImage(named: "selectedHome")?.withRenderingMode(.alwaysOriginal)
        
         let tabBarItem = UITabBarItem(title: "首页", image: image, selectedImage: selectImage)
        
         tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)
        
         self.tabBarItem = tabBarItem
         // navigation topbar

         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
        
         self.tables.delegate = self
         self.tables.dataSource = self
         self.tables.register(ScrollerCell.self, forCellReuseIdentifier: "menu1")
         self.tables.register(ScrollerCell2.self, forCellReuseIdentifier: "menu2")
         self.tables.register(jobdetailCell.self, forCellReuseIdentifier: "jobs")
        
        
        // 搜索栏
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "感兴趣"
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext  = true
        //searchController.searchBar.sizeToFit()
              //searchController.searchBar.setImage(UIImage(named:"lock"), for: .bookmark, state: .normal)
        
        let searchBarFrame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 36)
        searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.addSubview(searchController.searchBar)
        city = UIButton()
        city.setTitle(self.locatecity, for: .normal)
        city.setTitleColor(UIColor.black, for: .normal)
        city.backgroundColor = UIColor.green
        city.alpha =  0.5
        city.addTarget(self, action: #selector(chooseCity), for: .touchUpInside)
        searchBarContainer.addSubview(city)
        searchBarContainer.backgroundColor = UIColor.green
        //self.view.insertSubview(searchBarContainer, aboveSubview: self.tables)
        self.navigationItem.titleView = searchBarContainer
        self.automaticallyAdjustsScrollViewInsets  = false
 
       _ =  city.sd_layout().leftEqualToView(searchBarContainer)?.topSpaceToView(searchBarContainer,5)?.heightIs(30)?.widthIs(40)?.bottomSpaceToView(searchBarContainer,5)
       _ =  searchController.searchBar.sd_layout().leftSpaceToView(city,10)?.topEqualToView(city)?.bottomEqualToView(city)?.rightSpaceToView(searchBarContainer,30)
        
        
        // 下拉刷新
        self.tables.refreshControl = UIRefreshControl()
        self.tables.refreshControl?.addTarget(self, action: #selector(refreshdata), for: .valueChanged)
        self.tables.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        
        // 轮播图
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        headerView.backgroundColor = UIColor.lightGray
        self.tables.tableHeaderView = headerView
        self.tables.tableHeaderView?.isHidden = false
        
        self.tables.estimatedRowHeight = 100
        self.tables.rowHeight = UITableViewAutomaticDimension
        
        imagescroller = imageScroll(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        self.imagescroller.delegate = self
        self.imagescroller.isUserInteractionEnabled = true
        // 解决navigation 页面跳转后，scrollview content x 偏移差
        self.imagescroller.translatesAutoresizingMaskIntoConstraints = false
        
        self.createScrollView()

        
         super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        self.automaticallyAdjustsScrollViewInsets  = false
        //self.imagescroller.contentOffset = CGPoint(x: 0, y: 0)
        
        
    }
    
    override func viewDidLayoutSubviews() {
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
        if section == 0 {
            return 1
        }
        else if section  == 1{
            return 1
        }
        return self.jobItems.count
    }
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 10
    }
    
    // cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        else if indexPath.section == 1{
            return 100
        }
        return 50
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
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
        else{
        
        print(jobItems.count,indexPath.row,indexPath.section)
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobs", for: indexPath) as! jobdetailCell
            
            if jobItems.count > indexPath.row{
                cell.createCells(items:jobItems[indexPath.row])
            }
            
        return cell
            
        }
        
        
        
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    
    
    
    func createScrollView(){
        
        self.imagescroller.creatScrollImages(imageName: imageBanners, height: (self.tables.tableHeaderView?.frame.height)!, width: self.view.frame.width)
        //page.frame = CGRect(x:self.view.frame.width / 2 - 50,y:80,width:100,height:30)
        page.numberOfPages = imageBanners.count
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.black
        //将小白点放到scr之上
        
        
        self.tables.tableHeaderView?.addSubview(self.imagescroller)
        self.tables.tableHeaderView?.insertSubview(page, aboveSubview: self.imagescroller)
//        _ = self.imagescroller.sd_layout().topEqualToView(self.tables.tableHeaderView)?.bottomEqualToView(self.tables.tableHeaderView)?.widthIs(CGFloat(imageBanners.count) * (self.tables.tableHeaderView?.frame.width)!)
        
        _ = self.page.sd_layout().bottomSpaceToView(self.tables.tableHeaderView,10)?.widthIs(100)?.heightIs(30)?.leftSpaceToView(self.tables.tableHeaderView,120)
        
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
        print(self.imagescroller.contentOffset.x,self.imagescroller.contentOffset.y)
        //设置偏移量
        self.imagescroller.setContentOffset(CGPoint(x:self.imagescroller.contentOffset.x + self.view.frame.width, y:0), animated: true)
        //当偏移量达到最后一张的时候，让偏移量置零
        if self.imagescroller.contentOffset.x == CGFloat(self.view.frame.width) * CGFloat(self.imageBanners.count) {
            self.imagescroller.contentOffset = CGPoint(x:0, y:0)
            
        }
        
    }
    
    func stopTimer(){
        self.timer.invalidate()
        
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cpage = self.imagescroller.contentOffset.x / self.view.frame.width
        page.currentPage = Int(cpage)
        cnt = Int(cpage)
        
        
    }
    


    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cnt+=1
        page.currentPage = cnt % imageBanners.count
        
    }
    
    
    //TODO
    func updateSearchResults(for searchController: UISearchController){
        
    }
    
    func chooseCity(){
        let citylist = CitysView()
        citylist.currentCity = self.locatecity
        
        // 影藏bottom item
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(citylist, animated: true)
        self.hidesBottomBarWhenPushed = false

        print("forward to city list")
        
        
        
    }
  

}
