//
//  delivereddata.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation


enum CheckStatus:String {
    case success =  "投递成功"
    case review = "被查看"
    case communication = "待沟通"
    case interview = "面试"
    case fail = "不合适"
}

class  TestData{
    
    static func getAllDelivers() -> [Dictionary<String,Any>]{
        
        let data = [["company":"红玉凸新","jobname":"运营实习生","locate":"重庆","logo":"jodel","createtime":"2017-9-12","status":CheckStatus.success],
            ["company":"google","jobname":"研发实习生","locate":"mountain","logo":"google","createtime":"2017-9-31","status":CheckStatus.review],
            ["company":"企鹅","jobname":"产品调研","locate":"北京","logo":"qq","createtime":"2017-9-31","status":CheckStatus.fail]]
        return data
    }
    
    static func getReview() -> [Dictionary<String,Any>]{
        let data = [["company":"google","jobname":"研发实习生","locate":"mountain","logo":"google","createtime":"2017-9-31","status":CheckStatus.review]]
        return data
    }
    
    static func getfail() -> [Dictionary<String,Any>]{
        let data = [["company":"企鹅","jobname":"产品调研","locate":"北京","logo":"qq","createtime":"2017-9-31","status":CheckStatus.fail]]
        return data
    }
    
    
    
}
