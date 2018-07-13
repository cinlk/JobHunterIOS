//
//  subscribeConditionModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper




class BaseSubscribeModel: NSObject, Mappable{
    
    // 订阅id
    var id:String = ""
    
    var create_time:Date?
    var createTime:String?{
        get{
            guard  let time = create_time else {
                return ""
            }
            
            return showMonthAndDay(date: time)
        }
    }
    
    var type:String = ""
    
    var kind:subscribeType{
        get{
            if let type = subscribeType(rawValue: self.type) {
                return type
            }
            return .none
        }
    }
    
    var locate:String = ""
    var business:String = "不限"
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        create_time <- (map["create_time"], DateTransform())
        type <- map["type"]
        locate <- map["locate"]
        business <- map["business"]
    }
    
    
    func getTypeValue() -> [subscribeItemType:String]{
        
        return [:]
    }
    
    func getKeys()->[subscribeItemType]{
        return []
    }
    
    
}


class graduateSubscribeModel: BaseSubscribeModel{
    
    var salary:String = "不限"
    var degree:String = "不限"
    
    
   
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        salary <- map["salary"]
        degree <- map["degree"]
    }
    
    override func getTypeValue() -> [subscribeItemType : String] {
        
        return [.type:self.kind.rawValue, .locate:self.locate, .business: self.business,
                .salary: self.salary, .degree: self.degree]
    }
    
    override func getKeys() -> [subscribeItemType] {
        return [.type, .locate, .business, .salary, .degree]
    }
    
    
    
    
}

class internSubscribeModel: BaseSubscribeModel{
    
    

    var internDay:String = ""
    var degree:String = "不限"
    var internMonth:String = ""
    var internSalary:String = "不限"
    
    required init?(map: Map) {
        super.init(map: map)
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        
        internDay <- map["internDay"]
        degree <- map["degree"]
        internMonth <- map["internMonth"]
        internSalary <- map["internSalary"]
        
    }
    
    override func getTypeValue() -> [subscribeItemType : String] {
        
        return [.type:self.kind.rawValue, .locate:self.locate, .business: self.business,
                .internDay: self.internDay, .degree: self.degree, .internMonth: self.internMonth,
                .internSalary: self.internSalary]
    }
    
    override func getKeys() -> [subscribeItemType] {
        return [.type, .locate, .business, .degree, .internDay, .internMonth, .internSalary]
    }
    
}


