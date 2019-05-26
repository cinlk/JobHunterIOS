//
//  CareerTalkMeetingModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper


internal class NearByTalkMeetingModel: NSObject, Mappable {
    
    internal var meetingID:String?
    internal var collegeIconURL:URL?
    internal var distance:Double?
    internal var startTime:Date?
    internal var startTimeStr:String?{
        get{
            guard let t = self.startTime else {
                return ""
            }
            
            return meetingTalkTime(time: t)
        }
    }
    internal var college:String?
    internal var address:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        meetingID <- map["meeting_id"]
        collegeIconURL <- (map["college_icon_url"], URLTransform())
        distance <- map["distance"]
        startTime <- (map["start_time"], DateTransform())
        college <- map["college"]
        address <- map["address"]
        
    }
}

internal class CareerTalkMeetingListModel: NSObject, Mappable {
    
    internal var meetingID:String?
    internal var collegeIconURL:URL?
    internal var startTime:Date?
    internal var startTimeStr:String?{
        get{
            guard  let t = self.startTime else {
                return ""
            }
            return meetingTalkTime(time: t)
        }
    }
    internal var college:String?
    internal var companyName:String?
    internal var simplifyAddress:String?
    
    // search 过滤匹配数据
    internal var businessField:[String]?
    internal var city:String?
    
    
    required init?(map: Map) {
        
//        if map.JSON["meeting_id"] == nil  || map.JSON["college"] == nil {
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        meetingID <- map["meeting_id"]
        collegeIconURL <- (map["college_icon_url"], URLTransform())
        startTime <- (map["start_time"], DateTransform())
        companyName <- map["company_name"]
        simplifyAddress <- map["simplify_address"]
        college <- map["college"]
        businessField <- map["business_field"]
        city <- map["city"]
        
    }
    
}


internal  class CareerTalkMeetingModel: BaseModel  {
    
    
    //关联 公司
    internal var company:SimpleCompanyModel?
    
    
    // 大学  (必须)
    internal var college:String?
    // 详细地址 (必须)
    internal var address:String?
    // 简写地址
    internal var simplifyAddress:String = ""
    internal var city:String?
    
    // 开始时间 (必须)
    internal var startTime:Date?
    
    internal var startTimeStr:String{
        get{
            
            guard let time = self.startTime else { return "" }
            
            
            if let str = showYearAndDayAndHour(date: time){
                return str
            }
            return ""
        }
    }
    // 结束时间
    internal var endTime:Date?

    
    // 信息来源
    internal var reference:String?
    
    // 内容
    internal var content:String?
    internal var contentType:String = "text"
    
    // 行业领域
    internal var businessField:[String] = []
    
    // 专业
    internal var majors:[String] = []
    
    
    
    
    internal var time:String{
        get{
            guard let time = self.startTime else { return "" }
            
            return meetingTalkTime(time:time)
            
        }
    }
    
    
    
    required init?(map: Map) {
        super.init(map: map)
//        if map.JSON["college"] == nil || map.JSON["address"] == nil || map.JSON["start_time"] == nil || map.JSON["end_time"] == nil  {
//            return nil
//        }
       
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        company <- map["company"]
        college <- map["college"]
        address <- map["address"]
        simplifyAddress <- map["simplify_address"]
        startTime <- (map["start_time"], DateTransform())
        endTime <- (map["end_time"],DateTransform())
        reference <- map["reference"]
        content <- map["content"]
        contentType <- map["content_type"]
        businessField <- map["business_field"]
        city <- map["city"]
        majors <- map["majors"]
        
        
        // 不能超过10个长度 TODO
        if simplifyAddress.count > 10{
            simplifyAddress = ""
        }
        
    }
    
    
}
