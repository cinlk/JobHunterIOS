//
//  MyForumArticleViewController.swift
//  internals
//
//  Created by ke.liang on 2019/5/27.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit

fileprivate let titleName:String = "我的帖子"
fileprivate let group:String = "管理分组"
fileprivate let pageTitleH:CGFloat = 45
fileprivate let titles:[String] = ["我发布的", "我收藏的"]


class MyForumArticleViewController: UIViewController {

    
    
    private lazy var rightBtn:UIBarButtonItem = { [unowned self] in
        let btn = UIBarButtonItem.init(title: group, style: .plain, target: self, action: #selector(managerGroup))
        return btn
    }()
    
    
    private lazy var pagetitle:PagetitleView = { [unowned self] in
        let title = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: pageTitleH),   titles: titles, lineCenter: true, itemWidth: 100, horizontalEdgeInset: 30)
        
        title.delegate = self
        return title
        
    }()
    
    
    
    private lazy var pageContent:PageContentView = {  [unowned self] in
        
        var childVC:[UIViewController] = []
        let mypost = BasePostItemsViewController()
        mypost.type = ForumType.mypost
        
        let mycollected = PostCollectedViewController()
        
        childVC.append(mypost)
        childVC.append(mycollected)
        
        
        let content = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH+pageTitleH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - pageTitleH ), childVCs: childVC, pVC: self)
        
        content.delegate = self
        return content
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = titleName
        self.view.addSubview(pageContent)
        self.view.addSubview(pagetitle)
        
        //self.navigationController?.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    // 切换到 子vc 会被删除，这里需要再次添加
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView(UIColor.blue)
        //self.hidesBottomBarWhenPushed = true
        
    }
    
    deinit {
        print("deinit myForumArticleVC \(String.init(describing: self))")
    }
    
}



//extension MyForumArticleViewController: UINavigationControllerDelegate{
//
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if viewController.isKind(of: DashboardViewController.self){
//            self.navigationController?.removeCustomerView()
//
//
//        }
//    }
//
//}

extension MyForumArticleViewController:pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int) {
        self.pageContent.moveToIndex(index)
        if index == 1{
            // 显示
            self.navigationItem.rightBarButtonItem = rightBtn
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
}


extension MyForumArticleViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pagetitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
        if targetIndex == 1{
            self.navigationItem.rightBarButtonItem = rightBtn
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
}


extension MyForumArticleViewController{
    @objc private func managerGroup(){
        
        let vc = groupManageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

