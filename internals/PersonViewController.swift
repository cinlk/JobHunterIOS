//
//  PersonViewController.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    
    lazy var  logoutButton:UIButton = {
       let button = UIButton.init(type: UIButtonType.custom)
        button.setTitle("退出登录", for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
        
    }()
        
    
    
    override func viewDidLoad() {
        self.view.addSubview(logoutButton)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillLayoutSubviews() {
        _ = self.logoutButton.sd_layout().topSpaceToView(self.view,60)?.centerXEqualToView(self.view)?.widthIs(100)?.heightIs(20)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc  func logout(){
        // 清理数据
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "login")  as! ViewController
        self.present(loginView, animated: true, completion: nil)
        
        
    }

}
