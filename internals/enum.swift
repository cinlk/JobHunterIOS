//
//  enum.swift
//  internals
//
//  Created by ke.liang on 2019/2/9.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation


// 刷新状态
enum PageRefreshStatus{
    case none
    case beginHeaderRefrsh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case NoMoreData
    case end
    // MARK 需要细化错误类型？
    case error(err:Error)
    
}



// 论坛分类
enum ForumType:String{
    
    case hottest = "hottest"
    case interview = "interview"
    case recommend = "recommend"
    case offer = "offer"
    case help = "help"
    case life = "life"
    case none = ""
    
    // 自己的帖子(标记查询条件)
    case mypost = "mypost"
    
    
    static var items:[ForumType]{
        get{
            return [ForumType.interview, ForumType.recommend, ForumType.offer, ForumType.help]
        }
    }
    
    var notificationName: Notification.Name?{
        switch  self {
        case .help:
            return Notification.Name.init("forumHelp")
        case .interview:
            return Notification.Name.init("forumInterview")
        case .offer:
            return Notification.Name.init("forumOffer")
        case .recommend:
            return Notification.Name.init("forumRecommnad")
        case .hottest:
            return Notification.Name.init("forumHottest")
        case .mypost:
            return Notification.Name.init("mypost")
        default:
            return nil
        }
    }
    var describe:String{
        switch self {
            
        case .hottest:
            return "热门"
        case .interview:
            return "面经"
        case .recommend:
            return "内推"
        case .offer:
            return "offer比较"
        case .help:
            return "互助"
        case .life:
            return "生活"
        case .mypost:
            return "我的帖子"
        default:
            return ""
        
        }
    }
}


// 举报分类
enum JuBaoType:String {
    case job = "job"
    case forum = "forum"
    case reply = "reply"
    case subReply = "subReply"
    
}



// 订阅条件 分类
enum subscribeItemType:String {
    case type = "type"
    case cityStr = "city_str"
    case fields = "fields"
    case salary = "salary"
    case degree = "degree"
    case internDay = "intern_day"
    case internMonth = "intern_month"
    case internSalary = "intern_salary"
    
    
    var describe:String{
        get {
            switch self {
            case .type:
                return "职位类型"
            case .cityStr:
                return "城市"
            case .fields:
                return "从事行业"
            case .degree:
                return "学历"
            case .salary:
                return "薪资范围"
            case .internDay:
                return "实习天数"
            case .internSalary:
                return "实习薪水"
            case .internMonth:
                return "实习时间"
            }
        }
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

enum ResumeDeliveryStatus:Int {
    
    case delivery = 0
    case read = 1
    case test = 2
    case interview = 3
    case offer = 4
    case reject = 5
    case all = 6
    case none = -1
    
    var color:UIColor{
        get{
            switch self {
            case .delivery:
                return UIColor.lightGray
            case .test:
                return UIColor.orange
            case .read:
                return  UIColor.brown
            case .interview:
                return UIColor.red
            case .offer:
                return UIColor.green
            case .reject:
                return UIColor.black
            case .all:
                return UIColor.clear
            default:
                return UIColor.clear
            }
        }
    }
    
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
                return "未知"
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
    case text = "text"
    case attachment = "attache"
    case none = ""
    
    var describe:String{
        get{
            switch self {
            case .text:
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

