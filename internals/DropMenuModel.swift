//
//  DropMenuModel.swift
//  internals
//
//  Created by ke.liang on 2019/2/22.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper

class SelectedCityModel: Mappable {
    
    
    var citys:[String:[String]]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        citys <- map["citys"]
    }
}


class BussinessFieldModel: Mappable {
    var fields:[String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        fields <- map["fields"]
    }
}

// 详细职位分类
class SubBusinessFieldModel: Mappable{
    
    var fields:[String:[String]]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        fields <- map["fields"]
    }
    
}


class CompanyTypeModel: Mappable{
    
    var type:[String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        type <- map["type"]
        
    }
    
}

class InternConditionModel: Mappable{
    
    var condition:[String:[String]]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        condition <- map["condition"]
    }
    
}


class CitysCollegeModel: Mappable{
    
    var cityCollege:[String:[String]]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cityCollege <- map["city_college"]
    }
}
