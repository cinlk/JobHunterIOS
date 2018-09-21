//
//  extension+UIlabel.swift
//  internals
//
//  Created by ke.liang on 2018/3/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


// 计算lable 文本高度和宽度
extension UILabel{
    class func sizeOfString(string:NSString,font:UIFont,maxWidth:CGFloat)->CGSize{
        
        let size = string.boundingRect(with: CGSize.init(width: maxWidth, height: 1200), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil).size
        // 与边框的距离
        return CGSize.init(width: size.width, height: size.height)
        
    }
    
    // 获取emotion富文本字符
    func getEmotionString() -> String {
        guard let attributedText = attributedText else { return "" }
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key.attachment] as? ChatEmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.text!)
            }
        }
        
        return attrMStr.string
    }
}

