//
//  Friends.swift
//  internals
//
//  Created by ke.liang on 2017/10/12.
//  Copyright © 2017年 lk. All rights reserved.
//


import Foundation

private let contacts = "contacts"

class Contactlist:NSObject{
    
    
    var pref:UserDefaults!
    // userid 和ChatRecord 关联
    var  usersMessage:Dictionary<String,messageRecords>
    private  var users:[FriendModel]
    
    static let shared:Contactlist = Contactlist()
    
    public override init() {
        
        pref = UserDefaults.standard
        self.usersMessage = [:]
        self.users = []
        super.init()
        self.setUsers()
    }
    
    
    
    open func getUsers() -> [FriendModel] {
        return users
    }
    
    open func removeAll(){
        if let col = pref.object(forKey: contacts) as? [Data]{
            for item in col{
                let user:FriendModel = NSKeyedUnarchiver.unarchiveObject(with: item) as!  FriendModel
                messageRecords.init(id: user.id).deleteAllByMes()
            }
        }
        pref.removeObject(forKey: contacts)
        
    }
    
    private func setUsers(){
        
        if let col =   pref.object(forKey: contacts) as? [Data]{
            for item in col{
                let user:FriendModel = NSKeyedUnarchiver.unarchiveObject(with: item) as!  FriendModel
                usersMessage[user.id] = messageRecords.init(id: user.id)
                users.append(user)
            }
        }
    }
    
    func addUser(user:FriendModel){
        if users.contains(user){
            return
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        if var col = pref.object(forKey: contacts) as? [Data]{
            col.append(data)
            pref.set(col, forKey: contacts)

        }else{
            var col:[Data] = []
            col.append(data)
            pref.set(col, forKey: contacts)
        }
        users.append(user)
        usersMessage[user.id] = messageRecords.init(id: user.id)
    }
    
    func removeUser(user:FriendModel, index:Int){
        if users.contains(user){
            if var col = pref.object(forKey: contacts) as? [Data]{
                col.remove(at: index)
                pref.set(col, forKey: contacts)
                // 清理message 数据
                usersMessage[user.id]?.deleteAllByMes()
                users.remove(at: index)
                usersMessage.removeValue(forKey: user.id)
                
            }
            
        }
        
    }
    
    
    open func getLasteMessageForUser(user:FriendModel)-> MessageBoby?{
        return  usersMessage[user.id]?.messages.last
    }
    
    
    
}


class FriendModel:NSObject,NSCoding{
    
    
    var companyName:String
    var name:String
    // 唯一号
    var id:String
    var avart:String
    
    
    
    
    init(name:String,avart:String, companyName:String,id:String) {
        self.name = name
        self.avart = avart
        self.companyName = companyName
        self.id = id
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avart, forKey: "avatar")
        aCoder.encode(companyName, forKey: "companyName")
        aCoder.encode(id, forKey: "id")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name =  aDecoder.decodeObject(forKey: "name") as! String
        self.avart = aDecoder.decodeObject(forKey: "avatar") as! String
        self.companyName = aDecoder.decodeObject(forKey: "companyName") as! String
        self.id = aDecoder.decodeObject(forKey: "id") as! String
    }
   
    
    // equal object  TODO
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? FriendModel{
            return  self.id == other.id
        }
        return false
    }
    
    
}

class messageRecords:NSObject{
    
    private var pre:UserDefaults
    private var prefix:String
    private var id:String
    var messages:[MessageBoby] = []
    
    init(id:String) {
        self.id = id
        pre = UserDefaults.standard
        prefix = "mes_" + id
        super.init()
        _ = self.GetAllMes()
        
    }
    
    
    //
    open func GetAllMes() -> [MessageBoby]?{
        
        if let mes =   pre.object(forKey: prefix) as? [Data]{
            for item in mes {
                messages.append(NSKeyedUnarchiver.unarchiveObject(with: item) as! MessageBoby)
            }
           
            return messages
        }
        return nil 
        
    }
    
    open func addMessageByMes(newMes:MessageBoby){
        
        let data = NSKeyedArchiver.archivedData(withRootObject: newMes)
        var mes:[Data] = []
        if let res =   pre.object(forKey: prefix) as? [Data]{
            mes = res
            mes.append(data)
        }else{
            mes.append(data)
        }
        messages.append(newMes)
        pre.set(mes, forKey: prefix)
        
    }
    
    
    open func deleteMessageByMes(oldMes:MessageBoby, index:Int) -> Error?{
        
       
        if  messages.contains(oldMes){
            if var res  =   pre.object(forKey: prefix) as? [Data]{
                 res.remove(at: index)
                //res.remove(at: res.index(of: data)!)
                 pre.set(res, forKey: prefix)
            }
            messages.remove(at: index)
            return nil
        }
        // mark todo
        return nil
        
    }
    
    open func deleteAllByMes(){
        if var res = pre.object(forKey: prefix) as? [Data]{
            messages.removeAll()
            res.removeAll()
            pre.set(res, forKey: prefix)
            pre.removeObject(forKey: prefix)
        }
    }
    
    
}


