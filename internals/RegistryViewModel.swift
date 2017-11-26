//
//  RegistryViewModel.swift
//  internals
//
//  Created by ke.liang on 2017/11/20.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift




class RegistryViewModel{
    
    
    
    var phoneTextStr:Variable<String> = Variable<String>.init("")
    var verifyCodeStr:Variable<String> = Variable<String>.init("")
    var passwordStr:Variable<String> = Variable<String>.init("")
    
    var validatePhone:Driver<Result>
    var validateCode:Driver<Result>
    var validatePassword:Driver<Result>
    
    
    var registryEnable:Driver<Bool>
    var registeyResult:Driver<myResponse>
    var progress:Driver<Bool>
    
    let disposebag = DisposeBag()
    
    init(input: (phoneText:Driver<String?>,tap:Driver<Void>,
        request:RegistryServer)) {
        
        // 观察事件是否还有
        let signInIndicator = ActivityIndicator()
        progress = signInIndicator.asDriver()
        
        self.validatePhone = phoneTextStr.asDriver().flatMapLatest{
            number in
            return (input.request.validatePhone(phone: number).asDriver(onErrorJustReturn: .error(message: "验证错误")))
        }
        
        self.validateCode = verifyCodeStr.asDriver().flatMapLatest{
            number in
            return (input.request.validateVerifyCode(verifyCode: number).asDriver(onErrorJustReturn: .error(message: "验证码错误")))
        }
        
        self.validatePassword = passwordStr.asDriver().flatMapLatest{
            password in
            return (input.request.validatePassword(password:password).asDriver(onErrorJustReturn: .error(message: "密码错误")))
        }
        
        registryEnable = Driver.combineLatest(validatePhone.asDriver(), validateCode.asDriver(), validatePassword.asDriver()){
            (phone,code,password) in
            
            return phone.validate && code.validate && password.validate
        }.distinctUntilChanged()
        
        // parameters
        let alls = Driver.combineLatest(phoneTextStr.asDriver(), verifyCodeStr.asDriver(),passwordStr.asDriver()){
             phone,code,password in
             (phone,code,password)
        }
        
        //tap  swift4 显示闭包类型
      registeyResult =   input.tap.withLatestFrom(alls.asDriver()).flatMapLatest { (arg) -> Driver<myResponse> in
            let (phone, code, password) = arg
        
        return input.request.registry(phone: phone, verifyCode: code, password: password).trackActivity(signInIndicator).asDriver(onErrorJustReturn: myResponse.error(code:-1, message: "server error"))
        
        }
        
    }
    
    
   
    
    
    
    
}
