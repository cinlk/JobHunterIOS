//
//  subscribeItems.swift
//  internals
//
//  Created by ke.liang on 2018/1/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation







class  SubScribeConditionItems:NSObject{
    
    
    var currentTypeList:[String] = []
    private var currentDict:Dictionary<String,String>!
    
    
    private var _type:String = ""
    
    var swich:String  {
        get{
            return _type
        }
        set{
            if newValue == types.first{
                currentTypeList = campusCondition
            }else if newValue == types.last{
                currentTypeList = internCondition
            }
            _type = newValue
        }
        
    }
    lazy var cityCond = cityCondition.init()
    lazy var businessCond = businessCondition.init()
    lazy var jobCategory = jobCategories.init()
    
    
    var typeDic:Dictionary<String,String> = ["工作城市":"(必选)请选择","实习城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"请选择","薪资范围":"请选择","实习天数":"请选择","实习时间":"请选择","学历":"请选择","实习薪水":"请选择"]
    let campusCondition = ["职位类型","工作城市","职位类别","从事行业","薪资范围","学历"]
    let internCondition = ["职位类型","实习城市","职位类别","从事行业","实习天数","实习薪水","实习时间","学历"]
    let types = ["校招","实习"]
    
    let salary:[String] = ["不限","1000-2000","2000-3000","3000-4000","4000-5000"]
    let internSalary:[String] = ["不限","80/天","100/天","150/天","200/天","250/天"]
    let internDay:[String] = ["2天/周","3天/周","4天/周","5天/周"]
    let internMonth:[String] = ["1个月","2个月","3个月","4个月","5个月","半年","半年以上"]
    let degree:[String] = ["不限","大专","本科","硕士","博士"]
    
    
    override init() {
        super.init()
        self.swich = types.first!
        self.currentDict = ["职位类型":self._type,"工作城市":"(必选)请选择","实习城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"请选择","薪资范围":"请选择","实习天数":"请选择","实习时间":"请选择","学历":"请选择","实习薪水":"请选择"]
        
       
        
    }
    
   func resetCurrentValue(){
        self.currentDict = ["职位类型":self._type,"工作城市":"(必选)请选择","实习城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"请选择","薪资范围":"请选择","实习天数":"请选择","实习时间":"请选择","学历":"请选择","实习薪水":"请选择"]
        
    }
    func getCurrentValue()->[String:String]{
        
        
        return self.currentDict.filter { (k , v) -> Bool in
            return self.currentTypeList.contains(k)
        }
        
    }
    
    func setCurrentValueByDict(data:[String:String]){
        data.forEach { (key, value) in
            self.updateCurrentValue(value: value, key: key)
        }
    }
    func updateCurrentValue(value:String, key:String){
        self.currentDict.updateValue(value, forKey: key)
    }
    
    
    func getResults()->(values:[String:String]?, err:String?){
        var vs:[String:String] = [:]
        if _type == types.first{
            if self.currentDict["工作城市"] == "(必选)请选择"{
                return (nil, "请选择城市")
            }else if self.currentDict["职位类别"] == "(必选)请选择"{
                return (nil, "请选择职位类别")
            }else{
                
                self.currentDict.forEach({ (k, v) in
                    if self.campusCondition.contains(k){
                        if ( (k == "从事行业" || k == "薪资范围" || k == "学历") && v == "请选择"){
                            vs[k] = "不限"
                            
                        }else{
                            vs[k] = v
                        }
                    }
                })
            
             return (vs, nil)
            }
            
        }else if _type == types.last{
            if self.currentDict["实习城市"] == "(必选)请选择"{
                return (nil, "请选择城市")
            }else if self.currentDict["职位类别"] == "(必选)请选择"{
                return (nil, "请选择职位类别")
            }else{
                
                self.currentDict.forEach({ (k, v) in
                    if self.internCondition.contains(k){
                        if ( (k == "从事行业" || k == "实习薪水" || k == "学历" || k == "实习天数" || k == "实习时间") && v == "请选择"){
                            vs[k] = "不限"
                            
                        }else{
                            vs[k] = v
                        }
                    }
                })
                
                return (vs, nil)
            }
            
        }
        
        return (nil,"unkown")
    }
}


extension SubScribeConditionItems{
    
    struct cityCondition {
        var city:[String]
        var cityChilds:Dictionary<String,[String]>
        var currentChild:[String]
        init() {
            self.city = ["不限","热门城市","广东","浙江","湖北"]
            self.cityChilds = ["不限":[],"热门城市":["北京","上海","广州","深圳"],"广东":["广州","韶关","深圳"],"浙江":["杭州","温州","湖州"],"湖北":["武汉","黄石"]]
            self.currentChild = []
        }
        
        mutating func changeChild(name:String){
            self.currentChild = self.cityChilds[name] ?? []
            
        }
    }
    
    struct businessCondition {
        var  business:[String]
        var  businessChilds:Dictionary<String,[String]>
        var  currentChild:[String]
        
        init() {
        
            self.business = ["不限","IT/互联网","电子/通信/硬件","金融","汽车/机械/制造"]
            self.businessChilds = ["不限":[],"IT/互联网":["互联网/电子商务","网络游戏","计算机软件","IT服务/系统集成"],"电子/通信/硬件":["电子技术/半导体/集成电路","通信","计算机硬件"],"金融":["银行","保险","会计/审计","基金/证券/投资"],"汽车/机械/制造":["汽车/模特","印刷/包装/造纸","加工制造"]]
            self.currentChild = []
        }
        
        
        mutating func changeChild(name:String){
            self.currentChild = self.businessChilds[name] ?? []
            
        }
    }
    
    
    struct  jobCategories {
        
        var level1:[String] =  ["销售/客服","技术","产品/设计/运营","项目管理/质量管理"]
        var level2:Dictionary<String,[String]> = ["":[],"销售/客服":["销售业务","销售管理","销售行政","客服"],"技术":["前端开发","后端开发"],"产品/设计/运营":["产品","设计","运营"],"项目管理/质量管理":["项目管理/项目协调","质量管理/安全防护"]]
        var level3:Dictionary<String,[String]> =  ["":[],"销售业务":["销售代表","客户代表","项目执行","代理销售","保险销售"],"销售管理":["客户经理/主管","大客户销售经理","招商总监","团购经理/主管"]
            ,"销售行政":["销售行政专员/助理","商务专员/助理","业务分析师/主管"],"客服":["VIP专员","网络客服","客服总监"],"前端开发":["web开发","JavaScript","HTML5","Flash"],
             "后端开发":["Java","Python","PHP",".NET","C#","C/C++","Golang"],"项目管理/项目协调":["项目专员"],"质量管理/安全防护":["质量检测员"],"产品":["产品助理","网页产品"],"设计":["网页设计","UI设计","美术设计"],"运营":["数据运营","产品运营"]]
        init() {
            
        }
    }
    
     
}

extension SubScribeConditionItems{
    
    
}
