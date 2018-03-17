//
//  httpservers.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

import ObjectMapper






// 请教基础类型

enum UserMoyaType{
    
    case SignIn(account:String, password:String)
    case Verify(phone:String)
    case Registry(account:String, password:String, verifyCode:String)
    case ResetPassword(account:String,password:String, verifyCode:String)
    case Login(account:String, password:String)
    
    
    
}




// moya 协议targetType
extension UserMoyaType: TargetType{
    
    
    var  baseURL:URL{
        return URL.init(string: APP_JOB_URL)!
    }
    
    
    
    var path: String {
        switch self {
        case .SignIn:
            return "/authorizations"
        case .Verify:
            return "/verifyPhone"
        case .Registry:
            return "/register"
        case .ResetPassword:
            return "/resetPassword"
        case .Login:
            return "/login"
            
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .SignIn:
            return .post
        case .Registry:
            return .post
        case .Verify:
            return .post
        case .ResetPassword:
            return .post
        case .Login:
            return .post
            
        }
    }
    
    
    
    
    var sampleData: Data {
        return "test data".data(using: String.Encoding.utf8)!
    }
    
    var task:  Task {
        
        switch self {
        case .SignIn:
            return  .requestPlain
        case let .Verify(phone):
            //  url 后缀参数
            return  .requestParameters(parameters: ["phone":phone], encoding: URLEncoding.queryString)
        case  let .Registry(account, password, verifyCode):
            return  .requestParameters(parameters: ["account":account, "password": password, "verifyCode":verifyCode],encoding: JSONEncoding.default)
            
            
            
            
        case  let .ResetPassword(account, password, verifyCode):
            // post json body 数据
            return  .requestParameters(parameters: ["phone":account, "password":password, "verifyCode":verifyCode], encoding: JSONEncoding.default)
            
        case let .Login(account, password):
            return .requestParameters(parameters: ["account":account, "password": password], encoding: JSONEncoding.default)
            
        }
    }
    
    var validate: Bool {
        return false
    }
    var headers: [String : String]? {
        return nil
    }
    var parameterEndcodeing: ParameterEncoding{
        return URLEncoding.default
    }
    
}


class BaseServer{
    
    // 判断phone 长度逻辑 （其他账号？？）
    func validatePhone(phone:String) -> Observable<Result>{
        guard phone != "", !phone.isEmpty else {
            return Observable<Result>.just(.none)
        }
        
        // 手机号 （其他账号）
        guard  phone.count >= 6  else {
            return Observable<Result>.just(.wrongPhoneNumber(message: ""))
        }
        return Observable<Result>.just(.pass)
        
        
    }
    
    func validatePassword(password:String) -> Observable<Result>{
        guard password != "",!password.isEmpty else {
            return Observable<Result>.just(.none)
        }
        guard password.count >= 6 else {
            return Observable<Result>.just(.error(message: "密码至少大于6位"))
        }
       
        return Observable<Result>.just(.pass)
    
    }
    
    func validateVerifyCode(verifyCode:String) -> Observable<Result>{
        
        guard verifyCode != "", !verifyCode.isEmpty else {
            return Observable<Result>.just(.none)
        }
        
        guard verifyCode.count == 6 else {
            return Observable<Result>.just(.error(message: "验证码为6位数"))
        }
       
        
        return Observable<Result>.just(.pass)
        
    }
    
    // 确认密码
    func validateConfirmPassword(firstPassword:String, secondPassword:String) -> Observable<Result>{
        guard firstPassword.count>=6 && secondPassword.count>=6 else {
            return Observable<Result>.just(.error(message: "密码至少大于6位"))
        }
        guard firstPassword == secondPassword else{
            return Observable<Result>.just(.error(message: "2次输入的密码不相同"))
        }
        return Observable<Result>.just(.pass)
    }
    
}
//
// login
class  loginServer: BaseServer{
    
    let httpRequestHandler: MoyaProvider<UserMoyaType>?

   
    var TestUser:UserModel?
    static let shareInstance:loginServer = loginServer()
    
