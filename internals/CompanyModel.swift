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
    // 地点
    internal var address:[String]?
    
    internal var staffs:String?
    // 网址
    internal var webSite:String?
    
    // 福利标签
    internal var tags:[String]?
    // 行业类型标签
    internal var type:[String]?
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["icon"] == nil{
            // 公司默认图标
            self.icon = "dong"
        }
        
    }
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        
       
        describe <- map["describe"]
        address <- map["address"]
        staffs <- map["staffs"]
        webSite <- map["webSite"]
        
        tags <- map["tags"]
        type <- map["type"]
        
        
    }
}

