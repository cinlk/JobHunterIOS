//
//  person_resume.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftyJSON


fileprivate let deafualtTX:String = "jing"

enum personBaseInfo:String{
    
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

struct person_base_info {
    
    var tx:String
    var name:String
    var sex:String
    var city:String
    var degree:String
    var birthday:String
    var age:Int = 0
    var phone:String
    var email:String
    let nowYear = DateInRegion().year
    
    init(tx:String? = nil,name:String,sex:String,city:String,degree:String,birthday:String,
         phone:String,email:String) {
        
        self.tx =  tx == nil ? deafualtTX : tx!
        self.name = name
        self.sex = sex
        self.city = city
        self.degree = degree
        self.birthday = birthday
        self.phone = phone
        self.email = email
    }
    
    init() {
        self.tx = deafualtTX
        self.name = ""
        self.sex = ""
        self.city = ""
        self.degree = ""
        self.birthday = ""
        self.phone = ""
        self.email = ""
    }
    
    mutating func setTX(tx:String){
        self.tx = tx
    }
    mutating func setAge(age:Int){
        self.age = age
    }
    
    func getValueByType(type:personBaseInfo)->String{
        
        switch type {
        
        case .tx:
            return self.tx
        case .birethday:
            return self.birthday
        case .city:
            return self.city
        case .degree:
            return self.degree
        case .email:
            return self.email
        case .gender:
            return self.sex
        case .phone:
            return self.phone
        case .name:
            return self.name
        default:
            return ""
        }
        
      
    }
    
    func getBaseNames()->[personBaseInfo]{
        
        return [personBaseInfo.tx,personBaseInfo.name,personBaseInfo.gender,personBaseInfo.city
            ,personBaseInfo.degree, personBaseInfo.birethday,personBaseInfo.phone
            ,personBaseInfo.email]
    }
    
    mutating func changeByKey(type:personBaseInfo,value:String){
        
        switch type {
        case .tx:
            self.tx = value
        case .gender:
            self.sex = value
        case .city:
            self.city = value
        case .birethday:
            self.birthday = value
            let year = String.init(value.split(separator: ".")[0])
            self.age = nowYear - (Int(year) ?? 0)
        case .degree:
            self.degree = value
        case .email:
            self.email = value
        case .name:
            self.name = value
        case .phone:
            self.phone = value
        default:
            return 
        }
    }
    
    
    
    
}

struct person_education {
    
    var startTime:String
    var endTime:String
    var colleage:String
    var degree:String
    var department:String
    var city:String
    
    init(startTime:String, endTime:String, colleage:String, degree:String, department:String,
         city:String) {
        self.startTime = startTime
        self.endTime = endTime
        self.degree = degree
        self.colleage = colleage
        self.department = department
        self.city = city
    }
    
    init() {
        self.startTime = ""
        self.endTime = ""
        self.department = ""
        self.degree = ""
        self.colleage = ""
        self.city = ""
    }
    
    mutating func changeCity(city:String){
        self.city = city
    }
    
    func getTimes(c:String = "至")->String{
        return self.startTime + c + self.endTime
    }
    
    func getItemByType(type:personBaseInfo)->String{
        switch type {
        case .startTime:
            return self.startTime
        case .endTime:
            return self.endTime
        case .degree:
            return self.degree
        case .city:
            return self.city
        case .department:
            return self.department
        case .colleage:
            return self.colleage
        default:
            break
        }
        
        return ""
    }
    func getItemList()->[personBaseInfo]{
        return [personBaseInfo.startTime,personBaseInfo.endTime,personBaseInfo.colleage,
                personBaseInfo.department,personBaseInfo.city,personBaseInfo.degree]
    }
    
    
    
