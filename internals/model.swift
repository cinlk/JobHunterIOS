//
//  sendCodeModel.swift
//  internals
//
//  Created by ke.liang on 2018/9/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper


class CodeSuccess: Mappable{
    
    var account: String?
    var number: Int?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        account <- map["account"]
        number <- map["number"]
    }
}




class  loginSuccess: Mappable{
    
    var token: String?
    var userExsit:Bool?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        userExsit <- map["user_exsit"]
    }
    
    
}


class BaseResponse: Mappable{
    
    var requestID:String?
    var statusCode:Int?
    var message:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        requestID <- map["request_id"]
        statusCode <- map["status_code"]
        message <- map["message"]
    }
    
    
}

