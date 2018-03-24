//
//  subscribeConditionModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class subscribeConditionModel: NSObject,  Mappable {
    
    var type:String?
    var des:[String]?
    var locate:String?
    var salary:String?
    var business:String?
    var internDay:String?
    var degree:String?
    var internMonth:String?
    var internSalary:String?
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        
        type <- map["type"]
        des <- map["des"]
        locate <- map["locate"]
        salary <- map["salary"]
        business <- map["business"]
        internDay <- map["internDay"]
        degree <- map["degree"]
        internMonth <- map["internMonth"]
        internSalary <- map["internSalary"]
    }
    
    func getAttributes()->[(String,String)]{
        if self.type == "校招"{
            return [("职位类型",type!),("城市", locate!),("职位类别",des!.joined(separator: "+")),("从事行业", business!),("学位",degree!),("薪资范围",salary!)]
        }
        return [("职位类型",type!),("城市",locate!),("职位类别",des!.joined(separator: "+")),("从事行业",business!),("实习天数",internDay!),("实习薪水",internSalary!),("实习时间",internMonth!),("学位",degree!)]
    }
    func transForData(target:[String:String]){
        self.type = target["职位类型"] ?? ""
        self.locate = target["城市"] ?? ""
        self.des = target["职位类别"]?.components(separatedBy: "+")
        self.business = target["从事行业"] ?? ""
        self.degree = target["学位"] ?? ""
        if self.type == "实习"{
            self.internDay = target["实习天数"]
            self.internMonth = target["实习时间"]
            self.internSalary = target["实习薪水"]
        }else{
            self.salary = target["薪资范围"]
        }
    }
    
}


