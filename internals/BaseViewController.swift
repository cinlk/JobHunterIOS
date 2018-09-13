//
//  BaseViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // 需要影藏的当前子view
    internal var handleViews:[UIView] = []
    
    //显示的错误界面
    internal lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        // 再次刷新
        eView.reload = reload
        return eView
    }()
    
    // 进度提示view
    internal lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        
        hub.label.text = LOADING
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.insertSubview(errorView,at: 0)
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }

    
 
    
   
    internal func setViews(){
        
        hub.show(animated: true)
        self.handleViews.forEach{
            $0.isHidden = true
        }
        
    }
    
    
    
    //获取数据后正常显示
   internal func didFinishloadData(){
        
        
        hub.hide(animated: true)
        self.handleViews.forEach{
            $0.isHidden = false
        }
        errorView.isHidden = true
        hub.isHidden = true 
        
        
    }
    
    // 显示错误界面
   internal func showError(){
        self.handleViews.forEach{
            $0.isHidden = true
        }
        
        hub.hide(animated: true)
        errorView.isHidden = false
    }
    
    
    // 再次获取数据
    internal func reload(){
        errorView.isHidden = true
        hub.show(animated: true)
    }
}
