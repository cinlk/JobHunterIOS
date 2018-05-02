//
//  BaseViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    
    // 这些view需要影藏
    var handleViews:[UIView] = []
    
    
    //显示的错误界面
    //错误显示界面
    lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        // 再次刷新
        eView.reload = reload
        return eView
    }()
    
    lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.label.text = "加载数据"
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.insertSubview(errorView,at: 0)
        //setViews()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func setViews(){
        
        hub.show(animated: true)
        self.handleViews.forEach{
            $0.isHidden = true
        }
        
    }
    
    
    
    //获取数据后正常显示
    func didFinishloadData(){
        
        hub.hide(animated: true)
        self.handleViews.forEach{
            $0.isHidden = false
        }
        errorView.isHidden = true
        hub.removeFromSuperview()
        
        
    }
    
    // 显示错误界面
    func showError(){
        self.handleViews.forEach{
            $0.isHidden = true
        }
        hub.hide(animated: true)
        errorView.isHidden = false
    }
    
    
    // 再次获取数据
    func reload(){
        errorView.isHidden = true
        hub.show(animated: true)
        
    }

}

extension BaseViewController{
    // 布局view
   
    
    // 加载数据

}
