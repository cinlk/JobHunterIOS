//
//  config.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//


import Foundation
import SwiftDate
import Alamofire
import Moya
import Kingfisher

/* 定义全局的变量 */
// 时区

let regionRome =  Region.init(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)






// plist
let CITYS:String = "citys"


// tabBarImage and Size
let BarImg_Size = CGSize.init(width: 27, height: 26)
// TabBArImages Tuple
let TabItemImages:[(UIImage,UIImage)] = [(#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "selectedHome")),(#imageLiteral(resourceName: "graduation"), #imageLiteral(resourceName: "selectedGraduation")),(#imageLiteral(resourceName: "message"),#imageLiteral(resourceName: "selectedMessage")),(#imageLiteral(resourceName: "forum"), #imageLiteral(resourceName: "forum")),(#imageLiteral(resourceName: "person"), #imageLiteral(resourceName: "selectedPerson"))]

// color
struct ConfigColor {
    
    struct TabBarItemColor {
        static let SelectedColor = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        static let normalColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
    }
    
    struct PageTitleColor {
        
        static let SublineColor = UIColor.init(r: 100, g: 100, b: 100, alpha: 0.5)
    }
    
    
    
    
}



// chat bar
let ChatInputBarH:CGFloat = 45.0
let ChatKeyBoardH:CGFloat =  258.0

// chat view
let avatarSize:CGSize = CGSize.init(width: 45, height: 45)

// 本地 登录后自己的信息 （用于测试）
let myself:PersonModel = PersonModel(JSON: ["userID":"123456","company":"","name":"来自地球大于6","role":"求职","icon": #imageLiteral(resourceName: "evil").toBase64String()])!

// 匿名用户



// global greeting msg
var GreetingMsg:String = ""
var IsGreeting:Bool = true 







// APP 启动获取的全局信息
// 个人基本信息
var resumeBaseinfo =  personalBasicalInfo(JSON: ["tx":"chrome","name":"lk","gender":"男",
                                                 "city":"北京","colleage":"北大","degree":"专科","phone":"13718754627","email":"dqwd@163.com","birthday":"1990-01"])!

var phoneNumber:String = ""




// moya https 配置
//let MoyaManager = Manager(
//    configuration: URLSessionConfiguration.default,
//    serverTrustPolicyManager: CustomServerTrustPoliceManager()
//)
//
//class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
//    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
//        return .disableEvaluation
//    }
//    public init() {
//        super.init(policies: [:])
//    }
//}




// umeng config
struct  ConfigUMConfig {
    static let umKey:String = "5ac6ed8bb27b0a7ba6000059"
    struct  wechat {
        static let wechatAppKey = "wxd795d58c78ac222b"
        static let wechatAppSecret = "779c58188ca57046f76353ea1e84412c"
        static let redirectURL = "http://mobile.umeng.com/social"
    }
   
    struct sina {
        static let sinaAppKey = "879467986"
        static let sinaAppSecret = "a426356a2f770cba1c2fd88564635206"
        static let redirectURL = "https://api.weibo.com/oauth2/default.html"
    }
    
    struct qq {
        static let qqAppKey = "1106824184"
        static let qqAppSecret = "V0zSNqtNlo2wPIo7"
        static let redirectURL = "http://mobile.umeng.com/social"
    }
    
}


// share Config
struct ConfigSharedApp{
    
    struct wechat {
        static let url = "weixin://"
        static let name = "微信好友"
        static let image: UIImage? = UIImage.init(named: "wechat")
        static let type: UMSocialPlatformType = .wechatSession
    }
    // 微信朋友圈
    struct  wechatFriends {
        static let url = "weixin://"
        static let name = "微信朋友圈"
        static let image: UIImage? = UIImage.init(named: "friendCircle")
        static let type: UMSocialPlatformType = .wechatTimeLine
    }
    
    struct sina {
        static let url = "sinaweibo://"
        static let name = "sina"
        static let image: UIImage? = UIImage.init(named: "sina")
        static let type: UMSocialPlatformType = .sina
    }
    
    struct qq {
        static let url = "mqqapi://"
        static let name = "QQ"
        static let image: UIImage? = UIImage.init(named: "qqCircle")
        static let type: UMSocialPlatformType = .QQ
        
    }
    
    struct  qqZone {
        static let url = "mqqapi://"
        static let name = "QQ空间"
        static let image: UIImage? = UIImage.init(named: "qqZone")
        static let type: UMSocialPlatformType = .qzone
    }
    
}



// server base url
struct GlobalConfig {
    
    static let BASE_URL = "http://127.0.0.1:9090/api/v1/"
    // 屏幕宽高
    static let ScreenW:CGFloat = UIScreen.main.bounds.width
    static let ScreenH:CGFloat = UIScreen.main.bounds.height
    static let NavH:CGFloat = UIDevice.current.isX() ? 88 : 64
    static let defaultImage = "bigCar"
}

struct HttpCodeRange {
    
    static func filter<R: RangeExpression>(statusCodes: R, target: Int) -> Bool where R.Bound == Int {
        guard statusCodes.contains(target) else {
           return false
        }
        return true
    }
    
    static func filterSuccessResponse(target:Int) -> Bool{
        return HttpCodeRange.filter(statusCodes: 200...299, target: target)
    }
    
}




struct UserRole {
    
    enum role:String {
        case hr = "hr"
        case seeker = "seeker"
        case anonymous = "anonymous"
    }
    
    
}
