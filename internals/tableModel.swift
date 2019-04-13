//
//  tableModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SQLite
import CryptoSwift


class DBError:Error{
    var message :String
    init(message:String) {
            self.message = message
    }
    
}
// 通过该类获取table操作对象
class  DBFactory{
    
    private let dbManager:SqliteManager = SqliteManager.shared
    
    private let searchTable:SearchHistory
    // 消息
    private let messageTable:MessageTable
    private let conversationTable:SingleConversationTable
    
    static let shared:DBFactory = DBFactory()
    
    private  init() {
    
        searchTable = SearchHistory.init(dbManager: self.dbManager)
        messageTable = MessageTable.init(dbManage: self.dbManager)
        conversationTable = SingleConversationTable.init(dbManage: self.dbManager)
    }
    
    open func getSearchDB()->SearchHistory{
        return self.searchTable
    }
    
    open func getMessageDB()->MessageTable{
        return self.messageTable
    }
    
    open func getConversationDB()->SingleConversationTable{
        return self.conversationTable
    }
    
    
    
}




extension DBFactory{
    
    // 删除会话原子操作
    func deteletAllMessage(conversationId: String) throws {

        
        do{
            try self.dbManager.db?.transaction(block: {
                // MARK TODO
                try messageTable.removeConversationMessage(conversationId: conversationId)
                try conversationTable.deleteConversationBy(conversationId: conversationId)
                
            })
        }catch{
            
            throw error
        }
        
     
        
    }
}




// 搜索历史
struct SearchHistory {
    
    static let search = Table("search")
    //
    static let id = Expression<Int64>("id")
    // 搜索类型
    static let type = Expression<String>("type")
    
    // 搜索记录
    static let name = Expression<String>("name")
    // 时间 排序 （MARK 默认是UTC时间）
    static let ctime = Expression<Date>("ctime")
    
    private let dbManager:SqliteManager
    
    fileprivate init(dbManager:SqliteManager) {
        self.dbManager = dbManager
    }
    
    
    func insertSearch(type:String,name:String){
        
        do{
            // 插入新数据 或替换原来数据的时间
            let target = SearchHistory.search.filter(SearchHistory.type  ==  type && SearchHistory.name == name)
            
            if let _ =  try dbManager.db?.pluck(target){
                    // 更新时间
                    try  dbManager.db?.run(target.update(SearchHistory.ctime <- Date()))
                
            }else{
            
            try dbManager.db?.run(SearchHistory.search.insert(SearchHistory.type <- type ,SearchHistory.name <- name, SearchHistory.ctime <- Date()))
            }
            
        }catch{
            print(error)
        }
    }
    
    func deleteSearch(type:String, name:String){
        do{
            try dbManager.db?.transaction(block: {
                let target = SearchHistory.search.filter(SearchHistory.name == name && SearchHistory.type == type )
                try dbManager.db?.run(target.delete())
            })
            
        }catch{
            print(error)
        }
    }
    
    func getSearches(type:String)->[String]{
        guard  let db = self.dbManager.db else {
            return []
        }
        do{
            var res = [String]()
            for item in try db.prepare(SearchHistory.search.select(SearchHistory.name).filter(SearchHistory.type == type).order(SearchHistory.ctime.desc)){
                res.append(item[SearchHistory.name])
            }
            if res.count > 0{
                res.insert(GlobalConfig.searchTopWord, at: 0)
            }
            return res
            
        }catch{
            print(error)
            
        }
        return []
    }
    
    
    func removeAllSearchItem(type:String){
        do{
            try dbManager.db?.run(SearchHistory.search.filter(SearchHistory.type == type).delete())
        }catch{
            print(error)
        }
    }
    
    
}



// 消息数据库表

struct MessageTable {
    
    static let message =  Table("message")
    // 自增的消息id 主键
    static let id = Expression<Int64>("id")
    // 属于conversation
    static let conversationId = Expression<String>("conversation_id")

    static let type = Expression<String>("type")
    // 根据不同类型解析不同类型数据
    static let content = Expression<Data?>("content")
    static let create_time = Expression<Date>("create_time")
    //static let read_time = Expression<Date>("read_time")
    
    static let isRead = Expression<Bool>("isRead")
    static let senderID = Expression<String>("sender_id")
    static let receiverID = Expression<String>("receiver_id")
    
