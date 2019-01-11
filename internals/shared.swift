//
//  shared.swift
//  internals
//
//  Created by ke.liang on 2019/1/5.
//  Copyright © 2019 lk. All rights reserved.
//

// 存储全局需要的公共数据类型

import Foundation


fileprivate let locPermit = "locPermit"
fileprivate let rememberLogin = "rememberLogin"
fileprivate let userAccount = "userAccount"
fileprivate let userPassword = "userPassword"


// 记录当前用户地理位置 城市 和区
fileprivate struct CurrentUserAddress {
    
    private var city:String
    private var zone:String
    private var address:String
    
    init() {
        self.city = ""
        self.zone = ""
        self.address = ""
    }
    
    mutating func set(city:String, zone:String, address:String){
        self.city = city
        self.zone = zone
        self.address = address
    }
    
}


// 发送简历时 默认发送的语句
fileprivate struct  FirstHelloMsg {
    
    private var index:Int
    private var sayHi:[String]
    
    init() {
        self.sayHi = [String]()
        self.index = self.sayHi.count
    }
    
   public mutating func setSayHi(contents:[String], index:Int){
        if contents.isEmpty{
            return
        }
        if index < 0 || index >= contents.count {
                return
        }
    
        self.sayHi = contents
        self.index = index
        
    }
    
    public func getSayHi() -> ([String]?, Int){
        if self.sayHi.count <=  0{
            return (nil, -1)
        }
        return (self.sayHi, self.index)
    }

    
}

// 分享面板的apps
public struct ShareAppItem {
    
    private var openURL:String
    public var name:String
    public var image:UIImage?
    public var type:UMSocialPlatformType
    private var bubbles:Int?
    
    init(name:String, image:UIImage?, type:UMSocialPlatformType, bubbles:Int? = nil) {
        self.openURL = ""
        self.name = name
        self.image = image ?? UIImage.init(named: "default")
        self.type = type
        self.bubbles = bubbles
    }
    
    
    init(url:String, name:String, image: UIImage?, type:UMSocialPlatformType, bubbles:Int? = nil) {
        self.openURL = url
        self.name = name
        self.image = image ?? UIImage.init(named: "default")
        self.type = type
        self.bubbles = bubbles
    }
    
    
    public func canOpen(items: inout [ShareAppItem]){
        if self.openURL == ""{
            items.append(self)
            return
        }
        
        if let url = URL.init(string: self.openURL), UIApplication.shared.canOpenURL(url){
            items.append(self)
        }
        
    }
    
}




enum UserRole:String {
    
    case hr = "hr"
    case student = "student"
    case anonymous = "anonymouse"
    
}

// 用户信息
class GlobalUserInfo {
    
    
    private static let single = GlobalUserInfo()
    
    open class var shared: GlobalUserInfo{
        get{
            return GlobalUserInfo.single
        }
    }
    
    // 缓存密码
    private lazy var userDefault:UserDefaults  = {
       return UserDefaults.standard
    }()
    
    private  var isRemember:Bool {
        get{
            return self.userDefault.bool(forKey: rememberLogin)
        }
        set{
            if newValue == true{
                // 存储账号和密码
                self.userDefault.set(self.account, forKey: userAccount)
                self.userDefault.set(self.password, forKey: userPassword)
            }
            self.userDefault.set(newValue, forKey: rememberLogin)
        }
    }
    public var isLogin:Bool = false {
        willSet{
            if newValue == false{
                self.role = .anonymous
            }
        }
    }
    
    public var token:String = ""
    
    
    private var account:String = ""
    private var password:String = ""
    private var role:UserRole = .anonymous
    
    init() {}
    
    init(isLogin:Bool, role:UserRole, account:String, password:String) {
        self.isLogin = isLogin
        self.role = role
        self.account = account
        self.password = password
        
    }
    
    open func setRole(role:String){
        if let r =  UserRole.init(rawValue: role){
            self.role = r
        }
    }

