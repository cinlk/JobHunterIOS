//
//  ForumViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let titles:[String] = ["热门","面经","内推","offer","互助"]
fileprivate let navTitle:String = "论坛"
fileprivate let imageSize:CGSize = CGSize.init(width: 25, height: 25)
fileprivate let pageTitleH:CGFloat = 45
fileprivate let titleW:CGFloat = 70

fileprivate class btn:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    convenience init(frame:CGRect, image:UIImage){
        self.init(frame: frame)
        self.setImage(image, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}


class ForumViewController: UIViewController, UISearchControllerDelegate {

    
    
    private lazy var publish: btn = { [unowned self] in
        let b = btn.init(frame: CGRect.zero, image: #imageLiteral(resourceName: "editPost").changesize(size: imageSize).withRenderingMode(.alwaysTemplate))
        b.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        return b
    }()

    
    private lazy var searchBtn: btn = { [unowned self] in
        let b = btn.init(frame: CGRect.zero, image: #imageLiteral(resourceName: "search").changesize(size: imageSize).withRenderingMode(.alwaysTemplate))
        b.addTarget(self, action: #selector(search), for: .touchUpInside)
        return b
    }()
   
    
    private lazy var pageTitle:PagetitleView = { [unowned self] in
        
        let pageTitle = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: pageTitleH), titles: titles, lineCenter: true, itemWidth: titleW, horizontalEdgeInset:5)
        
        pageTitle.delegate = self
        pageTitle.backgroundColor = UIColor.init(r: 105, g: 105, b: 105)
        return pageTitle
    }()
    
    private lazy var pageContent:PageContentView = { [unowned self] in
        var vcs:[UIViewController] = []
        // 热门
        let hot = PopularSectionVC()
        vcs.append(hot)
        
        // 笔经面经
        let qz = InterviewSectionVC()
        vcs.append(qz)
        
        // 内推
        let recommand = RecommendSectionVC()
        vcs.append(recommand)
        
        // offer
        let offer = OfferSectionVC()
        vcs.append(offer)
        
        // 互助
        let help = HelpSectionVC()
        vcs.append(help)
        
        
        let pageContent = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + pageTitleH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - (GlobalConfig.NavH + pageTitleH)), childVCs: vcs, pVC: self)
        
        pageContent.delegate = self
        return pageContent
        
    }()
    
    
    // 搜索控件
//    private lazy var searchController:BaseSearchViewController = { [unowned self] in
//        let sc =  BaseSearchViewController(searchResultsController: SearchResultController())
//        sc.delegate = self
//        sc.searchType = .forum
//        sc.searchField.placeholder = "搜索帖子"
//        sc.searchField.leftView = nil
//        //sc.chooseTypeBtn.isHidden = true
//
//        return sc
//    }()
    
    private lazy var searchController: ForumSearchViewController = {
        
        let s = ForumSearchViewController.init(searchResultsController: ForumSearchResultViewController())
        s.searchBar.sizeToFit()
        s.searchBar.placeholder = "搜索帖子"
        return s
    }()
    
    
    private var presentSearchControllFlag:Bool = false {
        willSet{
            if newValue{
            
            //self.searchController.searchBar.setPositionAdjustment(UIOffset.init(horizontal: 20 , vertical: 0), for: .search)
                
                self.searchController.searchField.layer.cornerRadius = self.searchController.searchBar.height/2
                self.navigationItem.rightBarButtonItems = nil
            }else{
                NotificationCenter.default.post(name: NotificationName.forumSearchWord, object: nil, userInfo: ["quit": true])
                //self.searchController.setSearchBar(open: newValue)
                self.navigationItem.title = navTitle
                self.navigationItem.titleView = nil
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: publish),
                                                           UIBarButtonItem.init(customView: searchBtn)]
            }
           
            //self.navigationController?.navigationBar.settranslucent(!newValue)
            self.tabBarController?.tabBar.isHidden = newValue
            //self.navigationController?.setToolbarHidden(newValue, animated: false)

           // (self.navigationController as? JobHomeNavigation)?.currentStyle =  newValue ? .default : .lightContent
        }
    }
    
    
    // 搜索包裹searchBar 的view 目的限制高度，不然navibar 自适应高度为56
    // 不能用lazy 初始化, 导致searchbar 高度没有被限制？？？
    private  var wrapBar:UIView =  UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.searchBarH))
    
    
    
    
    
    // 搜索包裹searchBar 的view
//    private lazy var searchBarContainer:UIView = {
//        // 搜索框
//        let searchBarFrame = CGRect(x: 0, y:0, width: GlobalConfig.ScreenW, height: GlobalConfig.searchBarH)
//        let searchBarContainer = UIView(frame:searchBarFrame)
//        searchBarContainer.backgroundColor = UIColor.clear
//        return searchBarContainer
//
//    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setNavigationBtn()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 从搜索解雇vc 返回result vc，tabbar 这里被控制显示？？
        self.tabBarController?.tabBar.isHidden = false || self.presentSearchControllFlag
        self.navigationController?.insertCustomerView(UIColor.lightGray)
        self.navigationController?.navigationBar.tintColor = UIColor.green
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        self.navigationController?.navigationBar.tintColor = UIColor.black
 
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        wrapBar.clipsToBounds = true
//        wrapBar.layer.cornerRadius = GlobalConfig.searchBarH / 2
//        wrapBar.backgroundColor = UIColor.orange
        _ = self.searchController.searchBar.sd_layout()?.topEqualToView(wrapBar)?.bottomEqualToView(wrapBar)?.leftEqualToView(wrapBar)?.rightEqualToView(wrapBar)
        self.wrapBar.layoutSubviews()

        
        
    }
   
    
    deinit {
        print("deinit forumViewController \(self)")
    }
    
    
 
}


