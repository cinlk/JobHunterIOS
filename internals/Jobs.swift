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



// 公司数据model

class  comapnyInfo: NSObject, Mappable, Comparable {
    
    static func < (lhs: comapnyInfo, rhs: comapnyInfo) -> Bool {
        return true
    }
    
    static func == (lhs: comapnyInfo, rhs: comapnyInfo) -> Bool {
        return lhs.id  ==  rhs.id
    }
    
    var id:String?
    var icon:String?
    var name:String?
    var describe:String?
    var address:String?
    var staffs:String?
    var industry:String?
    var tags:[String]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        icon <- map["icon"]
        name <- map["name"]
        describe <- map["describe"]
        address <- map["address"]
        staffs <- map["staffs"]
        industry <- map["industry"]
        tags <- map["tags"]
        
    }
}


// MARK 添加更多的属性，比如id，标签等？？
class CompuseRecruiteJobs :NSObject,Mappable, Comparable{
    
    static func <(lhs: CompuseRecruiteJobs, rhs: CompuseRecruiteJobs) -> Bool {
        return true
    }
    
    static func ==(lhs: CompuseRecruiteJobs, rhs: CompuseRecruiteJobs) -> Bool {
         return lhs.id  ==  rhs.id
    }
    
    var id:String?
    var type:String = "compuse"
    var tag:[String] = [""]
    var picture:String?
    var company:String?
    var jobName:String?
    var address:String?
    var salary:String?
    var create_time:String?
    var education:String?
    
    // 实习内容
    var day:Int = 0
    var duration:String?
    var isOfficial:Bool = false
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        id <- map["id"]
        tag <- map["tag"]
        type <-  map["type"]
        picture <- map["picture"]
        company <- map["company"]
        jobName <- map["jobName"]
        address <- map["address"]
        salary <- map["salary"]
        create_time <- map["create_time"]
        education <- map["education"]
        day <- map["day"]
        duration <- map["duration"]
        isOfficial <- map["isOfficial"]
       
        
    }
    
    
}


// multi sections
enum MultiSecontions{
    case newSection(title:String, items: [SectionItem])
    case CatagorySection(title:String, items: [SectionItem])
    case RecommandSection(title:String, itmes: [SectionItem])
    case RecruitMentMeet(title:String, items: [SectionItem])
    case ApplyOnline(title:String, items: [SectionItem])
    
    case CampuseRecruite(title:String, items: [SectionItem])
}
// items
enum SectionItem{
    case newItem(new:[String])
    case catagoryItem(imageNames:[String:String])
    case recommandItem(imageNames:[String:String])
    case recruimentMeet(list: [simpleRecruitModel])
    case applyonline(list: [applyOnlineModel])
    case campuseRecruite(job: CompuseRecruiteJobs)
    //case internRecruite(jobs:[InternshipJobs])
    
}

extension MultiSecontions: SectionModelType{
    typealias Item = SectionItem
    
    var items: [SectionItem]{
        switch self {
        case .newSection(title: _, let items):
            return items
        case .CatagorySection(title: _, let items):
            return items.map{$0}
        case .RecommandSection(title: _, let items):
            return items.map{$0}
        case .RecruitMentMeet(title: _,  let  items):
            return items
        case .ApplyOnline(title: _,  let items):
            return items
        case .CampuseRecruite(title:_,let items):
            return items
        
        }
    }
    
    var title:String{
        switch self {
        case .newSection(title: let title, items: _):
            return title
        case .CampuseRecruite(title: let title, items: _):
            return title
        case .CatagorySection(title: let title, items: _):
            return title
        case .RecommandSection(title: let title, itmes: _):
            return title
        case .RecruitMentMeet(title: let title, items: _):
            return title
        case .ApplyOnline(title: let title, items: _):
            return title
        }
    }
    
    init(original: MultiSecontions, items: [MultiSecontions.Item]) {
        switch original {
        case let .newSection(title: title, items: _):
            self = .newSection(title: title, items: items)
        case let .CatagorySection(title: title, items: _):
            self = .CatagorySection(title: title, items: items)
        case let .RecommandSection(title: title,  itmes:_):
            self = .RecommandSection(title: title, itmes: items)
        case let .RecruitMentMeet(title: title, items: items):
            self = .RecruitMentMeet(title: title, items: items)
        case let .ApplyOnline(title: title, items: items):
            self = .ApplyOnline(title: title, items: items)
        case let .CampuseRecruite(title: title, items: _):
            self = .CampuseRecruite(title: title, items: items)
        
        }
    
    }
    
}

