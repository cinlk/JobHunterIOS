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
    private var data:Dictionary<String,[Dictionary<String,String>]> = [:]
    
    private var childVC:[UIViewController] = []
    
    private let titles:[String] = ["全部","被查看","待沟通","面试","不合适"]
    // MARK start
    lazy var pageTitleView:pagetitleView = { [unowned self] in
        let pagetitle:pagetitleView = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: 40), titles: self.titles)
        pagetitle.delegate = self
        return pagetitle
    }()
    
    lazy var pageContent:pageContentView = { [unowned self] in
        
        
        
         for i in 0..<titles.count{
            let vc = deliveryCategoryView.init(style: .plain, datas: self.data[self.titles[i]])
            vc.view.backgroundColor = UIColor.white
            childVC.append(vc)
        }
        let v:pageContentView = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + 40 , width: ScreenW, height: ScreenH - NavH - 40), childVCs: childVC, pVC: self)
        v.delegate = self
        return v
    }()
    
    
    override func viewDidLoad() {
        //self.oldSetViews()
        super.viewDidLoad()
        self.loadData()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(pageTitleView)
        self.view.addSubview(pageContent)
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleName
    }

    override func viewWillLayoutSubviews() {
          
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
        data = ["全部":[["icon":"chrome","jobName":"AI","company":"Google","address":"mountain","type":"社招","resulte":"不合适","create_time":"2017-12-21"],
                        ["icon":"sina","jobName":"媒体编辑","company":"新浪","address":"上海","type":"社招","resulte":"被查看","create_time":"2017-12-21"]],
                "被查看":[["icon":"sina","jobName":"媒体编辑","company":"新浪","address":"上海","type":"社招","resulte":"被查看","create_time":"2017-12-21"]],
                "待沟通":[],
                "面试":[],
                "不合适":[["icon":"chrome","jobName":"AI","company":"Google","address":"mountain","type":"社招","resulte":"不合适","create_time":"2017-12-21"]]
        ]
    }
}



