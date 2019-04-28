//
//  visitor.swift
//  internals
//
//  Created by ke.liang on 2019/4/27.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper


class HasNewVisitor: Mappable{
    
    var exist:Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        exist <- map["exist"]
    }
}


class MyVisitors: NSObject, Mappable {
    
    var recruiterId:String?
    var name:String?
    var visitTime:Date?
    var visitTimeStr:String?{
        get{
            guard let time = self.visitTime else { return "" }
            if let  str =  showMonthAndDay(date: time){
                return str
            }
            return ""
        }
    }
    var checked:Bool?
    var company:String?
    var userIcon:URL?
    var title:String?
    
    required init?(map: Map) {
        if map["recruiter_id"] == nil{
            return nil 
        }
    }
    
    func mapping(map: Map) {
        recruiterId <- map["recruiter_id"]
        name <- map["name"]
        visitTime <- (map["visit_time"], DateTransform())
        checked <- map["checked"]
        company <- map["company"]
        userIcon <- (map["user_icon"], URLTransform())
        title <- map["title"]
    }
}


class HttpVisitorReq{
    
    var userId:String = ""
    var offset:Int = 0
    var limit:Int = 10
    
    
    init() {}
    
    func toJSON() -> [String: Any]{
        return ["user_id": userId, "offset": offset, "limit": limit]
    }
}
