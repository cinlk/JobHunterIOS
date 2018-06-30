//
//  BaseTableViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    
    private lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        // 再次刷新
        eView.reload = reload
        return eView
        
    }()
    
    
    private lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        hub.mode = .indeterminate
        hub.label.text = "加载数据"
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    
    var handleViews:[UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hub.removeFromSuperview()
        
    }
    
    func setViews(){
                
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        hub.show(animated: true)
        self.handleViews.forEach{
            $0.isHidden = true
        }
    }
    
    func didFinishloadData(){
        hub.hide(animated: true)
        self.handleViews.forEach{
            $0.isHidden = false
        }
        errorView.isHidden = true
        hub.removeFromSuperview()
        
       
    }
    
    func showError(){
        self.handleViews.forEach{
            $0.isHidden = true
        }
        hub.hide(animated: true)
        errorView.isHidden = false
        //backHubView.isHidden = true
    }

    func reload(){
        errorView.isHidden = true
        //backHubView.isHidden = false
        hub.show(animated: true)
    }
    

}
