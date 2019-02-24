//
//  NearByViewController.swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let titleName:String = "附近"
fileprivate let pageTitleH:CGFloat = 45
fileprivate let titles:[String] = ["宣讲会", "公司"]


class NearByViewController: UIViewController {


    private var childVC:[UIViewController] = []
    
    private lazy var pagetitle:PagetitleView = { [unowned self] in
        let title = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: pageTitleH),  titles: titles, itemWidth: 100, horizontalEdgeInset: 80)
       
        title.delegate = self
        return title
        
    }()
    
    
    
    private lazy var pageContent:PageContentView = {  [unowned self] in
      
        
        let career = NearCareerTalkMeetinVC()
        let company = NearCompanyViewController()
        
        childVC.append(career)
        childVC.append(company)
        
        
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
        
        self.navigationController?.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        

        // Do any additional setup after loading the view.
    }

    
    // 切换到 子vc 会被删除，这里需要再次添加
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.blue)
        self.hidesBottomBarWhenPushed = true 

    }
    
}



extension NearByViewController: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: DashboardViewController.self){
            self.navigationController?.removeCustomerView()
            
            
        }
    }
    
}

extension NearByViewController:pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int) {
        self.pageContent.moveToIndex(index)
    }
    
    
}


extension NearByViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pagetitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}
