//
//  config.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



/* 定义全局的变量 */

let KEYBOARD_HEIGHT:CGFloat = 216.0

// navigationbar 高度
let NavBarH:CGFloat = 44
// navigation View 高度
let NavH:CGFloat = 64

// 屏幕宽高
let ScreenW:CGFloat = UIScreen.main.bounds.width
let ScreenH:CGFloat = UIScreen.main.bounds.height


// cell lable offsetx 偏移
let TableCellOffsetX:CGFloat = 16


// url
let GITHUB_API_URL:String = "https://api.github.com"
let APP_JOB_URL:String = "http://127.0.0.1:8080"



// plist
let CITYS:String = "citys"


// tabBarImage and Size
let BarImg_Size = CGSize.init(width: 27, height: 26)
let Home_Img = "home"
let Select_Home_Img = "selectedHome"
let Message_Img = "message"
let Select_Message_Img = "selectedMessage"
let Person_Img = "person"
let Select_Person_Img = "selectedPerson"


// chat bar
let ChatInputBarH:CGFloat = 45.0
let ChatKeyBoardH:CGFloat =  258.0

// chat view
let avatarSize:CGSize = CGSize.init(width: 45, height: 45)


let myself:FriendModel = FriendModel.init(name: "lk", avart: "lk", companyName: "", id: "1")



// APP launch data

var talkedJobIds = [String]()
var SendResumeJobIds = [String]()


// global greeting msg
var GreetingMsg:String = ""
var IsGreeting:Bool = true 



// tableCell offsetX
let TableCellOffsetX:CGFloat = 16



