//
//  ChatBarView.swift
//  internals
//
//  Created by ke.liang on 2017/10/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


// 显示对应的键盘
protocol ChatBarViewDelegate: class {
    
    func showTextKeyboard()
    func showEmotionKeyboard()
    func showMoreKeyboard()
    func chatBarUpdateHeight(height:CGFloat)
    func chatBarSendMessage()
    func hiddens()
    
}

enum ChatKeyboardType: Int {
    case voice
    case text
    case emotion
    case more
    case none
}



fileprivate let inputTextHeight:CGFloat = 35.0
fileprivate let inputTextMaxHeight:CGFloat = 70.0

class ChatBarView: UIView {

    
    weak var delegate: ChatBarViewDelegate?
    
    var keyboardType: ChatKeyboardType = .none
    
    
    private lazy var chatMoreButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "chatMore"), for: .normal)
        button.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var chatEmotionButton:UIButton = {
        var button = UIButton.init(type: UIButtonType.custom)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "smile"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "keyboard"), for: .selected)
        
        button.addTarget(self, action: #selector(emotionClick(sender:)), for: .touchUpInside)
        return button
        
    }()
    
    // 输入框
    open lazy var inputText:UITextView = {
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
    
    private lazy var backGroundImg:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.image = #imageLiteral(resourceName: "b3")
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        inputText.removeObserver(self, forKeyPath: "attributedText")
    }
    
}


extension ChatBarView{
    
    private func setViews(){
        
        self.addSubview(backGroundImg)
        
        self.addSubview(inputText)
        self.addSubview(chatEmotionButton)
        self.addSubview(chatMoreButton)
        
        
        _  = backGroundImg.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)
        
        _ = chatMoreButton.sd_layout().rightSpaceToView(self,5)?.topSpaceToView(self,5)?.heightIs(35)?.widthIs(40)
        _ = chatEmotionButton.sd_layout().rightSpaceToView(chatMoreButton,5)?.topEqualToView(chatMoreButton)?.bottomEqualToView(chatMoreButton)?.widthIs(40)
        
        _ = inputText.sd_layout().leftSpaceToView(self,5)?.topSpaceToView(self,5)?.bottomSpaceToView(self,5)?.rightSpaceToView(chatEmotionButton,5)
    
        
    }
}


extension ChatBarView{
    
   
    @objc func moreClick(sender: UIButton){
        
        
        switch keyboardType {
        case .more:
            keyboardType = .text
            inputText.becomeFirstResponder()
            return
        case .text:
            delegate?.hiddens()
        default:
            break
        }
        
        keyboardType = .more
        inputText.resignFirstResponder()
        delegate?.showMoreKeyboard()
        
    }
    
    @objc func emotionClick(sender: UIButton){
        
        switch keyboardType {
        case .emotion:
            keyboardType = .text
            inputText.becomeFirstResponder()
            self.chatEmotionButton.isSelected = false
            return
        case .text:
            delegate?.hiddens()
        default:
            break
        }
        
        keyboardType = .emotion
        inputText.resignFirstResponder()
        delegate?.showEmotionKeyboard()
        self.chatEmotionButton.isSelected = true
        
    }
}

extension ChatBarView: UITextViewDelegate{
    
    // 显示输入框
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        keyboardType = .text
        delegate?.showTextKeyboard()
    }
    
    // 调整输入框高度
    func textViewDidChange(_ textView: UITextView) {
        
       
        
        var height =  textView.sizeThatFits(CGSize.init(width: textView.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
       
        height =  height > inputTextHeight ? height : inputTextHeight
        height = height < inputTextMaxHeight ? height : inputTextMaxHeight
        
       
        let currentHeight = height + 5 + 5
        if currentHeight >= ChatInputBarH{
           delegate?.chatBarUpdateHeight(height: currentHeight)
        }
        
    }
    // 发送文本消息
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            delegate?.chatBarSendMessage()
            return false
        }
        return true
    }
    // 监听text高度变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.inputText.scrollRangeToVisible(NSMakeRange(inputText.text.count, 1))
        self.textViewDidChange(inputText)
        
    }
}
