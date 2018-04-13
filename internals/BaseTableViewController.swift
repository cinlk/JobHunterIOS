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
        
        let  hub = MBProgressHUD.showAdded(to: self.backHubView, animated: true)
        hub.mode = .indeterminate
        hub.label.text = "加载数据"
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    
    // tableview 是第一个view，不能直接使用为hub的背景view
    lazy var backHubView:UIView = { [unowned self] in
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        view.backgroundColor = UIColor.white
        //用于 navigation
        self.navigationController?.view.insertSubview(view, at: 1)
        view.isHidden = true
        return view
        
    }()
    
    var handleViews:[UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hub.removeFromSuperview()
        backHubView.removeFromSuperview()
        
    }
    
    func setViews(){
        hub.show(animated: true)
        self.handleViews.forEach{
            $0.isHidden = true
        }
        backHubView.isHidden = false
    }
    
    func didFinishloadData(){
        hub.hide(animated: true)
        self.handleViews.forEach{
            $0.isHidden = false
        }
        backHubView.isHidden = true
        errorView.isHidden = true
        hub.removeFromSuperview()
        
       
    }
    
    func showError(){
        self.handleViews.forEach{
            $0.isHidden = true
        }
        hub.hide(animated: true)
        errorView.isHidden = false
        backHubView.isHidden = true
    }

    func reload(){
        errorView.isHidden = true
        backHubView.isHidden = false
        hub.show(animated: true)
    }
    

}
