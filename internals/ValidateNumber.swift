//
//  ValidateNumber.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxSwift


fileprivate var count =  10

class ValidateNumber {
    
    weak var b:UIButton?
    var obCount:BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    private var end:PublishSubject<Bool> = PublishSubject<Bool>.init()
    init?(button:UIButton?){
        guard let bt = button else{
            return nil
        }
        b =  bt
        self.b?.backgroundColor = UIColor.clear
        self.b?.setTitleColor(UIColor.blue, for: .normal)
        
    }
    
    
    
    func start(){
        
        obCount.onNext(false)
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).debug().takeUntil(end).takeWhile({ (i) -> Bool in
            i <= count
        }).subscribe(onNext: { i in
            
            if i == count{
                self.b?.setTitle("获取验证码", for: .normal)
                self.b?.setTitleColor(UIColor.blue, for: .normal)
                
                self.obCount.onNext(true)
            }else{
                self.b?.setTitle("重新获取(\(count - i))", for: .normal)
                self.b?.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
            
        })
    }
    
    func stop(){
        
        end.onNext(false)
        self.b?.setTitle("获取验证码", for: .normal)
        self.b?.setTitleColor(UIColor.blue, for: .normal)
        //self.obCount.value = true
        obCount.onNext(true)
    }
    
}
