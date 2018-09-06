//
//  quickLogin.swift
//  internals
//
//  Created by ke.liang on 2018/9/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

class QuickLoginViewModel{
    
    private var dispose:DisposeBag = DisposeBag()
    
    // server handler
    var server = LoginServer.shared
    
    
    init() {}
    
    
    func sendCode(phone:String) -> Observable<CodeSuccess>{
        
        return server.getVerifyCode(account: phone, type: "phone")
    }
    
    func sendAccountCode(account:String, type:String) -> Observable<CodeSuccess>{
        return server.getVerifyCode(account:account, type: type)
    }
    
    func quickLogin(phone:String, code:String) -> Observable<loginSuccess>{
        if let code = uint(code){
            return server.loginWithCode(account: phone, code: code)

        }
        return  Observable<loginSuccess>.error(RxError.noElements)
    }
    
    
    
    func resetPassword(account:String, code:String, pwd:String) -> Observable<Moya.Response>{
        if let code = uint(code){
            return server.resetPassword(account: account, code: code, pwd: pwd)
        }
        return Observable<Moya.Response>.error(RxError.noElements)
    }
    
    
    func registryAccount(account:String, code:String, pwd:String) -> Observable<loginSuccess>{
        if let code = uint(code){
            return server.registryAccount(account: account, code: code, pwd: pwd)
        }
        return Observable<loginSuccess>.error(RxError.noElements)
    }
    
    
}
