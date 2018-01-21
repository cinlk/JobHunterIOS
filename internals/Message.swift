//
//  ImageMessage.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation


enum messgeType:String {
    case text = "text"
    case picture = "picture"
    case smallGif =  "smallGif"
    case bigGif = "bigGif"
    case voice = "voice"
    case jobDetail = "jobDetail"
    case personCard = "personCard"
    case time = "time"
    
    
}

enum MessageStatus{
    case read
    case unKnow
    case canceled
}



//baseMessage 继承  nsobject 和  nscoding
class MessageBoby: NSObject, NSCoding{
    
    var messageID:Int?
    var url:String?
    var content:String
    var time:TimeInterval
    var type:messgeType = .text
    
    var messageStatus:MessageStatus = MessageStatus.unKnow
    
    //    var senderId:String
    //    var targetId:String
    var sender:FriendModel
    var target:FriendModel
    
    
    init(content:String,time:TimeInterval, sender:FriendModel, target:FriendModel) {
        self.content = content
        self.time = time
        self.sender = sender
        self.target = target
        self.type = .text
        
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(sender, forKey: "sender")
        aCoder.encode(target, forKey: "target")
        aCoder.encode(type.rawValue, forKey: "type")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.content =  aDecoder.decodeObject(forKey: "content") as! String
        self.time = aDecoder.decodeDouble(forKey: "time")
        
        //self.time = aDecoder.decodeDouble(forKey: "time")
        if let t = aDecoder.decodeObject(forKey: "type")  as? String{
            self.type = messgeType.init(rawValue: t)!
        }
        self.target = aDecoder.decodeObject(forKey: "target") as! FriendModel
        self.sender = aDecoder.decodeObject(forKey: "sender") as! FriendModel
    }
    
    
}

extension MessageBoby{
    override var description: String{
        return self.content + ":" + self.type.rawValue
    }
}
// copy 实现 ？

class  JobDetailMessage:MessageBoby{
    
    var icon:String
    var jobName: String
    var company:String
    var salary:String
    var tags:String
    
    init?(infos:[String:String]?,time:TimeInterval,sender:FriendModel,target:FriendModel) {
        
        
        
        guard let icon = infos?["icon"] else {
            return nil
        }
        guard let jobName = infos?["jobName"] else {
            return nil
        }
        
        guard let company = infos?["company"] else {
            return nil
        }
        guard  let salary = infos?["salary"] else {
            return nil
        }
        guard let tags = infos?["tags"] else {
            return nil
        }
        self.icon = icon
        self.jobName = jobName
        self.company = company
        self.salary = salary
        self.tags = tags
        super.init(content: "", time: time, sender: sender, target: target)
        type = .jobDetail
        
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(jobName, forKey: "jobName")
        aCoder.encode(company, forKey: "company")
        aCoder.encode(salary, forKey: "salary")
        aCoder.encode(tags, forKey: "tags")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.icon =  aDecoder.decodeObject(forKey: "icon") as! String
        self.jobName =  aDecoder.decodeObject(forKey: "jobName") as! String 
        self.company =  aDecoder.decodeObject(forKey: "company") as! String
        self.salary =  aDecoder.decodeObject(forKey: "salary") as! String
        self.tags =  aDecoder.decodeObject(forKey: "tags") as! String
        super.init(coder: aDecoder)
        
    }
    
    open func toDict()->Dictionary<String,String>{
        return ["icon": self.icon , "jobName": self.jobName, "company": self.company, "salary":self.salary,
                "tags": self.tags]
    }
    
    override var description: String{
        return self.icon  + ":" + self.jobName
    }
}


//  gif image message

class  imageMessageBody:MessageBoby{
    
    var imgPath:String
    
    init(time:TimeInterval, path:String,content:String,sender:FriendModel, target:FriendModel, type:messgeType) {
        imgPath = path
        super.init(content: content, time: time, sender: sender , target: target)
        self.type = type
        
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(imgPath, forKey: "imgPath")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.imgPath = aDecoder.decodeObject(forKey: "imgPath") as! String
        super.init(coder: aDecoder)
        
    }
}

extension imageMessageBody{
    override var description: String{
        return self.imgPath + ":" + self.type.rawValue
    }
}


class TimeMessageBody: MessageBoby{
    
    
    var timeStr:String?
    
    init(time: TimeInterval, sender: FriendModel, target: FriendModel) {
        super.init(content: "", time: time, sender: sender, target: target)
        self.type = .time
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class PersonCardMessage:MessageBoby{
    
    
    var name:String
    var image:String
    
    init(name:String,image:String,time:TimeInterval, sender:FriendModel, target:FriendModel) {
        self.name = name
        self.image = image
        super.init(content: "", time: time, sender: sender, target: target)
        self.type = .personCard
    }
    
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as! String
        super.init(coder: aDecoder)
    }
    
}



class CameraImageMessage:MessageBoby{
    
    var imageData:NSData
    
    
    init(imageData:NSData, time:TimeInterval, sender:FriendModel, target:FriendModel){
        
        self.imageData = imageData
        super.init(content: "", time: time, sender: sender, target: target)
        self.type = .picture
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(imageData, forKey: "imageData")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.imageData = aDecoder.decodeObject(forKey: "imageData") as! NSData
        super.init(coder: aDecoder)
    }
    
    
    
}

