//
//  extension+UITextView.swift
//  internals
//
//  Created by ke.liang on 2018/3/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



extension UITextView {
    
    
    class func sizeOfString(string:NSString,font:UIFont,maxWidth:CGFloat)->CGSize{
        
        let size = string.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil).size
        // 与边框的距离
        return CGSize.init(width: size.width, height: size.height)
        
    }
    
    
    
   
    // MARK:- 获取textView属性字符串,图片换成对应的表情字符串
    func getEmotionString() -> String {
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key.attachment] as? ChatEmotionAttachment {
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
        
        // 这里改变字体大小（默认是12）
       
        self.font = font
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        // 设置attrs 的font 大小  段落格式 不自动换行
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        
        
        attrMStr.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange.init(location: 0, length: attrMStr.length))

        attributedText = attrMStr
        
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        
    }
}

