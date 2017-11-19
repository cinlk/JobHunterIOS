//
//  extension+textfield.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation

extension UITextField{
    
    func scrollUpView(view:UIView?){
        
        let frame: CGRect = self.frame
        
        let offset: CGFloat = frame.origin.y + NAV_BAR_FRAME_HEIGHT/2 - (view!.frame.size.height - KEYBOARD_HEIGHT)
        let animationDuration : TimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        
        //如果text 被键盘遮挡，将视图的Y坐标向上移动offset个单位，
        if(offset>0) {
            view!.frame = CGRect(x:0.0, y: -offset, width:view!.frame.size.width,
                                     height:view!.frame.size.height)
            
        }
        UIView.commitAnimations()
    }
    
}
