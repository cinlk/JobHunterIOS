//
//  SqliteManager.swift
//  internals
//
//  Created by ke.liang on 2018/3/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SQLite

fileprivate let dbName = "app.db"

fileprivate let startDate = Date(timeIntervalSince1970: 0)

// singleton model
class  SqliteManager{
    fileprivate let fileManager = FileManager.default
    static let shared:SqliteManager = SqliteManager()
    var db:Connection?
    
    private init() {
    
        initialDBFile()
        
    }
    // create sqliteDB file in  sandbox
    private func initialDBFile(){
        
        
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let dbPath = url.last?.appendingPathComponent(dbName)
        let exist = fileManager.fileExists(atPath: dbPath!.path)
        if !exist{
            fileManager.createFile(atPath: dbPath!.path, contents: nil, attributes: nil)
        }
        
        initialTables(dbPath: dbPath!.path)
    }
    
    // create tables in sqliteDB
    private func initialTables(dbPath:String){
        do{
            db  = try Connection(dbPath)
            // 设置timeout
            db?.busyTimeout = 30
            db?.busyHandler({ (tries) -> Bool in
                if tries >= 3{
                    return false
                }
                return true
            })
            // 跟踪 sql 语句
            db?.trace{ print($0)}
        } catch {
            print(error)
        }
        
        // test table
        createUserTable()
        createSearchTable()
        createJobTable()
        createCompanyTable()
    }
    
    
    
}

// user 数据db 和 操作
extension SqliteManager{
    open func createUserTable(){
        do {
            try db?.run( UserTable.user.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(UserTable.id, primaryKey: PrimaryKey.autoincrement)
                //t.column(UserTable.id, primaryKey: true)
                t.column(UserTable.password, check: UserTable.password.length>=6, defaultValue: "")
                t.column(UserTable.account, unique: true, check: nil, defaultValue: "")
                t.column(UserTable.auto, defaultValue: false)
                t.check(UserTable.account.length >= 6)
                
            })
            )
            
        }catch{
            print(error)
        }
    }
    
}


// 搜索历史 表
extension SqliteManager{
    
    private func createSearchTable(){
        
        do{
            try db?.run(SearchHistory.search.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(SearchHistory.name, primaryKey: true)
                // 不是空字符串
                //t.check(SearchHistory.name.trim().length > 0)
                t.column(SearchHistory.ctime, defaultValue: startDate)

            }))
          
        }catch{
            print(error)
        }
    }
    
}

//  job 表
extension SqliteManager{
    
    private func  createJobTable(){
        do{
            try db?.run(JobTable.job.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(JobTable.jobID, primaryKey: true, check: JobTable.jobID.length > 6)
                t.column(JobTable.collected, defaultValue: false)
                t.column(JobTable.sendedResume, defaultValue: false)
                t.column(JobTable.validate, defaultValue: true)
                t.column(JobTable.talked, defaultValue: false)
            }))
            
        }catch{
            print(error)
        }
    }
}


// compay 表
extension SqliteManager{
    
    private func createCompanyTable(){
        do{
            try db?.run(CompanyTable.company.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(CompanyTable.companyID, primaryKey: true, check: CompanyTable.companyID.length > 6)
                t.column(CompanyTable.Iscollected, defaultValue: false)
                t.column(CompanyTable.validated, defaultValue: true)
                
            }))
            
        }catch{
            print(error)
        }
    }
}

