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

// 轮播图数据
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



// 推荐网申数据  
class applyOnlineModel:NSObject,Mappable{
    
    var imageIcon:String?
    var type:String?
    var title:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageIcon <- map["imageIcon"]
        type <- map["type"]
        title <- map["title"]
    }
    
}




