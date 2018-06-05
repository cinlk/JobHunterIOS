//
//  SubscribleItemEnum.swift
//  internals
//
//  Created by ke.liang on 2018/6/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation




enum subscribeItemType:String {
    case type = "type"
    case locate = "locate"
    case business = "business"
    case salary = "salary"
    case degree = "degree"
    case internDay = "internDay"
    case internMonth = "internMonth"
    case internSalary = "internSalary"
    
    
    var describe:String{
        get {
            switch self {
            case .type:
                return "职位类型"
            case .locate:
                return "城市"
            case .business:
                return "从事行业"
            case .degree:
                return "学历"
            case .salary:
                return "薪资范围"
            case .internDay:
                return "实习天数"
            case .internSalary:
                return "实习薪水"
            case .internMonth:
                return "实习时间"
            }
        }
    }
}
