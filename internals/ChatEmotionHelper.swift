//
//  ChatEmotionHelper.swift
//  internals
//
//  Created by ke.liang on 2017/10/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class ChatEmotionHelper: NSObject {
    // MARK:- 获取表情模型数组
    class func getAllEmotions() -> [MChatEmotion] {
        var emotions: [MChatEmotion] = [MChatEmotion]()
        let plistPath = Bundle.main.path(forResource: "test", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        
        var index = 0
        for dict in array {
            emotions.append(MChatEmotion(dict: dict))
            index += 1
            if index == 23 {
                // 添加删除表情
                emotions.append(MChatEmotion(isRemove: true))
                index = 0
            }
        }
        
        // 添加空白表情
        emotions = self.addEmptyEmotion(emotiions: emotions)
        
        return emotions
    }
    
    // 添加空白表情
    fileprivate class func addEmptyEmotion(emotiions: [MChatEmotion]) -> [MChatEmotion] {
        var emos = emotiions
        let count = emos.count % 24
        if count == 0 {
            return emos
        }
        for _ in count..<23 {
            emos.append(MChatEmotion(isEmpty: true))
        }
        emos.append(MChatEmotion(isRemove: true))
        return emos
    }
    
    class func getImagePath(emotionName: String?) -> String? {
        if emotionName == nil {
            return nil
        }
        return Bundle.main.bundlePath + "/test.bundle/" + emotionName! + ".png"
    }
}
