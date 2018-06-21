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

    
    
    private lazy var personTable = DBFactory.shared.getPersonDB()
    private lazy var messageTable = DBFactory.shared.getMessageDB()
    private lazy var conversationTable = DBFactory.shared.getConversationDB()
    
    static let shared:ConversationManager = ConversationManager()
    
    
    private override init() {}
    

    
    
    // 获取某个会话
    open func getConversationBy(usrID:String)->conversationModel?{
        
        guard var item = conversationTable.getOneConversation(userID: usrID) else {
            return nil
        }
        guard let mes = messageTable.getMessageByID(msgID: (item["messageID"] as! String)) else {
            return nil
        }
        
        guard let user = personTable.GetUserById(userId: (item["userID"] as! String)) else {
            return nil
        }
        
        item["message"] = mes.toJSON()
        item["user"] = user.toJSON()
        
        
        // 判断数据是否存在
        guard let one   = conversationModel(JSON: item) else {
            return nil
            
        }
        
        //conversationTable.upDateConversationData(userID: <#T##String#>, messageID: <#T##String#>, isUP: <#T##Bool#>)
        
        return one
        
    }
    // 获取全部会话 和 是否存在未读消息
    open func getConversaions()-> ([conversationModel], Bool){
        var conversationModes:[conversationModel] = []
        var unReadMes:Bool = false
        
         // 查出所有的会话 得到userid
        guard let res = conversationTable.getAllConversations() else { return ([], unReadMes) }
        for var item in res{
            
            
            // 最后一个消息
            if let mes = messageTable.getMessageByID(msgID: item["messageID"] as! String){
                    //mode.message = mes
               
                item["message"] = mes.toJSON()
            }
            // 聊天对象id
            if let user = personTable.GetUserById(userId: item["userID"] as! String){
                    //mode.user =
                item["user"] = user.toJSON()
                
                 // 获取 发送者未读的消息
                if let unReadCount =  messageTable.getUnReadMessages(SenderID: user.userID!){
                    item["unReadCount"] = unReadCount
                    unReadMes = true
                }
                
            }
            // 判断数据是否存在
            if let model  = conversationModel(JSON: item){
                
                 conversationModes.append(model)
            }
           
            
        }
        
        
        // 置顶的在前面  然后更加时间降序排序
        conversationModes.sort { (a, b) -> Bool in
            if  (a.isUP && b.isUP) || (a.isUP == false && b.isUP == false) {
                return a.upTime! >= b.upTime!

            }else if a.isUP && b.isUP == false{
                return true
            }else{
                return false
            }
            
            
        }
        
        return (conversationModes, unReadMes)
        
    }
    // 删除会话 删除聊天对象记录 和 消息历史记录
    open func removeConversationBy(userID:String){
            //conversationTable.deleteConversationBy(userID: userID)
            // person 表级联删除数据
        // MARK 原子操作??
        personTable.deletePersonBy(userID: userID)
        messageTable.removeAllMessageBy(userID: userID)
        // 删除对话存储的images
        AppFileManager.shared.deleteDirBy(userID: userID)
        
    }
    

    
    
    // 获取某人 历史聊天信息，从最近开始查
    
    open func getLatestMessageBy(chatWith:PersonModel,start:Int,limit:Int)->[MessageBoby]{
    
        return  messageTable.getMessages(chatWith:chatWith, start: start, limit: limit)
        
    }
    
    

    // 添加到 person 表
    open func insertPerson(person:PersonModel){
        personTable.insertPerson(person: person)
    }
    // 添加到communication 表 (默认不是置顶的)
    open func insertConversationItem(messageID:String,userID:String, date:Date){
        conversationTable.insertConversationDate(userID: userID, messageID: messageID, upTime: date)
    }
    
    open func updateConversationMessageID(messageID:String, userID:String, date: Date){
        conversationTable.upDateConversationMessageID(userID: userID, messageID: messageID, date: date)
    }
    
    open func updateConversationUPStatus(userID:String, isUp:Bool){
        conversationTable.upDateConversationUpStatus(userID: userID, isUP: isUp)
    }
    
    
    // 清楚会话未读消息
    open func clearUnReadMessageBy(userID:String){
        messageTable.clearUnReadeMessage(SenderID: userID)
        
        
    }
    
    // 插入消息表
    open func  insertMessageItem(items:[MessageBoby]) throws {
        guard items.count > 0 else {
            return
        }
        do{
            try items.forEach{ try messageTable.insertMessage(message: $0)}
        }catch{
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
           
           try SqliteManager.shared.db?.transaction(block: {
                self.insertPerson(person: person)
                try self.insertMessageItem(items: messages)
            self.insertConversationItem(messageID: (messages.last?.messageID!)!, userID: person.userID!, date: (messages.last?.creat_time)!)
            
            
            
            })
        }catch{
            print(error)
        }
       
    }
    
    
    
}
