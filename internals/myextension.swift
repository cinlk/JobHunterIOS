//
//  myextension.swift
//  internals
//
//  Created by ke.liang on 2017/9/20.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



private let  v =  UIImage.init()
private let defaulImg = build_image(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH), color: UIColor.navigationBarColor())
//private let bm = build_image(size: CGSize.init(width: NAV_BAR_FRAME_WIDTH, height: NAV_BAR_FRAME_HEIGHT), alpha: 1)

extension UINavigationBar{
    
    
    
    // change to translucent
    func settranslucent(_ tag: Bool){
        
        // MARK 如何保证 取消背景后的navigationbar，在恢复背景后 和以前效果一直。且
        // translate 为透明
        // 显示 lable
        //self.tintColor  = UIColor.black
        if tag == true{
            //self.settranslucent(<#T##tag: Bool##Bool#>)
            self.setBackgroundImage(v, for: .default)
            self.shadowImage = v
            //self.backgroundColor =  UIColor.clear
            self.isTranslucent = true
        }
        else{
            // 背景image为 navigationbar系统默认颜色？？
            
            self.setBackgroundImage(defaulImg, for: .default)
            //self.shadowImage = self.shadowImage
            self.isTranslucent = false
            
            
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





