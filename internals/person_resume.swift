//
//  person_resume.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate
import SwiftyJSON


// 所有简历基本元素
enum ResumeInfoType:String{
    
    case none = "none"
    case tx = "头像"
    case name = "姓名"
    case gender = "性别"
    case city = "城市"
    case degree = "学位"
    case birethday = "生日"
    case phone = "电话"
    case email = "邮件"
    
    case startTime = "开始时间"
    case endTime = "结束时间"
    // eduacation
    case colleage = "学校"
    case department = "专业"
    
    //company
    case position = "职位"
    case company = "公司"
    case describe = "内容"
    
    // skill
    case skill = "能力/技能"
    
    
}

class personBasicInfo: NSObject, Mappable {
    
    var tx:String = "default"
    var name:String = ""
    var gender:String = ""
    var city:String = ""
    var degree:String = ""
    var birthday:Date = Date.init(timeIntervalSince1970: 0)
    var phone:String = ""
    var email:String = ""
    var birthDayString:String{
        get {
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM"
            
            let str = dateFormat.string(from: birthday)
            if str == "1970-01"{
                return ""
            }else{
                return str
            }
        }
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tx <- map["tx"]
        name <- map["name"]
        gender <- map["gender"]
        city <- map["city"]
        degree <- map["degree"]
        birthday <- (map["birthday"], YearMonthtDateTransform())
        phone <- map["phone"]
        email <- map["email"]
        
    }
    
    func getBaseNames()->[ResumeInfoType]{
        
        return [ResumeInfoType.tx,ResumeInfoType.name,ResumeInfoType.gender,ResumeInfoType.city
            ,ResumeInfoType.degree, ResumeInfoType.birethday,ResumeInfoType.phone
            ,ResumeInfoType.email]
    }
    
    
    func changeValue(type: ResumeInfoType, value:String) {
        switch type {
            
        case .birethday:
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            
            self.birthday =  format.date(from: value)!
        case .email:
            self.email = value
        case .phone:
            self.phone = value
        case .tx:
            self.tx =  value
        case .city:
            self.city = value
        case .name:
            self.name = value
        case .gender:
            self.gender = value
        case .degree:
            self.degree = value
        default:
            break
        }
    }
    
    
    func getItemByType(type: ResumeInfoType) -> String?{
        switch type {
        case .email:
            return self.email
        case .degree:
            return self.degree
        case .birethday:
            return self.birthDayString
        case .city:
            return self.city
        case .name:
            return self.name
        case .tx:
            return self.tx
        case .gender:
            return self.gender
        case .phone:
            return self.phone
            
        default:
            return ""
        }
    }
    
    
    
}

class personEducationInfo: NSObject,Mappable {
    
    var startTime:Date = Date.init(timeIntervalSince1970: 0)
    var endTime:Date = Date.init(timeIntervalSince1970: 0)
    var colleage:String = ""
    var degree:String = ""
    var department:String = ""
    var city:String = ""
    
    var startTimeString:String{
        get {
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM"
            
            let str = dateFormat.string(from: startTime)
            if str == "1970-01"{
                return ""
            }else{
                return str
            }
        }
    }
    var endTimeString:String{
        get {
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM"
            
            let str = dateFormat.string(from: endTime)
            if str == "1970-01"{
                return ""
            }else{
                return str
            }
        }
    }

    required init?(map: Map) {
        
    }
    
    func getItemByType(type: ResumeInfoType) -> String{
        switch type {
        case .colleage:
            return self.colleage
        case .degree:
            return self.degree
        case .startTime:
            return self.startTimeString
        case .endTime:
            return self.endTimeString
        case .department:
            return self.department
        case .city:
            return self.city
            
        default:
            return ""
        }
    }
    
