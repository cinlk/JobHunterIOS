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



func getCitys(filename:String)->[String:[String]]{
    
    guard  let filePath = Bundle.main.path(forResource: filename, ofType: "plist")else{
        
        
        return [:]
    }
    guard  let citys = NSDictionary.init(contentsOfFile: filePath) as? [String:[String]] else {
        
        return [:]
    }
    
    return citys
    
    
}
