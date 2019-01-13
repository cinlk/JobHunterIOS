//
//  myextension.swift
//  internals
//
//  Created by ke.liang on 2017/9/20.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



private let  v =  UIImage.init()
private let defaulImg = build_image(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: NavH), color: UIColor.navigationBarColor())
//private let bm = build_image(size: CGSize.init(width: NAV_BAR_FRAME_WIDTH, height: NAV_BAR_FRAME_HEIGHT), alpha: 1)

extension UINavigationBar{
    
    
    // change to translucent
    func settranslucent(_ tag: Bool){
        
        //self.tintColor  = UIColor.black
        if tag == true{
            self.setBackgroundImage(v, for: .default)
            self.shadowImage = v
            self.isTranslucent = true
            self.barTintColor = UIColor.clear
        }
        else{
            
            self.setBackgroundImage(defaulImg, for: .default)
            self.isTranslucent = false
            self.barTintColor = UIColor.init(r: 192, g: 192, b: 192)
            
        }
    }
    
    // 控制backimage 来设置背景
    func backgroudImage(alpha:CGFloat){
        //self.setBackgroundImage(build_image(size: CGSize(width: NAV_BAR_FRAME_WIDTH,height:NAV_BAR_FRAME_HEIGHT), alpha: alpha), for: .default)
        self.isTranslucent = true
    }
    
    //
}


// viwe  对应的 uiviewcontroller
extension UIView{
    
    
    func viewController(aClass: AnyClass) -> UIViewController?{
        var next=self.superview;
        while(next != nil){
            let nextResponder = next?.next
            if((nextResponder?.isKind(of:aClass)) != nil){
                return nextResponder as? UIViewController
            }
            next=next?.superview
        }
        return nil
    }

    
}





