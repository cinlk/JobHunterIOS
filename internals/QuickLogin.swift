//
//  QuickLogin.swift
//  internals
//
//  Created by ke.liang on 2018/9/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

class LoginViewModel{
    
    private var dispose:DisposeBag = DisposeBag()
    
    // server handler
    private var server = LoginServer.shared
    
    // 发送验证码中
    
    // 登录中
    let loginIn: Driver<Bool>
    let activityIndicator = ActivityIndicator()
    
    init() {
        
        self.loginIn = activityIndicator.asDriver()
    }
    
    
    func sendCode(phone:String, _ resetPwd:Bool = false) -> Observable<ResponseModel<CodeSuccess>>{
        if resetPwd{
            return server.getExistPhone(phone: phone)
        }
       // debug().asd  .filterSuccessfulStatusCodes().asObservable().mapObject(CodeSuccess.self)
        return server.getVerifyCode(phone: phone)
    }
    
    
    func sendAccountCode(account:String, type:String) -> Observable<ResponseModel<CodeSuccess>>{
        return server.getVerifyCode(phone: account)
    }
    
    func quickLogin(phone:String, code:String) -> Observable<ResponseModel<LoginSuccess>>{
        
        return server.loginWithCode(account: phone, code: code).trackActivity(activityIndicator)
        
    }
    
    func passwordLogin(accont:String, pwd:String) -> Observable<ResponseModel<LoginSuccess>>{
        
        return server.loginWithPwd(account: accont, pwd: pwd).trackActivity(activityIndicator)
    }
    
    
    
    
    func resetPassword(account:String, code:String, pwd:String) -> Observable<ResponseModel<LoginSuccess>>{
        
        return server.resetPassword(account: account, code: code, pwd: pwd).trackActivity(activityIndicator)
        
    }
    
    
    func registryAccount(account:String, code:String, pwd:String) -> Observable<ResponseModel<LoginSuccess>>{
        
        return server.registryAccount(account: account, code: code, pwd: pwd).trackActivity(activityIndicator)
        
    }
    
    
    func anonymouseLogin() -> Observable<ResponseModel<LoginSuccess>>{
        return server.anonymouseLogin()
    }
    
    
    func getUserInfo(token:String) -> Observable<Any> {
        return server.userInfo(token:token)
    }
    
}
