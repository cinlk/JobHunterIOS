//
//  sendCodeModel.swift
//  internals
//
//  Created by ke.liang on 2018/9/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper


class CodeSuccess: Mappable, CustomStringConvertible{
    
    var code: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code <- map["code"]
    }
    
    var description: String{
        return self.toJSONString() ?? ""
    }
}




class  LoginSuccess: Mappable{
    
    var token: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
    
    
}



