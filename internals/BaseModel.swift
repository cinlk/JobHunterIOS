//
//  BaseModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel:NSObject, Mappable, Comparable{
    
    
    // 唯一号 (必须)
    internal var id:String?
    
    // 名字 （必须）
    internal var name:String?
    
    // 有效标记 (必须)
    internal var isValidate:Bool?
    // 收藏标记 (必须)
    internal var isCollected:Bool?
    // 投递标记
    internal var isApply:Bool?
    
    // 创建时间
    internal var create_time:Date?
    // 图片url (可选, 给出默认值)
    internal var icon:String = "default"
    
    
    
    internal var creatTimeStr:String{
        get{
            
            guard let time = self.create_time else { return "" }
            
            if let str = showMonthAndDay(date: time){
                return str
            }
            return ""
        }
    }
    
    required init?(map: Map) {
        if map.JSON["id"] == nil  || map.JSON["isCollected"] == nil
            || map.JSON["name"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isValidate <- map["isValidate"]
        isCollected <- map["isCollected"]
        isApply <- map["isApply"]
        create_time <- (map["create_time"], DateTransform())
        icon <- map["icon"]
        
    }
    
    
    
}


// 可比较
extension BaseModel{
    
    static func < (lhs: BaseModel, rhs: BaseModel) -> Bool {
        return true
    }
    static func == (lhs: BaseModel, rhs: BaseModel) -> Bool {
        return lhs.id  == rhs.id
    }
}
