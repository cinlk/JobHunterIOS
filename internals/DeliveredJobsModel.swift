//
//  DeliveredJobsModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class DeliveredJobsModel: NSObject, Mappable, Comparable {
    
    internal var id:String?
    internal var type:String?{
        didSet{
            guard let item = jobType(rawValue: type!)  else {
                jobtype = .none
                return
            }
            jobtype = item
        }
        
    }
    
    internal var jobtype:jobType = .none
    
    
    internal var icon:String = "default"
    internal var title:String?
    internal var companyName:String?
    internal var create_time:Date?
    internal var createTimeStr:String{
        get{
            guard let time = self.create_time else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd"
            let str = dateFormat.string(from: time)
            return str
        }
    }
    internal var currentStatus:String?
    internal var deliveryStatus:ResumeDeliveryStatus{
        
        get{
            guard let item = ResumeDeliveryStatus(rawValue: self.currentStatus!) else {
                return .none
            }
            return item
        }
    }
    

    // 当前反馈状态
    internal var feedBack:String = "[投递成功]"
    // 历史投递状态(状态 和 时间 YYYY-MM-DD HH:MM)
    internal var historyStatus:[(status:String,time:String)]?
    
    
    // 地址
    internal var address:[String]?
    // 专业
    internal var business:[String]?
    
    
    
    required init?(map: Map) {
        if map.JSON["id"] == nil || map.JSON["type"] == nil || map.JSON["title"] == nil
            || map.JSON["companyName"] == nil || map.JSON["currentStatus"] == nil ||  map.JSON["historyStatus"] == nil{
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        type <- map["type"]
        icon <- map["icon"]
        title <- map["title"]
        companyName <- map["companyName"]
        create_time <- (map["create_time"],DateTransform())
        currentStatus <- map["currentStatus"]
        feedBack <- map["feedBack"]
        historyStatus <- map["historyStatus"]
        address <- map["address"]
        business <- map["business"]
        
        
        
    }
}

extension DeliveredJobsModel{
    static func <(lhs: DeliveredJobsModel, rhs: DeliveredJobsModel) -> Bool {
        return true
    }
    
    static func ==(lhs: DeliveredJobsModel, rhs: DeliveredJobsModel) -> Bool {
        return lhs.id  ==  rhs.id
    }
}

