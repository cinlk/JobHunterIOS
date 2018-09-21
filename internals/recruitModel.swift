//
//  recruitModel.swift
//  internals
//
//  Created by ke.liang on 2018/9/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper



struct RecruitOnlineApply: Mappable {
    
    var city:[String]?
    var industry:String?
    // 扩展(根据 不同条件获取数据)
    var latest:Bool?
    var recommand:Bool?
    var user:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        city <- map["city"]
        industry <- map["industry"]
    }
}



// 职位和网申混合数据
struct  ListJobsOnlineAppy: Mappable {
    //var jobs:[CompuseRecruiteJobs] = []
    var onlineAppys:[OnlineApplyModel] = []
    
    var tagJobs:[String:[CompuseRecruiteJobs]] = [:]
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        tagJobs <- map["tag_jobs"]
        onlineAppys <- map["online_apply"]
    }
    
}


// 分类tag请求 body
struct  TagsDataItem: Mappable {
    
    var isPullDown:Bool = false
    // 记录tag 的offset
    var tagsOffset:[String:Int] = [:]
    // 获取指定tag 的数据
    // 为all时 获取所有tag的数据，偏移为0
    var tag:String = ""
    var companyId:String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        tagsOffset <- map["tag_offset"]
        tag <- map["tag"]
        companyId <- map["company_id"]
        isPullDown <- map["is_pull_down"]
        
    }
}







