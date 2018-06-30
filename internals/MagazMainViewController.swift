//
//  MagazMainViewController.swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let viewTitle:String = "专栏"
fileprivate let pageHeight:CGFloat = 45

class MagazMainViewController: UIViewController {

    
    fileprivate let titles:[String] = ["测试1","测试2","测试3","测试4", "测试5"]
    
    
    private lazy var pageTitleV:pagetitleView = {  [unowned self] in
        let ptitle = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: pageHeight), titles: titles, lineCenter: true, kSelectColor:(30,144,255) )
        ptitle.delegate = self
        
        return ptitle
    }()
    
    
    private lazy var childVC:[UIViewController] = []
    
    private lazy var pageContentV:pageContentView = { [unowned self] in
        
        let test1 = MagazineViewController(dataType: .test1(name:"测试1", url:"url地址"))
        
        //sub.hidesBottomBarWhenPushed = true
        childVC.append(test1)
        
        let test2 = MagazineViewController(dataType: .test1(name:"测试1", url:"url地址"))
         //sub.hidesBottomBarWhenPushed = true
        childVC.append(test2)
        
        let test3 = MagazineViewController(dataType: .test1(name:"测试1", url:"url地址"))
         //sub.hidesBottomBarWhenPushed = true
        childVC.append(test3)
        
        
        let test4 = MagazineViewController(dataType: .test1(name:"测试1", url:"url地址"))
         //sub.hidesBottomBarWhenPushed = true
        childVC.append(test4)
        
        
        
        let test5 = MagazineViewController(dataType: .test1(name:"测试1", url:"url地址"))
        //sub.hidesBottomBarWhenPushed = true
        childVC.append(test5)
        
        
        let pContent = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + pageHeight, width: ScreenW, height: ScreenH - NavH - pageHeight), childVCs: childVC, pVC: self)
        pContent.delegate = self
        
        return pContent
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = viewTitle
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.addSubview(pageTitleV)
        self.view.addSubview(pageContentV)
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.blue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension MagazMainViewController:PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        
        self.pageTitleV.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}



extension MagazMainViewController: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.pageContentV.moveToIndex(index)
    }
    
    
}
