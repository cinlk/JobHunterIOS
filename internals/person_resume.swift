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
    
    case none = ""
    case tx = "icon"
    case name = "name"
    case gender = "gender"
    case city = "city"
    case degree = "degree"
    case birthday = "birthday"
    case phone = "phone"
    case email = "email"
    
    
    case startTime = "startTime"
    case endTime = "endTime"
    // eduacation
    case colleage = "colleage"
    case department = "department"
    case rank = "rank"
    case orgName = "orgName"
    
    
    // project
    case pName = "pName"
    case pScale = "pScale"
    //company
    case position = "position"
    case company = "company"
    case describe = "describe"
    case workType = "workType"
    // social practice
    case practiceName = "practiceName"
    
    // skill
    case skill = "skill"
    
    
    //other
    case title = "title"
    
    var describe:String{
        get{
            switch self {
            case .tx:
                return "头像"
            case .name:
                return "名字"
            case .gender:
                return "性别"
            case .city:
                return "城市"
            case .degree:
                return "学历"
            case .birthday:
                return "生日"
            case .phone:
                return "电话"
            case .rank:
                return "专业排名"
            case .email:
                return "邮件"
            case .startTime:
                return "生日"
            case .endTime:
                return "生日"
            case .colleage:
                return "学校"
            case .department:
                return "专业"
            case .position:
                return "职位"
            case .orgName:
                return "组织名称"
            case .pName:
                return "项目/比赛名称"
            case .pScale:
                return "项目/比赛规模"
            case .company:
                return "公司"
            case .workType:
                return "工作类型"
            case .practiceName:
                return "活动名称"
            case .describe:
                return "描述"
            case .skill:
                return "技能类型"
            case .title:
                return "标题"
            
            default:
                return ""
            }
        }
    }
    
    
}



protocol reumseInfoAction: class {
    
    
    func getTypeValue()->[ResumeInfoType:String]
    
    func getPickerResumeType()->[ResumeInfoType]
    
    func getItemList()->[ResumeInfoType]
    
    var placeHolder:String{
        get
    }
    
}




// base

class  personBaseInfo:NSObject, Mappable, reumseInfoAction{
    
    
    var position:String = ""
    var describe:String = ""
    // 格式为 "YYYY-MM"
    var startTimeString:String = ""
    var endTimeString:String = ""
    var placeHolder:String{
        get{
            return "内容"
        }
    }
    
    
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        startTimeString <- map["startTime"]
        endTimeString <- map["endTime"]
        position <- map["position"]
        describe <- map["describe"]
    }
    
    func getTypeValue()->[ResumeInfoType:String]{
        return [:]
    }
    
    func getPickerResumeType()->[ResumeInfoType]{
        return []
    }
    
    func getItemList()->[ResumeInfoType]{
        return []
    }
    
   
}


class personalBasicalInfo: personBaseInfo {
    
    var tx:String = "default"
    var name:String = ""
    var gender:String = ""
    var city:String = ""
    var degree:String = ""
    var birthday:String = ""
    var phone:String = ""
    var email:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        tx <- map["tx"]
        name <- map["name"]
        gender <- map["gender"]
        city <- map["city"]
        degree <- map["degree"]
        birthday <- map["birthday"]
        phone <- map["phone"]
        email <- map["email"]
        
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.tx,ResumeInfoType.name,ResumeInfoType.gender,ResumeInfoType.city
            ,ResumeInfoType.degree, ResumeInfoType.birthday,ResumeInfoType.phone
            ,ResumeInfoType.email]
    }
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.tx:self.tx,ResumeInfoType.name:self.name,ResumeInfoType.gender:self.gender,ResumeInfoType.city:self.city,ResumeInfoType.degree:self.degree,ResumeInfoType.birthday:self.birthday, ResumeInfoType.phone:self.phone, ResumeInfoType.email: self.email]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.gender, .city, .degree, .birthday]
    }
    
    
    
    
}


class personEducationInfo: personBaseInfo {
    
   
    var colleage:String = ""
    var degree:String = ""
    var department:String = ""
    var rank:String = ""
    
    override var placeHolder:String{
        get{
            return "专业描述"
        }
    }
    required init?(map: Map) {
        super.init(map: map)
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
       
        colleage <- map["colleage"]
        degree <- map["degree"]
        department <- map["department"]
        rank <- map["rank"]
        
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.colleage,ResumeInfoType.department,ResumeInfoType.degree,ResumeInfoType.rank,
                ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }
   
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.colleage:self.colleage,ResumeInfoType.department:self.department,ResumeInfoType.degree:self.degree,ResumeInfoType.rank:self.rank, ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.startTime, .endTime,.degree, .rank]
    }
    
    func isValidate()->(Bool, String){
        return (true,"")
    }
    
}

