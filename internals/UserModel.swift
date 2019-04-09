//
//  Friends.swift
//  internals
//
//  Created by ke.liang on 2017/10/12.
//  Copyright © 2017年 lk. All rights reserved.
//


import Foundation
import ObjectMapper




// 代表会话个人信息model
class PersonModel:NSObject, Mappable{
    
    var userID:String?
    var name:String?
    var account:String?
    var icon:URL?
    var role: String?
    // leancloud 账号
    var leanCloudId:String?
    
    // 加密存储
    var password:String?
    
    
    required init?(map: Map) {
//        if map.JSON["user_id"] == nil || map.JSON["name"] == nil || map.JSON["roles"] == nil {
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        
        userID <- map["user_id"]
        name <- map["name"]
        icon <- (map["user_icon"], URLTransform())
        role <- map["role"]
        account <- map["account"]
        password <- map["password"]
        leanCloudId <- map["lean_cloud_account"]
        
    }
    
}

class HRPersonModel: PersonModel {
    
    var online:Date?
    var title:String?
    var company:String?
    
    var  ontimeStr:String{
        get{
            guard let time = online  else {
                return ""
            }
            return personOnlineTime(date: time)
            
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
//        if map.JSON["online"] == nil || map.JSON["title"] == nil{
//            return nil
//        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        online <- (map["online_time"], DateTransform())
        title <- map["title"]
        company <- map["company"]
    }
    
    
    
    
}

// 聊天列表显示的model
class ListPersonModel:NSObject, Mappable{
    
    var person:PersonModel?
    var messages:MessageBoby?
    
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        person <- map["person"]
        messages <- map["messages"]
    }
    
    
}




