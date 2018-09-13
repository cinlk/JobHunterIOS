//
//  ApplyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let titlePageH:CGFloat = 35
fileprivate let titles:[String] = ["网申","校招","宣讲会","公司","实习"]
fileprivate let topColor =  UIColor.init(r: 231, g: 41, b: 46, alpha: 1)

class JobHomeVC: UIViewController {

    
    private lazy var curentIndex:Int = 0
    
    // 跳转到宣讲会
    internal var scrollToindex2:Bool?{
        didSet{
            if scrollToindex2!{
                self.pageContent.moveToIndex(2)
                self.pageTitleView.changeTitleWithProgress(1, sourceIndex: curentIndex, targetIndex: 2)
                 curentIndex = 2

            }
        }
    }
    
    // 跳转到网申
    internal var scrollToindex:Bool?{
        didSet{
            if scrollToindex!{
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
    
    
    
    
    
    // 滑动栏
    private lazy var pageTitleView: pagetitleView = {  [unowned self] in
        let view = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: titlePageH), titles: titles,lineCenter:true)
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
        
     
        let content = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + titlePageH, width: ScreenW, height: ScreenH - NavH - titlePageH), childVCs: self.childVC, pVC: self)
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
        
        // 搜索代理设置
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
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

extension JobHomeVC: UISearchResultsUpdating{
    
    // 检测searchbar 输入信息
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
        if  let text = searchController.searchBar.text, !text.isEmpty{
            //MARK 显示搜索匹配结果
            //self.searchController.serchRecordVC.listRecords(word: text)
        }else{
            // 历史搜索记录
            //self.searchController.serchRecordVC.showHistory()
        }
        self.searchController.showRecordView = true
        
        
    }
    // 开始搜索，显示搜索结果控件
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 显示搜索resultview
        guard let searchItem = searchBar.text else {
            return
        }
        guard !searchItem.isEmpty else {
            return
        }
        
        self.searchController.startSearch(word: searchItem)
        
    }
}

extension JobHomeVC: UISearchBarDelegate{
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       
        return true
    }
    
    
    //文本发生改变
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text \(searchText)")
        
        // text 为空时 显示历史记录
        if searchText.isEmpty{
            //self.searchController.serchRecordVC.showHistory()
        }else{
           // self.searchController.serchRecordVC.listRecords(word: searchText)
        }
        // text 不为空 tableview 显示匹配搜索结果
    }
    
}