    private override init() {
        
        //self.TestUser = Users.init("13718754627", "111111")
        self.TestUser =  UserModel(JSON: ["account":"name","password":"pas","role":""])
        
        
        let endpointClosure = { (target: UserMoyaType) -> Endpoint<UserMoyaType> in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint<UserMoyaType> = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task,httpHeaderFields: nil)
            
            
            
            
            
            
            switch target {
            case .SignIn(let account, let password):
                let credentialData = "\(account):\(password)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                
                return endpoint.adding(newHTTPHeaderFields:["Authorization": "Basic \(base64Credentials)"])
                
            //.endpointByAddingParameterEncoding(JSONEncoding.default)
            default:
                return endpoint
            }
        }
        
        self.httpRequestHandler = MoyaProvider<UserMoyaType>.init(endpointClosure: endpointClosure)
        
        super.init()
        
        
    }
    
    
    // login request
    func login(_ account:String, password: String) -> Observable<Result>{
        //MARK 模拟网络请求序列 延迟效果 如果post 传递数据
    
     
        
        // 对产生的 res 事件 数据转换 和 可被监听
        return (httpRequestHandler?.rx.request(.Login(account: account, password: password)).debug().map({ (res) -> Result in
            switch res.statusCode{
            case 401:
                return Result.error(message: "权限错误")
            case 200,201,202:
                return Result.success(account: "admin", password: "role")
            default:
                return Result.none
            }
        }).asObservable())!
        

        //Observable.just(Result.error(message: "<#T##String#>"))
        
//        return (httpRequestHandler?.rx.request(.SignIn(account: "wowpandan@gmail.com", password: "s*#posix6u!")).debug().filterSuccessfulStatusCodes().mapJSON().map{
//            json in
//            print(json)
//            return Result.success(account: "admin", password: "role")
//            }.asObservable())!
        
        //return Observable.just(Result.success(account: "admin", password: "role"))
        
        
    }
    
}

// registry
class RegistryServer: BaseServer{
    
    static let instance = RegistryServer()
    
    let  httpRequest:MoyaProvider<UserMoyaType>?
    
    private override init() {
        self.httpRequest = MoyaProvider<UserMoyaType>.init()
        super.init()
        
    }
    
    
    //MARK
    func registry(phone:String, verifyCode:String, password:String) -> Observable<myResponse> {
        
        return (self.httpRequest?.rx.request(.Registry(account: phone, password: password, verifyCode: verifyCode)).debug()
            .mapJSON().map{
              json in
                myResponse.none
            }.asObservable().share(replay: 1)
        )!
        
    }
    
    
    func getVerifyCode(phone:String) -> Observable<myResponse>{
        
        return (self.httpRequest?.rx.request(.Verify(phone: phone)).debug()
            .mapJSON().map{
                json  in
                return myResponse.error(code: 404, message: "测试")
        }.asObservable().share(replay: 1))!
    }
    
}

// ChangePassword service
class ChangePasswordService: BaseServer {
    
    static let instance = ChangePasswordService.init()
    let  httpRequest:MoyaProvider<UserMoyaType>?
    
    override init() {
        httpRequest = MoyaProvider<UserMoyaType>.init()
        super.init()
    }
    
    
    func getVerifyCode(phone:String) -> Observable<myResponse>{
        
        
        return (self.httpRequest?.rx.request(.Verify(phone: phone)).debug()
            .mapJSON().map{
                json  in
                return myResponse.error(code: 404, message: "测试")
            }.asObservable().share(replay: 1))!
    }
    
    func submitNewPassword(phone:String, code:String,password:String) -> Observable<myResponse>{
        
        return (self.httpRequest?.rx.request(.ResetPassword(account: phone, password: password, verifyCode: code))
            .debug().mapJSON().map{
                json in
                return myResponse.error(code: 404, message: "测试")
            }.asObservable().share(replay: 1))!
    }
    
    
}
