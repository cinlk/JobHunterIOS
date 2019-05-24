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
//import SwiftyJSON


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
    
    
    case startTime = "start_time"
    case endTime = "end_time"
    // eduacation
    case college = "college"
    case major = "major"
    case rank = "rank"
    case orgName = "orgnization"
    
    
    // project
    case pName = "project_name"
    case pScale = "project_level"
    //company
    case position = "position"
    case company = "company_name"
    case describe = "describe"
    case workType = "work_type"
    // social practice
    case practiceName = "practice_name"
    
    // skill
    case skill = "skill_name"
    
    
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
                return "开始时间"
            case .endTime:
                return "结束时间"
            case .college:
                return "学校"
            case .major:
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





// 简历分类

class ReumseListModel: NSObject,Mappable{
    
    
    // 简历名称
    var name:String?
    // 默认简历
    var isPrimary:Bool?
    
    // 简历id
    var resumeId:String?
    
    // 创建时间
    var createTime:Date?
    
    
    var createTimeStr:String{
        get{
            return showMonthAndDay(date: createTime) ?? ""
        }
    }
    // 简历类型
    var type:String?
    
    var resumeKind:resumeType{
        get{
            return resumeType(rawValue: type ?? "")!
        }
    }
    
    //在线简历内容
//    var content:ResumeMode?
//
//    // 附件链接 打开浏览？
//    var attachment:String?

    
    required init?(map: Map) {
//        if map.JSON["name"] == nil || map.JSON["isDefault"] == nil || map.JSON["id"] == nil ||
//            map.JSON["create_time"] == nil || map.JSON["kind"] == nil  {
//            return nil
//        }
    
    }
    
    
    func mapping(map: Map) {
        name <- map["name"]
        isPrimary <- map["is_primary"]
        resumeId <- map["resume_id"]
        createTime <- (map["create_time"],DateTransform())
        type <- map["type"]
        //content <- map["content"]
        
    }

    
}




// 文本简历 个人信息
internal class personalBaseInfoTextResume: personBaseInfo {
    
    
    var tx:URL?
    var name:String = "姓名"
    var college:String = "学校"
    var gender:String = "性别"
    var city:String = "城市"
    var degree:String = "学历"
    var birthday:String = "生日"
    var phone:String = "电话号码"
    var email:String = "邮箱"
    
    
    required init?(map: Map) {
        super.init(map: map)
//        if map.JSON["name"] == nil || map.JSON["colleage"] == nil || map.JSON["gender"] == nil ||
//            map.JSON["degree"] == nil || map.JSON["birthday"] == nil || map.JSON["phone"] == nil ||
//            map.JSON["email"] == nil {
//            return nil
//        }
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        tx <- (map["icon"], URLTransform())
        name <- (map["name"], DefaultValueTransform.init(defaultValue: "姓名"))
        gender <- (map["gender"], DefaultValueTransform.init(defaultValue: "性别"))
        college <- (map["college"],DefaultValueTransform.init(defaultValue: "学校"))
        city <- (map["city"], DefaultValueTransform.init(defaultValue: "城市"))
        degree <- (map["degree"], DefaultValueTransform.init(defaultValue: "学历"))
        birthday <- (map["birthday"], DefaultValueTransform.init(defaultValue: "生日"))
        phone <- (map["phone"], DefaultValueTransform.init(defaultValue: "电话号码"))
        email <- (map["email"], DefaultValueTransform.init(defaultValue: "邮箱"))
        
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.tx,ResumeInfoType.name,ResumeInfoType.gender,ResumeInfoType.college, ResumeInfoType.city,ResumeInfoType.degree, ResumeInfoType.birthday,ResumeInfoType.phone
            ,ResumeInfoType.email]
    }
    
    override func getTypeValue() -> [ResumeInfoType : String]? {
        
//        guard  let name = self.name, let  colleage = self.colleage, let  gender = self.gender, let degree = self.degree, let birthday = self.birthday, let  phone = self.phone,  let email = self.email
//            else {
//                return nil
//        }
        return [ResumeInfoType.tx: self.tx?.absoluteString ?? "" ,ResumeInfoType.name:name,ResumeInfoType.gender:gender,.college: college, ResumeInfoType.city:self.city,ResumeInfoType.degree:degree,ResumeInfoType.birthday: birthday, ResumeInfoType.phone: phone, ResumeInfoType.email: email]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.gender, .city, .degree, .birthday]
    }
    
}


