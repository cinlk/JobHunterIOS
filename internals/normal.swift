//
//  normal.swift
//  internals
//
//  Created by ke.liang on 2019/3/3.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper

struct JobWarnList: Mappable {
    
    var warns:[String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        warns <- map["warns"]
    }
}




struct RecruiterMainModel: Mappable {
    
    var recruiter: HRPersonModel?
    var company: SimpleCompanyModel?
    var jobs: [SimpleJobModel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        recruiter <- map["recruiter"]
        company <- map["company"]
        jobs <- map["jobs"]
    }
}
