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
fileprivate let titleSelectedColor:(CGFloat, CGFloat, CGFloat) = (30,144,255)

class MagazMainViewController: UIViewController {

    
    public var titles:[String] = [] {
        willSet{
//            pageTitleV = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH , width: GlobalConfig.ScreenW, height: pageHeight), titles: newValue, lineCenter: true, kSelectColor: titleSelectedColor)
//            pageTitleV.delegate = self
            
            pageScrollTitleView = PageScrollTitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH , width: GlobalConfig.ScreenW, height: pageHeight), titles: newValue)
            pageScrollTitleView.delegate  = self
            //
            var childVC:[UIViewController] = []
            newValue.forEach {  item in
                let detail = MagazineViewController(type: item)
                childVC.append(detail)
            }
            
            
            self.pageContentV = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + pageHeight, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - pageHeight), childVCs: childVC, pVC: self)
            self.pageContentV.delegate = self
            
            
            
        }
    }
    
    private var pageTitleV:PagetitleView!
    private var pageContentV:PageContentView!
    
    private var pageScrollTitleView:PageScrollTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = viewTitle
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.view.addSubview(pageTitleV)
        self.view.addSubview(pageScrollTitleView)
        self.view.addSubview(pageContentV)
        // Do any additional setup after loading the view.
        self.hidesBottomBarWhenPushed = true
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.lightGray)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
    }
    

}


extension MagazMainViewController:PageContentViewScrollDelegate{
    
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        
        //self.pageTitleV.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
        self.pageScrollTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
}



extension MagazMainViewController: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int) {
        self.pageContentV.moveToIndex(index)
    }
    
    
}
