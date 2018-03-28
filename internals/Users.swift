//
//  Users.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginUserModel: Mappable {
    
    var account:String?
    var password:String?
    var role:String?
    
    var validateNumber:String?
    
    
    required init?(map: Map) {
    
    }
    
    
    //mapper
    
    public func mapping(map: Map) {
        
        password <- map["password"]
        account <- map["account"]
        role <- map["role"]
        
    }
    
    
    
    
    
    
}
