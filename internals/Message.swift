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
    
    
}

enum MessageStatus{
    case read
    case unKnow
    case canceled
}


//baseMessage 继承  nsobject 和  nscoding
class MessageBoby: NSObject,NSCoding{
    
    var messageID:Int?
    var url:String?
    var content:String
    var time:String
    var type:messgeType = .text
    
    var messageStatus:MessageStatus = MessageStatus.unKnow
    
    //    var senderId:String
    //    var targetId:String
    var sender:FriendModel
    var target:FriendModel
    
    
    init(content:String,time:String, sender:FriendModel, target:FriendModel) {
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
        self.time = aDecoder.decodeObject(forKey: "time") as! String
        if let t = aDecoder.decodeObject(forKey: "type")  as? String{
            self.type = messgeType.init(rawValue: t)!
        }
        self.target = aDecoder.decodeObject(forKey: "target") as! FriendModel
        self.sender = aDecoder.decodeObject(forKey: "sender") as! FriendModel
    }
    
    
}

extension MessageBoby{
    override var description: String{
        return self.content + self.type.rawValue
    }
}

//
class  JobDetailMessage:MessageBoby{
    
    private var icon:String
    private var JobName: String
    private var company:String
    private var salary:String
    private var tags:String
    
    init?(infos:[String:String]?,time:String,sender:FriendModel,target:FriendModel) {
        
        
        
        guard let Icon = infos?["icon"] else {
            return nil
        }
        guard let jobName = infos?["jobName"] else {
            return nil
        }
        
        guard let Company = infos?["company"] else {
            return nil
        }
        guard  let Salary = infos?["salary"] else {
            return nil
        }
        guard let Tags = infos?["tags"] else {
            return nil
        }
        icon = Icon
        JobName = jobName
        company = Company
        salary = Salary
        tags = Tags
        super.init(content: "", time: time, sender: sender, target: target)
        type = .jobDetail
        
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(content, forKey: "icon")
        aCoder.encode(content, forKey: "JobName")
        aCoder.encode(content, forKey: "company")
        aCoder.encode(content, forKey: "salary")
        aCoder.encode(content, forKey: "tags")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.icon =  aDecoder.decodeObject(forKey: "icon") as! String
        self.JobName =  aDecoder.decodeObject(forKey: "JobName") as! String
        self.company =  aDecoder.decodeObject(forKey: "company") as! String
        self.salary =  aDecoder.decodeObject(forKey: "salary") as! String
        self.tags =  aDecoder.decodeObject(forKey: "tags") as! String
        super.init(coder: aDecoder)
        
    }
}




class ImageBody:NSCoder{
    
    var image:NSData?
    var avatar:String?
    
    init(image:NSData, avatar:String){
        self.image = image
        self.avatar = avatar
    }
    
    
}

