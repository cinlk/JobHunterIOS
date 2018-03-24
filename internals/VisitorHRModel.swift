//
//  VisitorHRModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class VisitorHRModel: NSObject, Mappable {
    
    var iconURL:String?
    var position:String?
    var company:String?
    
    var tag:String?
    var jobName:String?
    var visit_time:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        iconURL <- map["iconURL"]
        position <- map["position"]
        company <- map["company"]
        tag <- map["tag"]
        jobName <- map["jobName"]
        visit_time <- map["visit_time"]
        
        
    }
    

    
}
