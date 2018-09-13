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
    
   
   // 职位诱惑 描述
   internal var benefits:String?
    
   // 关联的公司
   internal var company:CompanyModel?
    
   // 发布者
   internal var hr:HRPersonModel?
    
    
   // 应聘者技能要求
   internal var requirement:String?
   // 职位工作内容
   internal var works:String?
    
   // 职位类型 (对应筛选行业条件)
   internal var industry:[String] = []
    internal var major:[String] = []
    
   // 对应公司里 职位筛选条件
   internal var jobtags:[String] = []
    // 发布者ID
   internal var publisherID:String?
    
   // 和hr聊天标记
   internal var isTalked:Bool?
   
   //浏览次数
   internal var readNums:Int64 = 0
    
   // 工作城市
   internal var addressCity:[String] = []
   
   internal var address:[String] = ["不限"]
    
   // 工作地址
   internal var addressStr:String{
        get{
            // 最多5多个地址（前5个地址）
            if address.count > 5{
                return   address[0..<5].joined(separator: " ")
            }
            return   address.joined(separator: " ")
        }
    }
   
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
        
        if map.JSON["type"] == nil || map.JSON["company"] == nil ||
            map.JSON["create_time"] == nil || map.JSON["is_apply"] == nil || map.JSON["is_talk"] == nil   {
            return nil
        }
       
    }
    
    
    override func mapping(map: Map) {
      
        super.mapping(map: map)
        benefits <- map["benefits"]
        type <-  map["type"]
        company <- map["company"]
        address <- map["address"]
        salary <- map["salary"]
        education <- map["education"]
        perDay <- map["per_day"]
        months <- map["month"]
        isStuff <- map["is_staff"]
        isTalked <- map["is_talk"]
        applyEndTime <- (map["apply_end_time"], DateTransform())
        readNums <- map["read_num"]
        hr <- map["hr"]
        requirement <- map["requirement"]
        works <- map["works"]
        addressCity <- map["city"]
        industry <- map["industry"]
        major <- map["major"]
        jobtags <- map["job_tags"]
        
        
    }
    
    
}




