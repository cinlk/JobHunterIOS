//
//  collectedModel.swift
//  internals
//
//  Created by ke.liang on 2019/5/26.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper



class CollectedJobModel:NSObject, Mappable{
    
    var jobId:String?
    var kind:jobType = .none
    
    var iconUrl:URL?
    var companyName:String?
    var name:String?
    var createdTime:Date?
    var createdTimeStr:String{
        get{
            return showDayAndHour(date: createdTime) ?? ""
        }
    }
    
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        jobId <- map["job_id"]
        iconUrl <- (map["icon_url"], URLTransform())
        companyName <- map["company_name"]
        name <- map["name"]
        createdTime <- (map["created_time"], DateTransform())
    }
}


class CollectedInternJobModel: CollectedJobModel{
    
 
    
 
    required init?(map: Map) {
        super.init(map: map)
        self.kind = .intern
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}


class CollectedCampusJobModel: CollectedJobModel{
    
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        self.kind = .graduate
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}



class CollectedCompanyModel: NSObject, Mappable{
    
    var companyId:String?
    var iconURL:URL?
    var name:String?
    var type:String?
    var citys:[String]?
    var createdTime:Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        companyId <- map["company_id"]
        iconURL <- (map["icon_url"], URLTransform())
        name <- map["name"]
        type <- map["type"]
        citys <- map["citys"]
        createdTime <- (map["created_time"], DateTransform())
    }
}



//class CollectedCareerTalkModel: NSObject, Mappable{
//    
//    
//    var careerTalkId:String?
//    var iconURL:URL?
//    var name:String?
//    var companyName:String?
//    var college:String?
//    var address:String?
//    var createdTime:Date?
//    
//    
//    required init?(map: Map) {
//        
//    }
//    
//    func mapping(map: Map) {
//        careerTalkId <- map["career_talk_id"]
//        iconURL <- (map["icon_url"], URLTransform())
//        companyName <- map["company_name"]
//        college <- map["college"]
//        address <- map["address"]
//        name <- map["name"]
//        createdTime <- (map["created_time"], DateTransform())
//    }
//}


class CollectedOnlineApplyModel: NSObject, Mappable{
    
    var onlineApplyId:String?
    var iconURL:URL?
    var companyName:String?
    var name:String?
    var positions:[String]?
    var createdTime:Date?
    var createdTimeStr:String{
        get{
            return showDayAndHour(date: createdTime) ?? ""
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        onlineApplyId <- map["online_apply_id"]
        iconURL <- (map["icon_url"], URLTransform())
        companyName <- map["company_name"]
        name <- map["name"]
        positions <- map["positions"]
        createdTime <- (map["created_time"],DateTransform())
    }
}


