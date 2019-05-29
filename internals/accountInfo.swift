
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
    var open:Bool? = false
 
    var kind:notifyType{
        get{
            guard let type = notifyType(rawValue: self.type!) else  {
                return .none
            }
            return type
        }
    }
    
    required init?(map: Map) {
//        if map.JSON["type"] == nil || map.JSON["open"] == nil{
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        
        type <- map["type"]
        open <- map["open"]
        
    }
    
    
}

// 打招呼常用语
class greetingModel:NSObject,Mappable{
    
    var messages:[String] = []
    var open:Bool = false
    var number:Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messages <- map["messages"]
        open <- map["open"]
        number <- map["number"]
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
    
    
    var wechat:String? = ""
    var servicePhone:String? = ""
    var appId:String? = ""
    
    var appIcon:URL?
    
    var appName:String? = ""
    var appDes:String? = ""
    
    var company:String? = ""
    var version:String? = ""
    var copyRight:String? = ""
    
    // 服务条款
    var agreement:URL?
    
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        wechat <- map["wechat"]
        servicePhone <- map["service_phone"]
        appId <- map["app_id"]
        appIcon <- (map["app_icon"], URLTransform())
        appName <- map["app_name"]
        appDes <- map["app_describe"]
        company <- map["company"]
        version <- map["version"]
        copyRight <- map["copy_right"]
        agreement <- (map["agree_ment"], URLTransform())
        
        
    }
}

