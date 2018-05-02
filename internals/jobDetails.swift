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