    mutating func changeValue(pinfoType:personBaseInfo,value:String){
        switch pinfoType {
        case .startTime:
            self.startTime = value
        case .endTime:
            self.endTime = value
        case .degree:
            self.degree = value
        case .colleage:
            self.colleage = value
        case .department:
            self.department = value
        case .city:
            self.city = value
        default:
            break
        }
    }
    // MARK replace by error type
    func isValidate()->(Bool,String){
        if self.startTime == "" || self.endTime == "" || self.degree == "" || self.colleage == ""
        || self.department == "" {
            return (false,"请检查输入")
        }
        return (true,"")
        
    }
    
}

struct person_projectInfo {
    
    var company:String
    var position:String
    var startTime:String
    var endTime:String
    var describe:String
    var city:String
    
    init(company:String, role:String, startTime:String, endTime:String, content:String,
         city:String) {
        self.company = company
        self.position = role
        self.startTime = startTime
        self.endTime = endTime
        self.describe = content
        self.city = city
    }
    init() {
        self.company = ""
        self.position = ""
        self.startTime = ""
        self.endTime = ""
        self.describe = ""
        self.city = ""
        
    }
    
    func getTimes(c:String = "至")->String{
        return self.startTime + c + self.endTime
    }
    
    func getOthers()->String{
        return self.company + "|" + self.position + "|" + self.city
    }
    
    func isValidate()->(Bool,String){
        if self.startTime == "" || self.endTime == "" || self.company == "" || self.position == ""
            || self.city == "" {
            return (false,"请检查输入")
        }
        return (true,"")
        
    }
    
    func getItemByType(type:personBaseInfo)->String{
        switch type {
        case .startTime:
            return self.startTime
        case .endTime:
            return self.endTime
        case .company:
            return self.company
        case .city:
            return self.city
        case .position:
            return self.position
        case .describe:
            return self.describe
        default:
            break
        }
        
        return ""
    }
    
    func getItemList()->[personBaseInfo]{
        return [personBaseInfo.startTime,personBaseInfo.endTime,personBaseInfo.city,
                personBaseInfo.company,personBaseInfo.position,personBaseInfo.describe]
    }
    mutating func changeValue(pinfoType:personBaseInfo,value:String){
        switch pinfoType {
        case .startTime:
            self.startTime = value
        case .endTime:
            self.endTime = value
        case .position:
            self.position = value
        case .company:
            self.company = value
        case .describe:
            self.describe = value
        case .city:
            self.city = value
        default:
            break
        }
    }
    
}




struct person_skills {
    
//    enum skillType:String {
//        case professional = "职业技能"
//        case language = "语言能力"
//        case other = "其他"
//    }
    
    
    var skillType:String
    var describe:String
    
    
    init(type:String, describe:String) {
        self.skillType = type
        self.describe = describe
    }
    
    init() {
        self.skillType = ""
        self.describe = ""
    }
    
    func isValidate()->(Bool,String){
        if self.skillType == "" || self.describe == "" {
            return (false,"请检查输入")
        }
        return (true,"")
        
    }
    
    func getItemList()->[personBaseInfo]{
        return [personBaseInfo.skill,personBaseInfo.describe]
    }
    
    func getItemByType(type:personBaseInfo)->String{
        switch type {
        case .skill:
            return self.skillType
        case .describe:
            return self.describe
        default:
            return ""
        }
    }
    
    mutating func changeValue(pinfoType:personBaseInfo,value:String){
        switch pinfoType {
        case .skill:
            self.skillType = value
        case .describe:
            self.describe = value
        default:
            break
        }
    }
    
}



class  personModelManager {
    
    
    var personBaseInfo:person_base_info?
    
    var educationInfos:[person_education] = []
    
    var projectInfo:[person_projectInfo] = []
    
    var skillInfos:[person_skills] = []
    var estimate = ""
    
    static let shared: personModelManager = personModelManager()
    
    //var modifyIndex:[Int] = [0,0,0]
    
    private init(){
        initialData()
    }
    
    
    enum InfoType:String{
        case education = "教育经历"
        case project = "项目经历"
        case skill = "技能"
        
        
    }
    
