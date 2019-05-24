//
//  SearchEnum.swift
//  internals
//
//  Created by ke.liang on 2019/2/18.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation


// 搜索类型
enum searchItem:String{
    
    case onlineApply = "onlineApply"
    case graduate = "graduate"
    case intern = "intern"
    case meeting = "meeting"
    case company = "company"
    case forum = "forum"
    case none = "none"
    // 简历添加类型
    case online = "online"
    case attachment = "attach"
    
    
    
    var searchType:String{
        get{
            switch self {
            case .forum:
                return "forum" 
            case .company, .intern, .meeting, .graduate, .onlineApply:
                return "jobs"
            default:
                return ""
            }
        }
    }
    
    func  getHotestWords()->[String]{
        
        
        return []
    }
    
    var describe:String{
        get{
            switch self {
            case .intern:
                return "实习"
            case .graduate:
                return "校招"
            case .onlineApply:
                return "网申"
            case .meeting:
                return "宣讲会"
            case .forum:
                return "论坛"
            case .company:
                return "公司"
            case .online:
                return "在线简历"
            case .attachment:
                return "附件简历"
            default:
                return ""
            }
        }
        
    }
    
    static func getType(name:String)->searchItem{
        if name == "实习"{
            return .intern
        }else if name == "校招"{
            return .graduate
        }else if name == "网申"{
            return .onlineApply
        }else if name == "论坛"{
            return .forum
        }else if name == "公司"{
            return .company
        }
        return .none
    }
    
}



