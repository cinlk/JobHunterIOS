//
//  config.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



/* 定义全局的变量 */


//  几何形状相关


let NAV_BAR_FRAME_WIDTH:CGFloat = 320.0
let NAV_BAR_FRAME_HEIGHT:CGFloat = 64.0
let KEYBOARD_HEIGHT:CGFloat = 216.0

let NavBarH:CGFloat = 44
let NavH:CGFloat = 64

let ScreenW:CGFloat = UIScreen.main.bounds.width
let ScreenH:CGFloat = UIScreen.main.bounds.height

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





let myself:FriendModel = FriendModel.init(name: "lk", avart: "lk", companyName: "", id: "1")


