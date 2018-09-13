//
//  searchModel.swift
//  internals
//
//  Created by ke.liang on 2018/9/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper


struct MatchKeyWordsModel: Mappable {
    
    var type:String?
    var words:[String]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        type <- map["type"]
        words <- map["words"]
    }
    
}





// 请求body
struct  searchOnlineApplyBody: Mappable {
    
    var word:String?
    var city:[String]?
    var industry:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        word <- map["word"]
        city <- map["city"]
        industry <- map["industry"]
    }
    
}

struct searchGraduateRecruiteBody: Mappable {
    
    var word:String?
    var city:[String]?
    var industry:String?
    var company:String?
    
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        word <- map["word"]
        city <- map["city"]
        industry <- map["industry"]
        company <- map["company"]
    }
    
}



struct searchInternJobsBody:Mappable {
    
    var word:String?
    var city:[String]?
    var industry:String?
    var interns:[String:String]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        word <- map["word"]
        city <- map["city"]
        industry <- map["industry"]
        interns <- map["interns"]
    }
    
}


struct  searchCareerTalkBody:Mappable {
    
    var word:String?
    var college:[String]?
    var industry:String?
    var date:String? // TODO timinterval??
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        word <- map["word"]
        college <- map["college"]
        industry <- map["industry"]
        date <- map["date"]
    }
    
}


struct searchCompanyBody:Mappable {
    
    var word:String?
    var city:[String]?
    var field:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        word <- map["word"]
        city <- map["city"]
        field <- map["field"]
        
    }
}

