//
//  loginServer.swift
//  internals
//
//  Created by ke.liang on 2018/9/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import Alamofire


// 响应类型





// 请求类型
enum loginManager {
    case getVerifyCode(name:String, type:String)
    case quickLogin(identity:String, code:uint, account:String)
    case accontLogin(account:String, pwd:String)
    case weixinLogin
    case weiboLogin
    case registryAccount(account:String, code:uint, pwd:String)
    case updatePassword(account:String, code:uint, pwd:String)
    case bindWeixin
    case binWeibo
    
}






extension loginManager: TargetType{
    

    var baseURL: URL{
       
        return URL.init(string: "http://www.baidu.com/app/api/")!
    }
    
    
    var path: String{
        
        switch self {
        case .binWeibo, .bindWeixin:
            return "link"
        case .getVerifyCode(let account, let type):
            return "code/\(account)/\(type)"
        case .quickLogin( _ ,  _ ,  _):
            return "login/code"
        case .accontLogin(_, _):
            return "login/account"
        case .updatePassword(_, _, _):
            return "registry/password"
        case .registryAccount(_, _, _):
            return "registry/account"
        default:
            return "login"
        }
        
    }
    
    
    var method: Moya.Method {
        switch self {
        case .getVerifyCode:
            return Method.get
        case .quickLogin(_, _, _):
            return Method.post
        case .accontLogin(_, _):
            return Method.post
        case .updatePassword(_, _, _):
            return Method.put
        case .registryAccount(_, _, _):
            return Method.post
        default:
            return Method.post
        }
    }
    
    
    var task: Task{
        switch self {
        case  .getVerifyCode(_, _):
            return .requestPlain
        case  .quickLogin(let identity , let code, let account):
            return .requestParameters(parameters: ["identity":identity,"code":code,"account":account], encoding: JSONEncoding.default)
        case .accontLogin(let account, let pwd):
            return .requestParameters(parameters: ["account":account, "password":pwd, "identity":""], encoding: JSONEncoding.default)
        case .updatePassword(let account, let code, let pwd):
            return .requestParameters(parameters: ["account":account, "password":pwd, "code": code], encoding: JSONEncoding.default)
        case .registryAccount(let account, let code, let pwd):
            return .requestParameters(parameters:["account":account, "password":pwd, "code": code], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data{
        switch self {
        case let .getVerifyCode(name, type):
            return "{\"account\": \(name), \"type\":\(type)}".utf8Encoded
        case .quickLogin(_, _, _):
            return "{\"token\":\"dqwdq-dqwdg5346-dwqd-5435345543\", \"user_exsit\":true}".utf8Encoded
        case .accontLogin(_, _):
            return "{\"token\":\"dqwdq-dqwdg5346-dwqd-5435345543\", \"user_exsit\":true}".utf8Encoded
        case .updatePassword(_, _, _):
            return "".utf8Encoded
        case .registryAccount(_, _, _):
            return "{\"token\":\"dqwdq-dqwdg5346-dwqd-5435345543\", \"user_exsit\":true}".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    
    
    
    var headers: [String : String]? {
       
        return ["Content-type": "application/json","User-Agent":"ios"]
    }
    
    
}


class LoginServer {
    
    private let disposebag = DisposeBag()
    
    lazy var  provider:MoyaProvider<loginManager> = {
        let p =  MoyaProvider<loginManager>(manager: MoyaManager, plugins: [NetworkLoggerPlugin(verbose: true)])
        return p
    }()
    
    static let shared:LoginServer = LoginServer()
    
    
    
    private init() {}
    
    
    func getVerifyCode(account:String, type:String) -> Observable<CodeSuccess> {
        
        return provider.rx.request(.getVerifyCode(name: account, type: type)).debug().filterSuccessfulStatusCodes().asObservable().mapObject(CodeSuccess.self)
        
    }
    
    // 手机号 快捷登录(TODO)
    func loginWithCode(account:String, code:uint) -> Observable<loginSuccess>{
        
        return provider.rx.request(.quickLogin(identity: "", code: code, account: account)).debug().filterSuccessfulStatusCodes().asObservable().mapObject(loginSuccess.self)
    }
    
    
    // 账号 密码登录
    func loginWithPwd(account:String, pwd:String) -> Observable<loginSuccess>{
        return provider.rx.request(.accontLogin(account:account, pwd:pwd)).debug().filterSuccessfulStatusCodes().asObservable().mapObject(loginSuccess.self)
    }
    
    // 重置密码
    func resetPassword(account:String, code:uint, pwd:String) -> Observable<Moya.Response>{
        return provider.rx.request(.updatePassword(account:account, code: code, pwd:pwd)).debug().filterSuccessfulStatusCodes().asObservable()
    }
    
    //注册新账号
    func registryAccount(account:String, code:uint, pwd:String) -> Observable<loginSuccess>{
        return provider.rx.request(.registryAccount(account:account, code:code, pwd:pwd)).debug().filterSuccessfulStatusCodes().asObservable().mapObject(loginSuccess.self)
    }
    
    
}




