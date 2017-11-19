//
//  loginViewModel.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


enum Result{

    case none
    case pass
    case success(account:String, password:String)
    case wrongPhoneNumber(message:String)
    case accountExist(messae:String)
    case error(message:String)
    case user(user:Users)
    
}

extension Result{
    var textColor:UIColor{
        switch self {
        case .pass:
            return UIColor.clear
        default:
            return UIColor.red
        }
    }
    var describtion:String{
        switch self {
        case let .wrongPhoneNumber(message):
            return message
        case .pass:
            return ""
        case let .error(message):
            return message
        default:
            return ""
        }
    }
    var validate:Bool{
        switch self {
        case .pass:
            return true
        default:
            return false
        }
    }
}





class loginVM{
    
    var phoneNumberText:Variable<String> = Variable.init("")
    var passowordText:Variable<String> = Variable.init("")
    
    var validatePhone:Observable<Result>?
    var validatePassword:Observable<Result>?
    
    var loginbuttonEnable:Observable<Bool>?
    
    var loginProcess:Driver<Result>
    
    
    
    
    let progressEnable: Driver<Bool>
    
    
    
    let dispose = DisposeBag.init()
    
    
    init(input: (loginTap: Driver<Void>, loginServer:loginServer)) {
        
        
        
        
        let signInIndicator = ActivityIndicator()
        progressEnable = signInIndicator.asDriver()
        
        
        validatePhone =  phoneNumberText.asObservable().flatMapLatest{ 
            phone in
            return input.loginServer.validatePhone(phone: phone).observeOn(MainScheduler.instance)
            }.share(replay: 1)
        
        validatePassword = passowordText.asObservable().flatMapLatest{
            password in
            return input.loginServer.validatePassword(password: password).observeOn(MainScheduler.instance)
            
            
        }.share(replay: 1)
        
        
    
        loginbuttonEnable = Observable.combineLatest(validatePhone!, validatePassword!, progressEnable.asObservable()){
            vphone, vpassword, progress in
            return vphone.validate && vpassword.validate && !progress
        }.distinctUntilChanged().share(replay: 1)
        

        
        
        
        let phoneAndpassword = Driver.combineLatest(phoneNumberText.asDriver(), passowordText.asDriver()){
            ($0,$1)
        }
        
        // trackActivity  如果流有消息 则为true， 没消息则为false
        loginProcess = input.loginTap.withLatestFrom(phoneAndpassword).flatMapLatest{
            phone,password in
            return input.loginServer.login(phone, password: password).trackActivity(signInIndicator).asDriver(onErrorJustReturn: .error(message: "连接服务失败"))
            
            
            

        }
        
       
        
        
        
        
        
        
        
    }
    
    
    
    
    
  
    
    
    
}






    
    
    
    

