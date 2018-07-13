//
//  PersonNavViewController.swift
//  internals
//
//  Created by ke.liang on 2018/7/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class PersonNavViewController: UINavigationController {

    
    
    internal var currentStatusStyle = UIStatusBarStyle.default{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return currentStatusStyle
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
