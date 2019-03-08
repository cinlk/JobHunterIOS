//
//  HXQButton.swift
//  internals
//
//  Created by ke.liang on 2019/3/2.
//  Copyright © 2019 lk. All rights reserved.
//


import UIKit

class HXQButton: UIButton {
    
    var buttonClickBlock: ((HXQButton)->Void)?
    
    /// 快速创建UIButton
    convenience init(title: String = "",
                     color: UIColor = .black,
                     font: UIFont = UIFont.systemFont(ofSize: 14),
                     didClick:((HXQButton)->Void)? = nil) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        buttonClickBlock = didClick
        if didClick != nil {
            self.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonClick(_ item: HXQButton){
        buttonClickBlock?(item)
    }
}
