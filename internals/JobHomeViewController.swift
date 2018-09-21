//
//  ApplyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




fileprivate let topColor =  UIColor.init(r: 231, g: 41, b: 46, alpha: 1)

class JobHomeVC: UIViewController {

    static let titlePageH:CGFloat = 35
    
    private lazy var curentIndex:Int = 0
    
    // 跳转到宣讲会
    internal var scrollToCareerTalk:Bool?{
        didSet{
            if scrollToCareerTalk!{
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
    private lazy var searchController:baseSearchViewController = baseSearchViewController(searchResultsController: searchResultController())
    
    
    // 搜索包裹searchBar 的view
    private lazy var searchBarContainer:UIView = {
        // 搜索框
        let searchBarFrame = CGRect(x: 0, y:0, width: ScreenW, height: SEARCH_BAR_H)
        let searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.backgroundColor = UIColor.clear
        return searchBarContainer
    }()
    
    
    internal var isScrollEnabled:Bool = true{
        didSet{
            self.pageContent.collectionView.isScrollEnabled = isScrollEnabled
        }
    }
    
    // 滑动栏
    private lazy var pageTitleView: pagetitleView = {  [unowned self] in
        let view = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: JobHomeVC.titlePageH), titles: JOB_PAGE_TITLES,lineCenter:true)
        view.delegate = self
        view.backgroundColor = topColor
        // 设置属性
        view.moveLine.layer.cornerRadius = 5
        view.subline.isHidden = true
        view.moveLine.backgroundColor = UIColor.white
        return view
    }()
    
    internal var childVC:[UIViewController] = []

    // 内容vc
    private lazy var pageContent:pageContentView = { [unowned self] in
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
        
     
        let content = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + JobHomeVC.titlePageH, width: ScreenW, height: ScreenH - NavH - JobHomeVC.titlePageH), childVCs: self.childVC, pVC: self)
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
        _ = searchController.searchBar.sd_layout().leftSpaceToView(searchBarContainer,0)?.rightSpaceToView(searchBarContainer,0)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
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

        
        // 保证Controller 和 搜索container 高度一致, 搜索框左右圆角正常
        searchController.height = SEARCH_BAR_H
        // searchBar 放入containerview
        searchBarContainer.addSubview(searchController.searchBar)
        //搜索条件menu
        searchController.popMenuView.datas = [.onlineApply, .graduate, .intern, .meeting, .company]
        //searchController.hidesNavigationBarDuringPresentation = false
        // 搜索containerview 作为title viwe
        self.navigationItem.titleView = searchBarContainer
        searchController.delegate = self
        searchController.searchType = .company
        
        
        // 加入titleview
        self.view.addSubview(self.pageTitleView)
        // 加入contentview
        self.view.addSubview(pageContent)
        
    }
}

// pagetitle 代理实现
extension JobHomeVC: pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        curentIndex = index
        self.pageContent.moveToIndex(index)
     }
}
// page 内容代理
extension JobHomeVC: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        curentIndex = targetIndex
        self.pageTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
}


// 搜索代理
extension JobHomeVC: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.setPositionAdjustment(UIOffset.init(horizontal: 60, vertical: 0), for: .search)
        self.searchController.setSearchBar(open: true)
        
        self.navigationController?.navigationBar.settranslucent(false)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.setPositionAdjustment(UIOffset.init(horizontal: 0, vertical: 0), for: .search)
        self.searchController.setSearchBar(open: false)
        
        self.navigationController?.navigationBar.settranslucent(true)
        self.tabBarController?.tabBar.isHidden = false
    }
}


