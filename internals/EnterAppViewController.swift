//
//  EnterViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let firstRun:String = "firstRun"
fileprivate let userLoggingStatus:String = "userLoggingStatus"

class EnterAppViewController: UIViewController {

    
    
    //private var isFisrtRun:Bool = true
    
    private var isLogging:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        run()
        
        
        // Do any additional setup after loading the view.
    }

    
    
    
    

}


extension EnterAppViewController{
    private func run(){
        
        // 第一次run
        if  UserDefaults.standard.value(forKey: firstRun) == nil {
            
            perform(#selector(showUserGuide), with: nil, afterDelay: 0.03)
                
        }else{
             // 不是第一次run
            if let logging = UserDefaults.standard.value(forKey: userLoggingStatus) as? Bool{
                
                // 判断 能否自动登录
                
            }
            
            // 进入广告界面
            perform(#selector(showAdvertise), with: nil, afterDelay: 0.03)
            
            
        }
        
    
        
    }
    

}

extension EnterAppViewController{
    @objc private  func showUserGuide(){
       // UserDefaults.standard.set(true, forKey: firstRun)
        let guide = UserGuideViewController()
        present(guide, animated: false, completion: nil)
    }
    
    @objc private func showAdvertise(){
        let Advertise = AdvertiseViewController()
        present(Advertise, animated: false, completion: nil)
    }
    
    private func showLogging(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as?  LoginNavigationController{
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func showAppMain(){
        if let vc  =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as? MainTabBarViewController{
            present(vc, animated: true, completion: nil)
        }
    }
    
    func finishShowGuide() {
        UserDefaults.standard.set(true, forKey: firstRun)
        
        dismiss(animated: false, completion: nil)
        showLogging()
       
    }
    
    func finishShowAdvertise(){
        dismiss(animated: false, completion: nil)
        showAppMain()
        
    }
    
    
}



