//
//  HXQLabel.swift
//  internals
//
//  Created by ke.liang on 2019/3/2.
//  Copyright © 2019 lk. All rights reserved.
//


import UIKit

class HXQLabel: UILabel {
    
    var labelTapBlock:  (() ->Void)?
    
    /// 快速创建
    convenience init(text: String = "",
                     color: UIColor = .black,
                     font: UIFont = .systemFont(ofSize: 14),
                     alignment: NSTextAlignment = .left,
                     lines: Int = 1,
                     didTap: (() ->Void)? = nil) {
        self.init()
        self.text = text
        self.font = font
        self.textAlignment = alignment
        self.textColor = color
        self.numberOfLines = lines
        self.labelTapBlock = didTap
        if didTap != nil {
            self.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LabelTap(_:)))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func LabelTap(_ tap: UIGestureRecognizer){
        labelTapBlock?()
    }
}