extension ForumViewController{
    
    private func setViews(){
        self.title = navTitle
        
        //self.navigationItem.searchController  = searchController
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        
        self.wrapBar.backgroundColor = UIColor.clear
        self.wrapBar.addSubview(self.searchController.searchBar)
        
        self.view.addSubview(pageTitle)
        self.view.addSubview(pageContent)
        //self.view.backgroundColor = UIColor.white
        //
        self.navigationController?.navigationBar.settranslucent(true)
        
        self.definesPresentationContext = true
        //searchController.height = GlobalConfig.searchBarH
        //searchBarContainer.addSubview(searchController.searchBar)
        // 不显示搜索分类
   
        
        // 搜索代理
        _ = self.searchController.rx.willPresent.takeUntil(self.rx.deallocated).subscribe(onNext: {  [weak self] _ in
            self?.presentSearchControllFlag = true
        })
        _ = self.searchController.rx.didDismiss.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] _ in
            self?.presentSearchControllFlag = false
        })
        
        
        
        //searchController.searchField?.placeholder = "搜索帖子"
        // 代理
//        searchController.searchResultsUpdater = self
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
        // 论坛
        //searchController.searchType = .forum
    }
    
    private func setNavigationBtn(){
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: publish),
                                                   UIBarButtonItem.init(customView: searchBtn)]
    }
}


extension ForumViewController{
    @objc private func newPost(){
        // 判断用户是否登录
        guard GlobalUserInfo.shared.isLogin else {
            self.view.showToast(title: "请登录", customImage: nil, mode: .text)
            return
        }
        
        let post = EditPostViewController()
        post.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    @objc private func search(){
        
        self.navigationItem.titleView = wrapBar
        // 显示出searchbar 设置点击状态
        searchController.isActive = true
        
        self.searchController.searchField.backgroundColor = UIColor.orange
       
      }
    
    
}


extension ForumViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController)
        searchController.searchResultsController?.view.isHidden = true
    }
    
    
}

extension ForumViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pageTitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}

extension ForumViewController: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int) {
        self.pageContent.moveToIndex(index)
    }
    
    
}



// 搜索代理
//extension ForumViewController: UISearchControllerDelegate {
//
//    func willPresentSearchController(_ searchController: UISearchController) {
////        self.searchController.searchBar.setPositionAdjustment(UIOffset.init(horizontal: 60, vertical: 0), for: .search)
//        //self.navigationController?.navigationBar.settranslucent(false)
//
//
//        self.searchController.showRecordView = true
//        self.navigationItem.rightBarButtonItems = nil
//
//        self.tabBarController?.tabBar.isHidden = true
//
//    }
//
//    func didDismissSearchController(_ searchController: UISearchController) {
//
//        self.searchController.showRecordView = false
//        //self.searchController.setSearchBar(open: false)
//        self.navigationItem.title = nvaTitle
//        self.navigationItem.titleView = nil
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: publish),
//                                                   UIBarButtonItem.init(customView: searchBtn)]
//        //self.navigationController?.navigationBar.settranslucent(true)
//        self.tabBarController?.tabBar.isHidden = false
//    }
//}

//extension ForumViewController: UISearchResultsUpdating{
//
//    // 检测searchbar 输入信息
//    @available(iOS 8.0, *)
//    func updateSearchResults(for searchController: UISearchController) {
//
//        if  let text = searchController.searchBar.text, !text.isEmpty{
//            //MARK 显示搜索匹配结果
//            //self.searchController.serchRecordVC.listRecords(word: text)
//        }else{
//            // 历史搜索记录
//            //self.searchController.serchRecordVC.showHistory()
//        }
//        // 处理view
//        self.searchController.showRecordView = true
//
//
//    }
//    // 开始搜索，显示搜索结果控件
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // 显示搜索resultview
//        guard let searchItem = searchBar.text else {
//            return
//        }
//        guard !searchItem.isEmpty else {
//            return
//        }
//        // 搜索帖子
//        self.searchController.startPostSearch(word: searchItem)
//
//    }
//}

//extension ForumViewController: UISearchBarDelegate{
//
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//
//        return true
//    }
//
//
//    //文本发生改变
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        // text 为空时 显示历史记录
//        if searchText.isEmpty{
//            //self.searchController.serchRecordVC.showHistory()
//        }else{
//            //self.searchController.serchRecordVC.listRecords(word: searchText)
//        }
//        // text 不为空 tableview 显示匹配搜索结果
//    }
//
//}

