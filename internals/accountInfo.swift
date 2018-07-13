
//
//  accountInfo.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper



class AccountBase: Mappable{
    
    
    var imageName:String?
    var name:String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageName <- map["imageName"]
        name <- map["name"]
    }
    
    
}

// 
class AccountSecurity: AccountBase{
    
    var extra:String?
    
   
    required init?(map: Map) {
        super.init(map: map)
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        extra <- map["extra"]
    }
    
}

// 第三方登录app 绑定
class AccountBinds: AccountBase{
    
    var isBind:Bool? = false
    var type:String?
    var kind:appType{
        get{
            guard let type = appType(rawValue: self.type!) else {
                    return .none
            }
            return type
        }
    }
    
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["isBind"] == nil || map.JSON["type"] == nil{
            return nil
        }
    }
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        isBind <- map["isBind"]
        type <- map["type"]
    }
    
    
}


// 消息提醒 model

class  notifyMesModel:Mappable{
    
    var type:String?
    var isOn:Bool? = false
 
    var kind:notifyType{
        get{
            guard let type = notifyType(rawValue: self.type!) else  {
                return .none
            }
            return type
        }
    }
    
    required init?(map: Map) {
        if map.JSON["type"] == nil || map.JSON["isOn"] == nil{
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        type <- map["type"]
        isOn <- map["isOn"]
        
    }
    
    
}

// 打招呼常用语
class greetingModel:NSObject,Mappable{
    
    var des:[String] = []
    var isOn:Bool = false
    var currentIndex:Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        des <- map["des"]
        isOn <- map["isOn"]
        currentIndex <- map["currentIndex"]
    }
}


// 帮助文档
class HelpAskModel:NSObject,Mappable{
    
    var items:[HelpItemsModel] = []
    var guide:[HelpGuidModel] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        guide <- map["guide"]
    }
    
    
}

class HelpGuidModel:NSObject, Mappable{
    
    var name:String?
    var image:String?
    // 查询具体的数据
    var guideURL:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        image <- map["image"]
        guideURL <- map["guideURL"]
    }
    
}


class HelpItemsModel:NSObject, Mappable{
    
    var title:String?
    var content:String?
    //
    var selected:Bool = false
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        content <- map["content"]
    
    }
    
}



// 我的app描述 model
class  AboutUsModel:Mappable{
    
    enum item:String {
        case serviceLaw
        case wechat
        case weibo
        case serviceCall
        case share
        
        var des:String{
            get{
                switch self {
                case .serviceLaw:
                    return "服务条款"
                case .wechat:
                    return "关注微信公众号"
                case .weibo:
                    return "关注微博"
                case .serviceCall:
                    return "客服电话"
                case .share:
                    return "分享我们"
                
                }
            }
        }
    }
    
    
    var wecaht:String? = ""
    var servicePhone:String? = ""
    var appId:String? = ""
    
    var appIcon:String? = "default"
    var appName:String? = ""
    var appDes:String? = ""
    
    var company:String? = ""
    var version:String? = ""
    var copyRight:String? = ""
    
    // 服务条款
    var serviceRuleURL:String? = "http://"
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        wecaht <- map["wecaht"]
        servicePhone <- map["servicePhone"]
        appId <- map["appId"]
        appIcon <- map["appIcon"]
        appName <- map["appName"]
        appDes <- map["appDes"]
        company <- map["company"]
        version <- map["version"]
        copyRight <- map["copyRight"]
        serviceRuleURL <- map["serviceRuleURL"]
        
        
    }
}

