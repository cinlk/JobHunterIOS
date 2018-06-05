//
//  extension+navigation.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


extension UINavigationController{
    
    
    func insertCustomerView(_ color: UIColor? = nil){
        
        if self.view.viewWithTag(10) == nil{
            let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
            // naviagtionbar 默认颜色
            v.backgroundColor =  color ?? UIColor.navigationBarColor()
            v.tag  = 10
            self.view.insertSubview(v, at: 1)
        }
        
    }
    
    
    
    func removeCustomerView(){
        if let v = self.view.viewWithTag(10){
            v.removeFromSuperview()
            self.view.willRemoveSubview(v)
        }
       
    }
}
