//
//  HRModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class HRModel: NSObject, Mappable, Comparable {
   
    
    
    internal var userID:String?
    internal var name:String?
    internal var icon:String = "default"
    internal var position:String?
    internal var company:String?
    internal var companyID:String?
    
    internal var tag:String?
    
    
    required init?(map: Map) {
        if map.JSON["userID"] == nil || map.JSON["name"] == nil || map.JSON["company"] == nil{
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        userID <- map["userID"]
        name <- map["name"]
        icon <- map["icon"]
        position <- map["position"]
        company <- map["company"]
        tag <- map["tag"]
        
        
    }
    
}
extension HRModel{
    
    static func < (lhs: HRModel, rhs: HRModel) -> Bool {
        return true
    }
    
    static func == (lhs: HRModel, rhs: HRModel) -> Bool{
        return lhs.userID == rhs.userID
    }
    
}


class HRVisitorModel:HRModel{
    
    
    internal var visitTime:Date?
    internal var visitTimeStr:String{
        get{
            guard let time = self.visitTime else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let str = dateFormat.string(from: time)
            return str
        }
    }
    
     required init?(map: Map) {
        super.init(map: map)
        if map.JSON["visitTime"] == nil{
            return nil
        }
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        visitTime <- (map["visitTime"], DateTransform())
    }
    
}
