//
//  personRequestModel.swift
//  internals
//
//  Created by ke.liang on 2019/5/18.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation




class PersonBriefReq {
    
    private var name:String = ""
    private var gender:String = ""
    private var sex:String {
        get{
            // 后台识别的类型
            if self.gender == "男"{
                return "male"
            }else if self.gender == "女"{
               return "female"
            }else{
                return ""
            }
        }
    }
    private var colleage:String = ""
    
    init(name:String, gender: String, colleage:String) {
        self.name = name
        self.gender = gender
        self.colleage = colleage
    }
    
    
    
    func toJSON() -> [String:Any]{
        return ["name": self.name, "gender": sex, "college": colleage]
    }
    
    
    
}


@objcMembers class TextResumeBaseInfoReq:NSObject{
    
    var id:String = ""
    var resumeId:String = ""
    var name:String = ""
    var college:String = ""
    var gender:String = ""
    var city:String = ""
    var degree:String = ""
    var birthday:String = ""
    var phone:String = ""
    var email:String = ""
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["id": self.id, "resume_id":self.resumeId, "name": self.name, "college": self.college, "gender": self.gender, "city":self.city, "degree":self.degree, "birthday": self.birthday, "phone":self.phone, "email":self.email]
    }
    
}




@objcMembers class TextResumeEducationReq:NSObject{
    
    var resumeId:String = ""
    var major:String = ""
    var college:String = ""
    var rank:String = ""
    var degree:String = ""
    var describe:String = ""
    var start_time:String = ""
    var end_time:String = ""
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "major": self.major, "college": self.college, "rank": self.rank, "degree":self.degree, "describe":self.describe, "start_time":self.start_time, "end_time": self.end_time]
    }
    
}


@objcMembers class TextResumeWorkReq:NSObject{
    
    var resumeId:String = ""
    var company_name:String = ""
    var work_type:String = ""
    var city:String = ""
    var position:String = ""
    var describe:String = ""
    var start_time:String = ""
    var end_time:String = ""
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "company_name": self.company_name, "work_type": self.work_type, "city":self.city, "position": self.position, "describe":self.describe, "start_time":self.start_time, "end_time": self.end_time]
    }
}


@objcMembers class TextResumeProjectReq:NSObject{
    
    var resumeId:String = ""
    var project_name:String = ""
    var project_level:String = ""
    var position:String = ""
    var describe:String = ""
    var start_time:String = ""
    var end_time:String = ""
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "project_name": self.project_name, "project_level": self.project_level, "position": self.position, "describe":self.describe, "start_time":self.start_time, "end_time": self.end_time]
    }
}



@objcMembers class TextResumeCollegeActiveReq:NSObject{
    
    var resumeId:String = ""
    var college:String = ""
    var orgnization:String = ""
    var position:String = ""
    var describe:String = ""
    var start_time:String = ""
    var end_time:String = ""
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "college": self.college, "orgnization": self.orgnization, "position": self.position, "describe":self.describe, "start_time":self.start_time, "end_time": self.end_time]
    }
}




@objcMembers class TextResumeSocialPracticeReq:NSObject{
    
    var resumeId:String = ""
    var practice_name:String = ""
    var describe:String = ""
    var start_time:String = ""
    var end_time:String = ""
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "practice_name": self.practice_name, "describe":self.describe, "start_time":self.start_time, "end_time": self.end_time]
    }
}



@objcMembers class TextResumeSkillReq:NSObject{
    
    var resumeId:String = ""
    var skill_name:String = ""
    var describe:String = ""
   
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "skill_name": self.skill_name, "describe":self.describe]
    }
}



@objcMembers class TextResumeOtherReq:NSObject{
    
    var resumeId:String = ""
    var title:String = ""
    var describe:String = ""
    
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "title": self.title, "describe":self.describe]
    }
}


@objcMembers class TextResumeEstimateReq:NSObject{
    
    var resumeId:String = ""
    var content:String = ""
    
    
    
    override init() {
        super.init()
    }
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["resume_id":self.resumeId, "content": self.content]
    }
}


@objcMembers class JobSubscribeReq: NSObject {
    
    var fields:String = ""
    var citys:[String] = []
    var degree:String = ""
    var type:String = ""
    var salary:String = ""
    var intern_day:String = ""
    var intern_month:String = ""
    var intern_salary:String = ""
    override init() {
        super.init()
    }
    
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    func toJSON() -> [String:Any]{
        return ["fields":self.fields, "citys": self.citys, "degree": self.degree,
                "type": self.type, "salary": self.salary, "intern_day": self.intern_day,
                "intern_month": self.intern_month, "intern_salary": self.intern_salary]
    }
}


