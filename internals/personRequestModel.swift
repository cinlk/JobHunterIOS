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


