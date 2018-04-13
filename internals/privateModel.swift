//
//  InvalidateCompany.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper






class privateMode: Mappable{
    
    var list:[privateListModel]?
    var backListComp:[String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        list <- map["list"]
        backListComp <- map["backListComp"]
    }
}

class privateListModel: NSObject, Mappable{
    
    var name:String?
    var isOn:Bool?
    var showCompany:Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        isOn <- map["isOn"]
        showCompany <- map["showCompany"]
        
    }
    
    
    
}


