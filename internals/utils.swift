//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2017/12/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation


//
func  build_image(frame: CGRect, color:UIColor)->UIImage{
    
    UIGraphicsBeginImageContext(frame.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(frame)
    
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
    
    
    
}



let whiteColot = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)

