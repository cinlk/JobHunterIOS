//
//  InvalidateCompany.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper


class  BlackistCompanyModel: NSObject, Mappable{
    
    var companyID:String?
    var companyName:String?
    // 表示已经添加（黑名单 搜索结果vc 显示需要）
    var validate:Bool?
    
    required init?(map: Map) {
        if map.JSON["companyID"] == nil || map.JSON["companyName"] == nil || map.JSON["validate"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        companyID <- map["companyID"]
        companyName <- map["companyName"]
        validate <- map["validate"]
    }
}


class ResumePrivacyModel: NSObject, Mappable{
    
    
    // 设置条件
    var listItem:[String:Bool]?
    
    // 屏蔽的公司 名称
    var companyBlacklist:[BlackistCompanyModel] = []
    
    required init?(map: Map) {
        if map.JSON["listItem"] == nil  {
            return nil
        }
    }
   
    func mapping(map: Map) {
        listItem <- map["listItem"]
        companyBlacklist <- map["companyBlacklist"]
    }
    
}


