//
//  imageScroll.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit





extension UIScrollView {
    
    
    
    
    // scrollview with images
    func creatScrollImages(imageName:[String],height:CGFloat,width:CGFloat){
        
        for i in 0..<imageName.count{
            let imageView = UIImageView(frame:CGRect(x: CGFloat(i)*width, y: 0, width: width, height: height))
            print("image \(imageView.frame)")
            imageView.image = UIImage(named: imageName[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            self.addSubview(imageView)
            
        }
        
        self.contentSize = CGSize(width: CGFloat(imageName.count)*width, height: height)
        print("imagescroller contentSize \(self.contentSize)")
        self.bounces = false
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isUserInteractionEnabled = true
        
        
      
        
        
    }
    
    //创建轮播图定时器
    func creatTimer(count:Int) {
        // pass value in userinfo (Any)
       
        let timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerManager), userInfo: count, repeats: true)
        
        //这句话实现多线程，如果你的ScrollView是作为TableView的headerView的话，在拖动tableView的时候让轮播图仍然能轮播就需要用到这句话
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
    }
    
    
    //创建定时器管理者
     @objc
    func timerManager(timer:Timer) {
        //设置偏移量
        let count = timer.userInfo as? Int
        let offsetx = Int((self.contentOffset.x + self.frame.width) / self.frame.width)
        
        
        if CGFloat(CGFloat(offsetx) * self.frame.width)  == CGFloat(self.frame.width) * CGFloat(count!){
            self.setContentOffset(CGPoint(x:0, y:0), animated: true)
        }
        else{
            self.setContentOffset(CGPoint(x: CGFloat(offsetx) * self.frame.width, y:0), animated: true)
        }
        //当偏移量达到最后一张的时候，让偏移量置零
        
        
        
    }
}

