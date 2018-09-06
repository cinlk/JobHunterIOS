//
//  accountLogin.swift
//  internals
//
//  Created by ke.liang on 2018/9/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift





class AccountLoginViewModel {
    
    
    private var server:LoginServer = LoginServer.shared
    
    init() {
        
        
    }
    
    func passwordLogin(accont:String, pwd:String) -> Observable<loginSuccess>{
        
       return server.loginWithPwd(account: accont, pwd: pwd)
    }
    
    
}
