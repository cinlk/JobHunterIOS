//
//  OnlineApplyModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper


class OnlineApplyListModel: NSObject, Mappable {
    
    internal var onlineApplyID:String?
    internal var companyIconURL:URL?
    internal var companyName:String?
    internal var citys:[String]?
    internal var name:String?
    internal var businessField:[String]?
    internal var endTime:Date?
    internal var endTimeStr:String?{
        get{
            guard let t = endTime, let ts = showMonthAndDay(date: t) else {
                return ""
            }
            return ts
        }
    }
    
    internal var outside:Bool?
    internal var isSimple:Bool = false 
    internal var link:URL?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
    
        onlineApplyID <- map["online_apply_id"]
        companyIconURL <- (map["company_icon_url"], URLTransform())
        citys <- map["citys"]
        businessField <- map["business_field"]
        endTime <- (map["end_time"], DateTransform())
        companyName <- map["company_name"]
        name <- map["name"]
        outside <- map["outside"]
        link <- map["link"]
        
    }
    
    
}

class OnlineApplyModel: BaseModel {
    
    // 举办公司
    //internal var companyIcon:String = "default"
   // internal var companyName:String?
    internal var company:CompanyModel?
    // 截止时间
    internal var end_time:Date?
    
    
    internal var endTimeStr:String{
        get{
            
            guard let time = self.end_time else { return "" }
            if let str = showMonthAndDay(date: time) {
                return str
            }
            return ""
        }
    }
    
    
    // 工作城市
    internal var address:[String]?
    // 专业
    internal var majors:[String]?
    // 职位
    internal var positions:[String]?
    
    

 
    
    // 外部链接
    //申请跳转外部地址
    // 如果是内部发布的网申，显示content 并简历可以投递
    internal var outer:Bool = true
    
    // 网申招聘描述（MARK）
    internal var contentType:String = "text" // html 或 text
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
        company <- map["company"]
        //companyIcon <- map["company_icon"]
        //companyName <- map["company_name"]
        address <- map["address"]
        positions <- map["positions"]
        majors <- map["majors"]
        contentType <- map["content_type"]
        content <- map["content"]
        outer <- map["outer"]
        
        
        
    }
    

    
}
