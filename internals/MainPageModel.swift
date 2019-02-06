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

protocol ImageBanner{
    var imageURL:String? {get set}
    var link:String? {get set}
}

// 轮播图数据
internal struct RotateCategory:Mappable, ImageBanner {
    
    var imageURL:String?
    var link:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
            imageURL <- map["image_url"]
            link <- map["link"]
    }
    
}







internal class JobField: Mappable{
    var ImageUrl:String?
    var Title:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ImageUrl <- map["image_url"]
        Title <- map["title"]
    }
    
    
}


internal class latestColumn: JobField{
    
    var Link:String?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
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
    var articles: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        articles <- map["title"]
    }
    
    
}

// 组合 数据
internal struct SpecialRecommands:Mappable{
    
    var news:[latestNews]  = []
    var jobFields:[JobField] = []
    var latestColumns:[latestColumn] = []
    var recruitMeetings: [CareerTalkMeetingModel] = []
    var applyOnlineField:[applyField] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        jobFields <- map["job_category"]
        latestColumns <- map["top_jobs"]
        recruitMeetings <- map["career_talk"]
        applyOnlineField <- map["apply_classify"]
        news <- map["news"]
    }
    
  
    
}








