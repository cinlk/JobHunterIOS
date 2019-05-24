//
//  BaseActionResumeVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseActionResumeVC: UITableViewController {

    
    internal var isEdit:Bool = false
    internal var isChange:Bool =  false
    
    internal var diction:[ResumeInfoType:String] = [:]
    internal var keys:[ResumeInfoType] = []
    internal var onlyPickerResumeType:[ResumeInfoType] = []
    internal var res:[String:Any] = [:]
    
    
    internal let pManager = personModelManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    internal func checkValue() -> Bool{
        
        self.view.endEditing(true)
       
        var stop:Bool = false
        res.removeAll()
        
        diction.forEach{ [weak self] in
            if $0.value.isEmpty{
                print("\($0.key.describe) 为空")
                stop = true
            }
            self?.res[$0.key.rawValue] = $0.value
        }
        
        if stop{
            return false
        }
        
        isChange = false
        return true
        
    }
  

}


extension BaseActionResumeVC{
    
    @objc internal func editStatus(_ notify:Notification){
        if let info = notify.userInfo as? [String:Bool]{
            isEdit =  info["edit"]!
        }
    }
    
}

