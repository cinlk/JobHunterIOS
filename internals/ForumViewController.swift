//
//  ForumViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


class ForumViewController: UIViewController {

    
    
    private lazy var publish:UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setImage(UIImage.init(named: "editPost")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        //btn.layer.masksToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        return btn
    }()
    
    private lazy var searchBtn:UIButton = {
        let btn = UIButton.init(frame:  CGRect.zero)
        btn.setImage(UIImage.init(named: "search")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        //btn.layer.masksToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        return btn
    }()
    
    //
    
    private lazy var pageTitle:pagetitleView = {
        let pageTitle = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: 45), titles: ["热门","求职","生活","吐槽","专栏"], lineCenter: true)
        pageTitle.delegate = self
        pageTitle.backgroundColor = UIColor.init(r: 105, g: 105, b: 105)
        return pageTitle
    }()
    
    private lazy var pageContent:pageContentView = { [unowned self] in
        var vcs:[UIViewController] = []
        // 热门
        let hot = BasePostItemsViewController()
        hot.type = .popular
        
        vcs.append(hot)
        
        // 求职
        let qz = BasePostItemsViewController()
        qz.type = .jobs
        vcs.append(qz)
        // 生活
        let life = BasePostItemsViewController()
        life.type = .life
        vcs.append(life)
        // 吐槽
        let talk = BasePostItemsViewController()
        talk.type = .roast
        vcs.append(talk)
        // 专栏
        let article = MagazineViewController()
        vcs.append(article)
        
        let pageContent = pageContentView.init(frame: CGRect.init(x: 0, y: NavH+45, width: ScreenW, height: ScreenH - (NavH+45)), childVCs: vcs, pVC: self)
        
        pageContent.delegate = self
        return pageContent
        
    }()
    
    
    // 搜索控件
    private lazy var searchController:baseSearchViewController = baseSearchViewController(searchResultsController: searchResultController())
    
    
    // 搜索包裹searchBar 的view
    private lazy var searchBarContainer:UIView = {
        // 搜索框
        let searchBarFrame = CGRect(x: 0, y:0, width: ScreenW, height: searchBarH)
        let searchBarContainer = UIView(frame:searchBarFrame)
        searchBarContainer.backgroundColor = UIColor.clear
        return searchBarContainer
        
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setNavigationBtn()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "论坛"
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.navigationBar.tintColor = UIColor.green
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = searchController.searchBar.sd_layout().leftSpaceToView(searchBarContainer,10)?.rightSpaceToView(searchBarContainer,10)?.topEqualToView(searchBarContainer)?.bottomEqualToView(searchBarContainer)
        
    }
   
    
    
 
}


extension ForumViewController{
    
    private func setViews(){
        self.view.addSubview(pageTitle)
        self.view.addSubview(pageContent)
        self.view.backgroundColor = UIColor.white
        //
        self.navigationController?.navigationBar.settranslucent(true)
        //self.navigationController?.hidesBarsOnSwipe = true
        self.definesPresentationContext = true
        searchController.height = searchBarH
        // searchBar 放入containerview
        searchBarContainer.addSubview(searchController.searchBar)
        //searchController.popMenuView.datas = []
        // 不显示搜索分类
        searchController.chooseTypeBtn.isHidden = true
        searchController.searchField?.placeholder = "搜索帖子"
        // 代理
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        // 论坛
        searchController.serchRecordVC.isForum = true
    }
    
    private func setNavigationBtn(){
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: publish),
                                                   UIBarButtonItem.init(customView: searchBtn)]
    }
}


extension ForumViewController{
    @objc private func newPost(){
        let post = EditPostViewController()
        //self.navigationController?.navigationBar.settranslucent(false)
        self.tabBarController?.tabBar.isHidden = true

        self.navigationController?.pushViewController(post, animated: true)
    }
    @objc private func search(){
        
        self.navigationItem.titleView = searchBarContainer
        searchController.isActive = true
       
      }
    
    
}


extension ForumViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pageTitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}

extension ForumViewController: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.pageContent.moveToIndex(index)
    }
    
    
}



// 搜索代理
extension ForumViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
//        self.searchController.searchBar.setPositionAdjustment(UIOffset.init(horizontal: 60, vertical: 0), for: .search)
        self.navigationController?.navigationBar.settranslucent(false)

        
        self.searchController.showRecordView = true
        self.navigationItem.rightBarButtonItems = nil
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {

        self.searchController.showRecordView = false
        //self.searchController.setSearchBar(open: false)
        self.navigationItem.title = "论坛"
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: publish),
                                                   UIBarButtonItem.init(customView: searchBtn)]
        self.navigationController?.navigationBar.settranslucent(true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension ForumViewController: UISearchResultsUpdating{
    
    // 检测searchbar 输入信息
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
        if  let text = searchController.searchBar.text, !text.isEmpty{
            //MARK 显示搜索匹配结果
            self.searchController.serchRecordVC.listRecords(word: text)
        }else{
            // 历史搜索记录
            self.searchController.serchRecordVC.showHistory()
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
        // 搜索帖子
        self.searchController.startPostSearch(word: searchItem)
        
    }
}

extension ForumViewController: UISearchBarDelegate{
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    
    //文本发生改变
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // text 为空时 显示历史记录
        if searchText.isEmpty{
            self.searchController.serchRecordVC.showHistory()
        }else{
            self.searchController.serchRecordVC.listRecords(word: searchText)
        }
        // text 不为空 tableview 显示匹配搜索结果
    }
    
}
