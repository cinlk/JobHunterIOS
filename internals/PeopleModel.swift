//
//  Friends.swift
//  internals
//
//  Created by ke.liang on 2017/10/12.
//  Copyright © 2017年 lk. All rights reserved.
//


import Foundation
import ObjectMapper


// 会话model
class conversationModel:NSObject, Mappable{
    
    // 聊天对象
    var user:HRPersonModel?
    // last message
    var message:MessageBoby?
    var unReadCount:Int?
    
    // 是否置顶会话
    var isUP:Bool = false
    // 最后一条消息时间
    var upTime:Date?
    
    required init?(map: Map) {
        if map.JSON["upTime"] == nil || map.JSON["message"] == nil || map.JSON["user"] == nil {
            return nil
        }
    }
    
    
    func mapping(map: Map) {
        
        user <- map["user"]
        message <- map["message"]
        unReadCount <- map["unReadCount"]
        isUP <- map["isUP"]
        upTime <- (map["upTime"], DateTransform())
    }
    
    
}

// 代表会话个人信息model
class PersonModel:NSObject, Mappable{
    
    var userID:String?
    var name:String?
    
    // 
    //var icon:Data?
    var icon:URL?
    var roles:[String]?
    var identity:String?
    // 屏蔽 不接受和发送信息
   // var isShield:Bool?
    // 用户是否存在
    var isValidate:Bool?
    
    var phone:String?
    
    
    
    required init?(map: Map) {
//        if map.JSON["user_id"] == nil || map.JSON["name"] == nil || map.JSON["roles"] == nil {
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        
        userID <- map["user_id"]
        name <- map["name"]
        
        //base64 转换为data
        //icon <- (map["icon"], DataTransformBase64())
        icon <- (map["user_icon"], URLTransform())
        roles <- map["roles"]
        identity <- map["identity"]
        //isShield <- map["isShield"]
        isValidate <- map["validate"]
        phone <- map["phone"]
        
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




