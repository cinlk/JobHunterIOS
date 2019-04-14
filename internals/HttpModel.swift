//
//  HttpModel.swift
//  internals
//
//  Created by ke.liang on 2019/1/29.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper



struct ResponseModel<T>: Mappable where T: Mappable{
    
    typealias obj = T
    var returnCode:String?
    var returnMsg:String?
    var code:Int?
    var body:obj?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        returnCode <- map["return_code"]
        returnMsg <- map["return_msg"]
        code      <- map["code"]
        body      <- (map["body"], JsonObjectTransform<obj>())
    }
}


struct ResponseArrayModel<T>: Mappable where T: Mappable {
    typealias obj = T
    var returnCode:String?
    var returnMsg:String?
    var code:Int?
    var body:[obj]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        returnCode <- map["return_code"]
        returnMsg <- map["return_msg"]
        code      <- map["code"]
        body      <- (map["body"], JsonArrayObjectTransform<obj>())
    }
    
}





