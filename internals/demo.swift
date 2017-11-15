//
//  demo.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class demo: UITableViewController {
    
    
    var datas = ["数据1","数据2","数据3"]
    
    let images = ["banner1","banner2","banner3"]
    
    let src = UIScrollView()
    let page = UIPageControl()

    override func viewDidLoad() {
        
        // 下拉刷新
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(refreshdata), for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        // 轮播图
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        let headerView:UIView = UIView(frame:
            CGRect(x:0, y:0, width:tableView!.frame.size.width, height:120))
        headerView.backgroundColor = UIColor.lightGray
        self.tableView?.tableHeaderView = headerView
        
        src.delegate = self
        src.frame = (self.tableView.tableHeaderView?.frame)!
        
        self.createScrollView()
        
        // 搜索bar

        
        super.viewDidLoad()

      
        
        
    }
    
    
    
    @objc private func refreshdata(){
        print("flush data")
        self.datas.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            for _ in 0..<5{
                
                self.datas.append("数据\(Int(arc4random()%1000))")
                
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "mycell")
        
        cell.textLabel?.text = self.datas[indexPath.row]
        
        cell.detailTextLabel?.text = "detail"
        
        return cell
        
        
        
    }
    
    func createScrollView(){
        
        src.creatScrollImages(imageName: images, height: 120, width: self.view.frame.width)
        page.frame = CGRect(x:self.view.frame.width / 2 - 50,y:80,width:100,height:30)
        page.numberOfPages = images.count
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.black
        //将小白点放到scr之上
        
        
        self.tableView.tableHeaderView?.addSubview(src)
        self.tableView.tableHeaderView?.insertSubview(page, aboveSubview: src)
        //src.insertSubview(page, aboveSubview: src)
        self.creatTimer()
        
        
    }
    
    //创建轮播图定时器
    func creatTimer() {
        let  timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerManager), userInfo: nil, repeats: true)
        
        //这句话实现多线程，如果你的ScrollView是作为TableView的headerView的话，在拖动tableView的时候让轮播图仍然能轮播就需要用到这句话
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
    }
    
    //创建定时器管理者
    @objc func timerManager() {
      
        //设置偏移量
        src.setContentOffset(CGPoint(x:src.contentOffset.x + self.view.frame.width, y:0), animated: true)
        //当偏移量达到最后一张的时候，让偏移量置零
        if src.contentOffset.x == CGFloat(self.view.frame.width) * CGFloat(images.count) {
            src.contentOffset = CGPoint(x:0, y:0)
            print("last")
        }
        
    }
    
    var cnt = 0
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cpage = src.contentOffset.x / self.view.frame.width
        page.currentPage = Int(cpage)
        cnt = Int(cpage)
        
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cnt+=1
        page.currentPage = cnt % images.count
    }
    
   
}
