//
//  tests.swift
//  internals
//
//  Created by ke.liang on 2017/12/4.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class tests: UIViewController {
    
    var table:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table = UITableView.init()
        self.view.addSubview(table)
        table.frame = self.view.frame
        
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
