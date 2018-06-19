//
//  CompanyModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper


// 公司数据model

class  CompanyModel: BaseModel {
    
    
    

    
    // 简介
    internal var describe:String?
    // 简单描述
    internal var simpleDes:String?
    // 地点
    internal var address:[String]?
    // 员工人数
    internal var staffs:String?
    // 网址
    internal var webSite:String?
    
    // 福利标签
    internal var tags:[String]?
    // 所属行业
    internal var industry:[String]?
    
    // 关注人数
    internal var follows:Int = 0
    
    
    // 发布的职位
    internal var jobs:[CompuseRecruiteJobs]?
    // 宣讲会
    internal var careerTalk:[CareerTalkMeetingModel]?
    
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        
        if map.JSON["address"] == nil || map.JSON["industry"] == nil {
            return nil
        }
        
        if map.JSON["icon"] == nil{
            // 公司默认图标
            self.icon = "default"
        }
        
        
    }
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        
    
        describe <- map["describe"]
        simpleDes <- map["simpleDes"]
        address <- map["address"]
        staffs <- map["staffs"]
        webSite <- map["webSite"]
        tags <- map["tags"]
        industry <- map["industry"]
        follows <- map["follows"]
    
        jobs <- map["jobs"]
        careerTalk <- map["careerTalk"]
        
    }
}

