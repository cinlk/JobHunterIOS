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








// plist
let CITYS:String = "citys"


// tabBarImage and Size

// TabBArImages Tuple
//let TabItemImages:[(UIImage,UIImage)] = [(#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "selectedHome")),(#imageLiteral(resourceName: "graduation"), #imageLiteral(resourceName: "selectedGraduation")),(#imageLiteral(resourceName: "message"),#imageLiteral(resourceName: "selectedMessage")),(#imageLiteral(resourceName: "forum"), #imageLiteral(resourceName: "forum")),(#imageLiteral(resourceName: "person"), #imageLiteral(resourceName: "selectedPerson"))]

// color
struct ConfigColor {
    
    struct TabBarItemColor {
        static let SelectedColor = UIColor(red: 240.0/255.0, green: 185.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        static let normalColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
    }
    
    struct PageTitleColor {
        
        static let SublineColor = UIColor.init(r: 100, g: 100, b: 100, alpha: 0.5)
    }
    
    
    
    
}



// chat bar

let ChatKeyBoardH:CGFloat =  258.0
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
    
    static let BASE_URL = "http://192.168.1.3:9090/api/v1/"
    // 屏幕宽高
    static let ScreenW:CGFloat = UIScreen.main.bounds.width
    static let ScreenH:CGFloat = UIScreen.main.bounds.height
    static let NavH:CGFloat = (UIDevice.current.isX() ? 44  : 20) + 44
    static let defaultImage = "bigCar"
    static let searchBarH:CGFloat = 30
    static let searchTopWord:String = "搜索记录"
    static let locale = Locale(identifier: "zh_CN")
    static let JobHomePageTitles:[String] = ["网申","校招","宣讲会","公司","实习"]
    static let dropMenuViewHeight:CGFloat = 40
    static let toolBarH:CGFloat = 44
    static let ChatInputBarH:CGFloat = 45
    
    static let DBName:String = "app.db"
    static let AvatarSize:CGSize = CGSize.init(width: 45, height: 45)
    static let regionRome =  Region.init(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
    
    struct DropMenuTitle {
        static let city = "城市"
        static let businessField = "行业分类"
        static let subBusinessField = "职业类型"
        static let companyType = "公司性质"
        static let interCondition = "实习条件"
        static let meetingTime = "宣讲时间"
        static let college = "大学"
        static let degree = "学历"
        
    }
    
    struct StoryBordVCName {
        static let Main = "Main"
        static let LoginVC = "login"
    }
    struct LeanCloudApp {
        static let AppId = "Wg3eXD1ftMSGqoDJhsFgy5xk-gzGzoHsz"
        static let AppKey = "iXpuFsScQm6YzIjK0fXGnob9"
        static let MasterKey = "PVrKTVDpgMveiCFBrjJGqKmc"
        // test user
        static let User1 = "5c885f55fe88c20065e160c8"
        static let User2 = "5c885f55fe88c20065e160c8"
        static let ConversationID = "5c88f876fb4ffe00638220a0"
    }
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

struct  NotificationName {
    static let searchType:Notification.Name =  Notification.Name.init("searchType")
    static let jobTag: Notification.Name = Notification.Name.init("jobTag")
    static let refreshChatList: Notification.Name = Notification.Name.init("refreshChat")
    static let refreshChatRow: Notification.Name = Notification.Name.init("refreshChatRow")
    static let messageBadge: Notification.Name = Notification.Name.init("messageBadage")
}

struct TabBarItems {
    
    struct barItem {
        var title:String
        var normalImg:UIImage
        var selectedImg:UIImage
    }
    
    static let items:[barItem]  = [barItem.init(title: "主页", normalImg: #imageLiteral(resourceName: "home"), selectedImg: #imageLiteral(resourceName: "selectedHome")),
                                   barItem.init(title: "职位", normalImg: #imageLiteral(resourceName: "degree"), selectedImg: #imageLiteral(resourceName: "graduation")),
                                   barItem.init(title: "消息", normalImg: #imageLiteral(resourceName: "message"), selectedImg: #imageLiteral(resourceName: "selectedMessage")),
                                   barItem.init(title: "论坛", normalImg: #imageLiteral(resourceName: "edit"), selectedImg: #imageLiteral(resourceName: "sms")),
                                   barItem.init(title: "个人", normalImg: #imageLiteral(resourceName: "person"), selectedImg: #imageLiteral(resourceName: "hr"))]
    
    // 切图替换
    static let imageSize = CGSize.init(width: 25, height: 25)
    
    
}


struct UserRole {
    
    enum role:String {
        case hr = "hr"
        case seeker = "seeker"
        case anonymous = "anonymous"
        
        var describe:String{
            switch self {
            case .hr:
                return "hr"
            case .seeker:
                return "seeker"
            case .anonymous:
                return "anonymous"
          
            }
        }
    }
    
   
    
}
