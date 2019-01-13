//
//  EnterViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


class EnterAppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        run()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
        
    }
}


extension EnterAppViewController{
    
    private func run(){
        if  UserDefaults.standard.value(forKey: UserDefaults.firstOpen) == nil {
            
            performSelector(onMainThread: #selector(showUserGuide), with: nil, waitUntilDone: false)
        }else{
            // 登录成功跳转到广告界面
            SingletoneClass.shared.userLogin { (b) in
                //print("login state", b)
                b ? self.performSelector(onMainThread: #selector(self.showAdvertise), with: nil, waitUntilDone: false) : self.performSelector(onMainThread: #selector(self.showLogging), with: nil, waitUntilDone: false)
            }
        }
    }
    
}

extension EnterAppViewController{
    
    @objc private  func showUserGuide(){
       
        let guide = UserGuideViewController()
        present(guide, animated: false, completion: nil)
    }
    
    @objc private func showAdvertise(){
        let Advertise = AdvertiseViewController()
        present(Advertise, animated: false, completion: nil)
    }
    
   @objc  private func showLogging(){
        
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
        UserDefaults.standard.set(true, forKey: UserDefaults.firstOpen)
        dismiss(animated: false, completion: nil)
        showLogging()
       
    }
    
    func finishShowAdvertise(){
        dismiss(animated: false, completion: nil)
        showAppMain()
        
    }
    
    
}
