//
//  extension+String.swift
//  internals
//
//  Created by ke.liang on 2017/12/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation




extension String {
    
//    func getStringCGRect(size:CGSize, font:UIFont) -> CGRect{
//
//        let constraintRect = CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)
//        let sSize = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        return sSize
//    }
    
    func rect(withFont font: UIFont, size: CGSize) -> CGRect {
        return (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    }
    /// 根据固定的size和font计算文字的height
    func height(withFont font: UIFont, size: CGSize) -> CGFloat {
        return self.rect(withFont: font, size: size).height
    }
    /// 根据固定的size和font计算文字的width
    func width(withFont font: UIFont, size: CGSize) -> CGFloat {
        return self.rect(withFont: font, size: size).width
    }
    
    
    // 分割然后拼接字符串
    func imageSubString(st:String)->String{
        
        let sp = self.components(separatedBy: st)
        let sSt = sp[sp.count - 2]
        let eSt = sp[sp.count - 1]
        
        return "/" + sSt + "/" + eSt
        
        
    }
    
    
    func getTimeInterval(format:String) -> TimeInterval{
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .short
        dateFormat.dateFormat = format
        if let date =  dateFormat.date(from: self){
            return date.timeIntervalSince1970
        }
        return 0
    }
    
    
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data =  self.data(using: String.Encoding.unicode, allowLossyConversion: true) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    

    var urlEscaped: String{
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data{
        return data(using: .utf8)!
    }
}










