//
//  ChatBarView.swift
//  internals
//
//  Created by ke.liang on 2017/10/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


// chatBarView代理
protocol ChatBarViewDelegate: class {
    
    func showEmotionKeyboard()
    func showMoreKeyboard()
    func chatBarUpdateHeight(height:CGFloat)
    // 发送富文本消息
    func chatBarSendMessage()
    
    
}

// 显示的keybaord 类型
enum ChatKeyboardType: Int {
    case voice
    case text
    case emotion
    case more
    case none
}



fileprivate let inputTextHeight:CGFloat = 35.0
fileprivate let inputTextMaxLine:CGFloat = 4

fileprivate let iconSize:CGSize = CGSize.init(width: 30, height: 30)

// 输入框view
class ChatBarView: UIView {

    
    weak var delegate: ChatBarViewDelegate?
    
    var keyboardType: ChatKeyboardType = .none
    
    
    private lazy var chatMoreButton:UIButton = { [unowned self] in
        var button = UIButton.init(type: UIButton.ButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.setImage(#imageLiteral(resourceName: "chatMore").changesize(size: CGSize.init(width: iconSize.width, height: iconSize.height)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.black
        
        button.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var chatEmotionButton:UIButton = { [unowned self] in
        var button = UIButton.init(type: UIButton.ButtonType.custom)
        // 默认是表情 输入view
        button.setImage(#imageLiteral(resourceName: "smile").changesize(size: CGSize.init(width: iconSize.width, height: iconSize.height)).withRenderingMode(.alwaysTemplate), for: .normal)
        // 选中 图片切换为文本输入keyboard
        button.setImage(#imageLiteral(resourceName: "keyboard").changesize(size: CGSize.init(width: iconSize.width, height: iconSize.height)).withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = UIColor.black
        
        button.addTarget(self, action: #selector(emotionClick(sender:)), for: .touchUpInside)
        return button
        
    }()
    
    // 输入框
    lazy var inputText:UITextView = { [unowned self] in 
        let inputV = UITextView(frame: CGRect.init(x: 5, y: 5, width: GlobalConfig.ScreenW - 60 - 10 - 10, height: 35))
        
        inputV.font = UIFont.systemFont(ofSize: 16.0)
        inputV.textColor = UIColor.black
        inputV.showsVerticalScrollIndicator = true
        inputV.returnKeyType = .send
        inputV.layer.cornerRadius = 4.0
        inputV.layer.masksToBounds = true
        inputV.layer.backgroundColor = UIColor.white.cgColor
        inputV.layer.borderWidth = 0.5
        inputV.delegate = self
        inputV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        let views:[UIView] = [backGroundImg, inputText, chatEmotionButton, chatMoreButton]
        self.sd_addSubviews(views)
        
        _  = backGroundImg.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)
        
        _ = chatMoreButton.sd_layout().rightSpaceToView(self,5)?.topSpaceToView(self,5)?.heightIs(iconSize.height)?.widthIs(iconSize.width)
        
        _ = chatEmotionButton.sd_layout().rightSpaceToView(chatMoreButton,5)?.widthIs(iconSize.width)?.topEqualToView(chatMoreButton)?.heightIs(iconSize.height)

    }
}


extension ChatBarView{
    
    
    @objc func moreClick(sender: UIButton){
        
        if keyboardType == .more{
            keyboardType = .text
            inputText.becomeFirstResponder()
            return
        }
        
        keyboardType = .more
        inputText.resignFirstResponder()
        // 显示more输入view
        delegate?.showMoreKeyboard()
        
    }
    
    @objc func emotionClick(sender: UIButton){
        
        if keyboardType == .emotion{
            keyboardType = .text
            inputText.becomeFirstResponder()
            self.chatEmotionButton.isSelected = false
            return
        }
        
        keyboardType = .emotion
        // 影藏文本键盘
        inputText.resignFirstResponder()
        delegate?.showEmotionKeyboard()
        self.chatEmotionButton.isSelected = true
        
    }
}

extension ChatBarView: UITextViewDelegate{
    
    // 显示输入框
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        keyboardType = .text
        return true
    }
    
    
   
    func textViewDidChange(_ textView: UITextView) {
        

        let height =  textView.sizeThatFits(CGSize.init(width: textView.width, height: CGFloat(textView.font!.lineHeight))).height
        
        let line = floor(height / textView.font!.lineHeight)
        
        
        
        if line > 1 && line <= inputTextMaxLine{
            
            let addHeigh = textView.font!.lineHeight*(line - 1)
            delegate?.chatBarUpdateHeight(height:  addHeigh)
            textView.frame = CGRect.init(x: 5, y: 5, width: GlobalConfig.ScreenW - 60 - 20, height: addHeigh + 35)
            
        }else if line == 1{
            delegate?.chatBarUpdateHeight(height: 0)
            textView.frame = CGRect.init(x: 5, y: 5, width: GlobalConfig.ScreenW - 60 - 20, height: 35)

        }

        textView.scrollRangeToVisible(textView.selectedRange)
        
    }
    // 发送文本消息
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            delegate?.chatBarSendMessage()
            return false
        }
        
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //self.inputText.scrollRangeToVisible(NSMakeRange(inputText.text.count, 1))
        self.textViewDidChange(inputText)
    }

    
}
