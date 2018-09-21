//
//  JobHomeNavigation.swift
//  internals
//
//  Created by ke.liang on 2018/6/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class JobHomeNavigation: UINavigationController {

    // 改变 status  颜色
    var currentStyle = UIStatusBarStyle.default{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return currentStyle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
