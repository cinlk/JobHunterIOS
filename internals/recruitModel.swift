//
//  recruitModel.swift
//  internals
//
//  Created by ke.liang on 2018/9/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper



class BaseFilter: Mappable {
    
    var offset:Int64 = 0
    var limit:Int = 10
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        offset <- map["offset"]
        limit <- map["limit"]
    }
    
    func setOffset(offset:Int64){
        self.offset = offset
    }
    
    func toJSON() -> [String : Any] {
        fatalError("not impleted")
//        return ["citys" : self.citys, "business_field": self.businessField,
//                "offset": self.offset, "limit" : self.limit]
    }
}

class OnlineFilterReqModel: BaseFilter {
    
    // 搜索关键字的网申信息
    var typeField:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    
    var citys:[String] = []{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var businessField:String = ""{
        didSet{
            self.offset = 0
            self.limit = 10
        }
    }

    required init?(map: Map) {
        super.init(map: map)
        
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        citys <- map["citys"]
        businessField <- map["business_field"]
        typeField <- map["type_field"]
       
    }
    
    func setCitys(citys:[String]) -> Bool{
    
        if self.citys.isEmpty{
            self.citys = citys
            return true
        }
    
        for (_, c) in citys.enumerated() {
            if self.citys.contains(c) == false{
                self.citys = citys
                return true
            }
        }
        // 不刷新
        return false
    }
    
    func setBusinessField(b:String) -> Bool{
        if self.businessField != b {
            self.businessField = b
            return true
        }
        return false
    }
    // 重写该方法 返回正确的数据
   override func toJSON() -> [String : Any] {
    
        return ["citys" : self.citys, "business_field": self.businessField,
                "offset": self.offset, "limit" : self.limit, "type_field": self.typeField]
    }
    
}


// graduate  filter requst

class GraduateFilterModel: BaseFilter {
    
    var citys:[String] = []{
        didSet{
            self.offset = 0
            self.limit = 10
        }
    }
    var subBusinessField:String = ""{
        didSet{
            self.offset = 0
            self.limit = 10
        }
    }
    var degree:String = ""{
        didSet{
            self.offset = 0
            self.limit = 10
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        citys <- map["citys"]
        subBusinessField <- map["sub_business_field"]
        degree <- map["degree"]
        
    }
    
    
    func setCitys(citys:[String]) -> Bool{
        
        if self.citys.isEmpty{
            self.citys = citys
            return true
        }
        
        for (_, c) in citys.enumerated() {
            if self.citys.contains(c) == false{
                self.citys = citys
                return true
            }
        }
        // 不刷新
        return false
    }
    
    func setBusinessField(b:String) -> Bool{
        if self.subBusinessField != b {
            self.subBusinessField = b
            return true
        }
        return false
    }
    
    func setDegree(d:String) -> Bool{
        if self.degree != d{
            self.degree = d
            return true
        }
        
        return false
    }
   
    override func toJSON() -> [String : Any] {
        
        return ["citys" : self.citys, "sub_business_field": self.subBusinessField,
                "degree": self.degree,
                "offset": self.offset, "limit" : self.limit]
    }
    
}

class InternFilterModel: BaseFilter{
    
    var citys:[String] = []{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var subBusinessField:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var internCondition:[String:String] = [:]{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        citys <- map["citys"]
        subBusinessField <- map["sub_business_field"]
        internCondition <- map["intern_condition"]
    }
    
    func setCitys(citys:[String]) -> Bool{
        
        if self.citys.isEmpty{
            self.citys = citys
            return true
        }
        
        for (_, c) in citys.enumerated() {
            if self.citys.contains(c) == false{
                self.citys = citys
                return true
            }
        }
        // 不刷新
        return false
    }
    
    func setBusinessField(b:String) -> Bool{
        if self.subBusinessField != b {
            self.subBusinessField = b
            return true
        }
        return false
    }
    
    func setCondition(c:[String:String]) -> Bool{
        if self.internCondition  == c {
            return false
        }
        self.internCondition = c
        return true
    }
    
    
    
    override func toJSON() -> [String : Any] {
        
        return ["citys" : self.citys, "sub_business_field": self.subBusinessField,
                "intern_condition": self.internCondition,
                "offset": self.offset, "limit" : self.limit]
    }
}


class CareerTalkFilterModel: BaseFilter{
    
    var college:[String] = []{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var time:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var businessField:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var city:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        city <- map["city"]
        time <- map["time"]
        businessField <- map["business_field"]
        college <- map["college"]
    }
    
