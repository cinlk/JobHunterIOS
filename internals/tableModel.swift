//
//  tableModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SQLite

// 通过该类获取table操作对象
class  DBFactory{
    
    enum DBName {
        case user
        case search
        case job
    }
    
    private let dbManager:SqliteManager = SqliteManager.shared
    
    private let userTable:UserTable
    private let searchTable:SearchHistory
    private let jobTable:JobTable
    private let companyTable:CompanyTable
    
    static let shared:DBFactory = DBFactory()
    
    private  init() {
        userTable = UserTable.init(dbManager: self.dbManager)
        searchTable = SearchHistory.init(dbManager: self.dbManager)
        jobTable = JobTable.init(dbManager: self.dbManager)
        companyTable = CompanyTable.init(dbManage: self.dbManager)
    }
    
    
    
    open func getUserDB()->UserTable{
        return self.userTable
    }
    
    open func getSearchDB()->SearchHistory{
        return self.searchTable
    }
    
    open func getJobDB()->JobTable{
        return self.jobTable
    }
    
    open func getCompanyDB()->CompanyTable{
        return self.companyTable
    }
    
    
    
}


// version 0.1
struct UserTable{
    
    static let user = Table("user")
    static let id = Expression<Int64>("id")
    static let account = Expression<String>("account")
    static let password = Expression<String>("password")
    // 开启自动登录
    static let auto = Expression<Bool>("auto")
    
    private let dbManager:SqliteManager
    init(dbManager:SqliteManager) {
        self.dbManager = dbManager
    }
    
    
    
    func currentUser()->(account:String, password:String, auto:Bool){
        
        do{
            // 选择第一行
            if let user = try dbManager.db?.pluck(UserTable.user){
                return (user[UserTable.account], user[UserTable.password], user[UserTable.auto])
            }
        }catch{
            print(error)
        }
        
        return ("", "", false)
    }
    
    func insertUser(account:String, password:String, auto:Bool){
        
        
        
        do{
            try dbManager.db?.transaction {
                try dbManager.db?.run(UserTable.user.delete())
                try dbManager.db?.run(UserTable.user.insert(UserTable.account <- account, UserTable.password <- password,
                                                  UserTable.auto <- auto))
            }
            
        }catch{
            print(error)
        }
    }
    
    func deleteUser(){
        do{
            try dbManager.db?.run(UserTable.user.delete())
        }catch{
            print(error)
        }
    }
    
    
    func setLoginAuto(auto:Bool){
        do{
            try dbManager.db?.run(UserTable.user.update(UserTable.auto <- auto))
        }catch{
            print(error)
        }
    }
    
}



// 职位
struct JobTable {
    
    static let job = Table("job")
    static let jobID = Expression<String>("jobID")
    static let collected = Expression<Bool>("collected")
    static let sendedResume = Expression<Bool>("sendedResume")
    static let validate = Expression<Bool>("validate")
    static let talked = Expression<Bool>("talk")
    
    
    private let dbManager:SqliteManager
    init(dbManager:SqliteManager) {
        self.dbManager = dbManager
    }
    
    
    // 是否被收藏
    func isCollectedBy(id:String)->Bool{
        do{
            
            let target =  JobTable.job.where(JobTable.jobID == id)
            // 一条记录
            if let result = try dbManager.db?.pluck(target){
                return  try result.get(JobTable.collected)
            }
        }catch{
            print(error)
        }
        return false
    }
    
    func collectedJobBy(id:String){
        do{
            try dbManager.db?.transaction {
                // 先查找 如果有更新
                let target = JobTable.job.where(JobTable.jobID == id)
                if try (dbManager.db?.run(target.update(JobTable.collected <- true)))! > 0{
                    return
                }
                // 没有数据插入
                try dbManager.db?.run(JobTable.job.insert(JobTable.jobID <- id, JobTable.collected <- true))
            }
           
        }catch{
            print(error)
        }
    }
    
    func uncollectedJobBy(id:String){
        do{
            try dbManager.db?.transaction(block: {
                let target = JobTable.job.filter(JobTable.jobID == id)
                try dbManager.db?.run(target.update(JobTable.collected <- false))
            })
            
        }catch{
            print(error)
        }
    }
    
    func talkedBy(id:String){
        do{
            
            try dbManager.db?.transaction {
                // 先查找 如果有更新
                let target = JobTable.job.where(JobTable.jobID == id)
                if try (dbManager.db?.run(target.update(JobTable.talked <- true)))! > 0{
                    return
                }
                // 没有数据插入
                try dbManager.db?.run(JobTable.job.insert(JobTable.jobID <- id, JobTable.talked <- true))
            }
            
        }catch{
            print(error)
        }
    }
    
