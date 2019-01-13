//
//  shared.swift
//  internals
//
//  Created by ke.liang on 2019/1/5.
//  Copyright © 2019 lk. All rights reserved.
//

// 存储全局需要的公共数据类型

import Foundation
import ObjectMapper
import ObjectMapper





extension UserDefaults{
    // app 存储的keys
    
    static let locPermit = "locPermit"
    static let userAccount = "userAccount"
    static let userPassword = "userPassword"
    static let firstOpen = "firstOpen"
    
    
    public var localKeys:[String]{
        get{
            return [UserDefaults.locPermit, UserDefaults.userAccount,
                    UserDefaults.userPassword]
        }
    }
    
    
    
}

// 引导界面数据
class UserGuidePageItem: NSObject, Mappable {
    
    
    var imageURL: String?
    var title: String?
    var detail: String?
    
    required init?(map: Map) {
        if map["imageURL"] == nil || map["title"] == nil || map["detail"] == nil{
            return nil
        }
    }
    
    func mapping(map: Map) {
        imageURL <- map["imageURL"]
        title <- map["title"]
        detail <- map["detail"]
    }
    
    
}



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
fileprivate class  FirstHelloMsg: NSObject, Mappable  {
    
    private var choosed:Int
    private var texts:[String]
    
    required init?(map: Map) {
        self.choosed = 0
        self.texts = [String]()
    }
    
    
    func mapping(map: Map) {
        self.choosed <- map["choosed"]
        self.texts  <- map["texts"]
    }
    
    
    
    fileprivate  func setSayHi(_ choosed: Int){
    
        self.choosed = choosed
    
    }
    
    fileprivate func getSayHi() -> ([String], Int){
        
        return (self.texts, self.choosed)
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
    
    
    fileprivate var messageHi:FirstHelloMsg?
    
    
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
    
    // 引导界面数据
    public var guidanceData:[UserGuidePageItem]?
    // 广告背景图片
    public var adviseImage:String?
    
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
        self.userDefaule.set(permit, forKey: UserDefaults.locPermit)
    }
    // 存储到缓存
    private func getUserLocationPermit() -> Bool{
       return self.userDefaule.bool(forKey: UserDefaults.locPermit)
        
    }
    
}


extension SingletoneClass{
 
    
    public func setAddress(city:String, zone:String, address:String){
        self.currentUserAddress.set(city: city, zone: zone, address: address)
    }
    
    
    public func setChoosedMessage(index:Int){
        // 跟新数据 http 请求
        NetworkTool.request(GlobaHttpRequest.setHelloMsg(index: index), successCallback: { (data) in
           
            self.messageHi?.setSayHi(index)
        }) { (error) in
            print(error)
        }
        
        //self.messageHi?.setSayHi(index)
    }
    public func getSayHi() -> ([String], Int){
        if let  hi = self.messageHi{
            return hi.getSayHi()
        }
        return ([String](), 0)
    }
    
}


// 引导界面数据
extension SingletoneClass{
    
    public func getInitialData(finished: @escaping  (Bool)->Void){
    
        let group = DispatchGroup()
        

        let queue = DispatchQueue.init(label: "queue")
        
        group.enter()
        // 请求也是在其它线程 异步执行
        NetworkTool.request(GlobaHttpRequest.guideData, successCallback: { (data) in
            // swiftJson
            self.guidanceData =  Mapper<UserGuidePageItem>.init().mapArray(JSONObject: data)
            group.leave()
        }, failureCallback: { (error) in
            group.leave()
        })
        
        group.enter()
        NetworkTool.request(GlobaHttpRequest.adviseImages, successCallback: { (data) in
            if let d = data as? [String:String]{
                self.adviseImage = d["imageURL"]
            }
            
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        
        //  需要等待用户登录后 TODO
//        DispatchQueue.global().async(group: group, qos: .userInitiated, flags: .inheritQoS) {
//            NetworkTool.request(GlobaHttpRequest.helloMsg, successCallback: { (data) in
//                // swiftJson
//                self.messageHi = Mapper<FirstHelloMsg>.init().map(JSONObject: data)
//
//            }, failureCallback :{ (error) in
//                print(error)
//            })
//        }
      
        
        group.notify(queue: DispatchQueue.main){
            finished(true)
        }
    }
    
    // 用户登录
    func userLogin(completed: @escaping (Bool)->Void){
        
       
        guard let account = userDefaule.string(forKey: UserDefaults.userAccount) else{
            completed(false)
            return
        }
        
        guard let password = userDefaule.string(forKey: UserDefaults.userPassword) else{
            completed(false)
            return
        }
        
        NetworkTool.request(GlobaHttpRequest.userlogin(account: account, password: password), successCallback: { (_) in
            completed(true)
            // 返回TOKEN TODO
            
            // 记录用户名和密码
            self.userDefaule.set(account, forKey: UserDefaults.userAccount)
            self.userDefaule.set(password, forKey: UserDefaults.userPassword)
            // 设置用户角色 TODO
            
        }) { (error) in
            completed(false)
        }
        
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
