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
fileprivate let inputTextMaxHeight:CGFloat = 70.0
fileprivate let iconSize:CGSize = CGSize.init(width: 40, height: 35)

// 输入框view
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
        // 默认是表情 输入view
        button.setBackgroundImage(#imageLiteral(resourceName: "smile"), for: .normal)
        // 选中 图片切换为文本输入keyboard
        button.setBackgroundImage(#imageLiteral(resourceName: "keyboard"), for: .selected)
        
        button.addTarget(self, action: #selector(emotionClick(sender:)), for: .touchUpInside)
        return button
        
    }()
    
    // 输入框
    lazy var inputText:UITextView = {
        let inputV = UITextView()
        
        inputV.font = UIFont.systemFont(ofSize: 16.0)
        inputV.textColor = UIColor.black
        inputV.returnKeyType = .send
        inputV.layer.cornerRadius = 4.0
        inputV.layer.masksToBounds = true
        inputV.layer.backgroundColor = UIColor.white.cgColor
        inputV.layer.borderWidth = 0.5
        inputV.delegate = self
        // KVO 观察 atributeText 属性改变
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
        
        
        _ = inputText.sd_layout().leftSpaceToView(self,5)?.topSpaceToView(self,5)?.heightRatioToView(self,35/45)?.rightSpaceToView(chatEmotionButton,5)
    
        
    }
}


extension ChatBarView{
    
    
    @objc func moreClick(sender: UIButton){
        // 切换 view
        switch keyboardType {
        // 再次点击more 按钮 显示键盘
        case .more:
            keyboardType = .text
            inputText.becomeFirstResponder()
            return
        // 已经是键盘则影藏键盘
        case .text:
            break
            
        default:
            break
        }
        
        keyboardType = .more
        inputText.resignFirstResponder()
        // 显示more输入view
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
            break
        default:
            break
        }
        
        keyboardType = .emotion
        // 影藏文本键盘
        inputText.resignFirstResponder()
        // 在线上emotion 输入view
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
        
        
        var height =  textView.sizeThatFits(CGSize.init(width: textView.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
       
        height = height > inputTextHeight ? height : inputTextHeight
        
        height = height < inputTextMaxHeight ? height : inputTextMaxHeight
        
       
        let currentHeight = height + 10
        // 只调整输入框高度
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
        // 滚动到最底层
        self.inputText.scrollRangeToVisible(NSMakeRange(inputText.text.count, 1))
        self.textViewDidChange(inputText)
        
    }
}
