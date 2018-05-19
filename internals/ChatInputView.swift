//
//  ChatInputView.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let textContentH:CGFloat = 40

protocol ChatInputViewDelegate: class  {
    
    func changeBarHeight(textView:UITextView, height:CGFloat)
    func sendMessage(textView:UITextView)
    
    
}


class ChatInputView: UIView {

    
    
    internal var defaultText:String = ""
    
    // 默认值
    internal lazy var plashold:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        return label
        
    }()
    // 输入框
    internal lazy var chatView:UITextView = { [unowned self] in
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 20)
        text.contentMode = .left
        text.textColor = UIColor.black
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.borderWidth = 0.5
        text.layer.masksToBounds = true
        text.delegate = self
        text.layer.cornerRadius = 5.0
        text.returnKeyType = .send
        text.showsVerticalScrollIndicator = true
        
        return text
        
    }()
    // 代理
    weak var delegate:ChatInputViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(chatView)
        chatView.addSubview(plashold)
        _ = chatView.sd_layout().topSpaceToView(self,2.5)?.leftSpaceToView(self,5)?.rightSpaceToView(self,5)?.heightIs(textContentH)
        _ = plashold.sd_layout().centerYEqualToView(chatView)?.leftSpaceToView(chatView,5)?.autoHeightRatio(0)
        
        
        
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
            _ = textView.sd_layout().heightIs(textContentH)
            delegate?.changeBarHeight(textView: textView, height: 0)
            
            return
        }
        plashold.text = ""
        
        // 调整高度
        
        let size = textView.sizeThatFits(CGSize.init(width: textView.frame.width, height: CGFloat(textView.font!.lineHeight)))
        let line = floor(size.height / textView.font!.lineHeight)
       
        
        if line <= 3 && line > 1{
            let height = textView.font!.lineHeight * (line - 1)
            delegate?.changeBarHeight(textView: textView, height: height )
            _ = textView.sd_layout().heightIs(textContentH + height)
            
        }else if line > 3  {
            // 不改变frame
        }else{
            _ = textView.sd_layout().heightIs(textContentH)
            delegate?.changeBarHeight(textView: textView, height: 0)
 
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            plashold.text = defaultText
            return
        }
        plashold.text = ""
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            return
        }
        //delegate?.sendMessage(textView: textView)
        
    }
    
    
  
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.endEditing(true)
            // 恢复初始状态
            _ = textView.sd_layout().heightIs(textContentH)
            delegate?.changeBarHeight(textView: textView, height: 0)
            delegate?.sendMessage(textView: textView)
            textView.text = ""
            plashold.text = defaultText
            return false
        }
        return true
    }
    
    
    
}
