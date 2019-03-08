//
//  jobMultiSections.Swift
//  internals
//
//  Created by ke.liang on 2018/9/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import Differentiator



enum JobMultiSectionModel {
    case CompanySection(title:String, items: [JobSectionItem])
    case HRSection(title:String, items: [JobSectionItem])
    case JobDescribeSection(title:String, items: [JobSectionItem])
    case AddressSection(title:String, items: [JobSectionItem])
    case EndTimeSection(title:String, items: [JobSectionItem])
}


enum JobSectionItem {

    case CompanySectionItem(mode:SimpleCompanyModel)
    case HRSectionItem(mode:HRPersonModel)
    case JobDescribeSectionItem(mode:CompuseRecruiteJobs)
    case AddressSectionItem(adress:[String])
    case EndTimeSectionItem(time:String)
}


extension JobMultiSectionModel:SectionModelType{
    typealias Item = JobSectionItem
    var items: [JobSectionItem]{
        switch  self {
        case .CompanySection(_, let items):
            return items
        case .HRSection(_, let items):
            return items
        case .JobDescribeSection(_, let items):
            return items
        case .AddressSection(_, let items):
            return items
        case .EndTimeSection(_, let items):
            return items
       
        }
    }
    
    init(original: JobMultiSectionModel, items: [JobMultiSectionModel.Item]) {
        switch original {
        case .CompanySection(let title, _):
            self = .CompanySection(title: title, items: items)
        case .HRSection(let title, items: _):
            self = .HRSection(title: title, items: items)
        case .JobDescribeSection(let title, _):
            self = .JobDescribeSection(title: title, items: items)
        case .AddressSection(let title, _):
            self = .AddressSection(title: title, items: items)
        case .EndTimeSection(let title, _):
            self = .EndTimeSection(title: title, items: items)
        }
    }
    
    
}

extension JobMultiSectionModel{
    
    var title:String{
        switch  self {
        case .CompanySection(let title, _):
            return title
        case .HRSection(let title, _):
            return title
        case .JobDescribeSection(let title, _):
            return title
        case .AddressSection(let title, _):
            return title
        case .EndTimeSection(let title, _):
            return title
        }
    }
}








// 职位tag 和职位
enum CompanyTagJobSectionModel{
    case TagsSection(title:String, items:[CompanyTagJobItem])
    case JobsSection(title:String, items:[CompanyTagJobItem])
}

enum CompanyTagJobItem {
    case TagsItem(mode:[String])
    case JobsItem(mode:CompanyTagJobs)
}


extension CompanyTagJobSectionModel: SectionModelType{
    typealias Item = CompanyTagJobItem
    
    
    var items: [CompanyTagJobItem]{
        switch self {
        case .TagsSection(title: _, let items):
            return items
        case .JobsSection(title: _, let items):
            return items
        }
    }
    
    var title:String{
        switch self {
        case .TagsSection(let title, _):
            return title
        case .JobsSection(let title, _):
            return title
        }
    }
    
    init(original: CompanyTagJobSectionModel, items: [CompanyTagJobSectionModel.Item]) {
        switch original {
            case .TagsSection(let title, _):
                self = .TagsSection(title: title, items: items)
            case .JobsSection(let title, _):
                self = .JobsSection(title: title, items: items)
        }
    }
    
}
