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
    case recruimentMeet(list: [CareerTalkMeetingModel])
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



// 搜索table section

struct searchJobSection {
    var items: [Item]
}

extension searchJobSection:SectionModelType {
    
    typealias Item =  CompuseRecruiteJobs
    
    init(original: searchJobSection, items: [searchJobSection.Item]) {
        self = original
        self.items = items
        
    }
    
    
}


