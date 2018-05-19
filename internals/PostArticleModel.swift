//
//  PostArticleModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

import ObjectMapper



class PostBaseModel: NSObject, Mappable{
    
    
    
    var id:String?
    var title:String?
    var authorID:String?
    var authorName:String?
    var authorIcon:String = "default"
    var createTime:Date?
    var createTimeStr:String{
        get{
            guard let time = self.createTime else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd HH:MM"
            
            let str = dateFormat.string(from: time)
            return str
        }
    }
    
    
    // 点赞
    var thumbUP:Int = 0
    // 回复
    var reply:Int = 0
    
    
    
    required init?(map: Map) {
        if map.JSON["id"] == nil  || map.JSON["authorID"] == nil || map.JSON["createTime"] == nil || map.JSON["authorName"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
        authorID <- map["authorID"]
        authorName <- map["authorName"]
        authorIcon <- map["authorIcon"]
        createTime <- (map["createTime"],DateTransform())
        thumbUP <- map["thumbUP"]
        reply <- map["reply"]
    }
}


class PostArticleModel: PostBaseModel {
   
    
    // 帖子类型
    var kind:String?
    //var content:String?
    
    
    
    var type:forumType{
        get{
            guard let  kind = kind, let type = forumType(rawValue: kind) else {
                return .none
            }
            return type
        }
    }
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        if  map.JSON["kind"] == nil ||  map.JSON["title"] == nil  {
                return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        
    }
    
    
}

class PostContentModel:PostBaseModel{
    
    
   
    // 自己是否点赞
    var isLike:Bool = false
    var content:String?
    var images:[String]?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["content"] == nil ||  map.JSON["title"] == nil || map.JSON["isLike"] == nil {
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        content <- map["content"]
        images <- map["images"]
        isLike <- map["isLike"]
    }
    
    
}

// 第一层回帖
class FirstReplyModel: PostBaseModel{
    
    // 自己是否点赞
    var isLike:Bool = false
    var replyContent:String?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["replyContent"] == nil || map.JSON["isLike"] == nil   {
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        replyContent <- map["replyContent"]
        isLike <- map["isLike"]
    }
    
    
}

// 子回复(第二层)
class SecondReplyModel: NSObject, Mappable{
    
    var parentReplyID:String?
    var sender:String?
    var receiver:String?
    var content:String?
    
    
    required init?(map: Map) {
        if map.JSON["parentReplyID"] == nil ||  map.JSON["sender"] == nil || map.JSON["receiver"] == nil
            || map.JSON["content"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        parentReplyID <- map["parentReplyID"]
        sender <- map["sender"]
        receiver <- map["receiver"]
        content <- map["content"]
        
    }
}


