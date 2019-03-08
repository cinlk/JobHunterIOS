//
//  recruiterSectionModel.swift
//  internals
//
//  Created by ke.liang on 2019/3/3.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Differentiator

enum RecruiterSectionModel {
    case CompanySection(title:String, items: [RecruiterSectionItem])
    case JobsSection(title:String, items:[RecruiterSectionItem])
    case LabelSection(title:String, items:[RecruiterSectionItem])
}


enum RecruiterSectionItem {
    case CompanyItem(mode: SimpleCompanyModel)
    case JobItem(mode: SimpleJobModel)
    case Label(mode:String)
}


extension RecruiterSectionModel: SectionModelType{
    
    typealias Item = RecruiterSectionItem
    
    var items: [RecruiterSectionItem] {
        switch  self {
            case .CompanySection(_, let items):
                return items
            case .JobsSection(_, let items):
                return items
            case .LabelSection(_, let items):
                return items
        }
    }
        
    
    var title:String{
        switch  self {
            case .CompanySection(let title, _):
                return title
            case .JobsSection(let title, _):
                return title
            case .LabelSection(let title, _):
                return title
        }
    }
        
    init(original: RecruiterSectionModel, items: [RecruiterSectionItem]) {
        
        switch original {
            case .CompanySection(let title, _):
                self = .CompanySection(title: title, items: items)
            case .JobsSection(let title, _):
                self = .JobsSection(title: title, items: items)
            case .LabelSection(let title, _):
                self = .LabelSection(title: title, items: items)
            
        }
       
    }
    
    
   
    
    
}


