//
//  tableModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SQLite



class DBError:Error{
    var message :String
    
    init(message:String) {
            self.message = message
    }
    
}
// 通过该类获取table操作对象
class  DBFactory{
    
    private let dbManager:SqliteManager = SqliteManager.shared
    
    private let userTable:LoginUserTable
    private let searchTable:SearchHistory
    // 消息
    private let messageTable:MessageTable
    private let conversationTable:ConversationTable
    
    static let shared:DBFactory = DBFactory()
    
    private  init() {
        userTable = LoginUserTable.init(dbManager: self.dbManager)
        searchTable = SearchHistory.init(dbManager: self.dbManager)
        messageTable = MessageTable.init(dbManage: self.dbManager)
        conversationTable = ConversationTable.init(dbManage: self.dbManager)
    }
    
    open func getUserDB()->LoginUserTable{
        return self.userTable
    }
    
    open func getSearchDB()->SearchHistory{
        return self.searchTable
    }
    
    open func getMessageDB()->MessageTable{
        return self.messageTable
    }
    
    open func getConversationDB()->ConversationTable{
        return self.conversationTable
    }
    
    
    
}




extension DBFactory{
    
    // 删除会话原子操作
    func deteletAllMessage(userID: String)-> Error?{

        
        do{
            try self.dbManager.db?.transaction(block: {
                try conversationTable.deleteConversationBy(userID: userID)
                try messageTable.removeAllMessageBy(userID: userID)
            })
        }catch{
            
            return error
        }
        
        return nil
        
    }
}



// 存储用户的账号，如果有多个账号（选择最新的账号进行自动登录）
struct LoginUserTable{
    
    static let user = Table("user")
    static let id = Expression<Int64>("id")
    static let account = Expression<String>("account")
    static let password = Expression<String>("password")
    // 开启自动登录
    static let auto = Expression<Bool>("auto")
    
    // 更新时间
    static let latestTime = Expression<Date>("time")
    
    
    private let dbManager:SqliteManager
    init(dbManager:SqliteManager) {
        self.dbManager = dbManager
    }
    
    
    
    func currentUser()->((account:String, password:String, auto:Bool)?, Error?){
        
        do{
            // 选择最新更新时间行
           
            if let user = try dbManager.db?.pluck(LoginUserTable.user.order(LoginUserTable.latestTime.desc)){
                return ((user[LoginUserTable.account], user[LoginUserTable.password], user[LoginUserTable.auto]), nil)
            }
        }catch{
    
            return (nil, error)
        }
        
        return (nil, nil)
    }
    
    func insertUser(account:String, password:String, auto:Bool){
        
        do{
             try dbManager.db?.run(LoginUserTable.user.insert(or: OnConflict.replace, LoginUserTable.account <- account, LoginUserTable.password <- password,LoginUserTable.auto <- auto, LoginUserTable.latestTime <- Date()))
            
        // 失败记录日志
        }catch{
            //NSLog(<#T##format: String##String#>, <#T##args: CVarArg...##CVarArg#>)
            print(error)
        }
    }
    
