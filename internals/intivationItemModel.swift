//
//  intivationItemModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper

class InvitationModel:NSObject,Mappable{
    
    enum item:String {
        case permit = "permit"
        case email = "email"
        case sms = "sms"
        case none = ""
        
        var describe:String{
            get{
                switch self {
                case .email:
                    return "邮箱"
                case .permit:
                    return "开启邀请"
                case .sms:
                    return "短信"
                default:
                    return ""
                }
            }
        }
    }
    // 是否开启邀请
    internal var permit:Bool?
    
    // 通知方式
    internal var openEmail:Bool?
    
    internal var openSms:Bool?
    
    
    
    
    required init?(map: Map) {
        if map.JSON["permit"] == nil || map.JSON["openEmail"] == nil ||
            map.JSON["openEmail"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        permit <- map["permit"]
        openEmail <- map["openEmail"]
        openSms <- map["openSms"]
        
    }
    
    
    func changeValue(name:String, value:Bool){
        switch name {
        case "短信":
            self.openSms = value
        case "邮箱":
            self.openEmail = value
        case "开启邀请":
            self.permit = value
        default:
            break
        }
    }
    
    func getItems()->[(InvitationModel.item,Bool)]{
        
        return [(InvitationModel.item.permit, self.permit!),
                 (InvitationModel.item.email, self.openEmail!),
                 (InvitationModel.item.sms, self.openSms!)]
        
    }
    
    
    
}






class BaseInviteModel:NSObject, Mappable{
    
    
    internal var company:String?
    internal var content:String?
    
    internal var time:Date?
    internal var creatTimeStr:String{
        get{
            guard let time = self.time else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd"
            let str = dateFormat.string(from: time)
            return str
        }
    }
    
    required init?(map: Map) {
        if  map.JSON["content"] == nil || map.JSON["time"] == nil{
            return nil
        }
    }
    
    func mapping(map: Map) {
        company <- map["company"]
        content <- map["content"]
        time <- (map["time"], DateTransform())
    }
}

// 宣讲会邀请model
class CarrerTalkInviteModel:BaseInviteModel{
    
    
    internal var meetingID:String?
    
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["meetingID"] == nil || map.JSON["company"] == nil{
            return nil
        }
    }
    
   override  func mapping(map: Map) {
        super.mapping(map: map)
        meetingID <- map["meetingID"]
    
    }
    
    
}


class JobInviteModel: BaseInviteModel{
    
    
    internal var jobID:String?
    internal var jobtype:String?
    
    internal var type:jobType{
        get{
            guard let type = jobType(rawValue: jobtype!) else {
                return .none
            }
            return type
        }
    }
    
    // 可以是hr 或 公司名称
    internal var hr:String?
    // 谁邀请
    internal var title:String{
        get{
            guard let hr = hr else {
                guard  let company = company else {
                    return ""
                }
                return company
            }
            return hr
        }
    }
    
   
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["jobID"] == nil || map.JSON["jobtype"] == nil{
            return nil
        }
        if map.JSON["hr"] == nil && map.JSON["company"] == nil{
            return nil
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        hr <- map["hr"]
        jobID <- map["jobID"]
        jobtype <- map["jobtype"]
        
        
    }
}














