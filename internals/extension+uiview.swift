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


// 提示
extension UIView{
    
    var hub:MBProgressHUD?{
        get{
            return nil
        }
    }
    func showLoading(title:String, customImage:UIImageView?, mode: MBProgressHUDMode){
    
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.minSize=CGSize.init(width: 55, height: 55)
        hud.label.text = title
        hud.mode = mode
        hud.removeFromSuperViewOnHide = true
        hud.customView = customImage
    }
    
    func showToast(title:String, duration:Int = 3, customImage:UIImageView?, mode: MBProgressHUDMode){
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = title
        hud.mode = mode
        hud.hide(animated: true, afterDelay: TimeInterval(duration))
        hud.customView = customImage
        hud.removeFromSuperViewOnHide = true
       
    }
    func hiddenLoading(){
       MBProgressHUD.hide(for: self, animated: true) //hide(for: self, animated: true)
    }
}



// 父级viewcontroller
extension UIView{
    
    func targetViewController(aClass: AnyClass) -> UIViewController?{
        var next=self.superview;
        while(next != nil){
            let nextResponder = next?.next
            if((nextResponder?.isKind(of:aClass)) != nil){
                return nextResponder as? UIViewController
            }
            next=next?.superview
        }
        return nil
    }

}
