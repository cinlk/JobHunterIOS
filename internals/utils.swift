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

// 
struct showitem {
    
    var name:String?
    var image:String?
    var bubbles:Int?
    
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




// application bages, notificaion bages?

public func changeAppBages(number:Int){
    
    let app = UIApplication.shared
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.badge,.alert,.sound]) { (bool, error) in
        
    }
    app.registerForRemoteNotifications()
    app.applicationIconBadgeNumber = number
}






// open app
func openApp(appURL: String, completion: @escaping ((_ success: Bool)->())) {
    guard let url = URL(string: appURL) else {
        completion(false)
        return
    }
    guard #available(iOS 10, *) else {
        completion(UIApplication.shared.openURL(url))
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
}

// 生成uuid
func  getUUID()->String{
    return UUID().uuidString.lowercased()
}