    func deleteUser(account:String){
        
        do{
            try dbManager.db?.run(LoginUserTable.user.filter(LoginUserTable.account == account).delete())
        }catch{
        
        }
    }
    
    
    func setLoginAuto(account:String, auto:Bool){
        do{
            try dbManager.db?.run(LoginUserTable.user.filter(LoginUserTable.account == account).update(LoginUserTable.auto <- auto))
        }catch{
            print(error)
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
    // 唯一约束 索引
    static let messageID = Expression<String>("messageID")
    static let type = Expression<String>("type")
    // 根据不同类型解析不同类型数据
    static let content = Expression<Data?>("content")
    static let create_time = Expression<Date>("create_time")
    static let read_time = Expression<Date>("read_time")
    
    static let isRead = Expression<Bool>("isRead")
    static let senderID = Expression<String>("senderID")
    static let receiverID = Expression<String>("receiverID")
    
    private let dbManager:SqliteManager
    
    fileprivate init(dbManage:SqliteManager) {
        self.dbManager = dbManage
    }
    
    
    
    
    
    // 获取某条消息
    func getMessageByID(msgID:String) -> MessageBoby?{
        
        do{
            let one = MessageTable.message.filter(MessageTable.messageID == msgID)
            if let item =  try self.dbManager.db?.pluck(one){
                let contentString = item[MessageTable.content]?.base64EncodedString()
                return MessageBoby(JSON: ["messageID":item[MessageTable.messageID],
                    "type":item[MessageTable.type],
                    "content": contentString,
                    "isRead":item[MessageTable.isRead],
                    // Date 时间转换
                    "creat_time": item[MessageTable.create_time].timeIntervalSince1970 ])
                
            }
        }catch{
            print(error)
        }
        
        return nil
    }
    
    // 从最后向前查询 （sender 给我发的消息， 我给sender 发送的消息）
    func getMessages(chatWith:PersonModel, start:Int, limit:Int)->[MessageBoby]{
        var res:[MessageBoby] = []
        
        do{
            // 查找 发给我的消息 好 我发给ta的消息
            let query = MessageTable.message.select([MessageTable.messageID,MessageTable.type,MessageTable.content, MessageTable.isRead,MessageTable.senderID, MessageTable.create_time]).filter((MessageTable.senderID == chatWith.userID! && MessageTable.receiverID == myself.userID!)||(MessageTable.senderID == myself.userID! && MessageTable.receiverID == chatWith.userID!)).order(MessageTable.create_time.desc, MessageTable.id.desc).limit(limit, offset: start)
            
            for item in try self.dbManager.db!.prepare(query){
                
                guard let messageType = MessgeType(rawValue: item[MessageTable.type]) else {
                    continue
                }
                
                var mb:MessageBoby?
                
                
                // 转为具体的消息类型
                switch  messageType {
                    case .bigGif, .smallGif:
                        guard let path = String.init(data: item[MessageTable.content]!, encoding: String.Encoding.utf8) else {
                            continue
                        }
                        
                        mb =  GigImageMessage(JSON: ["messageID":item[MessageTable.messageID],
                                                 "type":item[MessageTable.type],
                                                 "localGifPath":path,
                                                 "isRead":item[MessageTable.isRead],
                                                 "creat_time": item[MessageTable.create_time].timeIntervalSince1970])
                    
                case .picture:
                    guard let path = String.init(data: item[MessageTable.content]!, encoding: String.Encoding.utf8) else {
                        continue
                    }
                    mb = PicutreMessage(JSON: ["messageID":item[MessageTable.messageID],
                                                   "type":item[MessageTable.type],
                                                   "imageFileName":path,
                                                   "isRead":item[MessageTable.isRead],
                                                   "creat_time": item[MessageTable.create_time].timeIntervalSince1970])
                case .text:
                    
                    mb =  MessageBoby(JSON: ["messageID":item[MessageTable.messageID],
                                             "type":item[MessageTable.type],
                                             "content":item[MessageTable.content]!.base64EncodedString(),
                                             "isRead":item[MessageTable.isRead],
                                             "creat_time": item[MessageTable.create_time].timeIntervalSince1970])
                case .jobDescribe:
                   
                    guard let content = item[MessageTable.content] else {
                        continue
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: content, options: []) as? [String : Any]

            
                    mb = JobDescriptionlMessage(JSON: ["messageID":item[MessageTable.messageID],
                                    "type":item[MessageTable.type],
                                    "content":item[MessageTable.content]!.base64EncodedString(),
                                    "isRead":item[MessageTable.isRead],
                                    "creat_time":item[MessageTable.create_time].timeIntervalSince1970,
                                    "jobID":json!["jobID"]!,"jobTypeDes":json?["jobTypeDes"] ?? "", "icon":json?["icon"] ?? "default","jobName":json!["jobName"]!,
                                    "company":json?["company"] ?? "","salary":json?["salary"]  ?? "","tags":json?["tags"] ?? ""])
                    
                    
                    
                   
                    
                default:
                        break
                }
                
          
                
                if item[MessageTable.senderID]  == chatWith.userID {
                    mb?.sender = chatWith
                    mb?.receiver = myself
                    
                }else if item[MessageTable.senderID] == myself.userID{
                    mb?.sender = myself
                    mb?.receiver = chatWith
                }
                
                
                if let mb = mb {
                    res.append(mb)
                }
                
            }
            // 翻转排序，从时间低到高顺序
            return res.reversed()
            
            
        }catch{
            print(error)
        }
        return []
    }
    
    
    

    
// 获取未读的消息
func getUnReadMessages(SenderID: String) -> Int?{
    
    do{
        let query = MessageTable.message.filter(MessageTable.senderID == SenderID && MessageTable.isRead == false).count
        if let count =  try self.dbManager.db?.scalar(query){
            return count
        }
        
    }catch{
        print(error)
    }
    
    return  nil
}
    
// 清楚未读消息
func clearUnReadeMessage(SenderID :String){
    do{
        
        // TEST
        let target = MessageTable.message.filter(MessageTable.senderID == SenderID && MessageTable.isRead == false)
        try  self.dbManager.db?.run(target.update(MessageTable.isRead <- true))
        
        
    }catch{
        print(error)
    }
    
}
 
    
func insertMessage(message: MessageBoby) throws {
    do{
        if message.isKind(of: JobDescriptionlMessage.self){
            try self.insertJobMessage(message: message as! JobDescriptionlMessage)
        }else if message.isKind(of: GigImageMessage.self){
            try self.insertGifMessage(message: message as! GigImageMessage)
        }else if message.isKind(of: PicutreMessage.self){
            try self.insertPictureMessage(message: message as! PicutreMessage)
        }else{
            try self.insertBaseMessage(message: message)
        }
        
    }catch{
        throw error
    }
    
    
}
func insertBaseMessage(message:MessageBoby) throws{
        do{
            guard let sender = message.sender else {
                return
            }
            guard  let receiver = message.receiver else {
                return
            }
            
           try self.dbManager.db?.run(MessageTable.message.insert(MessageTable.messageID <- message.messageID!,MessageTable.senderID <- sender.userID!,
                MessageTable.content <-  message.content ?? Data(),
                MessageTable.create_time <- message.creat_time!,
                MessageTable.isRead <- message.isRead, MessageTable.type <- message.type!,
                MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date.init(timeIntervalSince1970: 0)))
            
            
        }catch{
            // 抛出异常
            throw error
            //print(error)
        }
    }
    
    private func insertJobMessage(message:JobDescriptionlMessage) throws{
        do{
            
            guard let sender = message.sender else {
                throw DBError.init(message: "sender invalidate")
            }
            guard  let receiver = message.receiver else {
                throw DBError.init(message: "receiver invalidate")
            }
            
            
            // json 数据
            guard  let content =  message.JsonContentToDate()  else { return }
            
            try self.dbManager.db?.run(MessageTable.message.insert(
                                        MessageTable.messageID <- message.messageID!,MessageTable.senderID <- sender.userID!,
                                        MessageTable.content <- content,
                                        MessageTable.create_time <-  message.creat_time!,
                                        MessageTable.isRead <- message.isRead, MessageTable.type <- message.type!,
                                        MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date()))
            
        }catch{
            print(error)
        }
    }
    
    private func insertGifMessage(message:GigImageMessage) throws{
        do{
            guard let sender = message.sender else {
                return
            }
            guard  let receiver = message.receiver else {
                return
            }
            
            
            guard let content = message.localGifPath else {
                return
            }
            
            guard let data = content.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
            
            try self.dbManager.db?.run(MessageTable.message.insert(
                                    MessageTable.messageID <- message.messageID!,
                                    MessageTable.senderID <- sender.userID!,
                                    MessageTable.content <- data,
                                    MessageTable.create_time <- message.creat_time!,
                                    MessageTable.isRead <- message.isRead, MessageTable.type <- message.type!,
                                    MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date()))
        }catch{
            throw error
        }
    }
    
    private func insertPictureMessage(message: PicutreMessage) throws{
        do{
            guard let sender = message.sender else {
                return
            }
            guard  let receiver = message.receiver else {
                return
            }
            // 文件路径
            guard let imgName = message.imageFileName else { return }
            guard let data =  imgName.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return}
            
            try self.dbManager.db?.run(MessageTable.message.insert(
                                     MessageTable.messageID <- message.messageID!,
                                    MessageTable.senderID <- sender.userID!,
                                    MessageTable.content <- data,
                                    MessageTable.create_time <- message.creat_time!,
                                    MessageTable.isRead <- message.isRead, MessageTable.type <- message.type!,
                                    MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date()))
            
        }catch{
            throw error
        }
    }
    
    
    func removeAllMessageBy(userID:String)  throws{
        
        let targets = MessageTable.message.filter(MessageTable.receiverID == userID || MessageTable.senderID == userID)
        try self.dbManager.db?.run(targets.delete())
        
    }
    
    
}

// 会话表
struct  ConversationTable {
    
