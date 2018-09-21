//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ValidateNumber {
    
    weak var b:UIButton?
    
    var remainSeconds = 0{
        willSet{
            self.b?.setTitle("重新获取(\(newValue))", for: .normal)
            self.b?.setTitleColor(UIColor.lightGray, for: .normal)
            if newValue <= 0 {
                self.b?.setTitle("获取验证码", for: .normal)
                isCounting = false
                self.b?.setTitleColor(UIColor.blue, for: .normal)
            }
        }
        
        
    }
    
    
    var coundDown:Timer?
  
    
    var obCount:Variable<Bool> = Variable<Bool>(true)
    
    var isCounting = false{
        willSet{
            if newValue{
                coundDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counttime), userInfo: nil, repeats: true)
                remainSeconds = 10
                RunLoop.main.add(coundDown!, forMode: RunLoop.Mode.common)
                self.b?.backgroundColor = UIColor.clear
                obCount.value = false
            }
                
            else{
                coundDown?.invalidate()
                coundDown = nil
                self.b?.backgroundColor = UIColor.clear
                obCount.value = true
            }
            
            //self.b?.isEnabled = !newValue
            
            
        }
        
    }
    
    
    init?(button:UIButton?){
        guard let bt = button else{
            return nil
        }
        b =  bt
    }
    
    
    @objc private func  counttime(){
        remainSeconds -= 1
    }
    
    func start(){
       
        
        self.isCounting = true
    }
    
    func stop(){
        self.remainSeconds = 0
    }
    
}
