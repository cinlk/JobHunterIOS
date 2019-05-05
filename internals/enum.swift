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
    case offers = "offers"
    case help = "help"
    case life = "life"
    case none = ""
    
    // 自己的帖子
    case mypost = "mypost"
    
    
    static var items:[ForumType]{
        get{
            return [ForumType.interview, ForumType.recommend, ForumType.offers, ForumType.help]
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
        case .offers:
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
