//
//  MChatEmotion.swift
//  internals
//
//  Created by ke.liang on 2017/10/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers class MChatEmotion: NSObject {
    // MARK:- 定义属性
    
     dynamic var image: String? {   // 表情对应的图片名称
        
        didSet {
            imgPath = Bundle.main.bundlePath + "/"+bundle+"/" + image! + imageType
            storeImg = "/"+bundle+"/" + image! + imageType
        }
    }
    dynamic var text: String?     // 表情对应的文字
    
    // MARK:- 数据处理
    var imgPath: String?
    var storeImg:String?
    
    var isRemove: Bool = false
    var isEmpty: Bool = false
    // ".bundle"
    var bundle: String = ""
    // ".xxx"
    var imageType: String = ""
    
    override init() {
        super.init()
    }
    
    convenience init(dict: [String : String],bundle:String,type:String) {
        self.init()
        self.bundle = bundle
        self.imageType = type
        
        setValuesForKeys(dict)
    }
    
    init(isRemove: Bool) {
        self.isRemove = (isRemove)
    }
    init(isEmpty: Bool) {
        self.isEmpty = (isEmpty)
    }
}
