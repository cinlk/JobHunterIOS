//
//  ImageScrollerView.swift
//  internals
//
//  Created by ke.liang on 2018/7/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ImageScrollerView: UIScrollView {


    internal lazy var page:UIPageControl = {
        let page = UIPageControl.init()
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.blue
        return page
        
    }()
    
    
    internal var pageCount:Int?{
        
        didSet{
            self.page.numberOfPages = pageCount!
            self.page.currentPage = 0
            self.page.frame = CGRect.init(x: (ScreenW -  CGFloat(pageCount! * 20))/2, y: self.size.height - 20, width: CGFloat(pageCount! * 20), height: 10)
        }
    }
    
    private var timer:Timer?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        isPagingEnabled = true
        scrollsToTop = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isUserInteractionEnabled = true
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ImageScrollerView{
    
    
    open func createTimer(){
        timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.change), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        
    }
    
    
    @objc func change(timer:Timer) {
        
        var animated = true
        //设置偏移量
        if page.currentPage == page.numberOfPages - 1 {
            page.currentPage = 0
            animated = false
        } else if page.currentPage < page.numberOfPages - 1 {
            page.currentPage += 1
        }
        self.setContentOffset(CGPoint.init(x: (CGFloat(page.currentPage + 1)) * self.size.width, y: 0), animated: animated)
        
    }
    
    open func moveToLeft(){
        
        var animated = true
        if self.page.currentPage == 0 {
            animated = false
            self.page.currentPage = self.page.numberOfPages - 1
        }else{
            self.page.currentPage -=  1
        }
        
        self.setContentOffset(CGPoint.init(x: (CGFloat(page.currentPage + 1)) * self.size.width,y: 0), animated: animated)
    }
    
    open func moveToRight(){
        
        var animated = true
        if self.page.currentPage == self.page.numberOfPages-1{
            animated = false
            self.page.currentPage = 0
            
        }else{
            self.page.currentPage += 1
            
        }
        self.setContentOffset(CGPoint.init(x: (CGFloat(page.currentPage + 1)) * self.size.width,y: 0), animated: animated)
    }
    
    open func stopAutoScroller(){
        self.timer?.invalidate()
        
    }
    
}
