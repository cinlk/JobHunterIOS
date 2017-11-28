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
    
    
}




// moya 协议targetType
extension UserMoyaType: TargetType{
    
    
    var  baseURL:URL{
        return URL.init(string: GITHUB_API_URL)!
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
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .SignIn:
            return ["scopes": ["public_repo", "user"], "note": "RxSignInSignUp_demo (\(Date()))"]
        case let .Verify(phone):
            return ["phone":phone]
        case  let .Registry(account, password, verifyCode):
            return ["phone":account, "password": password, "verifyCode":verifyCode]
        
        case  let .ResetPassword(account, password, verifyCode):
            return ["phone":account, "password":password, "verifyCode":verifyCode]
        }
    }
    
    
    var sampleData: Data {
        return "test data".data(using: String.Encoding.utf8)!
    }
    
    var task:  Task {
        return .requestPlain
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
    
    // 判断逻辑
    func validatePhone(phone:String) -> Observable<Result>{
        guard phone != "", !phone.isEmpty else {
            return Observable<Result>.just(.none)
        }
        
        guard  phone.count <= 11  else {
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

   
    var TestUser:Users?
    static let shareInstance:loginServer = loginServer()
    
    private override init() {
        
        //self.TestUser = Users.init("13718754627", "111111")
        
        self.TestUser = Users(JSONString: "{'user':'dwdaw','role':'ada'}")
        
        
        let endpointClosure = { (target: UserMoyaType) -> Endpoint<UserMoyaType> in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint<UserMoyaType> = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: nil)
            
        
            
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
        //MARK 模拟网络请求序列 延迟效果

        //Thread.sleep(forTimeInterval: 3)
        
        return (httpRequestHandler?.rx.request(.SignIn(account: "wowpandan@gmail.com", password: "s*#posix6u!")).debug().filterSuccessfulStatusCodes().mapJSON().map{
            json in
            print(json)
            return Result.success(account: "admin", password: "role")
            }.asObservable())!
        
        
        
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
