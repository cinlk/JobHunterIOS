//
//  CompanyModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper




class NeayByCompanyModel: NSObject, Mappable{
    
    var companyID:String?
    var companyIconURL:URL?
    var companyName:String?
    var businessFiled:[String]?
    var distance:Double?
    var reviewCounts:Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        companyID <- map["company_id"]
        companyIconURL <- (map["company_icon_url"], URLTransform())
        companyName <- map["company_name"]
        businessFiled <- map["business_field"]
        distance <- map["distance"]
        reviewCounts <- map["review_counts"]
    }
    
}


class CompanyListModel: NSObject,  Mappable{
    
    var companyID:String?
    var companyIconURL:URL?
    var companyName:String?
    var reviewCounts:Int?
    var citys:[String]?
    var businessField:[String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        companyID <- map["company_id"]
        companyIconURL <- (map["company_icon_url"], URLTransform())
        companyName <- map["company_name"]
        reviewCounts <- map["review_counts"]
        citys <- map["citys"]
        businessField <- map["business_field"]
    }
}

// 公司数据model

class  CompanyModel: BaseModel {
    

    // 简介
    internal var describe:String?
    // 简单描述
    internal var simpleDes:String?
    // 地点
    internal var address:[String]?
    // 员工人数
    internal var staffs:Int = 0
    
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
        simpleDes <- map["simple_des"]
        address <- map["address"]
        staffs <- map["staffs"]
        tags <- map["tags"]
        industry <- map["industry"]
        follows <- map["follows"]
        jobs <- map["jobs"]
        careerTalk <- map["recruit_meeting"]
        
    }
}

