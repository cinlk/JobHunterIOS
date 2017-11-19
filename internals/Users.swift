//
//  Users.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class Users: Mappable {
    
    
    
   
    

    var phoneNumber:String?
    var password:String?
    var role:String?
    
    var validateNumber:String?
    
    
    init(_ phoneNumber:String, _ password:String) {
        
        self.phoneNumber = phoneNumber
        self.password = password
       
    }
    
    required init?(map: Map) {
    
    }
    
    
    //mapper
    
    public func mapping(map: Map) {
    
        phoneNumber <- map["phone"]
        role <- map["role"]
        
    }
    
    
    
    
    
    
}
