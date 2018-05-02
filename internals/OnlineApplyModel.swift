//
//  OnlineApplyModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class OnlineApplyModel: BaseModel {
    
    
    
    // 举办公司
    internal var companyModel:CompanyModel?
    // 截止时间
    internal var end_time:String?
    
    
    // 工作城市
    internal var positionAddress:[String]?
    // 专业
    internal var majors:[String]?
    // 职位
    internal var positions:[String]?
    
    

    // 官网招聘链接
    internal var link:String?
    
    // 外部链接
    // 1 外部网申 有content 展示content，申请跳转外部地址
    // 2 没有content 直接跳转外部地址
    // 3 如果是内部发布的网申，显示content 并简历可以投递
    internal var outer:Bool = true
    
    // 网申招聘描述（MARK）
    internal var content:String?
    
    
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["isApply"] == nil {
            return nil
        }
    }
    
    override func mapping(map: Map) {
       
        super.mapping(map: map)
        end_time <- map["end_time"]
        companyModel <- map["companyModel"]
        positionAddress <- map["positionAddress"]
        positions <- map["positions"]
        majors <- map["majors"]
        content <- map["content"]
        outer <- map["outer"]
        link <- map["link"]
        
    }
    

    
}
