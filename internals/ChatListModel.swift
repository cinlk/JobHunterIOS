//
//  ChatListModel.swift
//  internals
//
//  Created by ke.liang on 2019/3/11.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper

// 和HR会话model
class ConversationHRModel:NSObject, Mappable{
    
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
//        if map.JSON["upTime"] == nil || map.JSON["message"] == nil || map.JSON["user"] == nil {
//            return nil
//        }
    }
    
    
    func mapping(map: Map) {
        
        user <- map["user"]
        message <- map["message"]
        unReadCount <- map["unReadCount"]
        isUP <- map["isUP"]
        upTime <- (map["upTime"], DateTransform())
    }
    
}

