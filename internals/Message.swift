//
//  ImageMessage.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

enum MessgeType:String {
    case none = "none"
    case text = "text"
    case picture = "picture"
    case smallGif =  "smallGif"
    case bigGif = "bigGif"
    case voice = "voice"
    case jobDescribe = "jobDescribe"
    //case personCard = "personCard"
    case time = "time"
    
    
}

enum MessageStatus{
    case read
    case unKnow
    case canceled
}



// 消息结构
class MessageBoby: NSObject, Mappable{
   
    // 时间措和 客户端id 生成 唯一
    var messageID:String?
    //var url:String?
    var type:String?{
        didSet{
            messageType = MessgeType.init(rawValue: type!) ?? .none
        }
    }
    // data 转base64的string
    // 不同类型message可能是json 转data转base64或 文件路径转data 转base64
    //
    var content:Data?
    // Double 转Date
    var creat_time:Date?
    var isRead:Bool?
    
    var sender:PersonModel?
    var receiver:PersonModel?
    
    var messageType:MessgeType = .none
    

    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        
        messageID <- map["messageID"]
        type <- map["type"]
        content <- (map["content"], DataTransformBase64())
        // double 数据转Date
        creat_time <- (map["creat_time"], DateTransform())
        isRead <- map["isRead"]
       
    }
    
    // MARK 处理异常返回 ？？
    func getContent(isConversion:Bool) -> Any{
        // 可能是图片 json 数据，或string
        
         guard let data = content else { return "" }
        
        switch messageType {
            
        case .jobDescribe:
            return  isConversion == true ? "[职位]" : JSON(data: data)
        case .text:
            return  String.init(data: data, encoding: String.Encoding.utf8) ?? ""
        case .picture:
           let url =  URL.init(dataRepresentation: data, relativeTo: nil)
           return  "[图片]"
        case .smallGif,.bigGif:
            return String.init(data: data, encoding: String.Encoding.utf8) ?? ""
            
            
        default:
            break
        }
        
        return ""
    }
    
    // 对job message，获取job描述内容
    func contentToJson() ->JSON?{
    
        return JSON.init(data:  content!)
    }
    
    
}


// 投递职位信息 在聊天界面最上方
class  JobDescriptionlMessage:MessageBoby{
    
    var jobID:String?
    // 照片 base64String
    var icon:String?
    var jobName: String?
    var company:String?
    var salary:String?
    var tags:[String]?
    
  
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        jobID <- map["jobID"]
        icon <- map["icon"]
        jobName <- map["jobName"]
        company <- map["company"]
        salary <- map["salary"]
        tags <- map["tags"]
    }


    
    override var description: String{
        let s1 =  super.description
        guard let jobName = self.jobName, let company = self.company else {
            return s1
        }
        return s1  + " < " + jobName + company + " > "
       
    }
    
    // job描述内容 转换为字典
//    func contentToJson() ->JSON?{
//
//        return JSON.init(data: Data.init(base64Encoded: content!)!)
//    }
    
    func JsonContentToDate()->Data?{
        
       
        let jsonStr:JSON =  ["jobID":self.jobID!, "icon":self.icon!,"jobName":self.jobName!,
                             "company":self.company!, "salary":self.salary!, "tags": self.tags!]
        if  let jsonData =  try? jsonStr.rawData(){
            return jsonData
        }
        return nil
    }
}


//  gif image消息

class  GigImageMessageBody:MessageBoby{
    // 用本地的gif 图片？？还是data 数据
    var localGifPath:String?
    
    required init?(map: Map) {
         super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        localGifPath <- map["localGifPath"]
    }
    

}

extension GigImageMessageBody{
    
    override var description: String{
        
        let s1 =  super.description
        guard let gifPath = self.localGifPath else {
            return s1
        }
        return s1  + " < " + gifPath  + " > "
        
    }
}



// 时间消息 单独抽取显示cell
class TimeBody: MessageBoby{
    
    var timeStr:String?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        timeStr <- map["timeStr"]
    }
    
}


// 图片消息
class PicutreMessage:MessageBoby{
    
    // 存储文件路径
    var imageFilePath:String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        imageFilePath <- map["imageFilePath"]
    }

    
}

