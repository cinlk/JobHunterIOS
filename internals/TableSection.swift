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
    case JobFieldSection(title:String, items: [SectionItem])
    case ColumnSection(title:String, items: [SectionItem])
    case RecruitMentMeet(title:String, items: [SectionItem])
    case ApplyOnline(title:String, items: [SectionItem])
    
    case CampuseRecruite(title:String, items: [SectionItem])
}
// items
enum SectionItem{
    case newItem(new:[String])
    case jobFieldItem([jobField])
    case columnItem([latestColumn])
    case recruimentMeet(list: [CareerTalkMeetingModel])
    case applyonline(list: [applyField])
    case campuseRecruite(job: CompuseRecruiteJobs)
    //case internRecruite(jobs:[InternshipJobs])
    
}

extension MultiSecontions: SectionModelType{
    typealias Item = SectionItem
    
    var items: [SectionItem]{
        switch self {
        case .newSection(title: _, let items):
            return items
        case .JobFieldSection(title: _, let items):
            return items.map{$0}
        case .ColumnSection(title: _, let items):
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
        case .JobFieldSection(title: let title, items: _):
            return title
        case .ColumnSection(title: let title, items: _):
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
        case let .JobFieldSection(title: title, items: _):
            self = .JobFieldSection(title: title, items: items)
        case let .ColumnSection(title: title,  items:_):
            self = .ColumnSection(title: title, items: items)
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


