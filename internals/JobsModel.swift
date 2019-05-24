//
//  JobsModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper


// cell 显示job列表信息
class JobListModel: NSObject, Mappable{
    
    var jobId:String?
    var iconURL:URL?
    var companyName:String?
    var jobName:String?
    var address:[String]?
    var degree:String?
    var reviewCount:Int?
    var created_time:Date?
    // search 类型
    var companyType:String?
    var businessField:[String]?
    
    // 实习类型数据
    var days:Int?
    var months:Int?
    var payDay:Int?
    var isTransfer:Bool?
    
    
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
    
    var createdTimeStr:String{
        get{
            guard let time = self.created_time, let ts = showMonthAndDay(date: time) else {
                return ""
            }
            return ts
        }
    }
    
    
    required init?(map: Map) {
        if map.JSON["job_id"] == nil || map.JSON["type"] == nil{
            return nil
        }
    }
    
    func mapping(map: Map) {
        jobId <- map["job_id"]
        type <- map["type"]
        iconURL <- (map["icon_url"], URLTransform())
        companyName <- map["company_name"]
        jobName <- map["job_name"]
        address <- map["address"]
        degree <- map["degree"]
        reviewCount <- map["review_count"]
        created_time <- (map["created_time"], DateTransform())
        companyType <- map["company_type"]
        businessField <- map["business_field"]
        
        days <- map["days"]
        months <- map["months"]
        payDay <- map["pay_day"]
        isTransfer <- map["is_transfer"]
    }
    
}

class SimpleJobModel: NSObject, Mappable{
    
    var id:String?
    var name:String?
    var address:[String] = []
    
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
    
    var education:String?
    var created_time:Date?
    
    internal var creatTimeStr:String{
        get{
            
            guard let time = self.created_time else { return "" }
            
            if let str = showMonthAndDay(date: time){
                return str
            }
            return ""
        }
    }
    
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
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        address <- map["address"]
        education <- map["education"]
        created_time <- (map["created_time"],DateTransform())
        type <- map["type"]
        
      
    
        
        
    }
    
    
}

class CompanyTagJobs: SimpleJobModel{
    
    
    var tags:[String]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        tags <- map["tags"]
    }
}

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
   internal var company:SimpleCompanyModel?
    
   // 发布者
   internal var recruiter:HRPersonModel?
   // 对话id
   internal var conversation:String?
    
    
   // 应聘者技能要求
   internal var needSkills:String?
   // 职位工作内容
   internal var WorkContent:String?
    
   // 职位类型 (对应筛选行业条件)
   internal var businessField:[String] = []
   internal var major:[String] = []
    
   // 对应公司里 职位筛选条件
   internal var jobtags:[String] = []

    
   // 和hr聊天标记
   internal var isTalked:Bool?
   
   //浏览次数
   internal var reviewCounts:Int64 = 0
    
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
   
   internal var salary:String = ""
    
   internal var education:String = "不限"
    
    // 申请结束时间
   internal var applyEndTime:Date?
    
    // 实习数据
   internal var payDay:Int = 0
   internal var months:Int = 0
   // 可转正
   internal var isStuff:Bool = false
   internal var days:Int = 0
    
  
    
    
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
        
//        if map.JSON["type"] == nil || map.JSON["company"] == nil ||
//            map.JSON["create_time"] == nil || map.JSON["is_apply"] == nil || map.JSON["is_talk"] == nil   {
//            return nil
//        }
       
    }
    
    
    override func mapping(map: Map) {
      
        super.mapping(map: map)
        benefits <- map["benefits"]
        type <-  map["type"]
        company <- map["company"]
        address <- map["address"]
        salary <- map["salary"]
        education <- map["education"]
        
        days <- map["days"]
        payDay <- map["pay_day"]
        months <- map["months"]
        isStuff <- map["is_staff"]
        isTalked <- map["is_talk"]
        applyEndTime <- (map["apply_end_time"], DateTransform())
        reviewCounts <- map["review_counts"]
        
        recruiter <- map["recruiter"]
        needSkills <- map["need_skills"]
        WorkContent <- map["work_content"]
        addressCity <- map["city"]
        businessField <- map["business_field"]
        major <- map["major"]
        jobtags <- map["job_tags"]
        conversation <- map["conversation_id"]
        
        
    }
    
    
}




