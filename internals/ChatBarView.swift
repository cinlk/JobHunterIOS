//
//  ChatBarView.swift
//  internals
//
//  Created by ke.liang on 2017/10/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


// 显示对应的键盘
protocol ChatBarViewDelegate: NSObjectProtocol {
    func showTextKeyboard()
    func showVoice()
    func showEmotionKeyboard()
    func showMoreKeyboard()
    func chatBarUpdateHeight(height:CGFloat)
    func chatBarSendMessage()
    //
    func hiddens()
    
    
}

enum ChatKeyboardType: Int {
    case voice
    case text
    case emotion
    case more
    case none
}


class ChatBarView: UIView {

   
//    var chatInputView:InputTextView?
    
//    var chatEmotionView: ChatEmotionView?
//    var chatMoreView: ChatMoreView?
    
    weak var delegate: ChatBarViewDelegate?
    
    var keyboardType: ChatKeyboardType = .none
    // chatbar height
    var inputTextViewCurHeight:CGFloat = 45
    
    
    lazy var chatVoidButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "voice"), for: .normal)
        button.addTarget(self, action: #selector(voiceClick(sender:)), for: .touchUpInside)
        
        return button
        
    }()
    
    lazy var chatMoreButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
        return button
        
    }()
    
    lazy var chatEmotionButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "smileEmotion"), for: .normal)
        button.addTarget(self, action: #selector(emotionClick(sender:)), for: .touchUpInside)
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
        inputV.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
        return inputV
    }()
    
    
    override init(frame: CGRect) {
        
 //       chatInputView =  InputTextView()
//        chatMoreView  = ChatMoreView()
//        chatEmotionView = ChatEmotionView()
        super.init(frame: frame)

        let backImage = UIImageView.init()
        backImage.image = #imageLiteral(resourceName: "b3")
        self.addSubview(backImage)
        
        self.addSubview(chatVoidButton)
        self.addSubview(inputText)
        self.addSubview(chatEmotionButton)
        self.addSubview(chatMoreButton)
        
        
 //       self.addSubview(chatInputView!)
//        self.addSubview(chatMoreView!)
//        self.addSubview(chatEmotionView!)
        
//        _  = chatInputView?.sd_layout().leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(50)
        
//        _  = chatMoreView?.sd_layout().leftEqualToView(self)?.topSpaceToView(chatInputView,0)?.rightEqualToView(self)?.bottomEqualToView(self)
//
//        _  = chatEmotionView?.sd_layout().leftEqualToView(self)?.topSpaceToView(chatInputView,0)?.rightEqualToView(self)?.bottomEqualToView(self)
//
        _  = backImage.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)
        
        _ = chatVoidButton.sd_layout().leftSpaceToView(self,5)?.topSpaceToView(self,5)?.heightIs(35)?.widthIs(45)
        _ = inputText.sd_layout().leftSpaceToView(chatVoidButton,0)?.topEqualToView(chatVoidButton)?.bottomSpaceToView(self,5)?.widthIs(170)
        
        _ = chatEmotionButton.sd_layout().leftSpaceToView(inputText,5)?.topEqualToView(chatVoidButton)?.bottomEqualToView(chatVoidButton)?.widthIs(45)
        
        _ = chatMoreButton.sd_layout().leftSpaceToView(chatEmotionButton,5)?.topEqualToView(chatVoidButton)?.bottomEqualToView(chatVoidButton)?.widthIs(45)
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        inputText.removeObserver(self, forKeyPath: "attributedText")
    }
    
}


extension ChatBarView{
    func voiceClick(sender:UIButton){
        
    }
    func moreClick(sender: UIButton){
        
        if keyboardType == .more{
            keyboardType = .text
            inputText.becomeFirstResponder()
        }else{
            if keyboardType == .voice{
                
            }else if keyboardType == .text{
                //inputText.resignFirstResponder()
                delegate?.hiddens()
            }
            keyboardType = .more
            inputText.resignFirstResponder()
            delegate?.showMoreKeyboard()
            
        }
        
    }
    func emotionClick(sender: UIButton){
        print("emotion keyboard show!")
        
        if keyboardType == .emotion{
            //切换到 text
            keyboardType = .text
            inputText.becomeFirstResponder()
        }else{
            if keyboardType == .text{
                //inputText.resignFirstResponder()
                delegate?.hiddens()
                
            }else if keyboardType == .voice{
                // MARK
            }
            
            keyboardType = .emotion
            inputText.resignFirstResponder()
            
            
            // 代理显示
            delegate?.showEmotionKeyboard()
            
            
            
        }
    }
}

extension ChatBarView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        keyboardType = .text
        delegate?.showTextKeyboard()
    }
    // 改变输入框
    func textViewDidChange(_ textView: UITextView) {
        
        let normalheight:CGFloat = 35.0
        let maxheight:CGFloat = 80.0
        
        var height =  textView.sizeThatFits(CGSize.init(width: textView.width, height: CGFloat(FLT_MAX))).height
        height =  height > normalheight ? height : normalheight
        height = height < maxheight ? height : maxheight
        
        inputTextViewCurHeight  = height + 10
        if inputTextViewCurHeight != textView.height{
           delegate?.chatBarUpdateHeight(height: inputTextViewCurHeight)
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            delegate?.chatBarSendMessage()
            return false
        }
        
        
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.inputText.scrollRangeToVisible(NSMakeRange(inputText.text.characters.count, 1))
        self.textViewDidChange(inputText)
        
    }
}
