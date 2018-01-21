//
//  extension+String.swift
//  internals
//
//  Created by ke.liang on 2017/12/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation


extension String {
    
    func getStringCGRect(size:CGSize, font:UIFont) -> CGRect{
    
        let constraintRect = CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)
        let sSize = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return sSize
    }
    
    
    // 分割然后拼接字符串
    func imageSubString(st:String)->String{
        
        let sp = self.components(separatedBy: st)
        let sSt = sp[sp.count - 2]
        let eSt = sp[sp.count - 1]
        
        return "/" + sSt + "/" + eSt
        
        
    }
    
}