    func sendResumeJob(id:String){
        do{
            try dbManager.db?.transaction(block: {
                
                // 先查找 如果有更新
                let target = JobTable.job.where(JobTable.jobID == id)
                if try (dbManager.db?.run(target.update(JobTable.sendedResume <- true)))! > 0{
                    return
                }
                // 没有数据插入
                try dbManager.db?.run(JobTable.job.insert(JobTable.jobID <- id, JobTable.sendedResume <- true))
            })
            
        }catch{
            print(error)
        }
    }
    
    
    // 判断是否已近投递
    func isSendedResume(id:String)->Bool{
        do{
            
            let target =  JobTable.job.where(JobTable.jobID == id)
            if let result = try dbManager.db?.pluck(target){
                 return try result.get(JobTable.sendedResume)
            }
           
        }catch{
            print(error)
        }
        return false
    }
    
    // 已经和HR 沟通过
    func isTalked(id:String)->Bool{
        do{
            
            let target =  JobTable.job.where(JobTable.jobID == id)
            if let result = try dbManager.db?.pluck(target){
                return try result.get(JobTable.talked)
            }
            
        }catch{
            print(error)
            
        }
        return false
    }
    
    // 获取已经收藏职位
    func getCollectedIDs()->[String]{
        guard  let db = self.dbManager.db else {
            return []
        }
        do{
            var res = [String]()
            for item in try db.prepare(JobTable.job.select(JobTable.jobID).where(JobTable.collected == true)){
                res.append(item[JobTable.jobID])
            }
            return res
            
        }catch{
            print(error)
            return []
        }
    }
    
    
    
}


// 搜索历史
struct SearchHistory {
    static let search = Table("search")
    // 主键
    static let name = Expression<String>("name")
    // 时间 排序 （MARK 默认是UTC时间）
    static let ctime = Expression<Date>("ctime")
    
    private let dbManager:SqliteManager
    
    init(dbManager:SqliteManager) {
        self.dbManager = dbManager
    }
    
    
    func insertSearch(name:String){
        
        do{
            // 插入新数据 或替换原来数据的时间
            try dbManager.db?.run(SearchHistory.search.insert(or: .replace, SearchHistory.name <- name, SearchHistory.ctime <- Date()))
            
        }catch{
            print(error)
        }
    }
    
    func deleteSearch(name:String){
        do{
            try dbManager.db?.transaction(block: {
                let target = SearchHistory.search.filter(SearchHistory.name == name)
                try dbManager.db?.run(target.delete())
            })
            
        }catch{
            print(error)
        }
    }
    
    func getSearches()->[String]{
        guard  let db = self.dbManager.db else {
            return []
        }
        do{
            var res = [String]()
            for item in try db.prepare(SearchHistory.search.select(SearchHistory.name).order(SearchHistory.ctime.desc)){
                res.append(item[SearchHistory.name])
            }
            return res
            
        }catch{
            print(error)
            return []
        }
    }
    
    
    func removeAllSearchItem(){
        do{
            try dbManager.db?.run(SearchHistory.search.delete())
        }catch{
            print(error)
        }
    }
    
    
}



// 公司 表

struct CompanyTable {
    
    static let company = Table("company")
    static let companyID = Expression<String>("companyID")
    static let Iscollected = Expression<Bool>("Iscollected")
    static let validated = Expression<Bool>("validated")
    
    
    private let dbManage: SqliteManager
    
    init(dbManage:SqliteManager) {
        self.dbManage = dbManage
    }
    
    // 设置被收藏
    func setCollectedBy(id:String){
        do{
            try dbManage.db?.transaction {
                let target = CompanyTable.company.filter(CompanyTable.companyID == id)
                if try (dbManage.db?.run(target.update(CompanyTable.Iscollected <- true)))! > 0 {
                    return
                }
                try dbManage.db?.run(CompanyTable.company.insert(CompanyTable.companyID <- id, CompanyTable.Iscollected <- true))
                
            }
            
        }catch{
            print(error)
        }
        
    }
    
    // 取消收藏
    func unCollected(id:String){
        do{
            let target = CompanyTable.company.filter(CompanyTable.companyID == id )
            try dbManage.db?.run(target.update(CompanyTable.Iscollected <- false))
            
        }catch{
            print(error)
        }
    }
    
    // 判断是否被收藏
    func isCollectedBy(id:String)->Bool{
        do{
            let target = CompanyTable.company.filter(CompanyTable.companyID == id)
            if let result = try dbManage.db?.pluck(target){
                return  try result.get(CompanyTable.Iscollected)
            }
            
        }catch{
            print(error)
        }
        return false
    }
    
    // 全部收藏
    func allCollectedByIDs()->[String]{
        do{
            guard  let db =  dbManage.db else {
                return []
            }
            var res:[String] = []
            
            for item in try db.prepare(CompanyTable.company.select(CompanyTable.companyID).where(CompanyTable.Iscollected == true)){
                res.append(item[CompanyTable.companyID])
            }
            return res
            
        }catch{
            print(error)
        }
        return []
    }
    
    
}


