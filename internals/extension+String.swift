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
    
}
