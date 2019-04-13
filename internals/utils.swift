//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2019/4/10.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Photos



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
    
    
}

