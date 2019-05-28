//
//  personResponseModel.swift
//  internals
//
//  Created by ke.liang on 2019/5/18.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper


class HttpAvatarResModel: Mappable{

    var iconURL:URL?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        iconURL <- (map["icon_url"], URLTransform())
    }
}


class DeliveryJobsModel: NSObject, Mappable{
    
    var type:String?
    var jtype: jobType{
        get{
            return jobType(rawValue: type ?? "") ?? jobType.none
        }
    }
    var jobId:String?
    var jobName:String?
    var createdTime:Date?
    var address:[String]?
    var createdTimeStr:String{
        get{
            return showDayAndHour(date: self.createdTime) ?? ""
        }
    }
    var status:Int = -1
    var resumeStatue:ResumeDeliveryStatus{
        get{
            return ResumeDeliveryStatus(rawValue: status) ?? ResumeDeliveryStatus.none
        }
    }
    var companyName:String?
    var companyIcon:URL?
    var companyId:String?
    
    var feedBack:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        jobId <- map["job_id"]
        jobName <- map["job_name"]
        createdTime <- (map["created_time"], DateTransform())
        status <- map["status"]
        address <- map["address"]
        companyName <- map["company_name"]
        companyId <- map["company_id"]
        companyIcon <- (map["company_icon"], URLTransform())
        feedBack <- map["feed_back"]
    }
}


class DeliveryHistoryStatus: Mappable{
    
    private var time:Date?
    var timeStr:String{
        get{
            return showDayAndHour(date: time) ?? ""
        }
    }
    private var status:Int?
    var resumeStatus: ResumeDeliveryStatus{
        get{
            return ResumeDeliveryStatus(rawValue: status ?? -1)!
        }
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        time <- (map["time"], DateTransform())
        status <- map["status"]
        
    }
}


class OnlineApplyId: Mappable{
    
    var onlineApplyId:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        onlineApplyId <- map["online_apply_id"]
    }
}


class ResumeSubItem:Mappable{
    
    var id:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
}



class AttachResumRes:Mappable{
    var url:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
    }
}


class JobSubscribeItemRes: Mappable{
    
    var id:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
}


class JobSubscribeCondition: Mappable{
    
    var id:String?
    var kind:jobType{
        get{
            return jobType(rawValue: type ?? "")!
        }
    }
    var type:String?
    var fields:String?
    var citys:[String]?
    var cityStr:String{
        get{
            return citys?.joined(separator: "-") ?? ""
        }
    }
    var degree:String?
    var internDay:String?
    var internMonth:String?
    var internSalary:String?
    
    var salary:String?
    var createdTime:Date?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        fields <- map["fields"]
        citys <- map["citys"]
        degree <- map["degree"]
        internDay <- map["intern_day"]
        internMonth <- map["intern_month"]
        internSalary <- map["intern_salary"]
        salary <- map["salary"]
        createdTime <- (map["created_time"], DateTransform())
    }
}