    open func initialData(){
        
         let myinfo:person_base_info = person_base_info.init(name: "lk", sex: "男", city: "北京", degree: "硕士", birthday: "1988-10", phone: "13718754627", email: "kdwad@163.comdqwdq")
        
        
        let education_infos:[person_education] = [person_education.init(startTime: "2017-10", endTime: "2018-02", colleage: "北大", degree: "本科", department: "土木工程", city: "北京"),person_education.init(startTime: "2017-10", endTime: "2018-02", colleage: "北大", degree: "本科", department: "土木工程", city: "北京")]
        
        let project_infos:[person_projectInfo] = [person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 等我大大", city: "北京"),person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个打我打我的挖的我吊袜带挖打我多哇大无多无吊袜带挖 \n 等我大大达瓦大", city: "北京"),person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个打我打我的挖的我吊袜带挖打我多哇大无多无吊袜带挖 \n 等我大大达瓦大", city: "北京"),person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个打我打我的挖的我吊袜带挖打我多哇大无多无吊袜带挖 \n 等我大大达瓦大", city: "北京"),person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个打我打我的挖的我吊袜带挖打我多哇大无多无吊袜带挖 \n 等我大大达瓦大", city: "北京")]
        
        let skill_infos:[person_skills] = [person_skills.init(type: "职业技能", describe: "python"),person_skills.init(type: "职业技能", describe: "java 达瓦大哇多无 吊袜带挖达瓦大文的哇多无吊袜带挖多哇多吊袜带挖多哇多哇多哇多达瓦大多哇多哇多 \n 打我打我的"),
                                                   person_skills.init(type: "语言能力", describe: "英语6级 java 达瓦大哇多无 吊袜带挖达瓦大文的哇多无吊袜带挖多哇多吊袜带挖多哇多哇多哇\n 多达瓦大多哇多哇多 \n 达瓦大------43534dwad-  -dwadwadwddw")]
        
        let  evaluate:String = " 吊袜带挖达瓦大文的哇的伟大哇打我的娃吊袜带挖达瓦大文大大的挖的我达瓦的达瓦达瓦的达瓦大吊袜带挖达瓦大文打我打我的达瓦大哇多无  "
        
        personBaseInfo = myinfo
        estimate = evaluate
        self.educationInfos.removeAll()
        self.projectInfo.removeAll()
        self.skillInfos.removeAll()
        for item in education_infos{
            
            self.educationInfos.append(item)
        }
        for item in project_infos{
            self.projectInfo.append(item)
        }
        
        for item in skill_infos{
            self.skillInfos.append(item)
        }
        
        
    }
    
    
    
    //private var infoCollections:Dictionary<InfoType,[Any]> = [:]

    
    open  func add(type:InfoType, item:Any){
        switch type {
        case .education:
            if let data = item as? person_education{
                self.educationInfos.append(data)
            }
        case .project:
            if let data = item as? person_projectInfo{
                self.projectInfo.append(data)
            }
        case .skill:
            if let data = item as? person_skills{
                self.skillInfos.append(data)
            }
        
        }
    }
    
    open func modify(type:InfoType, item:Any, index:Int){
        switch type {
        case .education:
            if let data = item as? person_education{
                self.educationInfos[index] = data
            }
        case .project:
            if let data = item as? person_projectInfo{
                self.projectInfo[index] = data
            }
        case .skill:
            if let data = item as? person_skills{
                self.skillInfos[index] = data
            }
            
        }
    }
    
    open func delete(type:InfoType,index:Int){
        switch type {
        case .education:
            if self.educationInfos.count > index && index >= 0 {
                self.educationInfos.remove(at: index)
            }
        case .project:
            if self.projectInfo.count > index && index >= 0 {
                self.projectInfo.remove(at: index)
            }
        case .skill:
            if self.skillInfos.count > index && index >= 0 {
                self.skillInfos.remove(at: index)
            }
        }
    }
    
    
}

