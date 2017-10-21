//
//  GetChatEmotion.swift
//  internals
//
//  Created by ke.liang on 2017/10/22.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class GetChatEmotion: NSObject {
    static let shared: GetChatEmotion = GetChatEmotion()
    
    // MARK:- 查找属性字符串的方法
    func findAttrStr(text: String?, font: UIFont) -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        
        let pattern = "\\[.*?\\]" // 匹配表情
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let resutlts = regex.matches(in: text, options: [], range: NSMakeRange(0, text.characters.count))
        
        //        let attrMStr = NSMutableAttributedString(string: text)
        let attrMStr = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName : font])
        
        
        for (_, result) in resutlts.enumerated().reversed() {
            let emoStr = (text as NSString).substring(with: result.range)
            guard let imgPath = findImgPath(emoStr: emoStr) else {
                return nil
            }
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: imgPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        return attrMStr
    }
    
    func findImgPath(emoStr: String) -> String? {
        for emotion in ChatEmotionHelper.getAllEmotions() {
            if emotion.text! == emoStr {
                return emotion.imgPath
            }
        }
        return nil
    }
}
