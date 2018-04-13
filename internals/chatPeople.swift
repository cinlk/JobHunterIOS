//
//  Friends.swift
//  internals
//
//  Created by ke.liang on 2017/10/12.
//  Copyright © 2017年 lk. All rights reserved.
//


import Foundation
import ObjectMapper

private let contacts = "contacts"



// 会话model
class conversationModel:NSObject, Mappable{
    
    // 聊天对象
    var user:PersonModel?
    var userID:String?
    // last message
    var message:MessageBoby?
    var messageID:String?
    var unReadCount:Int?
    
    // 是否置顶会话
    var isUP:Bool?
    var upTime:Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        user <- map["user"]
        userID <- map["userID"]
        messageID <- map["messageID"]
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
    var company:String?
    // 
    var icon:Data?
    // 求职者 还是 职位发布者，还是其他
    var role:String?
    // 屏蔽 不接受和发送信息
    var isShield:Bool?
    // 用户是否存在
    var isExist:Bool?
    
    var phone:String?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        userID <- map["userID"]
        name <- map["name"]
        company <- map["company"]
        //base64 转换为data
        icon <- (map["icon"], DataTransformBase64())
        role <- map["role"]
        isShield <- map["isShield"]
        phone <- map["phone"]
        
    }
    
}

class HRPersonModel: PersonModel {
    
    var ontime:Date?
    var position:String?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        ontime <- (map["ontime"], DateTransform())
        position <- map["position"]
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




