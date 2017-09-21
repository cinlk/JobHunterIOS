//
//  myextension.swift
//  internals
//
//  Created by ke.liang on 2017/9/20.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation




func  build_image(size: CGSize, alpha:CGFloat)->UIImage{
    
    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let color = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
    
    UIGraphicsBeginImageContext(frame.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(frame)
    
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
    
    
    
}


private let  v = UIImage()
private let bm = build_image(size: CGSize(width: NAV_BAR_FRAME_WIDTH,height:NAV_BAR_FRAME_HEIGHT), alpha: 1)

extension UINavigationBar{
    
    
    
    // change to translucent
    func settranslucent(_ tag: Bool){
        
        
        self.tintColor  = UIColor.white
       
        if tag == true{
            self.setBackgroundImage(v, for: .default)
            self.shadowImage = v
            self.isTranslucent = true
        }
        else{
            print("nav bar \(self.size)")
            self.setBackgroundImage(bm, for: .default)
            self.isTranslucent = false
          
        }
    }
    
    //
}
