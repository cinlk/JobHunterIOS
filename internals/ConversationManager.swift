//
//  conversationManager.swift
//  internals
//
//  Created by ke.liang on 2018/3/25.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




// 单列模式
class ConversationManager: NSObject {

    
    private lazy var messageTable = DBFactory.shared.getMessageDB()
    private lazy var conversationTable = DBFactory.shared.getConversationDB()
    
    static let shared:ConversationManager = ConversationManager()
    
    
    private override init() {}
    

    
    
    // 获取某个会话
    open func getConversationBy(conversationId:String) ->ChatListModel?{
        
    
        do{
            
            guard let item = try conversationTable.getOneConversation(conversationId: conversationId)  else {
                return nil
            }
            guard let  mode = ChatListModel(JSON: item.toJSON())
            else{
                return nil
            }
            
            if let msg = try conversationTable.getLastMessage(conversationId: item.conversationId ?? ""){
                mode.lastMessage = msg
            }
            
            return mode
            
        }catch {
            print(error)
            return nil
        }
     
        
    }
    // 获取全部会话 和 是否存在未读消息
    open func getConversaions()-> [ChatListModel]{
        
        var conversationModes:[ChatListModel] = []
        
         // 查出所有的会话
        guard let cons =  try? conversationTable.getAllConversations() else {
            return []
        }
        
        
        for  c in cons{
            
           
            guard let  tmp  = ChatListModel.init(JSON: c.toJSON())
                
                else {
                continue
                }
           // tmp.recruiterIconURL = c.recruiterIconURL
            // 最后一条消息
            if let msg =  try? conversationTable.getLastMessage(conversationId: c.conversationId!){
                tmp.lastMessage = msg
            
            }
            print(tmp.toJSON())
            conversationModes.append(tmp)
        }
        
        
        // 置顶的在前面  然后更加时间降序排序
        conversationModes.sort { (a, b) -> Bool in
            
            if  a.isUp && b.isUp {
                let atime = a.upTime ?? Date.init(timeIntervalSince1970: 0)
                let btime = b.upTime ?? Date.init(timeIntervalSince1970: 0)
                
                return atime >= btime
                
            }else if a.isUp && b.isUp == false{
                return true
            }else if  a.isUp == false && b.isUp == false  {
                let atime = a.createdTime ?? Date.init(timeIntervalSince1970: 0)
                let btime = b.createdTime ?? Date.init(timeIntervalSince1970: 0)
                
                return atime >= btime
            }else{
                return false
            }
            
            
            
        }
        
        return conversationModes
        
    }
    // 删除会话
    open func removeConversationBy(id:String, complete:((_ bool:Bool, _ error: Error?)->Void)){
        
        do{
            try AppFileManager.shared.deleteDirBy(conversationId: id)
            try DBFactory.shared.deteletAllMessage(conversationId: id)
        }catch{
             
            complete(false, error)
            return
        }

        complete(true, nil)
        
        
    }
    
    // 创建会话
    open func createConversation(data: SingleConversation) -> Bool{
        do{
            try conversationTable.insertConversationDate(data: data)
            return true
        }catch{
            print(error)
        }
        
        return false
    }

    
    
    // 获取某人 历史聊天信息，从最近开始查
    
    open func getLatestMessageBy(conversationId:String,start:Int,limit:Int)->[MessageBoby]{
        
        do{
            return try messageTable.getMessages(conversationId: conversationId, start: start, limit: limit)

        }catch{
            print(error)
        }
        
        return []
        //return  messageTable.getMessages(chatWith:chatWith, start: start, limit: limit)

    }
    

    // 添加到communication 表 (默认不是置顶的)
//    open func insertConversationItem(messageID:String,userID:String, date:Date){
//        conversationTable.insertConversationDate(userID: userID, messageID: messageID, upTime: date)
//    }
//
//    open func updateConversationMessageID(messageID:String, userID:String, date: Date){
//        conversationTable.upDateConversationMessageID(userID: userID, messageID: messageID, date: date)
//    }
//
    open func setUpConversation(conversationId:String, isUp:Bool) -> Bool{
        do{
           try conversationTable.setUpConversation(conversationId: conversationId, up: isUp)

        }catch{
            return false
        }
        return true
    }
    
    
    // 清楚会话未读消息
    open func clearUnReadMessageBy(conversationId:String) -> Bool{
        do{
            try messageTable.closeUnReadMessage(conversationId: conversationId)

        }catch{
            return false
        }
        
        return true
    }
    
    // 插入消息表
    open func  insertMessageItem(items:[MessageBoby]) throws {
        guard items.count > 0 else {
            return
        }
        
        do{
            try items.forEach{ try messageTable.insertMessage(message: $0)}
        }catch{
            print("insert message \(error)")
            throw error
        }
    }
    
    
    
    
    // 事务提交  先保证前面语句成功 在提交后面语句， 只有发生异常 才会回滚，
    //  如果是表约束错误，不会回滚
    
    open func firstChatWith(person:PersonModel, messages:[MessageBoby]){
        guard   messages.count > 0 else {
            return
        }
        
        do{
//           try SqliteManager.shared.db?.transaction(block: {
//                try self.insertMessageItem(items: messages)
//            self.insertConversationItem(messageID: (messages.last?.messageID!)!, userID: GlobalConfig.LeanCloudApp.User2 , date: (messages.last?.creat_time)!)
//
//
//
//            })
        }catch{
            print(error)
        }
       
    }
    
    
    
}
