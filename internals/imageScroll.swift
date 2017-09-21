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
}

