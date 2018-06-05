//
//  DashboardNavigationVC.swift
//  internals
//
//  Created by ke.liang on 2018/5/28.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DashboardNavigationVC: UINavigationController {

    
    // 设置status 类型
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
