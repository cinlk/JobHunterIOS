//
//  DashboardNavigationVC.swift
//  internals
//
//  Created by ke.liang on 2018/5/28.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DashboardNavigationVC: UINavigationController {

     // 改变 status  颜色
    var currentStyle = UIStatusBarStyle.lightContent{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return currentStyle
        }
    }
    

}
