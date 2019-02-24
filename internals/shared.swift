//
//  shared.swift
//  internals
//
//  Created by ke.liang on 2019/1/5.
//  Copyright © 2019 lk. All rights reserved.
//

// 存储全局需要的公共数据类型

import Foundation
import Moya
import Alamofire
import ObjectMapper
import CoreLocation



extension UserDefaults{
    // app 存储的keys
    
    static let locPermit = "locPermit"
    static let userAccount = "userAccount"
    static let userPassword = "userPassword"
    static let firstOpen = "firstOpen"
    static let token = "token"
    
    public var localKeys:[String]{
        get{
            return [UserDefaults.locPermit, UserDefaults.userAccount,
                    UserDefaults.userPassword]
        }
    }
    
    
    
}




// 记录当前用户地理位置 城市 和区
fileprivate struct CurrentUserAddress {
    
    private var city:String
    private var zone:String
    private var address:String
    private var userLocation: CLLocation
    
    init() {
        self.city = ""
        self.zone = ""
        self.address = ""
        self.userLocation = CLLocation.init(latitude: CLLocationDegrees.init(), longitude: CLLocationDegrees.init())
    }
    
    mutating func set(city:String, zone:String, address:String){
        self.city = city
        self.zone = zone
        self.address = address
    }
    
    mutating func setLocation(location: CLLocation){
        self.userLocation = location
    }
    
    //
    func getAddress() -> String?{
        return self.address  == "" ? nil : self.address
    }
    
    func getLocation() -> CLLocation{
        return self.userLocation
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





//enum UserRole:String {
//    
//    case hr = "hr"
//    case student = "student"
//    case anonymous = "anonymouse"
//    
//}

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
    
    private var token:String = ""
    
    private var account:String? {
        get{
            return self.userDefault.string(forKey: UserDefaults.userAccount)
        }
        set{
            self.userDefault.set(newValue, forKey: UserDefaults.userAccount)
        }
    }
    
    private var password:String? {
        get{
           return self.userDefault.string(forKey: UserDefaults.userPassword)
        }
        set{
            self.userDefault.set(newValue, forKey: UserDefaults.userPassword)
        }
    }
    private var role:UserRole.role = UserRole.role.anonymous
    
    init() {}
    
    
    open func baseInfo(role: UserRole.role, token:String, account:String, pwd:String){
        
        self.token = token
        self.role = role
        switch self.role{
        case .anonymous:
            self.isLogin = false
        case .hr, .seeker:
            self.isLogin = true
            self.account = account
            self.password = pwd
        }
        return
        
        
    }
    
    open func getAccount() -> String?{
        return self.account
    }
    
    open func getPassword() -> String?{
        return self.password
    }
    
    open func getToken() -> String{
        return self.token
    }
    
    open func clear(){
        self.account = nil
        self.password = nil
        self.token = ""
        self.role = .anonymous
        UserDefaults.standard.removeObject(forKey: UserDefaults.userAccount)
        UserDefaults.standard.removeObject(forKey: UserDefaults.userPassword)
        //UserDefaults.standard.removeObject(forKey: <#T##String#>)
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
    public var guidanceData:ResponseArrayModel<GuideItems>?
    // 广告背景图片
    public var adviseImage:ResponseModel<AdViseImage>?
    // 选择的城市
    public var selectedCity:[String:[String]] = [:]
    // 选择的行业类型
    public var selectedBusinessField:[String] = []
    // 行业职位细分
    public var selectedSubBusinessField:[String:[String]] = [:]
    // 公司类型
    public var selectedCompanyType:[String] = []
    // 实习选择类型
    public var selectedInternCondition:[String:[String]] = [:]
    // 城市的大学
    public var selectedcityCollege:[String:[String]] = [:]
    // app用户协议地址
    public var appAgreementURL:String? = "http://www.immomo.com/agreement.html"
    
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
//    open var accessToken:String {
//        get {
//            return self.userDefaule.string(forKey: "token") ?? "fake"
//        }
//        set{
//            self.userDefaule.set(newValue, forKey: "token")
//            //GlobalUserInfo.shared.isLogin = true
//        }
//    }
    
    
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
    public func getAddress() -> String?{
        return self.currentUserAddress.getAddress()
    }
    public func getLocation() -> CLLocation{
        return self.currentUserAddress.getLocation()
    }
    
    public func setUserLocation(location: CLLocation){
       
        self.currentUserAddress.setLocation(location: location)
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
    
    public func logout(complete: @escaping (Bool)->Void) {
        let group = DispatchGroup()
        group.enter()
        var flag = false
        NetworkTool.request(.logout, successCallback: { (res) in
            print("logout \(res)")
            GlobalUserInfo.shared.clear()
            group.leave()
            flag = true 
        }) { (error) in
            group.leave()
            
            print("logout error \(error)")
        }
        group.notify(queue: DispatchQueue.main){
            complete(flag)
        }
        
    }
}


// 引导界面数据
extension SingletoneClass{
    
    public func getInitialData(finished: @escaping  (Bool)->Void){
    
        let group = DispatchGroup()
        

        //let queue = DispatchQueue.init(label: "queue")
        
        group.enter()
        // 请求也是在其它线程 异步执行
        NetworkTool.request(GlobaHttpRequest.guideData, successCallback: { (data) in
            // swiftJson
            
            self.guidanceData =  Mapper<ResponseArrayModel<GuideItems>>().map(JSONObject: data)
           
            group.leave()
        }, failureCallback: { (error) in
            group.leave()
        })
        
        group.enter()
        NetworkTool.request(GlobaHttpRequest.adviseImages, successCallback: { (data) in
            
            self.adviseImage  = Mapper<ResponseModel<AdViseImage>>().map(JSONObject: data)
            group.leave()
        }) { (error) in
            group.leave()
        }
        // 需要选择的数据 TODO
        group.enter()
        NetworkTool.request(.citys, successCallback: { (data) in
            if let res = Mapper<ResponseModel<SelectedCityModel>>().map(JSONObject: data)?.body, let citys = res.citys{
                self.selectedCity = citys
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.bussinessField, successCallback: { (data) in
            if let res = Mapper<ResponseModel<BussinessFieldModel>>().map(JSONObject: data)?.body, let field = res.fields{
                self.selectedBusinessField = field
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.subBusinessField, successCallback: { (data) in
            if let res = Mapper<ResponseModel<SubBusinessFieldModel>>().map(JSONObject: data)?.body,
                let field = res.fields{
                self.selectedSubBusinessField = field
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.companyType, successCallback: { (data) in
            if let res = Mapper<ResponseModel<CompanyTypeModel>>().map(JSONObject: data)?.body,
                let type = res.type{
                self.selectedCompanyType = type
            }
            
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        
        group.enter()
        NetworkTool.request(.internCondition, successCallback: { (data) in
            if let res = Mapper<ResponseModel<InternConditionModel>>().map(JSONObject: data)?.body,
                let condition = res.condition{
                self.selectedInternCondition = condition
            }
            
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.cityCollege, successCallback: { (data) in
            if let res = Mapper<ResponseModel<CitysCollegeModel>>().map(JSONObject: data)?.body, let c = res.cityCollege{
                self.selectedcityCollege = c
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
      
        // TODO  用户协议网址
        
        group.notify(queue: DispatchQueue.main){
            finished(true)
        }
    }
    
    // 用户登录
    func userLogin(completed: @escaping (Bool)->Void){
        
       
        guard let account = GlobalUserInfo.shared.getAccount() else{
            completed(false)
            return
        }
        
        guard let password = GlobalUserInfo.shared.getPassword()  else{
            completed(false)
            return
        }
        
        NetworkTool.request(GlobaHttpRequest.userlogin(phone: account, password: password), successCallback: { (json) in
            if let res =  Mapper<ResponseModel<LoginSuccess>>().map(JSONObject: json), let token = res.body?.token{
                completed(true)
                // 返回TOKEN TODO
                // 记录用户名和密码
                GlobalUserInfo.shared.baseInfo(role: UserRole.role.seeker, token: token , account: account, pwd: password)
                // 设置用户角色 TODO
                // 根据角色却换不同界面
            }
            
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


// moya https 配置
//let MoyaManager = Manager(
//    configuration: URLSessionConfiguration.default,
//    serverTrustPolicyManager: CustomServerTrustPoliceManager()
//)
//
//class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
//    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
//        return .disableEvaluation
//    }
//    public init() {
//        super.init(policies: [:])
//    }
//}