class personInternInfo: personBaseInfo {
    
    
    
    var company:String = ""
    
    var workType:String = ""
    
    var city:String = ""
    
    override var placeHolder:String{
        get{
            return "工作内容描述"
        }
    }
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
   

    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        company <- map["company"]
        city <- map["city"]
        workType <- map["workType"]
        
    }

    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.workType,ResumeInfoType.company,ResumeInfoType.city,ResumeInfoType.position,ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }

    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.company:self.company,ResumeInfoType.city:self.city,ResumeInfoType.workType:self.workType,ResumeInfoType.position:self.position,ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [ResumeInfoType.workType, .startTime, .endTime]
    }
    
    func isValidate()->(Bool, String){
        
        return (true,"")
    }
    
}






class personSkillInfo: NSObject, Mappable, reumseInfoAction{
    
    
    var skill:String = ""
    var describe:String = ""
    
    var placeHolder:String{
        get{
            return "技能描述"
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        skill <- map["skill"]
        describe <- map["describe"]
    }
    
    
    func getItemByType(type: ResumeInfoType) -> String{
        switch type {
        case .skill:
            return self.skill
        case .describe:
            return self.describe
        default:
            return ""
        }
    }
    
    func changeValue(type: ResumeInfoType, value:String) {
        
        switch type {
        case .skill:
            self.skill = value
        case .describe:
            self.describe = value
        default:
            break
        }
    }
    
    func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.skill,ResumeInfoType.describe]
    }
    
    func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.skill: self.skill, .describe:self.describe]
        
    }
    func getPickerResumeType() -> [ResumeInfoType] {
        return [ResumeInfoType.skill]
    }
    
    
    
    func isValidate()->(Bool, String){
        return (true,"")
    }
    
    
}

// project
class personProjectInfo: personBaseInfo{
    
    var pName:String = ""
    var pScale:String = ""
   
    override var placeHolder:String{
        get{
            return "项目描述与主要工作"
        }
    }
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        pName <- map["pName"]
        pScale <- map["pScale"]
       
    }
    
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.pName,ResumeInfoType.pScale,ResumeInfoType.position,ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }
    
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.pName:self.pName,ResumeInfoType.pScale:self.pScale,ResumeInfoType.position:self.position,ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [ResumeInfoType.pScale, .startTime, .endTime]
    }
    
    
}



// 校园工作
class studentWorkInfo: personBaseInfo{
    
    
    var colleage:String = ""
    var orgName:String = ""
    
    override var placeHolder:String{
        get{
            return "负责的工作内容"
        }
    }
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        colleage <- map["colleage"]
        orgName <- map["orgName"]
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.colleage,ResumeInfoType.orgName,ResumeInfoType.position,ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }
    
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.colleage:self.colleage,ResumeInfoType.orgName:self.orgName,ResumeInfoType.position:self.position,ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.startTime, .endTime]
    }
    
}



// 社会实践
class socialPracticeInfo: personBaseInfo{
    
    var practiceName:String = ""
    
    override var placeHolder:String{
        get{
            return "实践内容"
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        practiceName <- map["practiceName"]
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.practiceName,ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }
    
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.practiceName:self.practiceName,ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.startTime, .endTime]
    }
    
}



class resumeOther: personBaseInfo{
    
    var title:String = ""
    
    override var placeHolder:String{
        get{
            return "技能描述"
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.title,ResumeInfoType.describe]
    }
    
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.title:self.title,ResumeInfoType.describe:self.describe]
        
    }
    
    
}


class  ResumeMode:NSObject, Mappable{
    
    var basicinfo:personalBasicalInfo?
    var educationInfo:[personEducationInfo] = []
    
    var internInfo:[personInternInfo] = []
    var projectInfo:[personProjectInfo] = []
    var studentWorkInfo:[studentWorkInfo] = []
    var practiceInfo:[socialPracticeInfo] = []
    var skills:[personSkillInfo] = []
    var resumeOtherInfo:[resumeOther] = []
    
    // 个人评价
    var estimate:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        basicinfo <- map["basicinfo"]
        educationInfo <- map["educationInfo"]
        projectInfo <- map["projectInfo"]
        internInfo <- map["educationInfo"]
        studentWorkInfo <- map["studentWorkInfo"]
        practiceInfo <- map["practiceInfo"]
        skills <- map["skills"]
        resumeOtherInfo <- map["resumeOtherInfo"]
        estimate <- map["estimate"]
        
        
    }
    
}

