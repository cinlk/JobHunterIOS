//
//  BaseTableViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let hubTitle = "加载数据"

class BaseTableViewController: UITableViewController {

    
    lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        return eView
        
    }()
    
    
    private lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        hub.mode = .indeterminate
        hub.label.text = hubTitle
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    
    var hiddenViews:[UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.insertSubview(errorView,at: 0)
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        _  = errorView.sd_layout().centerXEqualToView(self.tableView)?.centerYEqualToView(self.tableView)?.widthRatioToView(self.tableView, 0.7)?.heightRatioToView(self.tableView,0.4)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //hub.removeFromSuperview()
        
    }
    
    func setViews(){
                
      
        
        hub.show(animated: true)
        self.hiddenViews.forEach{
            $0.isHidden = true
        }
    }
    
    func didFinishloadData(){
        hub.hide(animated: true)
        self.hiddenViews.forEach{
            $0.isHidden = false
        }
        errorView.isHidden = true
        hub.removeFromSuperview()
        
       
    }
    
    func showError(){
        self.hiddenViews.forEach{
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
