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
        gifEmotion3.append(contentsOf: ChatEmotionHelper.getAllEmotion2(emotionName: "emotion4", type: ".gif"))
    }
    
    deinit {
        print("deinit GetChatEmotion")
        baseEmotion = []
        gifEmotion2 = []
        gifEmotion3 = []
    }
    // MARK:- 查找属性字符串的方法
    
    func findAttrStr(text: String?, font: UIFont, replace:Bool = false) -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        
        let pattern = "\\[.*?\\]" // 匹配表情
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let resutlts = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
       
        
        // 可变的
        let attrMStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : font])
        
        
        // 替换表情符文本[xxx] 为表情符model 对应的image (bundle路径)
        for (_, result) in resutlts.enumerated().reversed() {
            //[xxx]
            var emoStr = (text as NSString).substring(with: result.range)
            
            // 计算高度和宽度 把表情字符 替换为一个字符来计算 才准确
            if replace{
                
                if  let _ = findImgPath(emoStr: emoStr) {
                    emoStr = "[a]"
                    attrMStr.replaceCharacters(in: result.range, with: emoStr)
                }
              
            }else{
                
                guard let imgPath = findImgPath(emoStr: emoStr) else {
                    continue
                }
                
                // 添加图片
                let attachment = ChatEmotionAttachment()
                attachment.text = emoStr
            
                attachment.image = UIImage(contentsOfFile: imgPath)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                
                let attrImageStr = NSAttributedString(attachment: attachment)
                attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
                
                
            }
            
          
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
            
           let target  =  gifEmotion2.filter {
                if let text = $0.text, text == gifName{
                    return true
                }
                return false
            }
          
           return target.count > 0 ?  target[0].imgPath : nil
           
        case .bigGif:
            let target = gifEmotion3.filter {
                if let text = $0.text, text == gifName{
                    return true
                }
                return false
            }
            
            return target.count > 0 ? target[0].imgPath : nil
            
        default:
            return nil
        }
        

    }
    
    
}
