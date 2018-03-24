//
//  SysNotificationController.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let titles = ["来访者", "招聘小秘"]
fileprivate let titleHeaderH:CGFloat = 45

class SysNotificationController: UIViewController {

    
    
    // header
    lazy var headerTitleView:pagetitleView = { [unowned self] in
       let titleView = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: titleHeaderH), titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    lazy var contentView:pageContentView = { [unowned self] in
        var vc:[UIViewController] = []
        vc.append(newVisitor())
        vc.append(XiaoMi())
        let contentView = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + titleHeaderH, width: ScreenW, height: ScreenH - NavH - titleHeaderH), childVCs: vc, pVC: self)
        contentView.delegate = self
        return contentView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
       
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "通知消息"
        self.navigationController?.insertCustomerView()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
    }
    

}


extension SysNotificationController{
    
    private  func setViews(){
        
        self.view.backgroundColor = UIColor.viewBackColor()
        self.view.addSubview(headerTitleView)
        self.view.addSubview(contentView)
        
    }
}


extension SysNotificationController: pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.contentView.moveToIndex(index)
    }
    
}


extension SysNotificationController: PageContentViewScrollDelegate{
    
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.headerTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}

