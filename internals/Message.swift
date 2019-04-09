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
    
    var describe:String{
        switch self {
        case .text:
            return "text"
        case .picture:
            return "picture"
        case .smallGif:
            return "smallGif"
        case .bigGif:
            return "bigGif"
        case .voice:
            return "voice"
        case .jobDescribe:
            return "jobDescribe"
        case .time:
            return "time"
        default:
            return ""
        }
    }
    
}

enum MessageStatus{
    case read
    case unKnow
    case canceled
}


// 单聊
class SingleConversation: NSObject, Mappable{
    
    var conversationId:String?
    // 我的id
    var myid:String?
    // hr的id
    var recruiterId:String?
    var jobId:String?
    var createdTime:Date?
    var upTime:Date?
    var isUp:Bool = false 
    
    // recuiter 信息
    var recruiterName:String?
    var recruiterIconURL:URL?
    
    
    
    required init?(map: Map) {
        if map.JSON["conversation_id"] == nil{
            return nil 
        }
    }
    
    func mapping(map: Map) {
        conversationId <- map["conversation_id"]
        myid <- map["my_id"]
        recruiterId <- map["recruiter_id"]
        jobId <- map["job_id"]
        createdTime <- (map["created_time"], DateTransform())
        upTime <- (map["up_time"], DateTransform())
        isUp <- map["is_up"]
        recruiterName <- map["recruiter_name"]
        recruiterIconURL <- (map["recruiter_icon_url"], URLTransform())
        
    }
}


class ChatListModel: SingleConversation{
    
    // 未读消息个数 TODO
    var unReadNum:Int?
    
    var lastMessage:MessageBoby?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        lastMessage <- map["last_message"]
        unReadNum <- map["un_read_num"]
    }
}

// 消息结构
class MessageBoby: NSObject, Mappable{
   
    // 时间措和 客户端id 生成 唯一
    //var messageID:String?
    //var url:String?
    var conversayionId:String?
    
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
    // 接受的消息才有
    var isRead:Bool = false
    
    var talkTime:String{
        get{
            guard let time = creat_time else {
                return ""
            }
            
            return chatListTime(date: time) ?? ""
        }
    }
    var senderId:String?
    var receiveId:String?
    
    //var sender:PersonModel?
    //var receiver:PersonModel?
    
    var messageType:MessgeType = .none

    

    required init?(map: Map) {
    
       // 除了time message 除外
       
       if map.JSON["conversation_id"] == nil || map.JSON["sender_id"] == nil || map.JSON["receiver_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        //messageID <- map["messageID"]
        conversayionId <- map["conversation_id"]
        type <- map["type"]
        
        content <- (map["content"], DataTransformBase64())
        // double 数据转Date
        creat_time <- (map["creat_time"], DateTransform())
        isRead <- map["is_read"]
        //sender <- map["sender"]
        //receiver <- map["receiver"]
        senderId <- map["sender_id"]
        receiveId <- map["receiver_id"]
       
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
    var salary:String = "面谈"
    var tags:[String] = []
    
    // 职位类型
    var jobtype:jobType{
        get{
            if let type =  jobType(rawValue: jobTypeDes){
                return type
            }
            return jobType.getType(name: jobTypeDes)
            
        }
    }
    
    
    
    var jobTypeDes:String = ""
    
  
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["job_id"] == nil || map.JSON["job_name"] == nil || map.JSON["company"] == nil
        || map.JSON["job_type_des"] == nil {
            return nil 
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        jobID <- map["job_id"]
        // url
        icon <- map["icon"]
        jobName <- map["job_name"]
        company <- map["company"]
        salary <- map["salary"]
        tags <- map["tags"]
        jobTypeDes <- map["job_type_des"]
        
    }

    

    
    //  json 转为 data 放到content 中
    func JsonContentToDate()->Data?{
        
       
        let jsonStr:[String:Any] =  ["job_id":self.jobID!, "icon":self.icon,"job_name":self.jobName!,
                                     "company":self.company , "salary":self.salary, "tags": self.tags,"job_type_des":self.jobTypeDes]
        

        if let data =  try? JSONSerialization.data(withJSONObject: jsonStr, options: .prettyPrinted){
            return data
        }
        return nil
    }
    
    
    
}


//  gif image消息

class  GifImageMessage:MessageBoby{
    // 用本地的gif 资源路径,  或者网络url地址
    var localGifName:String?
    
    required init?(map: Map) {
         super.init(map: map)
        if map.JSON["local_gif_name"] == nil{
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        localGifName <- map["local_gif_name"]
    }
    

    func pathToData() -> Data?{
        
        return self.localGifName?.data(using: String.Encoding.utf8, allowLossyConversion: false)
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

    func pathToData() -> Data?{
        
        return self.imageFileName?.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
    
}

