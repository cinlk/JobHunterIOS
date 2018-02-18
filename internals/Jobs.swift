//
//  Jobs.swift
//  internals
//
//  Created by ke.liang on 2017/11/25.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources




class JobManager{
    
    enum jobType {
        case compus
        case intern
        case company
        case none 
    }
    
    static let shared:JobManager = JobManager.init()
    private init(){
        initialData()
    }
    
    
    
    private func initialData(){
        for _ in 0..<5{
            
            let json:[String:String] = ["picture":"chrome","company":"google","jobName":"研发",
                                        "address":"山上","salary":"100万","create_time":"2018-01-09","education":"本科"]
            let cjson:[String:Any] = ["id":"678","icon":"sina","name":"新浪","describe":"大公司，有前景","staffs":"1000人以上","tags":["带我去的","地段"]]
            
            collectedCompanys.append(comapnyInfo(JSON: cjson)!)
            
            collectedJobs.append(CompuseRecruiteJobs(JSON: json)!)
        }
        
    }
    
    //TODO  合并 实习和社招被收藏的job 条目 ？？
    private var collectedJobs:[CompuseRecruiteJobs] = []
    private var collectedInternJobs:[InternshipJobs] = []
    
    // 收藏的公司信息
    private var collectedCompanys:[comapnyInfo] = []
    
    open func  addCollectedItem(item:CompuseRecruiteJobs){
        if collectedJobs.contains(item){
            return
        }
        
        collectedJobs.append(item)
    }
    
    open func removeCollectedByIndex(type:jobType,row:[Int]){
        switch type {
        case .compus:
            
            self.collectedJobs.remove(indexes: row)
        case .company:
            self.collectedCompanys.remove(indexes: row)
        default:
            break
        }
    }
    
    open func removeCollectedItem(item:CompuseRecruiteJobs){
        if let index =   collectedJobs.index(of: item){
            collectedJobs.remove(at: index)
        }
    }
    
    open func addCompanyItem(item: comapnyInfo){
        if collectedCompanys.contains(item){
            return
        }
        
        collectedCompanys.append(item)
    }
    
    open func removeCollectedCompany(item: comapnyInfo){
        if let index = collectedCompanys.index(of: item){
            collectedCompanys.remove(at: index)
        }
    
    }
    
    open func getCollections(type:jobType)->[Any]{
        switch type {
            
        case .compus:
            return collectedJobs
        case .intern:
            return collectedInternJobs
        case .company:
            return collectedCompanys
        default:
            return [Int]()
        }
    }
    
}
// 单列
let jobManageRoot:JobManager = JobManager.shared

// 公司数据

struct  comapnyInfo: Mappable, Comparable {
    
    static func < (lhs: comapnyInfo, rhs: comapnyInfo) -> Bool {
        return true
    }
    
    static func == (lhs: comapnyInfo, rhs: comapnyInfo) -> Bool {
        return lhs.id  ==  rhs.id
    }
    
    var id:String?
    var icon:String?
    var name:String?
    var describe:String?
    var address:String?
    var staffs:String?
    var industry:String?
    var tags:[String]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        icon <- map["icon"]
        name <- map["name"]
        describe <- map["describe"]
        address <- map["address"]
        staffs <- map["staffs"]
        industry <- map["industry"]
        tags <- map["tags"]
        
    }
}


// MARK 添加更多的属性，比如id，标签等？？
struct CompuseRecruiteJobs :Mappable, Comparable{
    
    static func <(lhs: CompuseRecruiteJobs, rhs: CompuseRecruiteJobs) -> Bool {
        return true
    }
    
    static func ==(lhs: CompuseRecruiteJobs, rhs: CompuseRecruiteJobs) -> Bool {
         return lhs.jobName  ==  rhs.jobName
    }
    
    var picture:String?
    var company:String?
    var jobName:String?
    var address:String?
    var salary:String?
    var create_time:String?
    var education:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        picture <- map["picture"]
        company <- map["company"]
        jobName <- map["jobName"]
        address <- map["address"]
        salary <- map["salary"]
        create_time <- map["create_time"]
        education <- map["education"]
    }
    
    
    
}


struct InternshipJobs: Mappable{
    var picture:String?
    var company:String?
    var jobName:String?
    var address:String?
    var salary:String?
    var create_time:String?
    var day:Int = 0
    var duration:String?
    var isOfficial:Bool = false
    var education:String?
    
    
    init?(map: Map) {
        picture <- map["picture"]
        company <- map["company"]
        jobName <- map["jobName"]
        address <- map["address"]
        salary <- map["salary"]
        create_time <- map["create_time"]
        day <- map["day"]
        duration <- map["duration"]
        isOfficial <- map["isOfficial"]
        education <- map["education"]
    }
    
    mutating func mapping(map: Map) {
        
    }
}

// multi sections
enum MultiSecontions{
    case CatagorySection(title:String, items: [SectionItem])
    case RecommandSection(title:String, itmes: [SectionItem])
    case CampuseRecruite(title:String, items: [SectionItem])
}
// items
enum SectionItem{
    case catagoryItem(imageNames:[String])
    case recommandItem(imageNames:[String])
    case campuseRecruite(job:CompuseRecruiteJobs)
    //case internRecruite(jobs:[InternshipJobs])
    
}

extension MultiSecontions: SectionModelType{
    typealias Item = SectionItem
    
    var items: [SectionItem]{
        switch self {
        case .CatagorySection(title: _, let items):
            return items.map{$0}
        case .RecommandSection(title: _, let items):
            return items.map{$0}
        case .CampuseRecruite(title:_,let items):
            return items
        
        }
    }
    
    var title:String{
        switch self {
        case .CampuseRecruite(title: let title, items: _):
            return title
        case .CatagorySection(title: let title, items: _):
            return title
        case .RecommandSection(title: let title, itmes: _):
            return title
        }
    }
    
    init(original: MultiSecontions, items: [MultiSecontions.Item]) {
        switch original {
        case let .CatagorySection(title: title, items: _):
            self = .CatagorySection(title: title, items: items)
        case let .RecommandSection(title: title,  itmes:_):
            self = .RecommandSection(title: title, itmes: items)
        case let .CampuseRecruite(title: title, items: _):
            self = .CampuseRecruite(title: title, items: items)
        
        }
    
    }
    
}

