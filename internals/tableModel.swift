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
        case cmessage
        case cuser
        
    }
    
    private let dbManager:SqliteManager = SqliteManager.shared
    
    private let userTable:LoginUserTable
    private let searchTable:SearchHistory
    private let jobTable:JobTable
    private let companyTable:CompanyTable
    
    // 消息
    private let personTable:PersonTable
    private let messageTable:MessageTable
    private let conversationTable:ConversationTable
    
    static let shared:DBFactory = DBFactory()
    
    private  init() {
        userTable = LoginUserTable.init(dbManager: self.dbManager)
        searchTable = SearchHistory.init(dbManager: self.dbManager)
        jobTable = JobTable.init(dbManager: self.dbManager)
        companyTable = CompanyTable.init(dbManage: self.dbManager)
        personTable = PersonTable.init(dbManage: self.dbManager)
        messageTable = MessageTable.init(dbManage: self.dbManager)
        conversationTable = ConversationTable.init(dbManage: self.dbManager)
    }
    
    
    
    open func proxy(type:DBName) -> Any{
        switch type {
        case .cmessage:
            return messageTable
        case .user:
            return personTable
        case .cuser:
            return conversationTable
        default:
            break
        }
        return ""
    }
    
    open func getUserDB()->LoginUserTable{
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
    
    open func getPersonDB()->PersonTable{
        return self.personTable
    }
    open func getMessageDB()->MessageTable{
        return self.messageTable
    }
    
    open func getConversationDB()->ConversationTable{
        return self.conversationTable
    }
    
    
    
}


