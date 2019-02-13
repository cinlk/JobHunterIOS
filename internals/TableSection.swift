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
    case jobFieldSection(title:String, items: [SectionItem])
    case columnSection(title:String, items: [SectionItem])
    case recruitMentMeet(title:String, items: [SectionItem])
    case applyOnline(title:String, items: [SectionItem])
    
    case campuseRecruite(title:String, items: [SectionItem])
}
// items
enum SectionItem{
    case newItem(new:[String])
    case jobFieldItem([JobField])
    case columnItem([latestColumn])
    case recruimentMeet(list: [CareerTalkMeetingListModel])
    case applyonline(list: [applyField])
    case campuseRecruite(job: JobListModel)
    //case internRecruite(jobs:[InternshipJobs])
    
}

extension MultiSecontions: SectionModelType{
    typealias Item = SectionItem
    
    var items: [SectionItem]{
        switch self {
        case .newSection(title: _, let items):
            return items
        case .jobFieldSection(title: _, let items):
            return items.map{$0}
        case .columnSection(title: _, let items):
            return items.map{$0}
        case .recruitMentMeet(title: _,  let  items):
            return items
        case .applyOnline(title: _,  let items):
            return items
        case .campuseRecruite(title:_,let items):
            return items
        
        }
    }
    
    var title:String{
        switch self {
        case .newSection(title: let title, items: _):
            return title
        case .campuseRecruite(title: let title, items: _):
            return title
        case .jobFieldSection(title: let title, items: _):
            return title
        case .columnSection(title: let title, items: _):
            return title
        case .recruitMentMeet(title: let title, items: _):
            return title
        case .applyOnline(title: let title, items: _):
            return title
        }
    }
    
    init(original: MultiSecontions, items: [MultiSecontions.Item]) {
        switch original {
        case let .newSection(title: title, items: _):
            self = .newSection(title: title, items: items)
        case let .jobFieldSection(title: title, items: _):
            self = .jobFieldSection(title: title, items: items)
        case let .columnSection(title: title,  items:_):
            self = .columnSection(title: title, items: items)
        case let .recruitMentMeet(title: title, items: items):
            self = .recruitMentMeet(title: title, items: items)
        case let .applyOnline(title: title, items: items):
            self = .applyOnline(title: title, items: items)
        case let .campuseRecruite(title: title, items: _):
            self = .campuseRecruite(title: title, items: items)
        
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


