//
//  extension+button.swift
//  internals
//
//  Created by ke.liang on 2017/12/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


extension UIButton {
    
    convenience init(title:(name:String, type:UIControlState), fontSize:CGFloat = 10, alignment: NSTextAlignment = .left, bColor:UIColor = UIColor.clear) {
        self.init(type: .custom)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.titleLabel?.textAlignment = alignment
        self.backgroundColor = bColor
        self.setTitle(title.0, for: title.1)
    }
    
    
}
