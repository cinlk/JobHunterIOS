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
    
    
    private var baseEmotion:[MChatEmotion] = []
    private var gifEmotion2:[MChatEmotion] = []
    private var gifEmotion3:[MChatEmotion] = []
    
    
    private override init() {
        baseEmotion = ChatEmotionHelper.getAllEmotions()
        gifEmotion2 = ChatEmotionHelper.getAllEmotion2(emotionName: "emotion2", type: ".gif")
        gifEmotion3 = ChatEmotionHelper.getAllEmotion2(emotionName: "emotion3", type: ".gif")
    }
    // MARK:- 查找属性字符串的方法
    func findAttrStr(text: String?, font: UIFont) -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        
        let pattern = "\\[.*?\\]" // 匹配表情
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let resutlts = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        // 可变的
        let attrMStr = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font : font])
        
        
        // 替换表情符文本[xxx] 为表情符model 对应的image (bundle路径)
        for (_, result) in resutlts.enumerated().reversed() {
            //[xxx]
            let emoStr = (text as NSString).substring(with: result.range)
            guard let imgPath = findImgPath(emoStr: emoStr) else {
                return nil
            }
            // 添加图片
            let attachment = ChatEmotionAttachment()
            attachment.text = emoStr
            attachment.image = UIImage(contentsOfFile: imgPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
            
        }
        return attrMStr
    }
    
    private func findImgPath(emoStr: String) -> String? {
        // 空 image 去掉
        for emotion in baseEmotion {
            if  let  text = emotion.text, text == emoStr {
                return emotion.imgPath
            }
        }
        return nil
    }
    
    // 查找gif image 路径
    func findGifImage(gifName:String, type: MessgeType)->String?{
        switch type {
        case .smallGif:
            for gif in gifEmotion2{
                if let text = gif.text, text == gifName{
                    return gif.imgPath
                }
            }
            return nil
        case .bigGif:
            for gif in gifEmotion3{
                if let text = gif.text, text == gifName{
                    return gif.imgPath
                }
            }
            return nil
        default:
            break
        }
        
    
        return nil
    }
    
    
}
