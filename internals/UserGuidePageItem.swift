//
//  UserGuidePageItem.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class UserGuidePageItem: NSObject, Mappable {

    
    var imageName: String?
    var title: String?
    var detail: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageName <- map["imageName"]
        title <- map["title"]
        detail <- map["detail"]
    }
    
    
}