// version 0.1
struct LoginUserTable{
    
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
            if let user = try dbManager.db?.pluck(LoginUserTable.user){
                return (user[LoginUserTable.account], user[LoginUserTable.password], user[LoginUserTable.auto])
            }
        }catch{
            print(error)
        }
        
        return ("", "", false)
    }
    
    func insertUser(account:String, password:String, auto:Bool){
        
        
        
        do{
            try dbManager.db?.transaction {
                try dbManager.db?.run(LoginUserTable.user.delete())
                try dbManager.db?.run(LoginUserTable.user.insert(LoginUserTable.account <- account, LoginUserTable.password <- password,LoginUserTable.auto <- auto))
            }
            
        }catch{
            print(error)
        }
    }
    
    func deleteUser(){
        do{
            try dbManager.db?.run(LoginUserTable.user.delete())
        }catch{
            print(error)
        }
    }
    
    
    func setLoginAuto(auto:Bool){
        do{
            try dbManager.db?.run(LoginUserTable.user.update(LoginUserTable.auto <- auto))
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
    
    fileprivate init(dbManager:SqliteManager) {
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
    
    fileprivate init(dbManage:SqliteManager) {
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


// ********************************** //

// 聊天记录表

//  聊天个人信息表


struct PersonTable {
    
    
    static let person =  Table("person")
    static let personID = Expression<String>("id")
    static let personName = Expression<String>("name")
    static let company = Expression<String>("company")
    static let icon = Expression<Data?>("icon")
    static let role = Expression<String>("role")
    
    //屏蔽
    static let isShield = Expression<Bool>("isShield")
    // 是否存在
    static let isExist = Expression<Bool>("isExist")
    
    
    
    private let dbManage: SqliteManager
    
    fileprivate init(dbManage:SqliteManager) {
        self.dbManage = dbManage
    }
    
    
    func GetUserById(userId:String) -> PersonModel?{
        do{
            let target = PersonTable.person.filter(PersonTable.personID == userId)
            if let item = try dbManage.db?.pluck(target){
                // data 转为base64string
                let iconString = item[PersonTable.icon]?.base64EncodedString()
                return  PersonModel(JSON: ["userID":item[PersonTable.personID],
                                           "name":item[PersonTable.personName],
                                           "company":item[PersonTable.company],
                                           "icon":iconString ?? "",
                                           "role":item[PersonTable.role],
                                           "isShield":item[PersonTable.isShield],
                                           "isExist":item[PersonTable.isExist]])
                
            }
        }catch{
            print(error)
        }
        
        return nil
    }
    
    // 更新
    func updatePerson(){
        
    }
    
    
    // 什么时候跟新 会调用??
    func updatePerson(person: PersonModel?){
        guard let person = person else { return }
        
        do{
            let target = PersonTable.person.filter(PersonTable.personID == person.userID!)
            try dbManage.db?.run(target.update(PersonTable.company <- person.company ?? "", PersonTable.personName <- person.name!,PersonTable.icon <- person.icon ?? UIImagePNGRepresentation(#imageLiteral(resourceName: "default"))!, PersonTable.isExist <- person.isExist!))
            
            
        }catch{
            print(error)
        }
    }
    
    func insertPerson(person:PersonModel?){
        
        guard let Person = person else { return }
        
        do{
            //insert 或 replace（可能头像会更新)??? 
            
            let target = PersonTable.person.filter(PersonTable.personID == Person.userID!)
            // 存在
            if let _ = try dbManage.db?.pluck(target){
                return
            }
            
            try dbManage.db?.run(PersonTable.person.insert(PersonTable.personID <- Person.userID!, PersonTable.company <- Person.company ?? "", PersonTable.personName <- Person.name!,
                PersonTable.icon <- Person.icon ?? UIImagePNGRepresentation(#imageLiteral(resourceName: "default"))!, PersonTable.role <- Person.role!))
            
        }catch{
            print(error)
        }
    }
    
    func deletePersonBy(userID:String){
        
        do{
            let target = PersonTable.person.filter(PersonTable.personID == userID)
            try self.dbManage.db?.run(target.delete())
            
        }catch{
            print(error)
        }
        
        
        
    }
    // 获取所有的usemodel
    
    func selecteAll()->[PersonModel]{
        var persons:[PersonModel] = []
        do{
            for item in try dbManage.db!.prepare(PersonTable.person){
                persons.append(PersonModel(JSON: ["personID":item[PersonTable.personID], "name":item[PersonTable.personName], "company":item[PersonTable.company],
                    "role":item[PersonTable.role],
                    "iconURL":item[PersonTable.icon]!])!)
            }
            
            return persons
            
        }catch{
            print(error)
        }
        
        return []
    }
    
    
}


// 消息数据库表

struct MessageTable {
    
    static let message =  Table("Mesage")
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
    
    
    
    func insertProxy(message:Any, type:MessgeType){
        switch type {
        case .text:
            try? self.insertBaseMessage(message: message as! MessageBoby)
        case .jobDescribe:
            self.insertJobMessage(message: message as! JobDescriptionlMessage)
        case .bigGif,.smallGif:
            self.insertGifMessage(message: message as! GigImageMessageBody)
        case .picture:
            self.insertPictureMessage(message: message as! PicutreMessage)
            
        default:
            break
        }
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
                                          "creat_time":item[MessageTable.create_time]])
                
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
                let contentStr = item[MessageTable.content]?.base64EncodedString()
                let mb =  MessageBoby(JSON: ["messageID":item[MessageTable.messageID],
                                             "type":item[MessageTable.type],
                                             "content":contentStr!,
                                             "isRead":item[MessageTable.isRead],
                                             "creat_time": item[MessageTable.create_time].timeIntervalSince1970])!
                
                
            
                
                if item[MessageTable.senderID]  == chatWith.userID {
                    mb.sender = chatWith
                    mb.receiver = myself
                    
                }else if item[MessageTable.senderID] == myself.userID{
                    mb.sender = myself
                    mb.receiver = chatWith
                }
               
                res.append(mb)
                
            }
            // 翻转排序，从时间低到高顺序
            return res.reversed()
        }catch{
            print(error)
        }
        return []
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
                MessageTable.isRead <- message.isRead!, MessageTable.type <- message.type!,
                MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date.init(timeIntervalSince1970: 0)))
            
            
        }catch{
            // 抛出异常
            throw error
            //print(error)
        }
    }
    
    private func insertJobMessage(message:JobDescriptionlMessage){
        do{
            guard let sender = message.sender else {
                return
            }
            guard  let receiver = message.receiver else {
                return
            }
            
            
            // json 数据
            guard  let content =  message.JsonContentToDate()  else { return }
            
            try self.dbManager.db?.run(MessageTable.message.insert(MessageTable.senderID <- sender.userID!,
                                        MessageTable.content <- content,
                                        MessageTable.create_time <-  message.creat_time!,
                                        MessageTable.isRead <- message.isRead!, MessageTable.type <- message.type!,
                                        MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date()))
            
        }catch{
            print(error)
        }
    }
    
    private func insertGifMessage(message:GigImageMessageBody){
        do{
            guard let sender = message.sender else {
                return
            }
            guard  let receiver = message.receiver else {
                return
            }
            
            
            let content = message.localGifPath
            
            guard let data = content?.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
            
            try self.dbManager.db?.run(MessageTable.message.insert(MessageTable.senderID <- sender.userID!,
                                    MessageTable.content <- data,
                                    MessageTable.create_time <- message.creat_time!,
                                    MessageTable.isRead <- message.isRead!, MessageTable.type <- message.type!,
                                    MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date()))
        }catch{
            print(error)
        }
    }
    
    private func insertPictureMessage(message: PicutreMessage){
        do{
            guard let sender = message.sender else {
                return
            }
            guard  let receiver = message.receiver else {
                return
            }
            // 文件路径
            guard let imgPath = message.imageFilePath else { return }
            guard let data =  imgPath.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return}
            
            try self.dbManager.db?.run(MessageTable.message.insert(MessageTable.senderID <- sender.userID!,
                                    MessageTable.content <- data,
                                    MessageTable.create_time <- message.creat_time!,
                                    MessageTable.isRead <- message.isRead!, MessageTable.type <- message.type!,
                                    MessageTable.receiverID <- receiver.userID!, MessageTable.read_time <- Date()))
            
        }catch{
            print(error)
        }
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
                            "isUP":item[ConversationTable.isUP], "upTime":item[ConversationTable.upTime]])
            }
            
            return res
            
        }catch{
            print(error)
        }
        
        return nil
    }
    
    // 获取某个会话
    func getOneConversation(userID:String)-> conversationModel?{
        do{
            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
            if let row = try self.dbManager.db?.pluck(target){
                return   conversationModel(JSON:["userID":row[ConversationTable.userID],"messageID":row[ConversationTable.messageID],"isUP":row[ConversationTable.isUP],"upTime":row[ConversationTable.upTime]])
                
            }
            
        }catch{
            print(error)
        }
        
        return nil
    }
    // 更新会话 如果 isUP 为true 则最新事件 ，否则为最小时间
    func upDateConversationData(userID:String, messageID:String, isUP:Bool){
        do{
            var date:Date?
            if isUP == true{
                date = Date()
                
            }else{
                date =  Date.init(timeIntervalSince1970: 0)
            }
            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
            if try (self.dbManager.db?.run(target.update(ConversationTable.isUP <- isUP,ConversationTable.upTime <- date!,ConversationTable.messageID <- messageID)))! > 0 {
                return
            }else{
                // 插入数据
                try self.dbManager.db?.run(ConversationTable.conversation.insert(ConversationTable.userID <- userID,
                                                                             ConversationTable.messageID <- messageID,
                                                                             ConversationTable.isUP <- false))
            }
        }catch{
            print(error)
        }
    }
    
    // 删除会话
    func deleteConversationBy(userID:String){
        do{
            let target = ConversationTable.conversation.filter(ConversationTable.userID == userID)
            try self.dbManager.db?.run(target.delete())
            
        }catch{
            print(error)
        }
    }
    
    
    
}