    private let dbManager:SqliteManager
    
    fileprivate init(dbManage:SqliteManager) {
        self.dbManager = dbManage
    }
    
    
    
    
    // 清楚未读消息标记
    func closeUnReadMessage(conversationId:String) throws {
        let target = MessageTable.message.filter(MessageTable.conversationId == conversationId)
        try self.dbManager.db?.run(target.update(MessageTable.isRead <- true))
    }
    
    // 获取某条消息
//    func getMessageByID(msgID:String) -> MessageBoby?{
//
//        do{
//            let one = MessageTable.message.filter(MessageTable.messageID == msgID)
//            if let item =  try self.dbManager.db?.pluck(one){
//                let contentString = item[MessageTable.content]?.base64EncodedString()
//                return MessageBoby(JSON: ["messageID":item[MessageTable.messageID],
//                    "type":item[MessageTable.type],
//                    "content": contentString,
//                    "isRead":item[MessageTable.isRead],
//                    // Date 时间转换
//                    "creat_time": item[MessageTable.create_time].timeIntervalSince1970 ])
//
//            }
//        }catch{
//            print(error)
//        }
//
//        return nil
//    }
    
    // 从最后向前查询 某个conversation对话的消息: table 上滑动加载历史消息
    func getMessages(conversationId:String, startTime:Date, limit:Int) throws  ->[MessageBoby]{
        
        var res:[MessageBoby] = []
        
        do{
            // 查找 发给我的消息 好 我发给ta的消息
            let query = MessageTable.message.select([MessageTable.type,MessageTable.content, MessageTable.isRead, MessageTable.create_time, MessageTable.conversationId, MessageTable.senderID, MessageTable.receiverID]).filter(MessageTable.conversationId == conversationId && MessageTable.create_time < startTime).order(MessageTable.create_time.desc).limit(limit)
            
            guard let rows =  try self.dbManager.db?.prepare(query) else {
                return []
            }
            
            for item in rows{
                
                guard let messageType =  MessgeType(rawValue: item[MessageTable.type]) else {
                    continue
                }
                
               
                guard let data = item[MessageTable.content] else {
                    continue
                }
               
                if let mb =  MessageTable.buildMsg(messageType: messageType, item: item, data:data) {
                    res.append(mb)
                }
                
            }
            // 翻转排序，从时间低到高顺序 显示在该页
            return res.reversed()
            
            
        }catch{
            throw error
        }
        
        
    }

    static func buildMsg(messageType:MessgeType, item:Row, data:Data) -> MessageBoby?{
        
        // 转为具体的消息类型
        switch  messageType {
        case .bigGif, .smallGif:
            guard let name = String.init(data: data, encoding: String.Encoding.utf8) else {
                return nil
            }
            
            return  GifImageMessage(JSON: [
                "type": messageType.describe,
                "local_gif_name":name,
                // 必须加上content，聊天列表展示界面会用
                "content": name,
                "is_read":item[MessageTable.isRead],
                "creat_time":item[MessageTable.create_time].timeIntervalSince1970,
                "conversation_id": item[MessageTable.conversationId],
                "sender_id":item[MessageTable.senderID],
                "receiver_id":item[MessageTable.receiverID]
                ])
            
            
        case .picture:
            guard let name = String.init(data: data, encoding: String.Encoding.utf8) else {
                return nil
            }
            return PicutreMessage(JSON: [
                "type": messageType.describe,
                "fileName": name, // 本地image 文件名字
                "content": name,
                "fileUrl": name, // 这里是url 地址
                "is_read":item[MessageTable.isRead],
                "creat_time": item[MessageTable.create_time].timeIntervalSince1970,
                "conversation_id": item[MessageTable.conversationId],
                "sender_id":item[MessageTable.senderID],
                "receiver_id":item[MessageTable.receiverID]
                ])
        case .text:
            
            return MessageBoby(JSON: [
                "type": messageType.describe,
                "content":item[MessageTable.content]!,
                "is_read":item[MessageTable.isRead],
                "creat_time": item[MessageTable.create_time].timeIntervalSince1970,
                "conversation_id": item[MessageTable.conversationId],
                "sender_id":item[MessageTable.senderID],
                "receiver_id":item[MessageTable.receiverID]
                ])
            
            
        case .jobDescribe:
            
            guard let content = item[MessageTable.content] else {
                return nil
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: content, options: []) as? [String : Any] else {
                return nil
            }
        
            
            return JobDescriptionlMessage(JSON: [
                "type": messageType.describe,
                "content":item[MessageTable.content]!,
                "is_read":item[MessageTable.isRead],
                "creat_time":item[MessageTable.create_time].timeIntervalSince1970,
                "sender_id":item[MessageTable.senderID],
                "receiver_id":item[MessageTable.receiverID],
                "job_id":json["job_id"] ?? "","job_type_des":json["job_type_des"] ?? "", "icon":json["icon"] ?? "default","job_name":json["job_name"] ?? "",
                "company":json["company"] ?? "","salary":json["salary"]  ?? "","tags":json["tags"] ?? [],
                "conversation_id": item[MessageTable.conversationId]])
        case .location:
            guard let content = item[MessageTable.content] else{
                return nil
            }
            guard let json = try? JSONSerialization.jsonObject(with: content, options: []) as? [String: Any] else{
                return nil
            }
            
            return LocationMessage(JSON: [
                
                "type": messageType.describe,
                "content":item[MessageTable.content]!,
                "is_read":item[MessageTable.isRead],
                "creat_time":item[MessageTable.create_time].timeIntervalSince1970,
                "sender_id":item[MessageTable.senderID],
                "receiver_id":item[MessageTable.receiverID],
                "conversation_id": item[MessageTable.conversationId],
                "latitude": json["latitude"] ?? "",
                "longitude": json["longitude"] ?? "",
                "address": json["address"] ?? ""])
            
        default:
            return nil
        }
        
    }
    
