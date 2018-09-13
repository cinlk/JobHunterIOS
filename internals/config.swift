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

/* 定义全局的变量 */
// 时区

let regionRome =  Region.init(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)

// 手机安装的app 来第三方分享登录
var shareItems:[ShareItem] = []
//shareView Height
var shareViewH:CGFloat = 240




// url
let GITHUB_API_URL:String = "https://api.github.com"
let APP_JOB_URL:String = "http://18.179.132.85:8080"



// plist
let CITYS:String = "citys"


// tabBarImage and Size
let BarImg_Size = CGSize.init(width: 27, height: 26)
// TabBArImages Tuple
let TabItemImages:[(UIImage,UIImage)] = [(#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "selectedHome")),(#imageLiteral(resourceName: "graduation"), #imageLiteral(resourceName: "selectedGraduation")),(#imageLiteral(resourceName: "message"),#imageLiteral(resourceName: "selectedMessage")),(#imageLiteral(resourceName: "forum"), #imageLiteral(resourceName: "forum")),(#imageLiteral(resourceName: "person"), #imageLiteral(resourceName: "selectedPerson"))]
let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)



// chat bar
let ChatInputBarH:CGFloat = 45.0
let ChatKeyBoardH:CGFloat =  258.0

// chat view
let avatarSize:CGSize = CGSize.init(width: 45, height: 45)

// 本地 登录后自己的信息 （用于测试）
let myself:PersonModel = PersonModel(JSON: ["userID":"123456","company":"","name":"来自地球大于6","role":"求职","icon": #imageLiteral(resourceName: "evil").toBase64String()])!

// 匿名用户
var anonymous = false


// global greeting msg
var GreetingMsg:String = ""
var IsGreeting:Bool = true 







// APP 启动获取的全局信息
// 个人基本信息
var resumeBaseinfo =  personalBasicalInfo(JSON: ["tx":"chrome","name":"lk","gender":"男",
                                                 "city":"北京","colleage":"北大","degree":"专科","phone":"13718754627","email":"dqwd@163.com","birthday":"1990-01"])!

var phoneNumber:String = ""




// moya https 配置
let MoyaManager = Manager(
    configuration: URLSessionConfiguration.default,
    serverTrustPolicyManager: CustomServerTrustPoliceManager()
)

class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}





