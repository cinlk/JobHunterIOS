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
    
    static func getAllDelivers() -> [Dictionary<String,String>]{
        
        let data = [["companyName":"小张","jobname":"运营实习生","locate":"重庆","image":"jodel","createTime":"2017-9-12","salary":"100-150元/天", "times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科","currentstatus":"投递成功","id":"1"],
                    
            ["companyName":"google","jobname":"研发实习生","locate":"mountain","image":"google","createTime":"2017-9-31","salary":"100-150元/天","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科","currentstatus":"被查看","id":"2"],
            ["companyName":"企鹅","jobname":"产品调研","locate":"北京","image":"qq","createTime":"2017-9-31","salary":"100-150元/天","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科","currentstatus":"不合适","id":"3"]]
        return data
    }
    
    static func getReview() -> [Dictionary<String,String>]{
        let data = [["companyName":"google","jobname":"研发实习生","locate":"mountain","image":"google","createTime":"2017-9-31","salary":"100-150元/天","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科","currentstatus":"被查看","id":"2"]]
        return data
    }
    
    static func getfail() -> [Dictionary<String,String>]{
        let data = [["companyName":"企鹅","jobname":"产品调研","locate":"北京","image":"qq","createTime":"2017-9-31","salary":"100-150元/天","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科","currentstatus": "不合适","id":"3"]]
        return data
    }
    
    // 每个投递职位 状态集合数据 通过id 关联

    
    static   func findByid(id:String) ->[Array<String>]{
        
        var  s:[Array<String>]!
        // 数据倒着排序， 对于cell 显示
        if id ==  "1"{
            s =  [["投递成功","2017-9-12: 16:08"]]
            s.reverse()
            
        }else if id == "2"{
            s =  [["投递成功","2017-9-12: 16:08"],["被查看","2017-9-13: 08:21"]]
            s.reverse()
            
        }
        else if id == "3"{
            s =  [["投递成功","2017-9-12: 16:08"],["被查看","2017-9-13: 08:21"],
                  ["不合适","2017-9-13: 08:25"]]
            s.reverse()
        }
            
        else{
            s =  [["投递成功","2017-9-12: 16:08"],["被查看","2017-9-13: 08:21"],
                  ["待沟通","2017-9-13: 08:25"]]
            s.reverse()
        }
        return s
        
    }
    
    
    
    
}