    open func setAccount(account:String, password:String){
        self.account = account
        self.password = password
    }
    
}






class SingletoneClass {
    
    private static let single = SingletoneClass()
    
    open class var shared: SingletoneClass{
        get{
            return  SingletoneClass.single
        }
    }
    
    
    fileprivate lazy var messageHi:FirstHelloMsg = {
            return FirstHelloMsg()
    }()
    
     fileprivate lazy var currentUserAddress: CurrentUserAddress = {
            return CurrentUserAddress()
    }()
    
    //shareView Height
    public var shareViewH:CGFloat = 240.0
    
    // 手机安装的app 来第三方分享登录
    public var shareItems:[ShareAppItem] = []{
        willSet{
            if newValue.count >= 4 {
                self.shareViewH -= 87.5
            }
        }
    }
    
    private var userDefaule: UserDefaults = UserDefaults.standard
    

   
    open class var fileManager: FileManager {
        get{
            return FileManager.default
        }
    }
    
    
    
    // user location authorized
    open  var userLocationPermit:Bool {
        get{
            return self.getUserLocationPermit()
        }
    }
    
    
    init() {
        // 监听shareitem 数组长度变化
        ///objec
    }
    
    // 设置到缓存
    open func setUserLocation(permit:Bool){
        self.userDefaule.set(permit, forKey: locPermit)
    }
    // 存储到缓存
    private func getUserLocationPermit() -> Bool{
       return self.userDefaule.bool(forKey: locPermit)
        
    }
    
}


extension SingletoneClass{
 
    
    public func setAddress(city:String, zone:String, address:String){
        self.currentUserAddress.set(city: city, zone: zone, address: address)
    }
    
    public func setSayHi(contents:[String], index:Int){
        self.messageHi.setSayHi(contents: contents, index: index)
    }
    
    public func getSayHi() -> ([String]?, Int){
        return self.messageHi.getSayHi()
    }
    
}


extension SingletoneClass{
    // TODO 根据条件初始化需要分享的apps
    public func setSharedApps(condition:Any?){
        
        ShareAppItem.init(name: "复制链接", image: UIImage.init(named: "copyIcon"), type: UMSocialPlatformType.copyLink, bubbles: nil).canOpen(items: &self.shareItems)
        ShareAppItem.init(name: "更多", image: UIImage.init(named: "moreShare"), type: UMSocialPlatformType.more, bubbles: nil).canOpen(items: &self.shareItems)
        ShareAppItem.init(url: ConfigSharedApp.qq.url, name: ConfigSharedApp.qq.name, image: ConfigSharedApp.qq.image, type: ConfigSharedApp.qq.type, bubbles: nil).canOpen(items: &self.shareItems)
        ShareAppItem.init(url: ConfigSharedApp.qqZone.url, name: ConfigSharedApp.qqZone.name, image: ConfigSharedApp.qqZone.image, type: ConfigSharedApp.qqZone.type, bubbles: nil).canOpen(items: &self.shareItems)
        ShareAppItem.init(url: ConfigSharedApp.sina.url, name: ConfigSharedApp.sina.name, image: ConfigSharedApp.sina.image, type: ConfigSharedApp.sina.type, bubbles: nil).canOpen(items: &self.shareItems)
        ShareAppItem.init(url: ConfigSharedApp.wechat.url, name: ConfigSharedApp.wechat.name, image: ConfigSharedApp.wechat.image, type: ConfigSharedApp.wechat.type, bubbles: nil).canOpen(items: &self.shareItems)
        ShareAppItem.init(url: ConfigSharedApp.wechatFriends.url, name: ConfigSharedApp.wechatFriends.name, image: ConfigSharedApp.wechatFriends.image, type: ConfigSharedApp.wechatFriends.type, bubbles: nil).canOpen(items: &self.shareItems)
        
    }
    
    
}
