//
//  MBHubUtils.swift
//  internals
//
//  Created by ke.liang on 2018/4/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

import MBProgressHUD




// ***** Hub 提示框 ****** //
func showOnlyTextHub(message:String, view:UIView, second:Double = 2){
    
    let hub = MBProgressHUD.showAdded(to: view, animated: true)
    hub.mode = .text
    
    hub.label.text = message
    // 黑色半透明
    hub.bezelView.backgroundColor = UIColor.backAlphaColor()
    hub.margin = 5
    hub.label.textColor = UIColor.white
    hub.removeFromSuperViewOnHide = true
    hub.hide(animated: true, afterDelay: second)
    
}


func showCustomerImageHub(message:String, view:UIView,image:UIImage){
    
    let hub = MBProgressHUD.showAdded(to: view, animated: true)
    hub.mode = .customView
    let imageView = UIImageView.init()
    // 如何改变image 的颜色？？
    imageView.image = image.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
    imageView.tintColor = UIColor.white
    hub.customView = imageView
    hub.label.text = message
    // 黑色半透明
    hub.bezelView.backgroundColor = UIColor.backAlphaColor()
    hub.margin = 10
    hub.label.textColor = UIColor.white
    hub.removeFromSuperViewOnHide = true
    hub.hide(animated: true, afterDelay: 2)
}

// 进度条
func  showProgressHun(message:String, view:UIView) -> MBProgressHUD{
    let hub = MBProgressHUD.showAdded(to: view, animated: true)
    hub.mode = .indeterminate
    hub.label.text = message
    hub.label.textColor = UIColor.white
    hub.margin = 10
    hub.removeFromSuperViewOnHide = true
    hub.bezelView.backgroundColor = UIColor.backAlphaColor()

    return hub
    
    
    
}
