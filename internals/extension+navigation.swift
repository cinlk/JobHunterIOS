//
//  extension+navigation.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


extension UINavigationController{
    
    
    func insertCustomerView(_ color: UIColor? = nil, alpha:CGFloat = 1){
        
        if self.view.viewWithTag(1999) == nil{
            let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH))
            // naviagtionbar 默认颜色
            v.backgroundColor =  color ?? UIColor.navigationBarColor()
            v.tag  = 1999
            v.alpha = alpha
            self.view.insertSubview(v, at: 1)
        }
        
    }
    
    
    
    func removeCustomerView(){
        if let v = self.view.viewWithTag(1999){
            v.removeFromSuperview()
            self.view.willRemoveSubview(v)
        }
       
    }
}




// navigationbar 返回按钮事件拦截



public protocol ShouldPopDelegate
{
    func currentViewControllerShouldPop() -> Bool
}

extension UIViewController: ShouldPopDelegate
{
   @objc public func currentViewControllerShouldPop() -> Bool {
        return true
    }
}


private var key:Void?

extension UINavigationController: UINavigationBarDelegate
{
    
    
    
    
    // runtime 添加属性
    var isPoppingProgrammatically: Bool?{
        get{
            return objc_getAssociatedObject(self, &key) as?  Bool
        }
        set(newValue){
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
    }
    
    
    
    // 主动pop
    public func popvc(animated: Bool){
        self.isPoppingProgrammatically = true
        self.popViewController(animated: animated)
    }
    
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool
    {
        //item.ri
        // 主动调用pop 动作，非点击返回按钮
        if let b =  self.isPoppingProgrammatically, b{
            self.isPoppingProgrammatically = false
            return true
        }
        
        var shouldPop = true
        // 看一下当前控制器有没有实现代理方法 currentViewControllerShouldPop
        // 如果实现了，根据当前控制器的代理方法的返回值决定
        // 没过没有实现 shouldPop = YES
        let currentVC = self.topViewController
        //        if (currentVC?.responds(to: #selector(currentViewControllerShouldPop)))! {
        shouldPop = (currentVC?.currentViewControllerShouldPop())!
        //        }
        
        if (shouldPop == true)
        {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
            // 这里要return, 否则这个方法将会被再次调用
            return true
        }
        else
        {
            // 让系统backIndicator 按钮透明度恢复为1
            for subview in navigationBar.subviews
            {
                if (0.0 < subview.alpha && subview.alpha < 1.0) {
                    UIView.animate(withDuration: 0.25, animations: {
                        subview.alpha = 1.0
                    })
                }
            }
            return false
        }
    }
}




extension UINavigationBar{
    
    
    private var v:UIImage {
        return UIImage.init()
    }
    
    private var bgImage:UIImage {
        return UIImage.drawNormalImage(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH), color: UIColor.navigationBarColor())
    }
    
    // change to translucent
    func settranslucent(_ tag: Bool){
        
        //self.tintColor  = UIColor.black
        if tag == true{
            self.setBackgroundImage(v, for: .default)
            self.shadowImage = v
            self.isTranslucent = true
            self.backgroundColor = UIColor.clear
            self.barTintColor = UIColor.clear
        }
        else{
            
            self.setBackgroundImage(bgImage, for: .default)
            self.isTranslucent = false
            
        }
    }
    
}




