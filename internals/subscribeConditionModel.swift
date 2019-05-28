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
    
//    var cityStr:String = ""{
//        didSet{
//            self.citys =  cityStr.components(separatedBy: "+")
//        }
//    }
    var citys:[String] = []
    
    var fields:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        create_time <- (map["create_time"], DateTransform())
        type <- map["type"]
        //cityStr <- map["city_str"]
        fields <- map["fields"]
        citys <- map["citys"]
    }
    
    
    func getTypeValue() -> [subscribeItemType:String]{
        
        return [:]
    }
    
    func getKeys()->[subscribeItemType]{
        return []
    }
    
    
}


class GraduateSubscribeModel: BaseSubscribeModel{
    
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
        
        return [.type:self.kind.rawValue, .cityStr: self.citys.joined(separator: "+"), .fields: self.fields,
                .salary: self.salary, .degree: self.degree]
    }
    
    override func getKeys() -> [subscribeItemType] {
        return [.type, .cityStr, .fields, .salary, .degree]
    }
    
    
    
    
}

class InternSubscribeModel: BaseSubscribeModel{
    
    

    var internDay:String = ""
    var degree:String = "不限"
    var internMonth:String = ""
    var internSalary:String = "不限"
    
    required init?(map: Map) {
        super.init(map: map)
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        
        internDay <- map["intern_day"]
        degree <- map["degree"]
        internMonth <- map["intern_month"]
        internSalary <- map["intern_salary"]
        
    }
    
    override func getTypeValue() -> [subscribeItemType : String] {
        
        return [.type:self.kind.rawValue, .cityStr: self.citys.joined(separator: "+"), .fields: self.fields,
                .internDay: self.internDay, .degree: self.degree, .internMonth: self.internMonth,
                .internSalary: self.internSalary]
    }
    
    override func getKeys() -> [subscribeItemType] {
        return [.type, .cityStr, .fields, .degree, .internDay, .internMonth, .internSalary]
    }
    
}


