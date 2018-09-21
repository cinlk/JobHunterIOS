//
//  extension+uiview.swift
//  internals
//
//  Created by ke.liang on 2017/12/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



struct actionEntity {
    var title:String
    var selector:Selector?
    var args:Any?
    
    init(title:String, selector:Selector?, args:Any?) {
        self.title = title
        self.selector = selector
        self.args = args
    }
    
}



extension UIView{
    
    func presentAlert(type: UIAlertController.Style, title:String?, message:String?, items:[actionEntity],  target:AnyObject?, complete:(( _ alert:UIAlertController )->Void)){
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: type)
        
        
        for actionItem in items{
            let action = UIAlertAction.init(title: actionItem.title, style: .default) { action in
                if let selector = actionItem.selector{
                    
                    target?.performSelector(onMainThread: selector, with: actionItem.args, waitUntilDone: true)
                }
            }
            alertVC.addAction(action)
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
        complete(alertVC)
        
    }
    
    
}

