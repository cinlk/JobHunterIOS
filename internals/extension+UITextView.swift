//
//  extension+UITextView.swift
//  internals
//
//  Created by ke.liang on 2018/3/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



extension UITextView {
    
    
   
    // MARK:- 获取textView属性字符串,图片换成对应的表情字符串
    func getEmotionString() -> String {
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedStringKey.attachment] as? ChatEmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.text!)
            }
        }
        
        return attrMStr.string
    }
    
    // 插入富文本
    func insertEmotion(emotion: MChatEmotion) {
        // 空白
        if emotion.isEmpty {
            return
        }
        
        // 删除表情
        if emotion.isRemove {
            deleteBackward()
            return
        }
        
        // 表情
        let attachment = ChatEmotionAttachment()
        attachment.text = emotion.text
        attachment.image = UIImage(contentsOfFile: emotion.imgPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        // 图片替换
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        attributedText = attrMStr
        self.font = font
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}

