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


class MapJoblist:NSObject, Mappable{
    
    
    var jobtag:[String]?
    var jobs:[CompuseRecruiteJobs]?
    
    
    override var description: String{
        get{
            var tags = ""
            if let t = jobtag{
                for item in t{
                    tags += " " + item
                }
                
            }
            if let j = jobs {
                for item in j{
                    tags += "" + (item.jobName ?? "")
                }
            }
            
            return tags
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        jobtag <- map["jobtag"]
        jobs <- map["jobs"]
    }
    
    
}

class CompanyDetail: NSObject, Mappable {
    
   
    
    // MARK:
    var address:String?
    var webSite:String?
    var tags:[String]?
    var name:String?
    var describe:String?
    var simpleDes:String?
    var iconURL:String?
    var simpleTag:[String]?
    // 招聘职位
    var joblist:MapJoblist?
    
    
    //
    override var description: String{
        get{
        
            return self.name! + ":" + (self.joblist?.description ?? "")
        }
    }
    required init?(map: Map) {
        
    }
    
    
//    init(address:String, webSite:String,) {
//        self.address = address
//        self.webSite = webSite
//
//    }
    /**
     {
     "address":"",
     "iconURL":"",
     ....,
     "joblist":{
     "jobs":[{},{},{}],
     "jobtag":["","",""]
     
     }
     
     }
    **/
    func mapping(map: Map) {
        address <- map["address"]
        webSite <- map["webSite"]
        tags <- map["tags"]
        name <- map["name"]
        describe <- map["describe"]
        simpleDes <- map["simpleDes"]
        iconURL <- map["iconURL"]
        simpleTag <- map["simpleTag"]
        joblist <- map["joblist"]
        
    }
}