    // 获取未读的消息
    // 获取消息, ack 确认 lencloud 消息流程 MARK
    
//    func getUnReadMessages(SenderID: String) -> Int?{
//
//        do{
//            let query = MessageTable.message.filter(MessageTable.senderID == SenderID && MessageTable.isRead == false).count
//            if let count =  try self.dbManager.db?.scalar(query){
//                return count
//            }
//
//        }catch{
//            print(error)
//        }
//
//        return  nil
//    }
    
// 清楚未读消息
//    func clearUnReadeMessage(SenderID :String){
//        do{
//
//            // TEST
//            let target = MessageTable.message.filter(MessageTable.senderID == SenderID && MessageTable.isRead == false)
//            try  self.dbManager.db?.run(target.update(MessageTable.isRead <- true))
//
//
//        }catch{
//            print(error)
//        }
//
//    }
 
    
    func insertMessage(message: MessageBoby) throws {
        do{
            if message.isKind(of: JobDescriptionlMessage.self){
                try self.insertJobMessage(message: message as! JobDescriptionlMessage)
            }else if message.isKind(of: GifImageMessage.self){
                try self.insertGifMessage(message: message as! GifImageMessage)
            }else if message.isKind(of: PicutreMessage.self){
                try self.insertPictureMessage(message: message as! PicutreMessage)
            }else if message.isKind(of: LocationMessage.self){
                try self.insertLocationMessage(message: message as! LocationMessage)
            }
            else{
                try self.insertBaseMessage(message: message)
            }
            
        }catch{
            throw error
        }
    }
    
    
    func insertBaseMessage(message:MessageBoby) throws{
        
        do{
           
          
           try self.dbManager.db?.run(MessageTable.message.insert(
                MessageTable.content <-  message.content ?? Data(),
                MessageTable.create_time <- message.creat_time!,
                MessageTable.isRead <- message.isRead,
                MessageTable.type <- message.type!,
                MessageTable.conversationId <- message.conversayionId!,
                MessageTable.senderID <- message.senderId!,
                MessageTable.receiverID <- message.receiveId!
            ))
            
            
        }catch{
            // 抛出异常
            throw error
        }
    }
    
