//
//  jobDetails.swift
//  internals
//
//  Created by ke.liang on 2018/3/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class jobDetails: NSObject {

    var jobDescribe:String
    var jobCondition:String
    var address:String
    
    init(jobDescribe:String, jobCondition:String,address:String) {
        self.jobDescribe = jobDescribe
        self.jobCondition = jobCondition
        self.address = address
    }
}


class HRInfo:NSObject {
    
    var name:String
    var position:String
    var lastLogin:String
    var icon:String
    
    init(name:String, position:String, lastLogin:String, icon:String) {
        self.name = name
        self.position = position
        self.lastLogin = lastLogin
        self.icon = icon
    }
    
}


//
class CompanyJoblistModel:NSObject, Mappable{
    
    
    var jobtag:[String]?
    var jobs:[CompuseRecruiteJobs]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        jobtag <- map["jobtag"]
        jobs <- map["jobs"]
    }
    
    
}

class CompanyDetailModel: NSObject, Mappable {
    
   
    
    // MARK:
    var id:String?
    var address:String?
    var webSite:String?
    var tags:[String]?
    var name:String?
    var describe:String?
    var simpleDes:String?
    var iconURL:String?
    var simpleTag:[String]?
    // 招聘职位
    //var joblist:MapJoblist?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        address <- map["address"]
        webSite <- map["webSite"]
        tags <- map["tags"]
        name <- map["name"]
        describe <- map["describe"]
        simpleDes <- map["simpleDes"]
        iconURL <- map["iconURL"]
        simpleTag <- map["simpleTag"]
        //joblist <- map["joblist"]
        
    }
}