internal class educationInfoTextResume: personBaseInfo {
    
    
    var college:String = ""
    var degree:String = ""
    var major:String = ""
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
        
        college <- map["college"]
        degree <- map["degree"]
        major <- map["major"]
        rank <- map["rank"]
        
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.college,ResumeInfoType.major,ResumeInfoType.degree,ResumeInfoType.rank,
                ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.college:self.college,ResumeInfoType.major:self.major,ResumeInfoType.degree:self.degree,ResumeInfoType.rank:self.rank, ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.startTime, .endTime,.degree, .rank]
    }
    
    func isValidate()->(Bool, String){
        return (true,"")
    }
    
}




internal class workInfoTextResume: personBaseInfo {
    
    
    
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
        
        company <- map["company_name"]
        city <- map["city"]
        workType <- map["work_type"]
        
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


// project
class ProjectInfoTextResume: personBaseInfo{
    
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
        pName <- map["project_name"]
        pScale <- map["project_level"]
        
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
class CollegeActivityTextResume: personBaseInfo{
    
    
    var college:String = ""
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
        college <- map["college"]
        orgName <- map["orgnization"]
    }
    
    override func getItemList()->[ResumeInfoType]{
        return [ResumeInfoType.college,ResumeInfoType.orgName,ResumeInfoType.position,ResumeInfoType.startTime,ResumeInfoType.endTime,ResumeInfoType.describe]
    }
    
    
    override func getTypeValue() -> [ResumeInfoType : String] {
        return [ResumeInfoType.startTime:self.startTimeString,ResumeInfoType.endTime:self.endTimeString,ResumeInfoType.college:self.college,ResumeInfoType.orgName:self.orgName,ResumeInfoType.position:self.position,ResumeInfoType.describe:self.describe]
        
    }
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.startTime, .endTime]
    }
    
}


// 社会实践
class SocialPracticeTextResume: personBaseInfo{
    
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
        practiceName <- map["practice_name"]
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



class SkillsTextResume: NSObject, Mappable, reumseInfoAction{
    var getId: String{
        return id
    }
    
    
    var id:String = ""
    var isOpen:Bool = false
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
        id <- map["id"]
        skill <- map["skill_name"]
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
    
    func getTypeValue() -> [ResumeInfoType : String]? {
        
        return [ResumeInfoType.skill: self.skill, .describe: self.describe]
        
    }
    func getPickerResumeType() -> [ResumeInfoType] {
        return [ResumeInfoType.skill]
    }
    
    
    
    func isValidate()->(Bool, String){
        return (true,"")
    }
    
    
}



class OtherTextResume: personBaseInfo{
    
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

class EstimateTextResume:NSObject, Mappable{
    
    var id:String = ""
    var isOpen:Bool = false
    var content:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
    }
    
    
}



// 个人文本简历
class PersonTextResumeModel: NSObject, Mappable{
    
    var resumeId:String?
    var resumeTyp: resumeType = .text
    // 简历完善程度 1-100
    var level:Int = 1
    //
    var basePersonInfo:personalBaseInfoTextResume = personalBaseInfoTextResume.init(JSON: [ : ])!
    // 教育经历
    var educationInfos: [educationInfoTextResume] = []
    // 实习/工作经历
    var workInfos:[workInfoTextResume] = []
    // 项目/比赛经历
    var projectInfos:[ProjectInfoTextResume] = []
    // 学生工作
    var colleageActivities: [CollegeActivityTextResume] = []
    // 实践活动
    var practice: [SocialPracticeTextResume] = []
    
    var skills:[SkillsTextResume] = []
    
    var other:[OtherTextResume] = []
    var selfEstimate:EstimateTextResume = EstimateTextResume.init(JSON: [:])!
    
