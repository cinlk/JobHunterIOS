//
//  ImageScrollerView.swift
//  internals
//
//  Created by ke.liang on 2018/7/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ImageScrollerView: UIScrollView {

    private let isRunning = BehaviorRelay<Bool>.init(value: false)
    
    private var scrollerImages:[(UIImageView, String?)] = []
    
    
    private lazy var page:UIPageControl = {
        let page = UIPageControl.init()
        page.backgroundColor = UIColor.clear
        page.isEnabled  = false
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.blue
        return page
        
    }()
    
    
    private var pageCount:Int?{
        
        didSet{
            guard let b =  pageCount, b > 0 else{
                return
            }
            
            self.page.numberOfPages = b
            self.page.currentPage = 0
            self.page.frame = CGRect.init(x: (GlobalConfig.ScreenW -  CGFloat(b * 20))/2, y: self.size.height - 20, width: CGFloat(b * 20), height: 10)
            
           
        }
    }
    
    //private var timer:Timer?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        isPagingEnabled = true
        scrollsToTop = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isUserInteractionEnabled = true
        //
        contentInsetAdjustmentBehavior = .never
        
        self.setRunning()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension ImageScrollerView{
    
    
//    open func createTimer(){
//        timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.change), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
//
        
//    }
    
    open func setPagePosition(view:UIView){
        
        view.insertSubview(self.page, aboveSubview: self)
    }
    
    private func setRunning(){
        
        _ =  isRunning.asObservable().debug().flatMapLatest{ isRunning in
            isRunning ? Observable<Int>.interval(1, scheduler: MainScheduler.instance) : .empty()
            
            }.enumerated().flatMapLatest { (index, element)   in
                Observable.just(element)
            }.takeUntil(self.rx.deallocated).subscribe()
        
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
        //self.timer?.invalidate()
        self.isRunning.accept(false)
    }
    open func startScroller(){
        self.isRunning.accept(true)
    }
    
}


extension ImageScrollerView{
    
    
    @objc private func selectBanner(_ tap:UITapGestureRecognizer){
        guard  let image = tap.view as? UIImageView else {
            return
        }
        
        // 获取navigation controller
        guard let nav = self.targetViewController(aClass: UINavigationController.self) as? UINavigationController else {
            return
        }
        
        if image.tag < scrollerImages.count && image.tag >= 0{
            //
            let webView = BaseWebViewController()
            webView.mode = scrollerImages[image.tag].1
            webView.hidesBottomBarWhenPushed = true
            nav.pushViewController(webView, animated: true)
        }
    }
    
    
    open func buildImages(banners images: inout [ImageBanner]){
        
        if images.isEmpty{
            return
        }
        self.pageCount = images.count
        
        scrollerImages.forEach { $0.0.removeFromSuperview()}
        scrollerImages.removeAll()
        
        let first = images[0]
        let last = images[images.count - 1]
        images.append(first)
        images.insert(last, at: 0)
        for (index, item) in images.enumerated(){
            
            guard  item.imageURL != nil, item.link != nil else { continue }
            
            
            let imageView = UIImageView(frame:CGRect(x: CGFloat(index) * self.width, y: 0, width: self.width, height: self.height))
            // 记录tag
            imageView.tag = index - 1
            imageView.isUserInteractionEnabled = true
            
            let guest = UITapGestureRecognizer()
            guest.addTarget(self, action: #selector(self.selectBanner(_:)))
            imageView.addGestureRecognizer(guest)
            
            
            //(TODO) get image from url
            if let url = URL.init(string: item.imageURL ?? ""){
                 imageView.kf.setImage(with: Source.network(url), placeholder: #imageLiteral(resourceName: "banner3"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            //imageView.image = UIImage.init(named: item.imageURL ?? ROTATE_IMA)
           
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            self.addSubview(imageView)
            scrollerImages.append((imageView, item.link))
        }
        
        // 前后多加一张图
        self.contentSize = CGSize.init(width: CGFloat(CGFloat(images.count) * width), height: height)
        self.contentOffset = CGPoint.init(x: self.width, y: 0)
        self.startScroller()
        
    }
}
