//
//  extension+uicolor.swift
//  internals
//
//  Created by ke.liang on 2017/12/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1) {
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    class func randomeColor()-> UIColor{
       return UIColor.init(r: CGFloat(arc4random()%255), g: CGFloat(arc4random()%255), b: CGFloat(arc4random()%255))
    }
    
    class func backGroundColor()->UIColor{
        
        return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    }
}
