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
    
    var alls:[conversationModel]{
        get{
            return getConversaions()
        }
    }
    
    
    
    // 更新某个会话
    open func updateConversationBy(usrID:String)->conversationModel?{
        
        guard let one = conversationTable.getOneConversation(userID: usrID) else {
            return nil
        }
        guard let mes = messageTable.getMessageByID(msgID: one.messageID!) else {
            return nil
        }
        
        guard let user = personTable.GetUserById(userId: usrID) else {
            return nil
        }
        
        one.message = mes
        one.user = user
        
        return one
        
    }
    // 获取全部会话
    open func getConversaions()->[conversationModel]{
        var conversationModes:[conversationModel] = []

         // 查出所有的会话 得到userid
        guard let res = conversationTable.getAllConversations() else { return [] }
        for var item in res{
            
            
            if let mes = messageTable.getMessageByID(msgID: item["messageID"] as! String){
                    //mode.message = mes
                item["message"] = mes
            }
            if let user = personTable.GetUserById(userId: item["userID"] as! String){
                    //mode.user =
                item["user"] = user
            }
            
            // 判断数据是否存在
            if let model  = conversationModel(JSON: item), let mes = item["message"] as? MessageBoby,let  user = item["user"] as?
            PersonModel{
                
                 model.message = mes
                 model.user = user
                 conversationModes.append(model)
            }
           
            
        }
        
        
        return conversationModes
        
    }
    // 删除会话 删除聊天对象记录 和 消息历史记录
    open func removeConversationBy(userID:String){
            //conversationTable.deleteConversationBy(userID: userID)
            // person 表级联删除数据
        personTable.deletePersonBy(userID: userID)
        
        // 删除对话存储的images
        AppFileManager.shared.deleteDirBy(userID: userID)
        
    }
    
    // 置顶会话
    open func updateConversastion(userID:String, messageID:String, isUP:Bool){
            conversationTable.upDateConversationData(userID: userID, messageID: messageID, isUP: isUP)

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
    open func insertConversationItem(messageID:String,userID:String){
        conversationTable.upDateConversationData(userID: userID, messageID: messageID, isUP: false)
    }
    
    // 插入消息表
    open func  insertMessageItem(items:[MessageBoby]) throws {
        guard items.count > 0 else {
            return
        }
        do{
            // ??
            try items.forEach{ try messageTable.insertBaseMessage(message: $0)}
        }catch{
            throw error
        }
    }
    
    
    // 事务提交  先保证前面语句成功 在提交后面语句， 只有发生异常 才会回滚，
    //  如果是表约束错误，不会回滚
    
    open func firstChatWith(person:PersonModel, messages:[MessageBoby]){
        do{
           
           try SqliteManager.shared.db?.transaction(block: {
                self.insertPerson(person: person)
                try self.insertMessageItem(items: messages)
            self.insertConversationItem(messageID: (messages.last?.messageID!)!, userID: person.userID!)
            
            
            })
        }catch{
            print(error)
        }
       
    }
    
    
    
}
