//
//  Friends.swift
//  internals
//
//  Created by ke.liang on 2017/10/12.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation


class FriendData{
    
    var name:String!
    var id:String?
    var avart:String!
    var lastmessage:String?
    
    
    init(name:String,avart:String) {
        self.name = name
        self.avart = avart
    }
    
    
    func setLastMessage(mes:String){
        self.lastmessage = mes
    }
    
    func getDays()->String{
        return "10-12"
    }
    
    
}


enum messgeType:String {
    case text = "text"
    case picture = "picture"
    case voice = "voice"
    
}

enum MessageStatus{
    case read
    case unKnow
    case canceled
}

class MessageBoby{
    
    var messageID:Int?
    var url:String?
    var content:String!
    var time:String!
    var messageStatus:MessageStatus = MessageStatus.unKnow
    
    var sender:FriendData = FriendData.init(name: "lk", avart: "lk")
    var target:FriendData = FriendData.init(name: "locky", avart: "avartar")
    
    init(content:String,time:String) {
        self.content = content
        self.time = time
    }
    
}
