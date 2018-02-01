//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2017/12/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import SwiftDate
import UserNotifications

//
public func  build_image(frame: CGRect, color:UIColor)->UIImage{
    
    UIGraphicsBeginImageContext(frame.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(frame)
    
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
    
    
    
}



public func getCitys(filename:String)->[String:[String]]{
    
    guard  let filePath = Bundle.main.path(forResource: filename, ofType: "plist")else{
        
        
        return [:]
    }
    guard  let citys = NSDictionary.init(contentsOfFile: filePath) as? [String:[String]] else {
        
        return [:]
    }
    
    return citys
    
    
}


func showAlert(error:String, vc:UIViewController){
    let action = UIAlertAction.init(title: "确定", style: .default, handler: nil)
    let alertView = UIAlertController.init(title: nil, message: error, preferredStyle: .alert)
    alertView.addAction(action)
    vc.present(alertView, animated: true, completion: nil)
}




struct showitem {
    
    var name:String?
    var image:String?
    var bubbles:Int?
    
}



func buildStackItemView(items:[showitem]?, ItemRowNumbers:Int, mainStack:UIStackView?, itemButtons:inout [UIButton]?){
    guard let items = items else {
        return
    }
    let count = items.count
    let row = count / ItemRowNumbers + (count % ItemRowNumbers == 0 ? 0: 1)
    
    var start = 0
    var step = ItemRowNumbers
    
    for i in 0..<row{
        let  stack = UIStackView.init()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        //
        start = i*ItemRowNumbers
        if i == row - 1 {
            step = min(start + ItemRowNumbers, count) - ItemRowNumbers
        }
        for index in start..<start + step{
            let view = UIView.init(frame: CGRect.zero)
            view.backgroundColor = UIColor.white
            let btn = UIButton.init()
            btn.tag = index
            let img = UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: items[index].image!)
            btn.setImage(img, for: .normal)
            btn.backgroundColor = UIColor.clear
            
            itemButtons?.append(btn)
            
            let  lable = UILabel.init()
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.text =  items[index].name
            lable.textAlignment = .center
            
            view.addSubview(btn)
            view.addSubview(lable)
            
            _ = btn.sd_layout().leftSpaceToView(view,10)?.rightSpaceToView(view,10)?.topSpaceToView(view,5)?.heightIs(45)
            _ = lable.sd_layout().topSpaceToView(btn,2)?.leftEqualToView(btn)?.rightEqualToView(btn)?.bottomSpaceToView(view,5)
            
            stack.addArrangedSubview(view)
        }
        
        mainStack?.addArrangedSubview(stack)
    }
    
    
}


// application bages, notificaion bages?

public func changeAppBages(number:Int){
    
    let app = UIApplication.shared
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.badge,.alert,.sound]) { (bool, error) in
        
    }
    app.registerForRemoteNotifications()
    app.applicationIconBadgeNumber = number
}



