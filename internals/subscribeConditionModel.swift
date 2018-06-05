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
    var type:String = "校招"
    var locate:String = "不限"
    var business:String = "不限"
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
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
        self.type = "校招"
        return [.type:self.type, .locate:self.locate, .business: self.business,
                .salary: self.salary, .degree: self.degree]
    }
    
    override func getKeys() -> [subscribeItemType] {
        return [.type, .locate, .business, .salary, .degree]
    }
    
    
    
    
}

class internSubscribeModel: BaseSubscribeModel{
    
    

    var internDay:String = "不限"
    var degree:String = "不限"
    var internMonth:String = "不限"
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
        self.type = "实习"
        return [.type:self.type, .locate:self.locate, .business: self.business,
                .internDay: self.internDay, .degree: self.degree, .internMonth: self.internMonth,
                .internSalary: self.internSalary]
    }
    
    override func getKeys() -> [subscribeItemType] {
        return [.type, .locate, .business, .degree, .internDay, .internMonth, .internSalary]
    }
    
}