    subscript(index: ResumeSubItems) -> Any?{
        get{
            switch index{
            case .personInfo:
                return self.basePersonInfo
            case .education:
                return self.educationInfos
            case .works:
                return self.workInfos
            case .project:
                return self.projectInfos
            case .schoolWork:
                return self.colleageActivities
            case .practice:
                return self.practice
            case .other:
                return self.other
            case .skills:
                return self.skills
            case .selfEvaludate:
                return selfEstimate
                
            default:
                return nil
            }
        }
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resumeId <- map["resume_id"]
        basePersonInfo <- map["base_person_info"]
        educationInfos <- map["education_infos"]
        workInfos <- map["work_infos"]
        projectInfos <- map["project_infos"]
        colleageActivities <- map["colleage_activities"]
        practice <- map["practice"]
        skills <- map["skills"]
        other <- map["other"]
        selfEstimate <- map["self_estimate"]
        level <- map["level"]
        
    }
    
    open func sortByEndTime(type: ResumeSubItems){
        
        let timeFormat = "yyyy-MM"
        
        switch type {
        case .education:
            guard  self.educationInfos.count > 1  else { return }
            self.educationInfos.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
            }
        case .works:
            guard   self.workInfos.count > 1 else { return }
            self.workInfos.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
            
        case .project:
            guard  self.projectInfos.count > 1 else { return }
            self.projectInfos.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
            
        case .schoolWork:
            guard self.colleageActivities.count > 1 else { return }
            self.colleageActivities.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        case .practice:
            guard  self.practice.count > 1 else { return }
            self.practice.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        default:
            break
        }
    }
}










protocol reumseInfoAction: class {
    
    
    func getTypeValue()->[ResumeInfoType:String]?
    
    func getPickerResumeType()->[ResumeInfoType]
    
    func getItemList()->[ResumeInfoType]
    
    var placeHolder:String{
        get
    }
    var getId:String{
        get
    }
    
}




// base

class  personBaseInfo:NSObject, Mappable, reumseInfoAction{
    
    var getId: String{
        return self.id!
    }
    
    
    var id:String?
    var isOpen:Bool = false
    
    var position:String = ""
    var describe:String = ""
//    var startTime:Date?
//    var endTime:Date?
    
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
        id <- map["id"]
        startTimeString <- map["start_time"]
        endTimeString <- map["end_time"]
        position <- map["position"]
        describe <- map["describe"]
    }
    
    func getTypeValue()->[ResumeInfoType:String]?{
        return nil
    }
    
    func getPickerResumeType()->[ResumeInfoType]{
        return []
    }
    
    func getItemList()->[ResumeInfoType]{
        return []
    }
    
    
    
   
}

class PersonInTroduceInfo: personBaseInfo{
    var iconURL:URL?
    var name:String = ""
    var gender:String = ""
    var colleage:String = ""
    
    internal var types = [ResumeInfoType.tx,ResumeInfoType.name, ResumeInfoType.gender, ResumeInfoType.college]
    
    required init?(map: Map) {
        super.init(map: map)
        
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        iconURL <- (map["icon_url"], URLTransform())
        name <- map["name"]
        gender <- map["gender"]
        colleage <- map["colleage"]
    }
    
    override func getPickerResumeType() -> [ResumeInfoType] {
        return [.gender]
    }
    
    subscript(index: Int) -> String{
        get{
            switch index{
                
            case 0:
                return self.iconURL?.absoluteString ?? "localimage"
            case 1:
                return self.name
            case 2:
                return self.gender
            case 3:
                return self.colleage
            default:
                return ""
            }
        }
        set{
            switch index{
            case 0:
                self.iconURL = URL.init(string: newValue)
            case 1:
                self.name = newValue
            default:
                break
            }
        }
    }
}





class  ResumeMode:NSObject, Mappable{
    
    //var basicinfo:personalBasicalInfo?
    var educationInfo:[educationInfoTextResume] = []
    
    var internInfo:[workInfoTextResume] = []
    var projectInfo:[ProjectInfoTextResume] = []
    var studentWorkInfo:[CollegeActivityTextResume] = []
    var practiceInfo:[SocialPracticeTextResume] = []
    var skills:[SkillsTextResume] = []
    var resumeOtherInfo:[OtherTextResume] = []
    
    // 个人评价
    var estimate:EstimateTextResume?
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
       // basicinfo <- map["basicinfo"]
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



