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
    case RotateImageLayout(iamges:[RotateCategory],width:CGFloat,height:CGFloat)
    
}

// 轮播图数据
internal struct RotateCategory:Mappable {
    
    var imageURL:String?
    var link:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
            imageURL <- map["image_url"]
            link <- map["link"]
    }
    
}



 

internal struct jobField: Mappable{
    var ImageUrl:String?
    var Title:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ImageUrl <- map["image_url"]
        Title <- map["title"]
    }
    
    
}


internal struct latestColumn: Mappable{
    var ImageUrl:String?
    var Title:String?
    var Link:String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ImageUrl <- map["image_url"]
        Title <- map["title"]
        Link <- map["link"]
    }
    
}

internal struct applyField:Mappable{
    var ImageUrl:String?
    var Field:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ImageUrl <- map["image_url"]
        Field <- map["field"]
    }
    
    
}

internal struct latestNews:Mappable{
    var articles:[String] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        articles <- map["top_new"]
    }
    
    
}

internal struct SpecialRecommands:Mappable{
    var news:latestNews?  = nil
    var jobFields:[jobField] = []
    var latestColumns:[latestColumn] = []
    var recruitMeetings: [CareerTalkMeetingModel] = []
    var applyOnlineField:[applyField] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        jobFields <- map["job_field"]
        latestColumns <- map["columns"]
        recruitMeetings <- map["recruit_meeting"]
        applyOnlineField <- map["apply_field"]
        news <- map["news"]
    }
    
  
    
}








