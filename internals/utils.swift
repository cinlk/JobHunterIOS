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




// 输入验证
enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}

