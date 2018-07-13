//
//  config.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import SwiftDate


/* 定义全局的变量 */

// 时区

let  regionRome =  Region.init(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)


// 不同版本键盘高度不一样？？
let KEYBOARD_HEIGHT:CGFloat = 216.0


// navigationbar 高度
let NavBarH:CGFloat = 44
// navigation View 高度
let NavH:CGFloat = 64
let TOOLBARH:CGFloat = 44
let searchBarH:CGFloat = 30

// 屏幕宽高
let ScreenW:CGFloat = UIScreen.main.bounds.width
let ScreenH:CGFloat = UIScreen.main.bounds.height


// cell lable offsetx 偏移
let TableCellOffsetX:CGFloat = 16


// url
let GITHUB_API_URL:String = "https://api.github.com"
let APP_JOB_URL:String = "http://52.199.50.0:8080"



// plist
let CITYS:String = "citys"


// tabBarImage and Size
let BarImg_Size = CGSize.init(width: 27, height: 26)
let Home_Img = "home"
let Select_Home_Img = "selectedHome"
let Job_Img = "graduation"
let Select_Job_Img = "selectedGraduation"
let Message_Img = "message"
let Select_Message_Img = "selectedMessage"
let Person_Img = "person"
let Select_Person_Img = "selectedPerson"


// chat bar
let ChatInputBarH:CGFloat = 45.0
let ChatKeyBoardH:CGFloat =  258.0

// chat view
let avatarSize:CGSize = CGSize.init(width: 45, height: 45)

// 本地 登录后自己的信息 （用于测试）
let myself:PersonModel = PersonModel(JSON: ["userID":"123456","company":"","name":"来自地球大于6","role":"求职","icon": #imageLiteral(resourceName: "evil").toBase64String()])!



// global greeting msg
var GreetingMsg:String = ""
var IsGreeting:Bool = true 


//shareView Height
let shareViewH:CGFloat = 240




// APP 启动获取的全局信息
// 个人基本信息
var resumeBaseinfo =  personalBasicalInfo(JSON: ["tx":"chrome","name":"lk","gender":"男",
                                                 "city":"北京","colleage":"北大","degree":"专科","phone":"13718754627","email":"dqwd@163.com","birthday":"1990-01"])!

var phoneNumber:String = ""



