//
//  extension+navigation.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


extension UINavigationController{
    
    
     func insertCustomerView(){
        
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        // naviagtionbar 默认颜色
        v.backgroundColor = UIColor.navigationBarColor()
        v.tag  = 10
        self.view.insertSubview(v, at: 1)
        
    }
    
    func removeCustomerView(){
        let view = self.view.viewWithTag(10)
       // print(view.tag)
        view!.removeFromSuperview()
        self.view.willRemoveSubview(view!)
    }
}
