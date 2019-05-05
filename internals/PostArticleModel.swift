//
//  PostArticleModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

import ObjectMapper



// 发送请求的实体
class ArticleReqModel{
    
    var currentType: ForumType = .none
    
    private var offset:Int = 0
    private var limit:Int = 10
//    private var typeOffset: [ForumType: (Int, Int)] = [ForumType.help:(0, 10), ForumType.interview: (0,10), ForumType.offers: (0,10)]
//
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
        return ["type": self.currentType.rawValue, "offset": self.offset, "limit": 10]
    }
    
}


class PostBaseModel: NSObject, Mappable{
    
    // 帖子id
    var id:String?
    var title:String?
    var authorID:String?
    var authorName:String?
    var colleage:String?
    
    var authorIcon:URL?
    
    var createTime:Date?
    
    
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
        colleage <- map["user_colleage"]
        authorIcon <- (map["user_icon"], URLTransform())
        createTime <- (map["created_time"],DateTransform())
        thumbUP <- map["thumb_up"]
        reply <- map["reply"]
        read <- map["read"]
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

class PostContentModel:PostBaseModel{
    
    
    // 自己是否点赞
    var isLike:Bool = false
    var collected:Bool = false
    var content:String?
    // 内容带图片？？ MARK
    var images:[String]?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["content"] == nil ||  map.JSON["title"] == nil || map.JSON["isLike"] == nil  ||
            map.JSON["collected"] == nil {
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        content <- map["content"]
        images <- map["images"]
        isLike <- map["isLike"]
        collected <- map["collected"]
    }
    
    
}

// 第一层回帖
class FirstReplyModel: PostBaseModel{
    
    
    // 自己的id
    var replyID:String?
    
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
        replyID <- map["replyID"]
        replyContent <- map["replyContent"]
        isLike <- map["isLike"]
    }
    
    
}

// 子回复(第二层)
class SecondReplyModel: FirstReplyModel{
    

   
    var receiver:String?
    var subreplyID:String?
    
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["subreplyID"] == nil || map.JSON["receiver"] == nil{
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        receiver <- map["receiver"]
        subreplyID <- map["subreplyID"]
        
        
    }
}


