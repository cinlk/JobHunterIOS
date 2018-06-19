//
//  OnlineApplyModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

class OnlineApplyModel: BaseModel {
    
    
    
    // 举办公司
    internal var companyIcon:String = "default"
    internal var companyName:String?
    
    // 截止时间
    internal var end_time:Date?
    
    
    internal var endTimeStr:String{
        get{
            
            guard let time = self.end_time else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            
            if time.year == Date().year{
                dateFormat.dateFormat = "MM-dd"
            }else{
                dateFormat.dateFormat = "yyyy-MM-dd"
            }
            let str = dateFormat.string(from: time)
            return str
        }
    }
    
    
    // 工作城市
    internal var address:[String]?
    // 专业
    internal var majors:[String]?
    // 职位
    internal var positions:[String]?
    
    

    // 官网招聘链接
    internal var link:String?
    
    // 外部链接
    //申请跳转外部地址
    // 如果是内部发布的网申，显示content 并简历可以投递
    internal var outer:Bool = true
    
    // 网申招聘描述（MARK）
    internal var content:String?
    
    // cell 视图显示条件
    internal var isSimple:Bool = false
    
    
    
    required init?(map: Map) {
        super.init(map: map)
      
        if map.JSON["end_time"] == nil{
            return nil
        }
        if map.JSON["outer"] != nil && (map.JSON["outer"] as! Bool) == true && map.JSON["link"] == nil{
            return nil
        }
        
        
    }
    
    override func mapping(map: Map) {
       
        super.mapping(map: map)
        end_time <- (map["end_time"], DateTransform())
        companyIcon <- map["companyIcon"]
        companyName <- map["companyName"]
        address <- map["address"]
        positions <- map["positions"]
        majors <- map["majors"]
        content <- map["content"]
        outer <- map["outer"]
        link <- map["link"]
        
        
    }
    

    
}
