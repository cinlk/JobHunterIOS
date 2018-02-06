//
//  person_resume.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



fileprivate let deafualtTX:UIImage = #imageLiteral(resourceName: "jing")

struct person_base_info {
    
    var tx:UIImage
    var name:String
    var sex:String
    var city:String
    var degree:String
    var birthday:String
    var age:Int = 0
    var phone:String
    var email:String
    
    init(tx:UIImage? = nil,name:String,sex:String,city:String,degree:String,birthday:String,
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
    
    mutating func setAge(age:Int){
        self.age = age
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
    
    
    mutating func changeCity(city:String){
        self.city = city
    }
    
    func getTimes(c:String = "至")->String{
        return self.startTime + c + self.endTime
    }
    
}

struct person_projectInfo {
    var company:String
    var role:String
    var startTime:String
    var endTime:String
    var content:String
    var city:String
    
    init(company:String, role:String, startTime:String, endTime:String, content:String,
         city:String) {
        self.company = company
        self.role = role
        self.startTime = startTime
        self.endTime = endTime
        self.content = content
        self.city = city
    }
    
    func getTimes(c:String = "至")->String{
        return self.startTime + c + self.endTime
    }
    
    func getOthers()->String{
        return self.company + "|" + self.role + "|" + self.city
    }
}




struct person_skills {
    
    enum skillType:String {
        case professional = "职业技能"
        case language = "语言能力"
        case other = "其他"
    }
    
    
    var type:skillType
    var describe:String
    
    
    init(type:skillType, describe:String) {
        self.type = type
        self.describe = describe
    }
}


