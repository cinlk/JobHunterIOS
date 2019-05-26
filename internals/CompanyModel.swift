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

class SimpleCompanyModel: NSObject, Mappable{
    
    var companyID:String?
    var iconURL:URL?
    var name:String?
    var citys:[String]?
    var businessField:[String]?
    var staff:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        companyID <- map["company_id"]
        iconURL <- (map["icon_url"], URLTransform())
        name <- map["company_name"]
        citys <- map["citys"]
        businessField <- map["business_field"]
        staff <- map["staff"]
    }
    
    
}

// 公司数据model

class  CompanyModel: BaseModel {
    

    // 简介
    internal var describe:String?
    // 简单描述
    internal var simpleDes:String?
    // 地点
    internal var citys:[String]?
    // 员工人数
    internal var staff:String = ""
    
    // 福利标签
    internal var tags:[String]?
    // 职位类型标签
    internal var jobTags:[String]?
    // 所属行业
    internal var businessField:[String]?
    
    // 关注人数
    internal var reviewCounts:Int = 0
    internal var type:String?
    
    
    // 发布的职位
    internal var jobs:[JobListModel]?
    // 宣讲会
    internal var careerTalk:[CareerTalkMeetingListModel]?
    
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        
//        if map.JSON["address"] == nil || map.JSON["industry"] == nil {
//            return nil
//        }
        
//        if map.JSON["icon"] == nil{
//            // 公司默认图标
//            self.icon = "default"
//        }
        
        
    }
    
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        
        // 默认值
        //jobTags.insert("全部", at: 0)
        describe <- map["describe"]
        simpleDes <- map["simple_des"]
        citys <- map["citys"]
        staff <- map["staff"]
        tags <- map["tags"]
        jobTags <- map["job_tags"]
        businessField <- map["business_field"]
        reviewCounts <- map["review_counts"]
        jobs <- map["jobs"]
        type <- map["type"]
        careerTalk <- map["career_talks"]
    }
    
    
    
}

