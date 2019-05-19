//
//  httpResponseModel.swift
//  internals
//
//  Created by ke.liang on 2019/5/19.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import ObjectMapper




class OnlineJobApplyResModel:Mappable{
    
    
    var exist:Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        exist <- map["exist"]
    }
}
