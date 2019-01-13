//
//  constant.swift
//  internals
//
//  Created by ke.liang on 2018/9/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



// hub 提示
let LOADING = "加载中..."

var KEYBOARD_HEIGHT:CGFloat = 216.0
// 不同版本键盘高度不一样？？
func getKeyBoardHight() -> CGFloat{
    if #available(iOS 9.0, *){
        KEYBOARD_HEIGHT = 216.0
    }
    return KEYBOARD_HEIGHT
}




// navigationbar 高度
let NavBarH:CGFloat = 44
// navigation View 高度
let NavH:CGFloat = 64
let TOOLBARH:CGFloat = 44
let SEARCH_BAR_H:CGFloat = 30
let DROP_MENU_H:CGFloat = 40 

// 屏幕宽高


// cell lable offsetx 偏移
let TableCellOffsetX:CGFloat = 16


// Btn 名称
let NEARBY = "周边"


// 热门网申默认图片
let APPLY_DEFAULT_IMG = "default"
let ROTATE_IMA = "banner3"

// intern tag name
let INTERN_TAG_NAME = "实习"

// 滚动默认图
let SCROLLER_IMG = "banner3"


// 搜索分类
// job 板块
let JOB_PAGE_TITLES = ["网申","校招","宣讲会","公司","实习"]



//NOTIFICATION
let JOBTAG_NAME = "whichTag"




