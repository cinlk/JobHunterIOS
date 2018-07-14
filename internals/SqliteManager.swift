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
        print(dbPath)
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
            
            //try db?.execute("PRAGMA foreign_keys = ON;")
            // 跟踪 sql 语句
            db?.trace{ print($0)}
            // 开启外键约束 (sqlite 默认没开启)
            try db?.execute("PRAGMA foreign_keys = ON;")
            //try db?.execute("PRAGMA foreign_keys;")
        } catch {
            print(error)
        }
        
        
        
        
        
        // test table
        createUserTable()
        createSearchTable()
        
        createMessageTable()
        createConversationTable()
        
    }
    
    
    
}

// user 数据db 和 操作
extension SqliteManager{
    open func createUserTable(){
        do {
            try db?.run(LoginUserTable.user.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(LoginUserTable.id, primaryKey: PrimaryKey.autoincrement)
                //t.column(UserTable.id, primaryKey: true)
                t.column(LoginUserTable.password, check: LoginUserTable.password.length>=6, defaultValue: "")
                t.column(LoginUserTable.account, unique: true, check: nil, defaultValue: "")
                t.column(LoginUserTable.latestTime, defaultValue: Date.init(timeIntervalSince1970: 0))
                t.column(LoginUserTable.auto, defaultValue: false)
                t.check(LoginUserTable.account.length >= 6)
                
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
                t.column(SearchHistory.id, primaryKey: PrimaryKey.autoincrement)
                t.column(SearchHistory.type)
                t.column(SearchHistory.name, unique: true)
                // 不是空字符串
                //t.check(SearchHistory.name.trim().length > 0)
                t.column(SearchHistory.ctime, defaultValue: startDate)

            }))
          
        }catch{
            print(error)
        }
    }
    
}





// IM message  表
extension SqliteManager{
    
    private func createMessageTable(){
        do{
            
            try db?.run(MessageTable.message.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(MessageTable.id, primaryKey: PrimaryKey.autoincrement)
            
                t.column(MessageTable.messageID)
               // t.co
                t.column(MessageTable.type)
                t.column(MessageTable.content)
                t.column(MessageTable.senderID)
                t.column(MessageTable.receiverID)
                t.column(MessageTable.isRead)
                t.column(MessageTable.create_time)
                t.column(MessageTable.read_time, defaultValue: Date.init(timeIntervalSince1970: 0))
                
            }))
            //  messageID 作为索引
            try db?.run(MessageTable.message.createIndex(MessageTable.messageID, unique: true, ifNotExists: true))
            // 创建外键索引
            try db?.run(MessageTable.message.createIndex(MessageTable.senderID, unique: false, ifNotExists: true))
            try db?.run(MessageTable.message.createIndex(MessageTable.receiverID, unique: false, ifNotExists: true))
        }catch{
            print(error)
        }
        
    }
}

// 会话表

extension SqliteManager{
    
    private func createConversationTable(){
        do{
            try db?.run(ConversationTable.conversation.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(ConversationTable.id, primaryKey: PrimaryKey.autoincrement)
                t.column(ConversationTable.userID, unique: true)
                t.column(ConversationTable.messageID, unique: true, check: nil)
                t.column(ConversationTable.isUP, defaultValue: false)
                t.column(ConversationTable.upTime, defaultValue: Date.init(timeIntervalSince1970: 0))
               
                
            }))
            // userID索引
            try db?.run(ConversationTable.conversation.createIndex(ConversationTable.userID, unique: true, ifNotExists: true))
            
            
        }catch{
            print(error)
        }
    }
}





