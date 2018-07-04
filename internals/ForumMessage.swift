//
//  ForumMessage.swift
//  internals
//
//  Created by ke.liang on 2018/7/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper



class ForumBodyMessage:NSObject, Mappable{
    
    enum actionType:String {
        case thumbUP = "thumbup"
        case reply = "reply"
        case none = ""
        
        var describe:String{
            get{
                switch  self {
                case .thumbUP:
                    return "赞"
                case .reply:
                    return "回复"
                default:
                    return ""
                }
            }
        }
    }
        
    
    //  回复内容 (回帖，回复评论，赞没有回复内容)
    var replyContent:String?
    
    var type:actionType?{
        get{
            guard let type = actionType(rawValue: self.action) else {
                return .none
            }
            return type
        }
    }
    
    // 赞 或  回复
    var action:String = ""
    // 帖子,  回帖  和 评论
    var target:String?
    
    var kind:postKind{
        get{
            guard let type = postKind(rawValue: self.target!) else {
                return .none
            }
            return type
        }
    }
    
    //
    
    // 谁发给我
    var senderName:String?
    
    // 我发送给谁
    var receiverName:String?
    
    // 帖子标题 或 回帖内容  或 评论内容
    var title:String?
    
    required init?(map: Map) {
        
        if map.JSON["action"] == nil  ||
            map.JSON["title"] == nil || map.JSON["target"] == nil{
            return nil
        }
        
        if (map.JSON["action"] as! String) == "reply" && map.JSON["replyContent"] == nil {
            return nil
        }
    }
    
    
    func mapping(map: Map) {
        
        replyContent <- map["replyContent"]
        action <- map["action"]
        target <- map["target"]
        senderName <- map["senderName"]
        receiverName <- map["receiverName"]
        
        title <- map["title"]
        
        
    }
}

class ForumMessage: NSObject, Mappable {
    
    
    // 帖子id
    var postId:String?
    
    // 回帖id
    var firstCommentID:String?
    
    // 评论id
    var subReplyID:String?
    
    
    // 消息体
    var body:ForumBodyMessage?
    
    var time:Date?
    
    var timeStr:String?{
        get{
            if let time = showDayAndHour(date: time){
                return time
            }
            return ""
        }
    }
    
    
    
    required init?(map: Map) {
        if map.JSON["postId"] == nil || map.JSON["firstCommentID"] == nil || map.JSON["body"] == nil  || map.JSON["time"] == nil{
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        postId <- map["postId"]
        firstCommentID <- map["firstCommentID"]
        body <- map["body"]
        subReplyID <- map["subReplyID"]
        time <- (map["time"], DateTransform())
        
    }
}
