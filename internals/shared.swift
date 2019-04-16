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
import RxCocoa
import RxSwift
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
    static let remember = "remember"
    
    public var localKeys:[String]{
        get{
            return [UserDefaults.locPermit, UserDefaults.userAccount,
                    UserDefaults.userPassword, UserDefaults.remember]
        }
    }
    
    
    
}




// 记录当前用户地理位置 城市 和区
fileprivate struct CurrentUserAddress {


    private var address:String
    private var userLocation: CLLocation

    init() {
        self.address = ""
        self.userLocation = CLLocation.init(latitude: CLLocationDegrees.init(), longitude: CLLocationDegrees.init())
    }

    mutating func set(address:String){
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
class GlobalUserInfo: NSObject {
    
    
    private static let single = GlobalUserInfo()
    
    // leancloud user
    private  var imClient:AVIMClient?
    //private var connected:Bool = false
    private var leanCloudUserId:String?
    
    // 接收消息处理
    //internal let receiveMessage: PublishRelay<AVIMTypedMessage> =  PublishRelay<AVIMTypedMessage>.init()

    
    
    
    open class var shared: GlobalUserInfo{
        get{
            return GlobalUserInfo.single
        }
    }
    
    // 缓存密码
    private lazy var userDefault:UserDefaults  = {
       return UserDefaults.standard
    }()
    
  
    public var isLogin:Bool = false
    
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
            //  如果有密码 设置自动登录
            if let v = newValue, !v.isEmpty{
                self.userDefault.set(true, forKey: UserDefaults.remember)
            }
        }
    }
    
//    private var remember:Bool{
//
//    }
    private var role:UserRole.role = UserRole.role.anonymous{
        didSet{
            switch self.role{
            case .anonymous:
                self.isLogin = false
            case .hr, .seeker:
                self.isLogin = true
               
            }
            
        }
    }
    
    
    
    private var userData:[String:Any] = [:]{
        didSet{
            if let role = userData["role"] as? String{
                self.role = UserRole.role(rawValue: role) ?? .anonymous
            }
        }
    }
    
    
    
    override init() {}
    
    
    open func baseInfo(token:String, account:String, pwd:String,  lid:String, data:[String:Any]){
    
        
        
        self.userData = data
        self.token = token
        self.account = account
        self.password = pwd
        if self.role != .anonymous{
            self.imClient =  AVIMClient.init(clientId: lid)
            self.imClient?.delegate = self
        }
       
        // 获取用户信息
        
        
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
    
    open func getId() -> String?{
        
        return self.userData["user_id"] as? String
    }
    
    open func getName() -> String?{
        return self.userData["name"] as? String
    }
    
    open func getIcon() -> URL?{
        guard  let icon_url = self.userData["user_icon"] as? String else {
            return nil
        }
        return  URL.init(string: icon_url)
    }
    
//    open func getUserId() -> String{
//        return self.userId
//    }
    open func clear(){
        self.account = nil
        self.password = nil
        self.token = ""
        self.isLogin = false
        self.imClient?.close(callback: { (success, error) in
            
        })
        self.role = .anonymous
        UserDefaults.standard.localKeys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        //UserDefaults.standard.removeObject(forKey: UserDefaults.userAccount)
        //UserDefaults.standard.removeObject(forKey: UserDefaults.userPassword)
        //UserDefaults.standard.removeObject(forKey: <#T##String#>)
    }
    
    
    internal func openConnected(completed: @escaping (_:Bool, _ :Error?)->Void){
        
        self.imClient?.open { (success, error) in
            completed(success, error)
        }
        // cconversation
    }
    
    internal func buildConversation(conversation:String?, talkWith:String, jobId:String, completed:@escaping (_:AVIMConversation?, _:Error?) -> Void){
        guard  let im = self.imClient else {
            completed(nil, NSError.init())
            return
        }
        
       
        
        // 新建会话
        if conversation == nil{
            // 先查最新的会话 是否已经存在 TODO
            // name 要唯一
            let conversationName = im.clientId + "_" + jobId + "_" + talkWith
            let query = im.conversationQuery()
            query.whereKey("name", equalTo: conversationName)
            query.order(byDescending: "createdAt")
            // 不查本地缓存
            query.cachePolicy  = .ignoreCache
            query.findConversations { [weak self] (cons, error) in
                if let c = cons?.first{
                   
                    completed(c, error)
          
                }else{
                    self?.imClient?.createConversation(withName: conversationName, clientIds: [talkWith], callback: { (cons, err) in
                        print("create conversation \(String(describing: cons)) \(String(describing: err))")
                        completed(cons, err)
                    })
                }
               
            }
            return
            
        }
        
         // 查找 并加入会话
        if  let cid = conversation, !cid.isEmpty{
            
            self.imClient?.conversationQuery().getConversationById(cid, callback: { (convs, error) in
                completed(convs, error)
            })
            
            return
        }
        completed(nil, NSError.init())
        
        
        
       
        
    }
  

}



extension GlobalUserInfo: AVIMClientDelegate{
    
    func imClientPaused(_ imClient: AVIMClient) {
        
    }
    
    func imClientResuming(_ imClient: AVIMClient) {
        
    }
    
    func imClientResumed(_ imClient: AVIMClient) {
        
    }
    
    func imClientClosed(_ imClient: AVIMClient, error: Error?) {
        
    }
    
    
    func conversation(_ conversation: AVIMConversation, didReceive message: AVIMTypedMessage) {
        
        //print(conversation,message)
        let sender = conversation.clientId ?? ""
        switch message.mediaType {
        case .text:
            let txt = message as? AVIMTextMessage
            //txt?.content
            //print(txt)
            let option = AVIMMessageOption.init()
            option.priority = .high
            
            let replyText = AVIMTextMessage.init(content: "reply")
            replyText.text = "你好\(String(describing: txt?.text))"
            replyText.attributes = nil
            
            print("receive msg from \(sender) with content \(String(describing: txt?.text))")
            conversation.send(replyText, option: option, progressBlock: { (progress) in
                print(progress)
            }) { (success, error) in
                //print(success, error)
            }
        case .image:
            let _ =  message as? AVIMImageMessage
            
        default:
            break
        }
        
    }
    
}




class SingletoneClass {
    
    private static let single = SingletoneClass()
    
    open class var shared: SingletoneClass{
        get{
            return  SingletoneClass.single
        }
    }
    
    
    fileprivate  var messageHi:FirstHelloMsg?
    
    
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
    
    // 用户地址
    //public var userAddress:String?
    
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
    
    // job举报信息
    public var jobWarns:[String] = []
    
    private var userDefaule: UserDefaults = UserDefaults.standard
    
   
    
    

   
    open class var fileManager: FileManager {
        get{
            return FileManager.default
        }
    }
    
    
    
    // user location authorized
//    open  var userLocationPermit:Bool {
//        get{
//            return self.getUserLocationPermit()
//        }
//    }
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
//    open func setUserLocation(permit:Bool){
//        self.userDefaule.set(permit, forKey: UserDefaults.locPermit)
//    }
    
    // 存储到缓存
//    private func getUserLocationPermit() -> Bool{
//       return self.userDefaule.bool(forKey: UserDefaults.locPermit)
//
//    }
    
    
    
}


extension SingletoneClass{
 
    
    public func setAddress(address:String){
        self.currentUserAddress.set(address: address)
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
        NetworkTool.request(GlobaHttpRequest.guideData, successCallback: {  [weak self] (data) in
            // swiftJson
            
            self?.guidanceData =  Mapper<ResponseArrayModel<GuideItems>>().map(JSONObject: data)
           
            group.leave()
        }, failureCallback: { (error) in
            group.leave()
        })
        
        group.enter()
        NetworkTool.request(GlobaHttpRequest.adviseImages, successCallback: { [weak self] (data) in
            
            self?.adviseImage  = Mapper<ResponseModel<AdViseImage>>().map(JSONObject: data)
            group.leave()
        }) { (error) in
            group.leave()
        }
        // 需要选择的数据 TODO
        group.enter()
        NetworkTool.request(.citys, successCallback: {[weak self]   (data) in
            if let res = Mapper<ResponseModel<SelectedCityModel>>().map(JSONObject: data)?.body, let citys = res.citys{
                self?.selectedCity = citys
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.bussinessField, successCallback: { [weak self] (data) in
            if let res = Mapper<ResponseModel<BussinessFieldModel>>().map(JSONObject: data)?.body, let field = res.fields{
                self?.selectedBusinessField = field
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.subBusinessField, successCallback: { [weak self] (data) in
            if let res = Mapper<ResponseModel<SubBusinessFieldModel>>().map(JSONObject: data)?.body,
                let field = res.fields{
                self?.selectedSubBusinessField = field
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.companyType, successCallback: { [weak self] (data) in
            if let res = Mapper<ResponseModel<CompanyTypeModel>>().map(JSONObject: data)?.body,
                let type = res.type{
                self?.selectedCompanyType = type
            }
            
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        
        group.enter()
        NetworkTool.request(.internCondition, successCallback: {  [weak self] (data) in
            if let res = Mapper<ResponseModel<InternConditionModel>>().map(JSONObject: data)?.body,
                let condition = res.condition{
                self?.selectedInternCondition = condition
            }
            
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.cityCollege, successCallback: {  [weak self] (data) in
            if let res = Mapper<ResponseModel<CitysCollegeModel>>().map(JSONObject: data)?.body, let c = res.cityCollege{
                self?.selectedcityCollege = c
            }
            group.leave()
        }) { (error) in
            group.leave()
        }
        
        group.enter()
        NetworkTool.request(.jobWarns, successCallback: {  [weak self] (data) in
            if let res = Mapper<ResponseModel<JobWarnList>>().map(JSONObject: data)?.body, let w = res.warns{
                self?.jobWarns = w
                //print(self.jobWarns, "-------")
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
        // 等待所有任务并发执行后 才执行最后这一步
        group.notify(queue: DispatchQueue.main){
            finished(true)
        }
    }
    
    // 用户登录
    func userLogin(completed: @escaping (Bool)->Void){
        
        let remember = UserDefaults.standard.bool(forKey: UserDefaults.remember)
        guard  remember == true  else {
            completed(false)
            return
        }
        
        guard let account = GlobalUserInfo.shared.getAccount() else{
            completed(false)
            return
        }
        
        guard let password = GlobalUserInfo.shared.getPassword()  else{
            completed(false)
            return
        }
        
        NetworkTool.request(GlobaHttpRequest.userlogin(phone: account, password: password), successCallback: { (json) in
            if let res =  Mapper<ResponseModel<LoginSuccess>>().map(JSONObject: json), let token = res.body?.token, let lid = res.body?.leanCloudId{
              
                // 返回TOKEN TODO
                // 记录用户名和密码
                NetworkTool.request(.userInfo(token: token), successCallback: { (json) in
                    if let j = json as? [String:Any], let data = j["body"] as? [String:Any]{
                        GlobalUserInfo.shared.baseInfo(token: token , account: account, pwd: password, lid: lid, data: data)
                        completed(true)
                        return
                    }
                    
                }, failureCallback: { (error) in
                    completed(false)
                })
                // 设置用户角色 TODO
                // 根据角色却换不同界面
            }else{
                completed(false)
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





