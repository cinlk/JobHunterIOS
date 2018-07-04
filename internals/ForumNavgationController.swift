//
//  ForumNavgationController.swift
//  internals
//
//  Created by ke.liang on 2018/6/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ForumNavgationController: UINavigationController {

    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
