//
//  SearchMenuEnum.swift
//  internals
//
//  Created by ke.liang on 2018/4/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


// 搜索类型
enum searchItem:String{
    
    case onlineApply = "onlineApply"
    case graduate = "graduate"
    case intern = "intern"
    case meeting = "meeting"
    case company = "company"
    case forum = "forum"
    case none = "none"
    // 简历添加类型
    case online = "online"
    case attachment = "attachment"
    
    
    var type:String{
        get{
            switch self {
            case .forum:
                return "forum" // 只是论坛
            default:
                return "jobs"  // 公司, 职位, 其他条件
            }
        }
    }
    
    var describe:String{
        get{
            switch self {
            case .intern:
                return "实习"
            case .graduate:
                return "校招"
            case .onlineApply:
                return "网申"
            case .meeting:
                return "宣讲会"
            case .forum:
                return "论坛"
            case .company:
                return "公司"
            case .online:
                return "在线简历"
            case .attachment:
                return "附件简历"
            default:
                return ""
            }
        }
        
    }
    
    static func getType(name:String)->searchItem{
        if name == "实习"{
            return .intern
        }else if name == "校招"{
            return .graduate
        }else if name == "网申"{
            return .onlineApply
        }else if name == "论坛"{
            return .forum
        }else if name == "公司"{
            return .company
        }
        return .none
    }
    
}



// 职位类型
enum jobType:String {
    // 实习职位
    case intern = "intern"
    // 校招职位
    case graduate = "graduate"
    // 网申职位
    case onlineApply = "onlineApply"
    // 空
    case none = ""
    
    case all = "all"
    
    
    var describe:String{
        get{
            switch self {
            case .intern:
                return "实习"
            case .graduate:
                return "校招"
            case .onlineApply:
                return "网申"
            case .all:
                return "全部"
            default:
                return ""
            }
        }
    }
    
    
    static func getType(name:String)->jobType{
        if name == "实习"{
            return .intern
        }else if name == "校招"{
            return .graduate
        }else if name == "网申"{
            return .onlineApply
        }else if name == "全部"{
            return .all
        }
        return .none
    }
    
}


// 简历投递状态

enum ResumeDeliveryStatus:String {
    
    case delivery = "delivery"
    case read = "read"
    case test = "test"
    case interview = "interview"
    case offer = "offer"
    case reject = "reject"
    case all = "all"
    case none = "none"
    
    
    
    var describe:String{
        get{
            switch self {
            case .delivery:
                return "投递成功"
            case .test:
                return "笔试"
            case .read:
                return "HR已阅"
            case .interview:
                return "面试"
            case .offer:
                return "录取"
            case .reject:
                return "不合适"
            case .all:
                return "全部"
            default:
                return ""
            }
        }
    }
    
    
    static func getType(name:String)->ResumeDeliveryStatus{
        if name == "投递成功"{
            return .delivery
        }else if name == "笔试"{
            return .test
        }else if name == "HR已阅"{
            return .read
            
        }else if name == "全部"{
            return .all
        }else if name == "面试"{
            return .interview
        }else if name == "录取"{
            return .offer
        }else if name == "不合适"{
            return .reject
        }
        
        return .none
    }
    
    
}



// 论坛分类
enum forumType:String{
    
    case interview = "interview"
    case ask = "ask"
    case offers = "offers"
    case help = "help"
    case life = "life"
    case none = ""
    
    // 自己的帖子
    case mypost = "mypost"
    
    
    static var items:[forumType]{
        get{
            return [forumType.interview, forumType.ask, forumType.offers, forumType.help]
        }
    }
    
    var describe:String{
        switch self {

        case .interview:
            return "笔记面经"
        case .ask:
            return "热门问题"
        case .offers:
            return "offer比较"
        case .help:
            return "帮助"
        case .life:
            return "生活"
        case .mypost:
            return "我的帖子"
        case .none:
            return ""
        }
    
    }
}


// 专栏 类型
enum newsType {
    
    
    case toutiao(name:String, url:String)
    case zhuanlan(name:String, url:String)
    case test1(name:String, url:String)
    case test2(name:String, url:String)
    case none 
}



// 订阅类型
enum subscribeType:String {
    case graduate = "graduate"
    case intern = "intern"
    case none
    
    var describe:String{
        get{
            switch self {
            case .graduate:
                return "校招"
            case .intern:
                return "实习"
                
            default:
                return ""
            
            }
        }
    
    }
}

// 帖子分级
enum postKind:String {
    case post = "post"
    case reply = "reply"
    case subReply = "subReply"
    case none
    
    var describe:String{
        get{
            switch  self {
            case .post:
                return "帖子"
            case .reply:
                return "回帖"
            case .subReply:
                return "评论"
            default:
                return ""
            }
        }
    }
}


// 简历分类
enum resumeType:String {
    case online = "online"
    case attachment = "attachment"
    case none = ""
    
    var describe:String{
        get{
            switch self {
            case .online:
                return "在线简历"
            case .attachment:
                return "附件简历"
            default:
                return ""
                }
        }
    }
}


// 第三方app 类型
enum appType:String {
    
    case weixin = "weixin"
    case weibo = "weibo"
    case qq = "qq"
    case none = ""
    
    
    var des:String{
        get{
            switch self {
            case .weibo:
                return "微博账号"
            case .weixin:
                return "微信账号"
            case .qq:
                return "QQ账号"
            default:
                return ""
            }
        }
    }
    
}


// 消息提醒类型
enum notifyType:String {
    case subscribe = "subscribe"
    case text = "text"
    case applyProgress = "applyProgress"
    case invitation = "invitation"
    case night = "night"
    case none = ""
    
    var des:String{
        get{
            switch self {
            case .subscribe:
                return "新的职位通知"
            case .text:
                return "聊天消息通知"
            case .applyProgress:
                return "投递状态消息通知"
            case .invitation:
                return "邀约消息通知"
            case .night:
                return "夜间免打扰"
            default:
                return ""
            }
        }
    }
}

