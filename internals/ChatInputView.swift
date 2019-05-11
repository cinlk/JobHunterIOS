//
//  ChatInputView.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let textContentH:CGFloat = GlobalConfig.toolBarH - 10
fileprivate let maxWordCount:Int = 200

protocol ChatInputViewDelegate: class  {
    
     func changeBarHeight(textView:UITextView, height:CGFloat)
     func sendMessage(textView:UITextView)
}


class ChatInputView: UIView {
    
    internal var defaultText:String = ""
    
    // 默认值
    internal lazy var plashold:UILabel = {  [unowned self] in
        let label = UILabel(frame: CGRect.init(x: 10, y:  5 + (textContentH - 25)/2, width: self.bounds.width - 40 , height: 25))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        return label
        
    }()
    // 输入框
    internal lazy var chatView:UITextView = { [unowned self] in
        let text = UITextView(frame: CGRect.init(x: 5, y: 5, width: self.bounds.width - 10, height: textContentH))
        
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = UIColor.black
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.borderWidth = 0.5
        text.layer.masksToBounds = true
        text.delegate = self
        text.layer.cornerRadius = 5.0
        text.returnKeyType = .send
        text.showsVerticalScrollIndicator = true
        text.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return text
        
    }()
    
    // 代理
    weak var delegate:ChatInputViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.addSubview(chatView)
        chatView.addSubview(plashold)
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatInputView:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        if textView.text.isEmpty{
            plashold.text = defaultText
        }else{
             plashold.text = ""
        }
       
        
        // 限制字数
        if textView.text.count > maxWordCount {
            let start = textView.text.startIndex
            let end = textView.text.index(start, offsetBy: maxWordCount)
            textView.text = String(textView.text[start..<end])
            return
        }
        
        // 调整高度
        
        let size = textView.sizeThatFits(CGSize.init(width: textView.frame.width, height: CGFloat(textView.font!.lineHeight)))
        let line = floor(size.height / textView.font!.lineHeight)
       
        
        if line <= 3 && line > 1{
            let height = textView.font!.lineHeight * (line - 1)
            delegate?.changeBarHeight(textView: textView, height: height )
            //textView.frame.size.height = textContentH + height
            textView.frame = CGRect.init(x: 5, y: 5, width: self.bounds.width - 10 , height: textContentH + height)

            
        }else if line > 3  {
            // 不改变frame
        }else{
            delegate?.changeBarHeight(textView: textView, height: 0)
            //textView.frame.size.height = textContentH
            textView.frame = CGRect.init(x: 5, y: 5, width: self.bounds.width - 10 , height: textContentH)
 
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)

    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty{
            plashold.text = defaultText
        }else{
            plashold.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.endEditing(true)
            // 恢复初始状态
            textView.frame = CGRect.init(x: 5, y: 5, width: self.bounds.width - 10, height: textContentH)
            delegate?.changeBarHeight(textView: textView, height: 0)
            delegate?.sendMessage(textView: textView)
            textView.text = ""
            plashold.text = defaultText
            
            return false
        }
        return true
    }
    
    
    
}
