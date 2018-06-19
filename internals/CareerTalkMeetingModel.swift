//
//  CareerTalkMeetingModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class CareerTalkMeetingModel: BaseModel  {
    
    
    //关联 公司
    internal var companyModel:CompanyModel?

    
    // 大学  (必须)
    internal var college:String?
    // 地址 (必须)
    internal var address:String?
    // 开始时间 (必须)
    internal var start_time:Date?
    
    // 结束时间
    internal var end_time:Date?

    
    // 信息来源
    internal var source:String?
    
    // 内容
    internal var content:String?
    
    
    // 行业领域
    internal var industry:[String] = []
    
    // 连接
    internal var url:String?
    
    
    internal var time:String{
        get{
            guard let time = self.start_time else { return "" }
           
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
        
        companyModel <- map["companyModel"]
        college <- map["college"]
        address <- map["address"]
        start_time <- (map["start_time"], DateTransform())
        end_time <- (map["end_time"],DateTransform())
        source <- map["source"]
        content <- map["content"]
        industry <- map["industry"]
        url <- map["url"]
        
    }
    
    
}
