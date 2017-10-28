//
//  InputTextView.swift
//  internals
//
//  Created by ke.liang on 2017/10/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class InputTextView: UIView {

    
    lazy var chatVoidButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "voice"), for: .normal)
        
        return button
        
    }()
    
    lazy var chatMoreButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "plus"), for: .normal)
        
        return button
        
    }()
    
    lazy var chatEmotionButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "smileEmotion"), for: .normal)
        
        return button
        
    }()
    
    // 输入框
    lazy var inputText:UITextView = {
        let inputV = UITextView()
        inputV.font = UIFont.systemFont(ofSize: 15.0)
        inputV.textColor = UIColor.black
        inputV.returnKeyType = .send
        inputV.layer.cornerRadius = 4.0
        inputV.layer.masksToBounds = true
        inputV.layer.backgroundColor = UIColor.white.cgColor
        inputV.layer.borderWidth = 0.5
        inputV.delegate = self
        inputV.showsVerticalScrollIndicator = false
        inputV.showsHorizontalScrollIndicator = false
        
        inputV.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
        return inputV
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.addSubview(chatVoidButton)
        self.addSubview(inputText)
        self.addSubview(chatEmotionButton)
        self.addSubview(chatMoreButton)
        
        
        _ = chatVoidButton.sd_layout().leftSpaceToView(self,5)?.topEqualToView(self)?.bottomEqualToView(self)?.widthIs(45)
        
        _ = inputText.sd_layout().leftSpaceToView(chatVoidButton,0)?.topEqualToView(self)?.bottomEqualToView(self)?.widthIs(170)
        
        _  = chatEmotionButton.sd_layout().leftSpaceToView(inputText,0)?.topEqualToView(self)?.bottomEqualToView(self)?.widthIs(45)
        _  = chatMoreButton.sd_layout().leftSpaceToView(chatEmotionButton,5)?.topEqualToView(chatEmotionButton)?.bottomEqualToView(chatEmotionButton)?.widthIs(45)
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.inputText.removeObserver(self, forKeyPath: "attributedText")
    }
}


extension InputTextView: UITextViewDelegate{
    
}
