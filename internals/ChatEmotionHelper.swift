//
//  ChatEmotionHelper.swift
//  internals
//
//  Created by ke.liang on 2017/10/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class ChatEmotionHelper: NSObject {
    
    
    // 占时存储 emotion images
    
   
    
    // MARK:- 获取表情模型数组
    class func getAllEmotions() -> [MChatEmotion] {
        
        var emotions: [MChatEmotion] = [MChatEmotion]()
        
        //
        let plistPath = Bundle.main.path(forResource: "test", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        
        var index = 0
        for dict in array {
            
            let item  = MChatEmotion(dict: dict,bundle:"test.bundle",type:".png")
           
            emotions.append(item)
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
        //MARK
        return Bundle.main.bundlePath + "/test.bundle/" + emotionName! + ".png"
    }
    
    // emotion2
    class func getAllEmotion2(emotionName:String, type:String)-> [MChatEmotion]{
        
        
        var emotions: [MChatEmotion] = [MChatEmotion]()
        let plistPath = Bundle.main.path(forResource: emotionName, ofType: "plist")
        
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        for dict in array{
            
            let bundle = emotionName+".bundle"
            let item  = MChatEmotion(dict: dict, bundle:bundle, type:type)
            emotions.append(item)
            
        }
        return emotions
        
    }
    
    // get reply messages
    class func getAllReplyMessages(fileName:String) -> [String]{
        var res:[String] = []
        let plistPath = Bundle.main.path(forResource: fileName, ofType: "plist")
        let array = NSArray.init(contentsOfFile: plistPath!) as! [String]
        
        for str in array{
            res.append(str)
        }
        
        return res
    }
    
}
