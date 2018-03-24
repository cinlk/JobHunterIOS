//
//  deliveredHistory.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let titleName = "投递记录"

class deliveredHistory: UIViewController,UIScrollViewDelegate {

    
    //MARK  data map json?
    private var data:[DeliveredJobsResults] = []
    
    private var childVC:[UIViewController] = []
    
    // 数据顺序
    private let titles:[String] = ["全部","被查看","待沟通","面试","不合适"]
    lazy var pageTitleView:pagetitleView = { [unowned self] in
        let pagetitle:pagetitleView = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: 40), titles: self.titles)
        pagetitle.delegate = self
        return pagetitle
    }()
    
    lazy var pageContent:pageContentView = { [unowned self] in
        
         for i in 0..<data.count{
            let vc = deliveryCategoryView.init(style: .plain, datas: self.data[i])
            vc.view.backgroundColor = UIColor.white
            childVC.append(vc)
        }
        let v:pageContentView = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + 40 , width: ScreenW, height: ScreenH - NavH - 40), childVCs: childVC, pVC: self)
        v.delegate = self
        return v
    }()
    
    
    private lazy var navigationBackView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        // naviagtionbar 默认颜色
        v.backgroundColor = UIColor.navigationBarColor()
        
        return v
    }()
    
    override func viewDidLoad() {
        //self.oldSetViews()
        super.viewDidLoad()
        self.loadData()
        
        self.view.backgroundColor = UIColor.viewBackColor()
        self.view.addSubview(pageTitleView)
        self.view.addSubview(pageContent)
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleName
        self.navigationController?.view.insertSubview(navigationBackView, at: 1)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        navigationBackView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationBackView)
    }

}

// pagetitle delegate
extension deliveredHistory: pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.pageContent.moveToIndex(index)
    }

}

extension deliveredHistory: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pageTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}

// load data
extension deliveredHistory{
    
    private func loadData(){
        
        
       // 注意顺序
        let  d1 =  DeliveredJobsModel(JSON: ["id":"dwqdqwd","picture":"chrome","jobName":"AI","company":"Google","address":"mountain","type":"社招","checkStatus":"不合适","create_time":"2017-12-21","records":[["不合适","2017-9-13: 08:25"],["待沟通","2017-9-13: 08:25"],["被查看","2017-9-13: 08:21"],["投递成功","2017-9-12: 16:08"]], "response":["status":"不合适","des":"专业方向不符合 dqwd 吊袜带挖 当前为多群无 当前为多群无多多群无  当前为多无群多群 当前的群多群无"]])
        
        
        let  d2 =  DeliveredJobsModel(JSON: ["picture":"sina","jobName":"媒体编辑","company":"新浪","address":"上海","type":"社招","checkStatus":"被查看","create_time":"2017-12-21","records":[["被查看","2017-9-13: 08:21"],["投递成功","2017-9-12: 16:08"]],"response":["status":"被查看","des":""]])
        
        
        // 全部
        // 直接写json 构造函数 不能转换 为nil ？？
        let m1 = DeliveredJobsResults(JSON: ["title":"全部","jobs":[]])
        m1?.jobs?.append(d1!)
        m1?.jobs?.append(d2!)
        data.append(m1!)
        
        // 赋值有才数据  ？？
        //data.first?.jobs = [d1,d2]
        //self.title?.append("全部")
        
        let d3 = DeliveredJobsModel(JSON: ["picture":"sina","jobName":"媒体编辑","company":"新浪","address":"上海","type":"社招","checkStatus":"被查看","create_time":"2017-12-21"])
        data.append(DeliveredJobsResults(JSON: ["title":"被查看","jobs":[d3]])!)
        data.append(DeliveredJobsResults(JSON: ["title":"待沟通","jobs":[]])!)
        data.append(DeliveredJobsResults(JSON: ["title":"面试","jobs":[]])!)
        
        
        let d4 = DeliveredJobsModel(JSON: ["picture":"chrome","jobName":"AI","company":"Google","address":"mountain","type":"社招","checkStatus":"不合适","create_time":"2017-12-21"])
        
        data.append(DeliveredJobsResults(JSON: ["title":"不合适","jobs":[d4]])!)
      

    }
}



