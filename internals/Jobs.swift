//
//  Jobs.swift
//  internals
//
//  Created by ke.liang on 2017/11/25.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct CompuseRecruiteJobs :Mappable{
    var picture:String?
    var company:String?
    var jobName:String?
    var address:String?
    var salary:String?
    var create_time:String?
    var education:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        picture <- map["picture"]
        company <- map["company"]
        jobName <- map["jobName"]
        address <- map["address"]
        salary <- map["salary"]
        create_time <- map["create_time"]
        education <- map["education"]
    }
    
    
    
}


struct InternshipJobs: Mappable{
    var picture:String?
    var company:String?
    var jobName:String?
    var address:String?
    var salary:String?
    var create_time:String?
    var day:Int = 0
    var duration:String?
    var isOfficial:Bool = false
    var education:String?
    
    
    init?(map: Map) {
        picture <- map["picture"]
        company <- map["company"]
        jobName <- map["jobName"]
        address <- map["address"]
        salary <- map["salary"]
        create_time <- map["create_time"]
        day <- map["day"]
        duration <- map["duration"]
        isOfficial <- map["isOfficial"]
        education <- map["education"]
    }
    
    mutating func mapping(map: Map) {
        
    }
}

// multi sections
enum MultiSecontions{
    case CatagorySection(title:String, items: [SectionItem])
    case RecommandSection(title:String, itmes: [SectionItem])
    case CampuseRecruite(title:String, items: [SectionItem])
}
// items
enum SectionItem{
    case catagoryItem(imageNames:[String])
    case recommandItem(imageNames:[String])
    case campuseRecruite(job:CompuseRecruiteJobs)
    //case internRecruite(jobs:[InternshipJobs])
    
}

extension MultiSecontions: SectionModelType{
    typealias Item = SectionItem
    
    var items: [SectionItem]{
        switch self {
        case .CatagorySection(title: _, let items):
            return items.map{$0}
        case .RecommandSection(title: _, let items):
            return items.map{$0}
        case .CampuseRecruite(title:_,let items):
            return items
        
        }
    }
    
    var title:String{
        switch self {
        case .CampuseRecruite(title: let title, items: _):
            return title
        case .CatagorySection(title: let title, items: _):
            return title
        case .RecommandSection(title: let title, itmes: _):
            return title
        }
    }
    
    init(original: MultiSecontions, items: [MultiSecontions.Item]) {
        switch original {
        case let .CatagorySection(title: title, items: _):
            self = .CatagorySection(title: title, items: items)
        case let .RecommandSection(title: title,  itmes:_):
            self = .RecommandSection(title: title, itmes: items)
        case let .CampuseRecruite(title: title, items: _):
            self = .CampuseRecruite(title: title, items: items)
        
        }
    
    }
    
}

