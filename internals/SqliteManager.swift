//
//  SqliteManager.swift
//  internals
//
//  Created by ke.liang on 2018/3/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SQLite

fileprivate let dbName = GlobalConfig.DBName
fileprivate let startDate = Date(timeIntervalSince1970: 0)

// singleton model
class  SqliteManager{
    
    static let shared:SqliteManager = SqliteManager()
    var db:Connection?
    
    private init() {
        do{
            try initialDBFile()
        }catch{
            // 创建数据库失败
            exit(1)
        }
       
        
    }
    // create sqliteDB file in  sandbox
    private func initialDBFile() throws{
        
        
        //SingletoneClass.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let url = try SingletoneClass.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        
        let dbPath = url.appendingPathComponent(dbName)
        print("dataBase--->\(String.init(describing: dbPath)) \(String.init(describing: dbPath))")
        
        let exist = SingletoneClass.fileManager.fileExists(atPath: dbPath.path)
        if !exist{
            SingletoneClass.fileManager.createFile(atPath: dbPath.path, contents: nil, attributes: nil)
        }
        
    
       try  initialTables(dbPath: dbPath.path)
    }
    
    // create tables in sqliteDB
    private func initialTables(dbPath:String) throws{
        do{
        
            
            db = try Connection(dbPath)
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
          
            try createSearchTable()
            try createMessageTable()
            try createConversationTable()
            addNewColumn()
            
        } catch {
            throw error
        }
        
    }
    
}



// 搜索历史 表
extension SqliteManager{
    
    private func createSearchTable() throws{
        
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
           throw error
        }
    }
    
}





// IM message  表
extension SqliteManager{
    
    private func addNewColumn(){
        do{
            
            try db?.run(MessageTable.message.addColumn(MessageTable.sended, defaultValue: false))
        }catch{
            print(error)
        }
    }
    
    private func createMessageTable() throws{
        do{
            
            try db?.run(MessageTable.message.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(MessageTable.id, primaryKey: PrimaryKey.autoincrement)
            
                t.column(MessageTable.conversationId)
               // t.co
                t.column(MessageTable.type)
                t.column(MessageTable.content)
                t.column(MessageTable.senderID)
                t.column(MessageTable.receiverID)
                t.column(MessageTable.isRead)
                t.column(MessageTable.create_time)
                
                t.column(MessageTable.sended, defaultValue: false)
                
                // 外键关联
                t.foreignKey(MessageTable.conversationId, references: SingleConversationTable.conversation, SingleConversationTable.conversationId, update: TableBuilder.Dependency.setNull, delete: TableBuilder.Dependency.setNull)
                
            }))
            
            //  conversationId 作为索引
            //try db?.run(MessageTable.message.dropIndex(MessageTable.conversationId, ifExists: true))
            try db?.run(MessageTable.message.createIndex(MessageTable.conversationId, unique: false, ifNotExists: true))
            
            // 外键 TODO
            //try db?.run(MessageTable.message.for)
            // 创建外键索引
//            try db?.run(MessageTable.message.createIndex(MessageTable.senderID, unique: false, ifNotExists: true))
//            try db?.run(MessageTable.message.createIndex(MessageTable.receiverID, unique: false, ifNotExists: true))
        }catch{
            throw error
        }
        
    }
}

// 会话表

extension SqliteManager{
    
    private func createConversationTable() throws{
        do{
            try db?.run(SingleConversationTable.conversation.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                t.column(SingleConversationTable.conversationId, primaryKey: true)
                t.column(SingleConversationTable.createdTime, defaultValue: Date.init())
                t.column(SingleConversationTable.jobId)
                t.column(SingleConversationTable.myid)
                t.column(SingleConversationTable.recruiterId)
                t.column(SingleConversationTable.recruiterName, defaultValue: "")
                t.column(SingleConversationTable.recruiterIconURL, defaultValue: "")
                t.column(SingleConversationTable.isUP, defaultValue: false)
                t.column(SingleConversationTable.upTime, defaultValue: Date.init(timeIntervalSince1970: 0))
               t.column(SingleConversationTable.unreadCount, defaultValue: 0)
                
            }))
            // userID索引
            try db?.run(SingleConversationTable.conversation.createIndex(SingleConversationTable.conversationId, unique: true, ifNotExists: true))
            
            
        }catch{
             throw error
        }
        
    }
}





