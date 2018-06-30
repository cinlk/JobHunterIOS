//
//  NearByViewController.swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let titleName:String = "周边"
fileprivate let pageTitleH:CGFloat = 45

class NearByViewController: UIViewController {


    private var childVC:[UIViewController] = []
    
    private lazy var pagetitle:pagetitleView = { [unowned self] in
        let title = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: pageTitleH), titles: ["宣讲会","公司"])
        title.delegate = self
        return title
        
    }()
    
    
    
    private lazy var pageContent:pageContentView = {  [unowned self] in
      
        
        let career = NearCareerTalkMeetinVC()
        let company = NearCompanyViewController()
        
        childVC.append(career)
        childVC.append(company)
        
        
        let content = pageContentView.init(frame: CGRect.init(x: 0, y: NavH+pageTitleH, width: ScreenW, height: ScreenH - NavH - pageTitleH ), childVCs: childVC, pVC: self)
        
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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.pageContent.moveToIndex(index)
    }
    
    
}


extension NearByViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pagetitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}