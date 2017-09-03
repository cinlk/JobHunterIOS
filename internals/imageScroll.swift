//
//  imageScroll.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class imageScroll: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    

    func creatScrollImages(imageName:[String],height:CGFloat,width:CGFloat){
        
        for i in 0..<imageName.count{
            let imageView = UIImageView(frame:CGRect(x: CGFloat(i)*width, y: 0, width: width, height: height))
            imageView.image = UIImage(named: imageName[i])
            self.addSubview(imageView)
            
        }
        
        self.contentSize = CGSize(width: CGFloat(imageName.count)*width, height: height)
        self.bounces = false
        self.isPagingEnabled = true
        
        let imageView = UIImageView(frame:CGRect(x:CGFloat(imageName.count) * width, y: 0,width: width, height:height))
        imageView.image = UIImage(named:imageName[0])
        self.addSubview(imageView)
        
        
        
        
    }
}
