//
//  ImageMessage.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import ObjectMapper

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
    var isRead:Bool = false
    
    var talkTime:String{
        get{
            guard let time = creat_time else {
                return ""
            }
            
            
            return chatListTime(date: time) ?? ""
            
            
        }
    }
    var sender:PersonModel?
    var receiver:PersonModel?
    
    var messageType:MessgeType = .none

    

    required init?(map: Map) {
       if map.JSON["messageID"] == nil || map.JSON["type"] == nil || map.JSON["creat_time"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        messageID <- map["messageID"]
        type <- map["type"]
        content <- (map["content"], DataTransformBase64())
        // double 数据转Date
        creat_time <- (map["creat_time"], DateTransform())
        isRead <- map["isRead"]
        sender <- map["sender"]
        receiver <- map["receiver"]
       
    }
    
    // MARK 处理异常返回 ？？
    func getDescribe() -> String{
        // 可能是图片 json 数据，或string
        
         guard let data = content else { return "" }
        
        switch messageType {
            
        case .jobDescribe:
            return   "[职位]"
        case .text:
            return  String.init(data: data, encoding: String.Encoding.utf8) ?? ""
        case .picture:
           //let url =  URL.init(dataRepresentation: data, relativeTo: nil)
           return  "[图片]"
        case .smallGif,.bigGif:
            return String.init(data: data, encoding: String.Encoding.utf8) ?? ""
            
            
        default:
            break
        }
        
        return ""
    }
    
  
    
}


// 投递职位信息 在聊天界面最上方
class  JobDescriptionlMessage:MessageBoby{
    
    var jobID:String?
    // 照片 base64String
    var icon:String = "job_default"
    var jobName: String?
    var company:String = ""
    var salary:String = ""
    var tags:[String] = []
    
    // 职位类型
    var jobtype:jobType{
        get{
            if let type =  jobType(rawValue: jobTypeDes){
                return type
            }
            return .none
        }
    }
    
    
    
    var jobTypeDes:String = ""
    
  
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["jobID"] == nil || map.JSON["jobName"] == nil || map.JSON["company"] == nil
        || map.JSON["jobTypeDes"] == nil {
            return nil 
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        jobID <- map["jobID"]
        icon <- map["icon"]
        jobName <- map["jobName"]
        company <- map["company"]
        salary <- map["salary"]
        tags <- map["tags"]
        jobTypeDes <- map["jobTypeDes"]
        
    }

    

    
    //  json 转为 data 放到content 中
    func JsonContentToDate()->Data?{
        
       
        let jsonStr:[String:Any] =  ["jobID":self.jobID!, "icon":self.icon,"jobName":self.jobName!,
                                     "company":self.company , "salary":self.salary, "tags": self.tags,"jobTypeDes":self.jobTypeDes]
        

        
        if let data =  try? JSONSerialization.data(withJSONObject: jsonStr, options: .prettyPrinted){
            return data
        }
        return nil
    }
    
    
    
}


//  gif image消息

class  GigImageMessage:MessageBoby{
    // 用本地的gif 资源路径
    var localGifPath:String?
    
    required init?(map: Map) {
         super.init(map: map)
        if map.JSON["localGifPath"] == nil{
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        localGifPath <- map["localGifPath"]
    }
    

}




// 时间消息 单独抽取显示cell
class TimeMessage: MessageBoby{
    
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
    
    // 存储照片名字（文件系统查找指定路劲下的名字）
    var imageFileName:String?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["imageFileName"] == nil{
            return
        }
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        imageFileName <- map["imageFileName"]
    }

    
}

