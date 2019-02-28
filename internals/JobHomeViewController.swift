//
//  ApplyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




fileprivate let topColor =  UIColor.init(r: 231, g: 41, b: 46, alpha: 1)
fileprivate let titlePageH:CGFloat = 35


class JobHomeVC: UIViewController, UISearchControllerDelegate {

    
    private lazy var curentIndex:Int = 0
    // 跳转到宣讲会
    internal var scrollToCareerTalk:Bool?{
        didSet{
            if scrollToCareerTalk ?? false{
                self.pageContent.moveToIndex(2)
                self.pageTitleView.changeTitleWithProgress(1, sourceIndex: curentIndex, targetIndex: 2)
                 curentIndex = 2
            }
        }
    }
    
    // 跳转到网申
    internal var scrollToOnlineAppy:Bool?{
        didSet{
            if scrollToOnlineAppy!{
                self.pageContent.moveToIndex(0)
                self.pageTitleView.changeTitleWithProgress(1, sourceIndex: curentIndex, targetIndex: 0)
                curentIndex = 0
            }
        }
    }
    
    // 搜索控件
    private lazy var searchController:BaseSearchViewController = {
        let sc = BaseSearchViewController(searchResultsController: SearchResultController())
        sc.delegate = self
        sc.searchType = .company
        return sc
    }()
    
    private var presentSearchControllFlag:Bool = false {
        willSet{
            self.searchController.setSearchBar(open: newValue)
            self.navigationController?.navigationBar.settranslucent(!newValue)
            self.tabBarController?.tabBar.isHidden = newValue
            (self.navigationController as? JobHomeNavigation)?.currentStyle =  newValue ? .default : .lightContent
        }
    }

    // 搜索包裹searchBar 的view 目的限制高度，不然navibar 自适应高度为56
    private lazy var wrapBar:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.searchBarH))
        v.backgroundColor = UIColor.clear
        v.addSubview(self.searchController.searchBar)
        return v
    }()
    
    // 控制content 滑动
    internal var isScrollEnabled:Bool = true{
        didSet{
            self.pageContent.collectionView.isScrollEnabled = isScrollEnabled
        }
    }
    
    // 滑动栏
    private lazy var pageTitleView: PagetitleView = {  [unowned self] in
        let view = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: titlePageH), titles: GlobalConfig.JobHomePageTitles, lineCenter:true)
        view.delegate = self
        view.backgroundColor = topColor
        // 设置属性
        view.moveLine.layer.cornerRadius = 5
        view.subline.isHidden = true
        view.moveLine.backgroundColor = UIColor.white
        return view
    }()
    
    

    // 内容vc
    private lazy var pageContent:PageContentView = { [unowned self] in
        var childVC:[UIViewController] = []
        
        // 网申职位
        let applyVC:OnlineApplyViewController = OnlineApplyViewController()
        childVC.append(applyVC)
        // 校招职位
        let graduationJobs:GraduateJobsViewController = GraduateJobsViewController()
        childVC.append(graduationJobs)
        // 宣讲会
        let meeting:CareerTalkMeetingViewController = CareerTalkMeetingViewController()
        childVC.append(meeting)
        // 公司
        let company:CompanyListViewController = CompanyListViewController()
        childVC.append(company)
        
        // 实习职位
        let internJob:InternJobsViewController = InternJobsViewController()
        childVC.append(internJob)
        
     
        let content = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + titlePageH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - titlePageH), childVCs: childVC, pVC: self)
        content.delegate = self
        return content
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.insertCustomerView(topColor)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _ = self.searchController.searchBar.sd_layout()?.topEqualToView(wrapBar)?.bottomEqualToView(wrapBar)?.leftEqualToView(wrapBar)?.rightEqualToView(wrapBar)
        self.wrapBar.layoutSubviews()
        self.searchController.searchField.layer.cornerRadius = self.searchController.searchBar.height/2
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 子 vc 覆盖 navibar view
        self.navigationController?.removeCustomerView()
         
    }
    
    
}

extension JobHomeVC {
    
    private func setViews(){
        // searchController 占时新的控制视图时，显示在当前视图上
        self.definesPresentationContext  = true
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        self.navigationItem.titleView = wrapBar
        // 加入titleview
        self.view.addSubview(self.pageTitleView)
        // 加入contentview
        self.view.addSubview(pageContent)
        
        
        // 搜索代理
        _ = self.searchController.rx.willPresent.takeUntil(self.rx.deallocated).subscribe(onNext: { _ in
            self.presentSearchControllFlag = true
        })
        _ = self.searchController.rx.didDismiss.takeUntil(self.rx.deallocated).subscribe(onNext: { _ in
            self.presentSearchControllFlag = false
        })
    
    }
    
    class func titleHeight() -> CGFloat{
        return titlePageH
    }
    
    
}

// pagetitle 代理实现
extension JobHomeVC: pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int) {
        curentIndex = index
        self.pageContent.moveToIndex(index)
     }
}
// page 内容代理
extension JobHomeVC: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        curentIndex = targetIndex
        self.pageTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
}



