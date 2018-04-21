//
//  simpleRecuitModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

import ObjectMapper


class simpleRecruitModel:NSObject,Mappable{
    
    var image:String?
    var title:String?
    var des:String?
    var time:Date?
    
    var startTime:String{
        get {
            guard let time = self.time else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm "
            
            let str = dateFormat.string(from: time)
            return str
        }
    }
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        title <- map["title"]
        des <- map["des"]
        time <- (map["time"], DateTransform())
        
    }
}


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
