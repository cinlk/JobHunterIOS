//
//  PostArticleModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

import ObjectMapper




internal class articleBaseReqModel{
    
    internal var offset:Int = 0
    internal var limit:Int = 10
    
    init() {}
    
    func getOffset() -> Int{
        return self.offset
        //return self.typeOffset[self.currentType]?.0 ?? 0
    }
    
    func setOffset(offset:Int){
        if offset == 0 {
            // self.typeOffset[self.currentType]?.0 = 0
            self.offset = 0
        }else{
            //self.typeOffset[self.currentType]?.0 += offset
            self.offset += offset
        }
    }
    
    
    func toJSON() -> [String: Any]{
        fatalError()
    }
    
    
    
}

class ArticleReplyReqModel: articleBaseReqModel {
    
    var postId: String = ""
    
    override init() {
        super.init()
    }
    
    
    override func toJSON() -> [String: Any]{
        return ["post_id": self.postId, "offset": self.offset, "limit": 10]
    }
    
}

// 发送请求的实体
class ArticleReqModel: articleBaseReqModel{
    
    var currentType: ForumType = .none
    
    override init() {
        super.init()
    }
    
    
    override func toJSON() -> [String: Any]{
        return ["type": self.currentType.rawValue, "offset": self.offset, "limit": 10]
    }
    
}

// 子回复请求
class SubReplyReqModel: articleBaseReqModel{
    
    var replyId: String = ""
    
    override init() {
        super.init()
    }
    
    override func toJSON() -> [String: Any]{
        return ["reply_id": self.replyId, "offset": self.offset, "limit": 10]
    }
    
}

// 搜索请求
class ForumSearchReq: articleBaseReqModel{
    var word: String = ""
    override init() {
        super.init()
    }
    
    override func toJSON() -> [String: Any]{
        return ["word": self.word, "offset": self.offset, "limit": 10]
    }
}

// http 返回数据
class HttpForumResponse: HttpResultMode{
    
    var uuid:String?
    
    required init?(map: Map) {
        super.init(map: map)
//        if map.JSON["uuid"] == nil{
//            return nil
//        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        uuid <- map["uuid"]
    }
}


class HttpForumSearchResult: NSObject, Mappable{
    
    var words:[String] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        words <- map["words"]
    }
}

class PostBaseModel: NSObject, Mappable{
    
    // 帖子id
    var id:String?
    var title:String?
    var authorID:String?
    var authorName:String?
    var colleage:String?
    var content:String?
    var isLike:Bool = false
    var isCollected:Bool = false 
    
    var authorIcon:URL?
    
    var createTime:Date?
    
    // 关联的用户分组
    var userGroups:[String] = []
    
    
    var createTimeStr:String{
        get{
            guard let time = self.createTime else { return ""}
            if let str = showDayAndHour(date: time){
                return str
            }
            return ""
        }
    }
    
    
    // 点赞
    var thumbUP:Int = 0
    // 回复
    var reply:Int = 0
    // 预览次数
    var read:Int = 0
    
    
    required init?(map: Map) {
//        if map.JSON["id"] == nil  || map.JSON["authorID"] == nil || map.JSON["createTime"] == nil || map.JSON["authorName"] == nil || map.JSON["colleage"] == nil {
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        
        id <- map["uuid"]
        title <- map["title"]
        authorID <- map["user_id"]
        authorName <- map["user_name"]
        content <- map["content"]
        isLike <- map["is_like"]
        isCollected <- map["is_collected"]
        colleage <- map["user_colleage"]
        authorIcon <- (map["user_icon"], URLTransform())
        createTime <- (map["created_time"],DateTransform())
        thumbUP <- map["thumb_up"]
        reply <- map["reply"]
        read <- map["read"]
        userGroups <- map["user_group"]
    }
}


class PostArticleModel: PostBaseModel {
   
    
    // 帖子类型
    var kind:String?
    //var content:String?
    
    var showTag:Bool = false
    
    
    var type:ForumType{
        get{
            guard let  kind = kind, let type = ForumType(rawValue: kind) else {
                return .none
            }
            return type
        }
    }
    
    
    
    required init?(map: Map) {
        super.init(map: map)
//        if  map.JSON["kind"] == nil ||  map.JSON["title"] == nil  {
//                return nil
//        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        
    }
    
    
}



// 第一层回帖
class FirstReplyModel: NSObject, Mappable{
    
    
    var replyID:String?
    var userIcon:URL?
    var userId:String?
    
    var userName:String?
    var colleage:String?
    var createdTime:Date?
    var createdTimeStr:String?{
        get{
            if let time = self.createdTime{
                return showDayAndHour(date: time)
            }
            return ""
        }
    }
    var content:String?
    var likeCount:Int = 0
    var replyCount:Int = 0
    var isLike:Bool = false 
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        replyID <- map["reply_id"]
        userIcon <- (map["user_icon"], URLTransform())
        createdTime <- (map["created_time"], DateTransform())
        colleage <- map["colleage"]
        userName <- map["user_name"]
        userId <- map["user_id"]
        likeCount <- map["like_count"]
        replyCount <- map["reply_count"]
        content <- map["content"]
        isLike <- map["is_like"]
    }
    
    
}



// 子回复(第二层)
class SecondReplyModel: NSObject, Mappable{
    
    var replyId:String?
    var secondReplyId:String?
    
    var content:String?
    var isLike:Bool = false
    var createdTime:Date?
    var createdTimeStr:String{
        get{
            if let time = createdTime, let s = showDayAndHour(date: time){
                return s
            }
            return ""
        }
    }
    var likeCount:Int = 0
    
    var userId:String?
    var userIcon:URL?
    var userName:String?
    
    var talkedUserName:String?
    var talkedUserId:String?
    
    // 区分回复楼主 还是回复其他人的标记
    var toHost:Bool = false
    
    
    required init?(map: Map) {
//        if map.JSON["subreplyID"] == nil || map.JSON["receiver"] == nil{
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        replyId <- map["reply_id"]
        secondReplyId <- map["second_reply_id"]
        content <- map["content"]
        isLike <- map["is_like"]
        createdTime <- (map["created_time"], DateTransform())
        likeCount <- map["like_count"]
        userId <- map["user_id"]
        userIcon <- (map["user_icon"], URLTransform())
        userName <- map["user_name"]
        talkedUserName <- map["talked_user_name"]
        talkedUserId <- map["talked_user_id"]
        toHost <- map["to_host"]
        
    }
}





class UserRelateGroup: Mappable{
    
    var groupId:String?
    var name:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        groupId <- map["group_id"]
        name <- map["name"]
    }
}
//

class PostRelateGroup: Mappable{
    var group:[String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group <- map["group"]
    }
}
