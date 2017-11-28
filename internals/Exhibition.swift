//
//  Exhibition.swift
//  internals
//
//  Created by ke.liang on 2017/11/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import ObjectMapper


enum ItemLayout{
    case RotateImageLayout(iamges:[RotateImages],width:CGFloat,height:CGFloat)
    
}

struct RotateImages:Mappable {
    
    var imageURL:String?
    var body:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
            imageURL <- map["imageURL"]
            body <- map["body"]
    }
    
    
}

