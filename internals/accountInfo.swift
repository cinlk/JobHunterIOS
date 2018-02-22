
//
//  accountInfo.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper

class  myAccountInfo: Mappable{
    
    
    var itemName: [String:[AccountBase]]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        itemName <- map["itemName"]
    }
    
}


class AccountBase: Mappable{
    
    var imageName:String?
    var name:String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageName <- map["imageName"]
        name <- map["name"]
    }
    
    
}

class AccountSecurity: AccountBase{
    
    var extra:String?
    
   
    required init?(map: Map) {
        super.init(map: map)
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        extra <- map["extra"]
    }
    
}

class AccountBinds: AccountBase{
    
    var isBind:Bool?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        isBind <- map["isBind"]
    }
    
    
}
