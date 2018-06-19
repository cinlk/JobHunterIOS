//
//  Extension+YNDropMenuView.swift
//  internals
//
//  Created by ke.liang on 2018/6/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import YNDropDownMenu


extension YNDropDownMenu{
    
    open func addSwipeGestureToBlurView(){
        
        
        
        // 被 父collectionview 覆盖
        let swipRight = UISwipeGestureRecognizer.init(target: self, action: #selector(swip))
        swipRight.direction = .right
        
        // 被 父collectionview 覆盖
        let swipLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(swip))
        swipLeft.direction = .left
        
        
        let swipUp = UISwipeGestureRecognizer.init(target: self, action: #selector(swip))
        swipUp.direction = .up
        
        
        let swipDown = UISwipeGestureRecognizer.init(target: self, action: #selector(swip))
        swipDown.direction = .down
        
        self.blurEffectView?.addGestureRecognizer(swipUp)
        self.blurEffectView?.addGestureRecognizer(swipDown)
        // 手势被父view(pageContent的collectionview) 接受，不能传递到这里
        self.blurEffectView?.addGestureRecognizer(swipLeft)
        self.blurEffectView?.addGestureRecognizer(swipRight)
        
    }
    
    
    @objc private func swip(_ sender: UISwipeGestureRecognizer){
        
        switch sender.direction {
        case .left, .right, .down, .up:
            self.hideMenu()
        default:
            break
        }
    }
}
