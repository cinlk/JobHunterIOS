
//
//  ForgetPasswordModeView.swift
//  internals
//
//  Created by ke.liang on 2017/11/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift






class ChangePasswordVM {
    
    
    
    var  phoneText:Variable<String> = Variable<String>.init("")
    var  verifyCode:Variable<String> = Variable<String>.init("")
    var  newPassword:Variable<String> = Variable<String>.init("")
    var  confirmPassword:Variable<String> = Variable<String>.init("")
    
    
    var  validatePhone:Observable<Result>
    var  validatePassword:Observable<Result>
    var  equalPassword:Observable<Bool>
    
    var showProgress:Driver<Bool>
    
    var submitEnable:Driver<Bool>
    var submitResult:Driver<myResponse>
    
    
    let disposebag = DisposeBag.init()
    
    
    init(input:(tap:Driver<Void>,request:ChangePasswordService)) {
        
        
        let signInIndicator = ActivityIndicator()
        showProgress = signInIndicator.asDriver()
        
    
        validatePhone = phoneText.asObservable().flatMapLatest{
            phone in
            return input.request.validatePhone(phone: phone).observeOn(MainScheduler.instance)
        }.share(replay: 1)
        
        validatePassword = newPassword.asObservable().flatMapLatest{
            password in
            return input.request.validatePassword(password: password).observeOn(MainScheduler.instance)
        }.share(replay: 1)
        
        
        equalPassword = Observable.combineLatest(newPassword.asObservable(), confirmPassword.asObservable()){
            p1,p2 in
            return p1 == p2
        }.observeOn(MainScheduler.instance).debug()
        
        
        
        
        submitEnable = Observable.combineLatest(validatePhone, validatePassword, equalPassword){
            phone,password,equals in
             return phone.validate && password.validate && equals
        }.asDriver(onErrorJustReturn: true).distinctUntilChanged()
        
        
        
        
        
        let alls = Driver.combineLatest(phoneText.asDriver(), verifyCode.asDriver(), newPassword.asDriver()){
          return ($0,$1,$2)
        }.asDriver().debug()
        
        
        submitResult  = input.tap.withLatestFrom(alls.asDriver()).flatMapLatest{
            (arg) -> Driver<myResponse> in
        
            let (phone, code, password) = arg
            return input.request.submitNewPassword(phone: phone, code: code, password: password).trackActivity(signInIndicator).asDriver(onErrorJustReturn: .error(code: 404, message: "错误"))
        }.debug()
        
    }
    
    
    
}
