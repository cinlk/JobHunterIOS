//
//  DeliveredJobsModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

//class DeliveredJobsModel: NSObject, Mappable, Comparable {
//    
//    // 职位id
//    internal var id:String?
//    // 职位类型
//    internal var type:String?{
//        didSet{
//            guard let item = jobType(rawValue: type!)  else {
//                jobtype = .none
//                return
//            }
//            jobtype = item
//        }
//        
//    }
//    
//    internal var jobtype:jobType = .none
//    
//    
//    // 公司icon
//    internal var icon:String = "default"
//    // 职位名称
//    internal var title:String?
//    // 公司名称
//    internal var companyName:String?
//    // 投递日期
//    internal var create_time:Date?
//    internal var createTimeStr:String{
//        get{
//            guard let time = self.create_time else { return "" }
//            if let time = showMonthAndDay(date: time){
//                return time
//            }
//            return ""
//        }
//    }
//    // 当前状态
//    internal var currentStatus:String?
//    internal var deliveryStatus:ResumeDeliveryStatus{
//        
//        get{
//            guard let item = ResumeDeliveryStatus(rawValue: self.currentStatus!) else {
//                return .none
//            }
//            return item
//        }
//    }
//    
//
//    // 当前反馈 信息（hr 来填写）
//    internal var feedBack:String = ""
//    // 历史投递状态(状态 和 时间 YYYY-MM-DD HH:MM)
//    internal var historyStatus:[(status:String,time:String)]?
//    
//    
//    // 地址（城市）
//    internal var address:[String]?
//  
//    
//    required init?(map: Map) {
//        if map.JSON["id"] == nil || map.JSON["type"] == nil || map.JSON["title"] == nil
//        || map.JSON["companyName"] == nil || map.JSON["currentStatus"] == nil ||  map.JSON["historyStatus"] == nil || map.JSON["create_time"] == nil  || map.JSON["address"] == nil{
//            return nil
//        }
//        
//    }
//    
//    func mapping(map: Map) {
//        
//        id <- map["id"]
//        type <- map["type"]
//        icon <- map["icon"]
//        title <- map["title"]
//        companyName <- map["companyName"]
//        create_time <- (map["create_time"],DateTransform())
//        currentStatus <- map["currentStatus"]
//        feedBack <- map["feedBack"]
//        historyStatus <- map["historyStatus"]
//        address <- map["address"]
//    }
//}
//
//extension DeliveredJobsModel{
//    static func <(lhs: DeliveredJobsModel, rhs: DeliveredJobsModel) -> Bool {
//        return true
//    }
//    
//    static func ==(lhs: DeliveredJobsModel, rhs: DeliveredJobsModel) -> Bool {
//        return lhs.id  ==  rhs.id
//    }
//}

