//
//  GuideModel.swift
//  internals
//
//  Created by ke.liang on 2019/2/1.
//  Copyright © 2019 lk. All rights reserved.
//

import ObjectMapper

struct AdViseImage: Mappable {
    
    var imageUrl:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        imageUrl <- map["image_url"]
    }
    
}


struct GuideItems:Mappable {
    
    var imageUrl:String?
    var title:String?
    var detail:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        imageUrl <- map["image_url"]
        detail <- map["detail"]
        title <- map["title"]
    }
    
}