    func setCitys(city:String) -> Bool{
        if self.city != city{
            self.city = city
            return true
        }
        
        return false
       
    }
    
    func setTime(t:String) -> Bool{
        if self.time != t {
            self.time = t
            return true
        }
        return false
    }
    
    func setBusinessField(b:String) -> Bool{
        if self.businessField != b {
            self.businessField = b
            return true
        }
        return false
    }
    
    func setCollege(colleges:[String]) -> Bool{
        
        if self.college.isEmpty{
            self.college = colleges
            return true
        }
        
        for (_, c) in colleges.enumerated() {
            if self.college.contains(c) == false{
                self.college = colleges
                return true
            }
        }
        // 不刷新
        return false
    }
    
    
    
    
    override func toJSON() -> [String : Any] {
        return ["city" : self.city, "business_field": self.businessField,
                "college" : self.college, "offset": self.offset, "limit" : self.limit, "time" : self.time]
    }
}



class CompanyFilterModel: BaseFilter{
    var citys:[String] = []{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var businessField:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    var companyType:String = ""{
        didSet{
            self.limit = 10
            self.offset = 0
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    
    func setCitys(citys:[String]) -> Bool{
        
        if self.citys.isEmpty{
            self.citys = citys
            return true
        }
        
        for (_, c) in citys.enumerated() {
            if self.citys.contains(c) == false{
                self.citys = citys
                return true
            }
        }
        // 不刷新
        return false
    }
    
    func setBusinessField(b:String) -> Bool{
        if self.businessField != b {
            self.businessField = b
            return true
        }
        return false
    }
    
    func setCompanyType(t:String) -> Bool{
        if self.companyType != t {
            self.companyType = t
            return true
        }
        return false
    }
    
    
     override func mapping(map: Map) {
        super.mapping(map: map)
        citys <- map["citys"]
        businessField <- map["business_field"]
        companyType <- map["company_type"]
    }
    
    override func toJSON() -> [String : Any] {
        return ["citys" : self.citys, "business_field": self.businessField,
                "offset": self.offset, "limit" : self.limit, "company_type" : self.companyType]
    }
}

struct RecruitOnlineApply: Mappable {
    
    var city:[String]?
    var industry:String?
    // 扩展(根据 不同条件获取数据)
    var latest:Bool?
    var recommand:Bool?
    var user:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        city <- map["city"]
        industry <- map["industry"]
    }
}



// 职位和网申混合数据
//struct  ListJobsOnlineAppy: Mappable {
//    //var jobs:[CompuseRecruiteJobs] = []
//    var onlineAppys:[OnlineApplyModel] = []
//    
//    var tagJobs:[String:[CompuseRecruiteJobs]] = [:]
//    
//    
//    init?(map: Map) {
//        
//    }
//    
//    mutating func mapping(map: Map) {
//        tagJobs <- map["tag_jobs"]
//        onlineAppys <- map["online_apply"]
//    }
//    
//}



struct  CompanyRecruitMeetingFilterModel: Mappable {
    
    var companyID:String?
    var offset:Int64 = 0
    var limit:Int64 = 10
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        companyID <- map["company_id"]
        offset <- map["offset"]
        limit <- map["limit"]
    }
    
    mutating func setOffset(offset:Int64){
        self.offset = offset
    }
    
    func toJSON() -> [String : Any] {
        
        return ["company_id": self.companyID ?? "", "offset": self.offset, "limit": self.limit]
    }
    
}

// 分类tag请求 body
struct  CompanyTagFilterModel: Mappable {
    
    // 记录tag 的offset
    var offset:Int64 = 0
    var limit:Int64 = 2
    
    var tag:String = ""{
        didSet{
            if oldValue == "全部"{
                return
            }
            offset = 0
            limit = 2
        }
    }
    var companyId:String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        offset <- map["offset"]
        limit <- map["limit"]
        tag <- map["tag"]
        companyId <- map["company_id"]
        
    }
    
    mutating func setTag(t:String) -> Bool{
        if self.tag != t {
            self.tag = t
            return true
        }
        return false
    }
    
    mutating func setOffset(offset:Int64){
        self.offset = offset
    }
    
    mutating func toJSON() -> [String : Any] {
         
        return ["company_id": self.companyId, "tag" : self.tag, "offset" : self.offset,
                "limit" : self.limit]
    }
}







