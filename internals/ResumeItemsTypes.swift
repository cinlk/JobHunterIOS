//
//  ResumeTypes.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation




enum ResumeSubItems:String {
    case personInfo = "personInfo"
    case education = "education"
    case works = "works"
    case project  = "project"
    
    case schoolWork = "schoolWork"
    // 社会实践活动
    case practice  = "practice"
    case skills = "skills"
    case other = "other"
    // 自我评价
    case selfEvaludate = "self_evaluate"
    case none = "none"
    
    
    var describe:String{
        get{
            switch self {
            case .personInfo:
                return "个人基本信息"
            case .education:
                return "教育经历"
            case .works:
                return "实习/工作经历"
            case .project:
                return "项目/比赛经历"
            case .schoolWork:
                return "学生工作"
            case .practice:
                return "实践活动"
            case .skills:
                return "技能"
            case .selfEvaludate:
                return "自我评价"
            case .other:
                return "其他信息"
                
            default:
                return ""
            }
        }
    }
    
    
    var add:String{
        get{
            return "添加" + self.describe
        }
    }
    
    var remove:String{
        get{
           return  "删除" + self.describe
        }
    }
    
    
    
    
    
}
