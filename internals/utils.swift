//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2019/4/10.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Photos
import UserNotifications


class Utils {
    
    // 判断相册使用权限
    static func PhotoLibraryAuthorization() -> Bool{
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        var flag = false
        switch authStatus {
        case .authorized:
            flag = true
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                flag =  status == .authorized ?  true : false
            }
        @unknown default:
            break
        }
        
        return flag
    }
    
//    static  func getCitys(filename:String)->[String:[String]]{
//
//        guard  let filePath = Bundle.main.path(forResource: filename, ofType: "plist")else{
//
//
//            return [:]
//        }
//        guard  let citys = NSDictionary.init(contentsOfFile: filePath) as? [String:[String]] else {
//
//            return [:]
//        }
//
//
//        return citys
//
//
//    }
    
    
//    static func showAlert(error:String, vc:UIViewController){
//        let action = UIAlertAction.init(title: "确定", style: .default, handler: nil)
//        let alertView = UIAlertController.init(title: nil, message: error, preferredStyle: .alert)
//        alertView.addAction(action)
//        vc.present(alertView, animated: true, completion: nil)
//    }

//
//    static  func changeAppBages(number:Int){
//
//        let app = UIApplication.shared
//        let center = UNUserNotificationCenter.current()
//
//        center.requestAuthorization(options: [.badge,.alert,.sound]) { (bool, error) in
//
//        }
//        app.registerForRemoteNotifications()
//        app.applicationIconBadgeNumber = number
//    }
    
    
    
    // open app
    static func openApp(appURL: String, completion: @escaping ((_ success: Bool)->())) {
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
    static func  getUUID()->String{
        return UUID().uuidString.lowercased()
    }

}

