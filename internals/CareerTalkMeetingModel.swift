//
//  CareerTalkMeetingModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

internal  class CareerTalkMeetingModel: BaseModel  {
    
    
    //关联 公司
    internal var companyModel:CompanyModel?
    
    
    // 大学  (必须)
    internal var college:String?
    // 详细地址 (必须)
    internal var address:String?
    // 简写地址
    internal var short_address:String = ""
    
    // 开始时间 (必须)
    internal var start_time:Date?
    
    internal var startTimeStr:String{
        get{
            
            guard let time = self.start_time else { return "" }
            
            
            if let str = showYearAndDayAndHour(date: time){
                return str
            }
            return ""
        }
    }
    // 结束时间
    internal var end_time:Date?

    
    // 信息来源
    internal var source:String?
    
    // 内容
    internal var content:String?
    internal var contentType:String = "text"
    
    // 行业领域
    internal var industry:[String] = []
    
    // 专业
    internal var major:[String] = []
    
    
    
    
    internal var time:String{
        get{
            guard let time = self.start_time else { return "" }
            print(time)
            return meetingTalkTime(time:time)
            
        }
    }
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["college"] == nil || map.JSON["address"] == nil || map.JSON["start_time"] == nil || map.JSON["end_time"] == nil  {
            return nil
        }
       
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        companyModel <- map["company"]
        college <- map["college"]
        address <- map["address"]
        short_address <- map["shorten_address"]
        start_time <- (map["start_time"], DateTransform())
        end_time <- (map["end_time"],DateTransform())
        source <- map["reference"]
        content <- map["content"]
        contentType <- map["content_type"]
        industry <- map["industry"]
        major <- map["major"]
        
        
        // 不能超过10个长度
        if short_address.count > 10{
            short_address = ""
        }
        
    }
    
    
}
