//
//  companyDetailMultiSection.swift
//  internals
//
//  Created by ke.liang on 2019/3/6.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Differentiator


enum  CompanyDetailMultiSection {
    case companyTagSection(title:String, items:[CompanyDetailItem])
    case companyDetailSection(title:String, items:[CompanyDetailItem])
    case companyLocation(title:String, items:[CompanyDetailItem])
    case companyLink(title:String, items:[CompanyDetailItem])
}

enum CompanyDetailItem{
    case tags(mode: [String])
    case detail(mode:String)
    case location(mode:[String])
    case link(mode:String)
}

extension CompanyDetailMultiSection: SectionModelType{
    typealias Item = CompanyDetailItem
    
    var title:String{
        switch self {
            case .companyTagSection(let title, _):
                return title
            case .companyDetailSection(let title, _):
                return title
            case .companyLocation(let title, _):
                return title
            case .companyLink(let title, _):
                return title
        }
    }
    
    var items: [CompanyDetailItem]{
        switch  self {
            case .companyTagSection(_, let items):
                return items
            case .companyDetailSection(_, let items):
                return items
            case .companyLocation(_, let items):
                return items
            case .companyLink(_, let items):
                return items
        }
    }
    
    init(original: CompanyDetailMultiSection, items: [CompanyDetailMultiSection.Item]) {
        switch original {
            case .companyTagSection(let title, _):
                self = .companyTagSection(title: title, items: items)
            case .companyDetailSection(let title, _):
                self = .companyDetailSection(title: title, items: items)
            case .companyLocation(let title, _):
                self = .companyLocation(title: title, items: items)
            case .companyLink(let title, _):
                self = .companyLink(title: title, items: items)
        }
    }
}

