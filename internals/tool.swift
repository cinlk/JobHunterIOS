//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



class ValidateNumber {
    
    var b:UIButton?
    
    var remainSeconds = 0{
        willSet{
            self.b?.setTitle("\(newValue)后重新获取", for: .normal)
            
            if newValue <= 0 {
                self.b?.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
        
        
    }
    
    
    var coundDown:Timer?
    
    var isCounting = false{
        willSet{
            if newValue{
                coundDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counttime), userInfo: nil, repeats: true)
                remainSeconds = 10
                self.b?.backgroundColor = UIColor.clear
            }
                
            else{
                coundDown?.invalidate()
                coundDown = nil
                self.b?.backgroundColor = UIColor.clear
            }
            self.b?.isEnabled = !newValue
            
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
}