    private func insertJobMessage(message:JobDescriptionlMessage) throws{
        
        do{
            
            // json 数据
            guard  let content =  message.JsonContentToDate()  else {
                throw DBError.init(message: "job content invalidate")
                //return
            }
            
            try self.dbManager.db?.run(MessageTable.message.insert(
                                        MessageTable.content <- content,
                                        MessageTable.create_time <-  message.creat_time!,
                                        MessageTable.isRead <- message.isRead,
                                        MessageTable.type <- message.type!,
                                        MessageTable.conversationId <- message.conversayionId!,
                                        MessageTable.senderID <- message.senderId!,
                                        MessageTable.receiverID <- message.receiveId!
                                    ))
            
        }catch{
            throw error
        }
    }
    
    
    private func insertGifMessage(message:GifImageMessage) throws{
        do{
           
            guard let data = message.pathToData() else{
                
                return
            }
            
            try self.dbManager.db?.run(MessageTable.message.insert(
                            MessageTable.content <- data,
                            MessageTable.create_time <- message.creat_time!,
                            MessageTable.isRead <- message.isRead,
                            MessageTable.type <- message.type!,
                            MessageTable.conversationId <- message.conversayionId!,
                            MessageTable.senderID <- message.senderId!,
                            MessageTable.receiverID <- message.receiveId!
                        ))
            
        }catch{
            throw error
        }
    }
    
    private func insertPictureMessage(message: PicutreMessage) throws{
        do{
           
            // 文件路径
            guard let data = message.pathToData() else {
                return
            }
            
            try self.dbManager.db?.run(MessageTable.message.insert(
                                    MessageTable.content <- data,
                                    MessageTable.create_time <- message.creat_time!,
                                    MessageTable.isRead <- message.isRead,
                                    MessageTable.type <- message.type!,
                                    MessageTable.conversationId <- message.conversayionId!,
                                    MessageTable.senderID <- message.senderId!,
                                    MessageTable.receiverID <- message.receiveId!
                            ))
            
        }catch{
            throw error
        }
    }
    
    private func insertLocationMessage(message: LocationMessage) throws{
        do{
            guard let data = message.location2Data() else {
                return
            }
            try self.dbManager.db?.run(MessageTable.message.insert(
                    MessageTable.content <- data,
                    MessageTable.create_time <- message.creat_time!,
                    MessageTable.isRead <- message.isRead,
                    MessageTable.type <- message.type!,
                    MessageTable.conversationId <- message.conversayionId!,
                    MessageTable.senderID <- message.senderId!,
                    MessageTable.receiverID <- message.receiveId!
            ))
        }catch{
            throw error
        }
    }
    
    func removeConversationMessage(conversationId:String)  throws{
        
        let targets = MessageTable.message.filter(MessageTable.conversationId == conversationId)
        try self.dbManager.db?.run(targets.delete())
    }
    
    
}

// 会话表(求职者关于某个job 和hr的会话)
struct  SingleConversationTable {
    
    static let conversation = Table("single_conversation")
    
    
    // 主键
    static let conversationId = Expression<String>("conversation_id")
    
    static let myid = Expression<String>("my_id")
    static let recruiterId = Expression<String>("recruiter_id")
    static let jobId = Expression<String>("job_id")
    static let createdTime = Expression<Date>("created_time")
    // others??
    
    // 最后一条消息 (可以为空)
    //static let messageID = Expression<String>("messageID")
    
    static let recruiterName = Expression<String>("recruiter_name")
    static let recruiterIconURL = Expression<String>("recruiter_icon_url")
    // 置顶
    static let isUP = Expression<Bool>("isUP")
    static let upTime = Expression<Date?>("upTime")
    
    private let dbManager:SqliteManager
    
    fileprivate init(dbManage:SqliteManager) {
        self.dbManager = dbManage
    }
    
    // 结果根据置顶 时间从大到小排序, 创建时间 从小到大（保证为置顶的数据保持原来位置）
    func getAllConversations() throws ->  [SingleConversation] {
        
        var res = [SingleConversation]()
        
        do{
        
            for item in try self.dbManager.db!.prepare(SingleConversationTable.conversation.order( SingleConversationTable.createdTime.desc)) {
                if let s = SingleConversation(JSON:[
                    "conversation_id": item[SingleConversationTable.conversationId],
                    "my_id": item[SingleConversationTable.myid],
                    "recruiter_id": item[SingleConversationTable.recruiterId],
                    "created_time": item[SingleConversationTable.createdTime].timeIntervalSince1970,
                    "job_id": item[SingleConversationTable.jobId],
                    "up_time": item[SingleConversationTable.upTime]?.timeIntervalSince1970 ?? Date.init(timeIntervalSince1970: 0),
                    "is_up": item[SingleConversationTable.isUP],
                    "recruiter_name": item[SingleConversationTable.recruiterName],
                    "recruiter_icon_url": item[SingleConversationTable.recruiterIconURL]
                    ]){
                    
                    res.append(s)
                }
            }
            
           
            
        }catch{
            throw error
        }
        
        return res
        
    }
    
