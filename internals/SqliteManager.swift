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

// singleton model
class  SqliteManager{
    fileprivate let fileManager = FileManager.default
    static let shared:SqliteManager = SqliteManager()
    fileprivate var db:Connection?
    
    private init() {
    
        initialDBFile()
        
    }
    // create sqliteDB file in  sandbox
    private func initialDBFile(){
        
        
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let dbPath = url.last?.appendingPathComponent(dbName)
        print(dbPath?.path)
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
        
    }
    
    
    
}

// user 数据db 和 操作
extension SqliteManager{
    open func createUserTable(){
        do {
            try db?.run( UserTable.user.create(temporary: false, ifNotExists: false, withoutRowid: false, block: { (t) in
                
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
    
    
    open func currentUser()->(account:String, password:String, auto:Bool){
        
        do{
           // 选择第一行
            if let user = try db?.pluck(UserTable.user){
                return (user[UserTable.account], user[UserTable.password], user[UserTable.auto])
            }
        }catch{
            print(error)
        }
        
        return ("", "", false)
    }
    
    open func insertUser(account:String, password:String, auto:Bool){
        
        
        
        do{
            try db?.transaction {
                try db?.run(UserTable.user.delete())
                try db?.run(UserTable.user.insert(UserTable.account <- account, UserTable.password <- password,
                                                  UserTable.auto <- auto))
            }
            
        }catch{
            print(error)
        }
    }
    
    open func deleteUser(){
        do{
            try db?.run(UserTable.user.delete())
        }catch{
            print(error)
        }
    }
    
    
    open func setLoginAuto(auto:Bool){
        do{
            try db?.run(UserTable.user.update(UserTable.auto <- auto))
        }catch{
            print(error)
        }
    }
    
    open func selectRows(){
        do{
            
            for user in  (try db?.prepare(UserTable.user))!{
                //print(user[UserTable.id], user[UserTable.name])
            }
            
        }catch let error {
            print(error)
        }
    }
   
}