    func changeValue(type: ResumeInfoType, value:String) {
        switch type {
        case .startTime:
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            self.startTime =  format.date(from: value)!
        case .endTime:
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            self.endTime =  format.date(from: value)!
        case .city:
            self.city = value
        case .department:
            self.department = value
        case .colleage:
            self.colleage = value
        case .degree:
            self.degree = value
        default:
            break
        }
    }
    
    func mapping(map: Map) {
        startTime <- (map["startTime"], YearMonthtDateTransform())
        endTime <- (map["endTime"], YearMonthtDateTransform())
        colleage <- map["colleage"]
        degree <- map["degree"]
        department <- map["department"]
        city <- map["city"]
    }
    
    func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.colleage,
                ResumeInfoType.department,ResumeInfoType.city,ResumeInfoType.degree]
    }
   
    
    func isValidate()->(Bool, String){
        return (true,"")
    }
    
}

class personInternInfo: NSObject, Mappable {
    
    var company:String = ""
    var position:String = ""
    var startTime:Date = Date.init(timeIntervalSince1970: 0)
    var endTime:Date = Date.init(timeIntervalSince1970: 0)
    var describe:String = ""
    var city:String = ""
    
    var startTimeString:String{
        get {
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM"
            
            let str = dateFormat.string(from: startTime)
            if str == "1970-01"{
                return ""
            }else{
                return str
            }
        }
    }
    
    var endTimeString:String{
        get {
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM"
            
            let str = dateFormat.string(from: endTime)
            if str == "1970-01"{
                return ""
            }else{
                return str
            }
        }
    }

    
    required init?(map: Map) {
        
    }
    
    func getItemByType(type: ResumeInfoType) -> String{
        switch type {
        case .company:
            return self.company
        case .position:
            return self.position
        case .startTime:
            return self.startTimeString
        case .endTime:
            return self.endTimeString
        case .describe:
            return self.describe
        case .city:
            return self.city
            
        default:
            return ""
        }
    }
    
    func changeValue(type: ResumeInfoType, value:String) {
        switch type {
        case .startTime:
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            self.startTime =  format.date(from: value)!
        case .endTime:
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            self.endTime =  format.date(from: value)!
        case .city:
            self.city = value
        case .describe:
            self.describe = value
        case .position:
            self.position = value
        case .company:
            self.company = value
        default:
            break
        }
    }
    
    
    func mapping(map: Map) {
        
        company <- map["company"]
        position <- map["position"]
        startTime <- (map["startTime"], YearMonthtDateTransform())
        endTime <- (map["endTime"], YearMonthtDateTransform())
        describe <- map["describe"]
        city <- map["city"]
        
    }

    func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.city,
                ResumeInfoType.company,ResumeInfoType.position,ResumeInfoType.describe]
    }
    
    func isValidate()->(Bool, String){
        
        return (true,"")
    }
    
}




class personSkillInfo: NSObject, Mappable{
    
    
    var skillType:String = ""
    var describe:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        skillType <- map["skillType"]
        describe <- map["describe"]
    }
    
    
    func getItemByType(type: ResumeInfoType) -> String{
        switch type {
        case .skill:
            return self.skillType
        case .describe:
            return self.describe
        default:
            return ""
        }
    }
    
    func changeValue(type: ResumeInfoType, value:String) {
        
        switch type {
        case .skill:
            self.skillType = value
        case .describe:
            self.describe = value
        default:
            break
        }
    }
    
    func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.skill,ResumeInfoType.describe]
    }
    
    func isValidate()->(Bool, String){
        return (true,"")
    }
    
    
}

class  ResumeMode:NSObject, Mappable{
    
    var basicinfo:personBasicInfo?
    var educationInfo:[personEducationInfo] = []
    var internInfo:[personInternInfo] = []
    var skills:[personSkillInfo] = []
    // 个人评价
    var estimate:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        basicinfo <- map["basicinfo"]
        educationInfo <- map["educationInfo"]
        internInfo <- map["educationInfo"]
        skills <- map["skills"]
        estimate <- map["estimate"]
        
        
    }
    
}