    // 获取某个会话
    func getOneConversation(conversationId:String) throws -> SingleConversation?{
        
        do{
            let target = SingleConversationTable.conversation.filter(SingleConversationTable.conversationId == conversationId)
            if let row = try self.dbManager.db?.pluck(target){
                return SingleConversation(JSON:[
                    "conversation_id": row[SingleConversationTable.conversationId],
                    "my_id": row[SingleConversationTable.myid],
                    "recruiter_id": row[SingleConversationTable.recruiterId],
                    "created_time": row[SingleConversationTable.createdTime].timeIntervalSince1970,
                    "job_id": row[SingleConversationTable.jobId],
                    "up_time": row[SingleConversationTable.upTime]?.timeIntervalSince1970 ?? Date.init(timeIntervalSince1970: 0),
                    "is_up": row[SingleConversationTable.isUP],
                    "recruiter_name": row[SingleConversationTable.recruiterName],
                    "recruiter_icon_url": row[SingleConversationTable.recruiterIconURL]
                    
                    ])
            }
            
        }catch{
            throw error
        }
        
        return nil
    }
    
    
    
    // 插入数据
    func insertConversationDate(data: SingleConversation) throws{
        
        do{
            let query = SingleConversationTable.conversation.filter(SingleConversationTable.conversationId == data.conversationId!)
            
            // 检查是否存在
            if let _ =  try self.dbManager.db?.pluck(query){
            }else{
                try self.dbManager.db?.run(
                    SingleConversationTable.conversation.insert(
                    SingleConversationTable.conversationId <- data.conversationId!,
                    SingleConversationTable.myid <- data.myid!,
                    SingleConversationTable.recruiterId <- data.recruiterId!,
                    SingleConversationTable.upTime <- data.upTime,
                    SingleConversationTable.createdTime <- data.createdTime ?? Date(),
                    SingleConversationTable.isUP <- data.isUp ,
                    SingleConversationTable.jobId <- data.jobId!,
                    SingleConversationTable.recruiterIconURL <- data.recruiterIconURL?.absoluteString ?? "",
                    SingleConversationTable.recruiterName <- data.recruiterName ?? ""
                ))
            }
            
            
            
        }catch{
             throw error
        }
    }
    
    func getLastMessage(conversationId:String) throws -> MessageBoby?{
        
        let target = SingleConversationTable.conversation.filter(SingleConversationTable.conversationId == conversationId)
        do{
            if let row = try self.dbManager.db?.pluck(target){
                let id = row[SingleConversationTable.conversationId]
                let lastMsg = MessageTable.message.filter(MessageTable.conversationId == id ).order(MessageTable.create_time.desc)
                if let msg =  try self.dbManager.db?.pluck(lastMsg){
                    guard let messageType =  MessgeType(rawValue: msg[MessageTable.type]) else {
                        return nil
                    }
                    guard let data = msg[MessageTable.content] else {
                        return nil
                    }
                    
                    return MessageTable.buildMsg(messageType: messageType, item: msg, data: data)
                }
                
            }
            
        }catch{
            throw error
        }
       
        return nil
    }
    // 更新 最后的会话id
//    func upDateConversationMessageID(userID:String, messageID:String, date:Date){
//        do{
//
//            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
//            try self.dbManager.db?.run(target.update(ConversationTable.upTime <- date,ConversationTable.messageID <- messageID))
//        }catch{
//            print(error)
//        }
//    }
    
    
    // 更新置顶状态
    func setUpConversation(conversationId:String, up:Bool) throws{
        
        do{
            let target = SingleConversationTable.conversation.filter(SingleConversationTable.conversationId == conversationId)
            try self.dbManager.db?.run(target.update(SingleConversationTable.isUP <- up, SingleConversationTable.upTime <- Date.init()))
            
        }catch{
            throw error
        }
    }
    
    
    
    // 删除会话
    func deleteConversationBy(conversationId:String) throws{
       
        let target = SingleConversationTable.conversation.filter(SingleConversationTable.conversationId == conversationId)
        try self.dbManager.db?.run(target.delete())
    }
    
    
    
}


