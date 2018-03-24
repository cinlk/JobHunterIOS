//
//  xiaomiNewsModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/19.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class xiaomiNewsModel: NSObject, Mappable {
    
    var create_time:String?
    var coverPicture:String?
    var describetion:String?
    // TODO
    var tag:[String]?
    var articleURL:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        create_time <- map["create_time"]
        coverPicture <- map["coverPicture"]
        describetion <- map["describetion"]
        articleURL <- map["articleURL"]
        
    }
    
}
