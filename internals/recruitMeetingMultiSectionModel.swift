//
//  recruitMeetingMultiSectionModel.swift
//  internals
//
//  Created by ke.liang on 2019/3/5.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Differentiator

enum RecruitMeetingSectionModel {
    
    case CompanySection(title:String, items:[RecruitMeetingSectionItem])
    case RecruitMeetingSection(title:String, items:[RecruitMeetingSectionItem])
}


enum RecruitMeetingSectionItem {
    case CompanyItem(mode: SimpleCompanyModel)
    case RecruitMeeting(mode: CareerTalkMeetingModel)
}


extension RecruitMeetingSectionModel: SectionModelType{
    typealias Item = RecruitMeetingSectionItem
    
    var items: [RecruitMeetingSectionItem]{
        switch self {
        case .CompanySection(title: _, let items):
            return items
        case .RecruitMeetingSection(_,  let items):
            return items
        }
    }
    
    var title:String{
        switch self {
        case .CompanySection(let title, _):
            return title
        case .RecruitMeetingSection(let title, _):
            return title
        }
    }
    
    init(original: RecruitMeetingSectionModel, items: [RecruitMeetingSectionItem]) {
        switch original {
        case .CompanySection(let title, _):
            self = .CompanySection(title: title, items: items)
        case .RecruitMeetingSection(let title, _):
            self = .RecruitMeetingSection(title: title, items: items)
        }
    }
}
