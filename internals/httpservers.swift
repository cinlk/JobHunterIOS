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
    case Verify(account:String, verifyCode:String)
    case Registry(account:String, password:String)
    
}




// moya 协议targetType
extension UserMoyaType: TargetType{
    
    
    var  baseURL:URL{
        return URL.init(string: GITHUB_API_URL)!
    }
    
    
    
    var path: String {
        switch self {
        case .SignIn(let account,let  password):
            return "/authorizations"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .SignIn(let _,let  _):
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .SignIn(let account, let password):
            
            return ["scopes": ["public_repo", "user"], "note": "RxSignInSignUp_demo (\(Date()))"]
        default:
            return nil
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



//






// login
class  loginServer{
    
    
    
   
    
    let httpRequestHandler: MoyaProvider<UserMoyaType>?

   
    var TestUser:Users?
    static let shareInstance:loginServer = loginServer()
    
    private init() {
        //self.TestUser = Users.init("13718754627", "111111")
        
        self.TestUser = Users(JSONString: "{'user':'dwdaw','role':'ada'}")
        
        
        
        
        
        var endpointClosure = { (target: UserMoyaType) -> Endpoint<UserMoyaType> in
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
        
        httpRequestHandler = MoyaProvider<UserMoyaType>.init(endpointClosure: endpointClosure)
    }
    
    
    
    // 判断逻辑
    func validatePhone(phone:String) -> Observable<Result>{
        
        
        guard  phone.count < 13  else {
            return Observable<Result>.just(.wrongPhoneNumber(message: "号码无效"))
        }
        guard phone.count != 0  else {
            return Observable<Result>.just(.none)
        }
        return Observable<Result>.just(.pass)
        
        
    }
    
    func validatePassword(password:String) -> Observable<Result>{
        guard password != "" else {
            return Observable<Result>.just(.error(message: "密码为空"))
        }
        guard password.count >= 6 else {
            return Observable<Result>.just(.error(message: "密码至少大于6位"))
        }
        return Observable<Result>.just(.pass)
    }
    
    
    // login request
    func login(_ account:String, password: String) -> Observable<Result>{
        //MARK 模拟网络请求序列 延迟效果

        //Thread.sleep(forTimeInterval: 3)
        // test
        
        print(TestUser)
        
        return (httpRequestHandler?.rx.request(.SignIn(account: "wowpandan@gmail.com", password: "s*#posix6u!")).debug().filterSuccessfulStatusCodes().mapJSON().map{
            json in
            print(json)
            return Result.error(message: "测试哈")
            }.asObservable())!
        
        
        
//        if account != self.TestUser?.phoneNumber  || password != self.TestUser?.password{
//            return Observable<Result>.just(.error(message: "用户名或密码错误"))
//        }
//        return Observable<Result>.just(.success(account: account, password: password))
//
//
        
    }
    
}

// registry
class RegistryServer{
    
}
