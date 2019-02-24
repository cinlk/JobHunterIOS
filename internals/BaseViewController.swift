//
//  BaseViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let loading = "加载中..."

class BaseViewController: UIViewController {

    // 需要影藏的当前子view
    internal var hiddenViews:[UIView] = []
    
    //显示的错误界面
    internal lazy var errorView:ErrorPageView = {  [unowned self] in
        
        let eView = ErrorPageView.init(frame: CGRect.zero)
        eView.isHidden = true
        return eView
    }()
    
    // 进度提示view
    internal lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.label.text = loading
        hub.removeFromSuperViewOnHide = false
        //hub.isHidden = true 
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //hub.show(animated: false)
        self.view.backgroundColor = UIColor.white
        self.view.insertSubview(errorView,at: 0)
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        _  = errorView.sd_layout().centerXEqualToView(self.view)?.centerYEqualToView(self.view)?.widthRatioToView(self.view, 0.7)?.heightRatioToView(self.view,0.4)
    }
   
    internal func setViews(){
        
        
        hub.show(animated: true)
        self.hiddenViews.forEach{
            $0.isHidden = true
        }
    }

    //获取数据后正常显示
   internal func didFinishloadData(){
        
         
        hub.hide(animated: true)
        self.hiddenViews.forEach{
            $0.isHidden = false
        }
        errorView.isHidden = true
        hub.isHidden = true 
        
        
    }
    
    // 显示错误界面
   internal func showError(){
        self.hiddenViews.forEach{
            $0.isHidden = true
        }
        
        hub.hide(animated: true)
        errorView.isHidden = false
    }
    
    internal func reload(){
        errorView.isHidden = true
        hub.show(animated: true)
        
    }
    
    // 跳转到登录界面  TODO
    internal func login(){
        
    }
    
}



extension BaseViewController{
    func setLoadinhTitle(title:String){
        self.hub.label.text = title
    }
}

