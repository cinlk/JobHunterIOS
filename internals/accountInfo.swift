
//
//  accountInfo.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper


enum appType:String {
    case weixin
    case weibo
    case qq
    case none
    
    
    var des:String{
        get{
            switch self {
            case .weibo:
                return "绑定微博账号"
            case .weixin:
                return "绑定微信账号"
            case .qq:
                return "绑定QQ账号"
            default:
                return ""
            }
        }
    }
    
}

class  myAccountInfo: Mappable{
    
    
    var itemName: [String:[AccountBase]]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        itemName <- map["itemName"]
    }
    
}


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

class AccountBinds: AccountBase{
    
    var isBind:Bool? = false
    var type:String?{
        didSet{
            apptype = appType.init(rawValue: type!)
        }
    }
    var apptype:appType?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        isBind <- map["isBind"]
        type <- map["type"]
    }
    
    
}


// 消息提醒 model

class  notifyMesModel:Mappable{
    
    var name:String?
    var isOn:Bool? = false
    var sectionTag:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        isOn <- map["isOn"]
        sectionTag <- map["sectionTag"]
    }
    
    
}

// 打招呼常用语
class greetingModel:Mappable{
    
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
class HelpAskModel:Mappable{
    
    var items:[HelpItemsModel] = []
    var guide:[HelpGuidModel] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        guide <- map["guide"]
    }
    
    
}

class HelpGuidModel:Mappable{
    
    var name:String?
    var image:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        image <- map["image"]
    }
    
}


class HelpItemsModel:Mappable{
    
    var title:String?
    var content:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        content <- map["content"]
    }
    
}



// 关注我们app model
class  AboutUsModel:Mappable{
    
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

