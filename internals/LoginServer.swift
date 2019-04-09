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
enum LoginManager {
    
    case getVerifyCode(phone:String)
    case resetPwdCode(phone:String)
    case quickLogin(identity:String, code:String, phone:String)
    case accontLogin(phone:String, pwd:String)
    case anonymouse
    case weixinLogin
    case weiboLogin
    case registryAccount(account:String, code:String, pwd:String)
    case updatePassword(account:String, code:String, pwd:String)
    case bindWeixin
    case binWeibo
    
    case userInfo(token:String)
    
}






extension LoginManager: TargetType{
    
    
    private var urlPrefix: String {
        return "account/"
    }
    
    var baseURL: URL{

        return URL.init(string:  GlobalConfig.BASE_URL)!
    }
    
    
    var path: String{
        
        
        switch self {
        case .binWeibo, .bindWeixin:
            return self.urlPrefix +  "link"
        case .anonymouse:
            return self.urlPrefix + "anonymouse"
        case .getVerifyCode(let account):
            return self.urlPrefix +  "code/\(account)"
        case .resetPwdCode(let phone):
            return self.urlPrefix +  "phone/\(phone)"
        case .quickLogin( _ ,  _ ,  _):
            return self.urlPrefix +  "login/code"
        case .accontLogin(_, _):
            return self.urlPrefix +  "login/pwd"
        case .updatePassword(_, _, _):
            return self.urlPrefix +  "password"
        case .registryAccount(_, _, _):
            return self.urlPrefix +  "registry/pwd"
        case .userInfo(_):
            return self.urlPrefix + "userinfo"
        default:
            return self.urlPrefix +  "login"
        }
        
    }
    
    
    var method: Moya.Method {
        switch self {
        case .getVerifyCode, .resetPwdCode:
            return Method.put
        case .quickLogin(_, _, _):
            return Method.post
        case .accontLogin(_, _):
            return Method.post
        case .updatePassword(_, _, _):
            return Method.post
        case .registryAccount(_, _, _):
            return Method.post
        default:
            return Method.get
        }
    }
    
    
    var task: Task{
        switch self {
        case  .getVerifyCode(_), .resetPwdCode(_), .userInfo(_):
            //return .requestParameters(parameters: ["phone": phone], encoding: JSONEncoding.default)
            return .requestPlain
        case  .quickLogin(let identity , let code, let phone):
            return .requestParameters(parameters: ["identity":identity,"code":code,"phone":phone], encoding: JSONEncoding.default)
        case .accontLogin(let phone, let pwd):
            return .requestParameters(parameters: ["phone":phone, "password":pwd], encoding: JSONEncoding.default)
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
        case let .getVerifyCode(name):
            return "{\"account\": \(name)}".utf8Encoded
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
        switch self {
        case .userInfo(let token):
            return ["Authorization": token]
        default:
            break
        }
        return  nil
    }
    
    
}


class LoginServer {
    
    private let disposebag = DisposeBag()
    
    lazy var  provider:MoyaProvider<LoginManager> = {
        
        let p =  MoyaProvider<LoginManager>(requestClosure: { (endpoint, closure) in
            do {
                var urlRequest = try endpoint.urlRequest()
                // 超时时间小于 验证码计时时间
                urlRequest.timeoutInterval = 30
                closure(.success(urlRequest))
                
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(MoyaError.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
            
            
        }, plugins: [NetworkLoggerPlugin(verbose: true)])
        return p
        
    }()
    
    static let shared:LoginServer = LoginServer()
    
    
    
    private init() {}
    
    
    func getVerifyCode(phone:String) -> Observable<ResponseModel<CodeSuccess>> {
        
        return provider.rx.request(.getVerifyCode(phone: phone)).debug().asObservable().mapObject(ResponseModel<CodeSuccess>.self)
        
    }
    
    // 重置密码 手机号存在 的code
    func getExistPhone(phone:String) -> Observable<ResponseModel<CodeSuccess>>{
        
        return provider.rx.request(.resetPwdCode(phone:phone)).observeOn(MainScheduler.instance).subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.default)).debug().asObservable().mapObject(ResponseModel<CodeSuccess>.self)
    }
   
    // 手机号 快捷登录(TODO)
    func loginWithCode(account:String, code: String) -> Observable<ResponseModel<LoginSuccess>>{
        
        return provider.rx.request(.quickLogin(identity: "", code: code, phone: account)).debug().asObservable().mapObject(ResponseModel<LoginSuccess>.self)
    }
    
    
    // 账号 密码登录
    func loginWithPwd(account:String, pwd:String) -> Observable<ResponseModel<LoginSuccess>>{
        return provider.rx.request(.accontLogin(phone:account, pwd:pwd)).debug().asObservable().mapObject(ResponseModel<LoginSuccess>.self)
    }
    
    // 重置密码
    func resetPassword(account:String, code: String, pwd:String) -> Observable<ResponseModel<LoginSuccess>>{
        return provider.rx.request(.updatePassword(account:account, code: code, pwd:pwd)).debug().asObservable().mapObject(ResponseModel<LoginSuccess>.self)
    }
    
    //注册新账号
    func registryAccount(account:String, code: String, pwd:String) -> Observable<ResponseModel<LoginSuccess>>{
        return provider.rx.request(.registryAccount(account:account, code:code, pwd:pwd)).debug().asObservable().mapObject(ResponseModel<LoginSuccess>.self)
    }
    
    // 匿名登录
    func anonymouseLogin() -> Observable<ResponseModel<LoginSuccess>>{
        return provider.rx.request(.anonymouse).debug().asObservable().mapObject(ResponseModel<LoginSuccess>.self)
    }
    
    // 获取用户信息
    func userInfo(token:String) -> Observable<Any>{
        return provider.rx.request(.userInfo(token: token)).asObservable().mapJSON(failsOnEmptyData: true)
    }
}




