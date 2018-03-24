//
//  DeliveredJobsModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class DeliveredJobsModel: NSObject, Mappable, Comparable {
    
    var id:String = "chishu"
    var type:String = "社招"
    var picture:String?
    var company:String?
    var jobName:String?
    var address:String?
    var salary:String = "面议"
    var create_time:String?
    var checkStatus:String?
    
    //
    var response:Dictionary<String,String>?
    var records:[[String]]?
    
    
    
    static func <(lhs: DeliveredJobsModel, rhs: DeliveredJobsModel) -> Bool {
        return true
    }
    
    static func ==(lhs: DeliveredJobsModel, rhs: DeliveredJobsModel) -> Bool {
        return lhs.id  ==  rhs.id
    }
    
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        type <-  map["type"]
        picture <- map["picture"]
        company <- map["company"]
        jobName <- map["jobName"]
        address <- map["address"]
        salary <- map["salary"]
        create_time <- map["create_time"]
        checkStatus <- map["checkStatus"]
        response <- map["response"]
        records <- map["records"]
    }
    
    
}


// 投递集合
class DeliveredJobsResults: Mappable{
    
    var jobs:[DeliveredJobsModel]?
    var title:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        jobs <- map["jobs"]
        title <- map["title"]
    }
    
}
