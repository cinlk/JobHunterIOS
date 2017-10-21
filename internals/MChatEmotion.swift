//
//  MChatEmotion.swift
//  internals
//
//  Created by ke.liang on 2017/10/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class MChatEmotion: NSObject {
    // MARK:- 定义属性
    var image: String? {   // 表情对应的图片名称
        didSet {
            imgPath = Bundle.main.bundlePath + "/test.bundle/" + image! + ".png"
        }
    }
    var text: String?     // 表情对应的文字
    
    // MARK:- 数据处理
    var imgPath: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dict: [String : String]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    init(isRemove: Bool) {
        self.isRemove = (isRemove)
    }
    init(isEmpty: Bool) {
        self.isEmpty = (isEmpty)
    }
}