    static let conversation = Table("conversation")
    
    // 主机 自增id
    static let id = Expression<Int64>("id")
    // 主键（被交流对象）
    static let userID = Expression<String>("userID")
    // others??
    
    // 最后一条消息 (可以为空)
    static let messageID = Expression<String>("messageID")
    
    // 置顶
    static let isUP = Expression<Bool>("isUP")
    static let upTime = Expression<Date>("upTime")
    
    private let dbManager:SqliteManager
    
    fileprivate init(dbManage:SqliteManager) {
        self.dbManager = dbManage
    }
    
    // 结果根据置顶 时间从大到小排序, 第二id 从小到大（保证为置顶的数据保持原来位置）
    func getAllConversations() -> [[String:Any]]?{
        do{
            
            var res = [[String:Any]]()
            
            for item in try self.dbManager.db!.prepare(ConversationTable.conversation.order(ConversationTable.upTime.desc, ConversationTable.id.asc)) {
                res.append(["userID":item[ConversationTable.userID], "messageID":item[ConversationTable.messageID],
                            "isUP":item[ConversationTable.isUP], "upTime":item[ConversationTable.upTime].timeIntervalSince1970])
            }
            
            return res
            
        }catch{
            print(error)
        }
        
        return nil
    }
    
    // 获取某个会话
    func getOneConversation(userID:String)-> [String:Any]?{
        do{
            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
            if let row = try self.dbManager.db?.pluck(target){
                return ["userID":row[ConversationTable.userID],"messageID":row[ConversationTable.messageID],"isUP":row[ConversationTable.isUP],"upTime":row[ConversationTable.upTime].timeIntervalSince1970]
                
            }
            
        }catch{
            print(error)
        }
        
        return nil
    }
    
    
    
    // 插入数据
    func insertConversationDate(userID:String, messageID:String, upTime:Date = Date(), isUP:Bool = false){
        do{
            
            try self.dbManager.db?.run(ConversationTable.conversation.insert(ConversationTable.userID <- userID,
                                                                             ConversationTable.messageID <- messageID,
                                                                             ConversationTable.isUP <- isUP,
                                                                             ConversationTable.upTime <- upTime))
            
        }catch{
            print(error)
        }
    }
    
    // 更新 最后的会话id
    func upDateConversationMessageID(userID:String, messageID:String, date:Date){
        do{
            
            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
            try self.dbManager.db?.run(target.update(ConversationTable.upTime <- date,ConversationTable.messageID <- messageID))
        }catch{
            print(error)
        }
    }
    
    
    // 更新置顶状态
    func upDateConversationUpStatus(userID:String, isUP:Bool){
        
        do{
            
            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
            try self.dbManager.db?.run(target.update(ConversationTable.isUP <- isUP))
            
        }catch{
            print(error)
        }
    }
    
    
    
    // 删除会话
    func deleteConversationBy(userID:String) throws{
       
        let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
        try self.dbManager.db?.run(target.delete())
    }
    
    
    
}


