//
//  JobsModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

// MARK 添加更多的属性，比如id，标签等？？
class CompuseRecruiteJobs :BaseModel{
    
    enum jobType:String {
        case intern = "intern"
        case graduate = "graduate"
        case onlineApply = "onlineApply"
        case none = ""
        
        var describe:String{
            get{
                switch self {
                case .intern:
                    return "实习"
                case .graduate:
                    return "校招"
                case .onlineApply:
                    return ""
                default:
                    return ""
                }
            }
        }
        
    }
    

   // 职位类型 (必须)
   internal var type:String?{
        didSet{
            guard type != nil else {
                kind = .none
                return
            }
            kind = jobType.init(rawValue: type!)
        }
    }
   internal var kind:jobType?
    
    
   internal var tag:[String] = [""]
    // 关联的公司id  (必须)
   internal var companyID:String?
    // 发布者ID
   internal var publisherID:String?
    
   // 和hr聊天标记
    internal var isTalked:Bool?
    
    
   internal var address:String = "不限"
   
   internal var salary:String = "面议"
    
   internal var education:String = "不限"
    
    // 申请结束时间
   internal var applyEndTime:Date?
    
    // 实习数据
   internal var perDay:String = "面议"
   internal var months:String = "面议"
   // 可转正
   internal var isStuff:Bool = false
  
    
   internal var endTime:String{
        get{
            guard let time = self.applyEndTime else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let str = dateFormat.string(from: time)
            return str
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["type"] == nil || map.JSON["companyID"] == nil ||
            map.JSON["create_time"] == nil || map.JSON["isApply"] == nil || map.JSON["isTalked"] == nil {
            return nil
        }
    }
    
    
    override func mapping(map: Map) {
      
        super.mapping(map: map)
        tag <- map["tag"]
        type <-  map["type"]
        companyID <- map["companyID"]
        publisherID <- map["publisherID"]
        address <- map["address"]
        salary <- map["salary"]
        education <- map["education"]
        perDay <- map["perDay"]
        months <- map["months"]
        isStuff <- map["isStuff"]
        isTalked <- map["isTalked"]
        applyEndTime <- (map["applyEndTime"], DateTransform())
        
        
        
    }
    
    
}




