//
//  Friends.swift
//  internals
//
//  Created by ke.liang on 2017/10/12.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



let mycontacts:Contactlist = Contactlist()

class Contactlist:NSObject{
    
    var userinfo:NSMutableArray = []
    
    var pref:UserDefaults!
    
    public override init() {
        
        pref = UserDefaults.standard
        super.init()
        //pref.removeObject(forKey: "contacts")
        self.getUsers()
        
    }
    
    
    class func shared()->Contactlist{
        return mycontacts
    }
    
    
    func getUsers(){
        
        if let col =   pref.object(forKey: "contacts") as? [Data]{
            for item in col{
                let data:FriendData = NSKeyedUnarchiver.unarchiveObject(with: item) as!  FriendData
                userinfo.add(data)
            }
        }
        
       
        
    }
    
    func addUser(user:FriendData){
        if userinfo.contains(user){
            return
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        if var col = pref.object(forKey: "contacts") as? [Data]{
            col.append(data)
            pref.set(col, forKey: "contacts")

        }else{
            var col:[Data] = []
            col.append(data)
            pref.set(col, forKey: "contacts")
        }
        self.userinfo.add(user)

        
    }
    
    func removeUser(user:FriendData){
        if userinfo.contains(user){
            if var col = pref.object(forKey: "contacts") as? [Data]{
                let data = NSKeyedArchiver.archivedData(withRootObject: user)
                col.remove(at: col.index(of: data)!)
                pref.set(col, forKey: "contacts")
                self.userinfo.remove(user)
            }
            
        }
        
    }
    
    
    
}
class FriendData:NSObject,NSCoding{
    
    var name:String!
    var id:String?
    var avart:String!
    var lastmessage:String?
    
    
    init(name:String,avart:String) {
        self.name = name
        self.avart = avart
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avart, forKey: "avatar")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name =  aDecoder.decodeObject(forKey: "name") as! String
        self.avart = aDecoder.decodeObject(forKey: "avatar") as! String
        
    }
    func setLastMessage(mes:String){
        self.lastmessage = mes
    }
    
    func getDays()->String{
        return "10-12"
    }
    // equal object  TODO
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? FriendData{
            return other.name == self.name && other.avart == self.avart
        }
        return false
    }
    
    
}


enum messgeType:String {
    case text = "text"
    case picture = "picture"
    case voice = "voice"
    
}

enum MessageStatus{
    case read
    case unKnow
    case canceled
}

class MessageBoby{
    
    var messageID:Int?
    var url:String?
    var content:String!
    var time:String!
    var type:messgeType = .text
    
    var messageStatus:MessageStatus = MessageStatus.unKnow
    
    var sender:FriendData = FriendData.init(name: "lk", avart: "lk")
    var target:FriendData = FriendData.init(name: "locky", avart: "avartar")
    
    init(content:String,time:String) {
        self.content = content
        self.time = time
    
    }
    
}
