//
//  TextAndPhontoCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let btnSizeWidth:CGFloat = 80
fileprivate let maxWords:Int = 500

protocol TextAndPhontoCellDelegate: class {
    func getTextContent(text:String)
}


class TextAndPhontoCell: UITableViewCell {
    
    
    weak var delegate:TextAndPhontoCellDelegate?
    
    internal var placeholdStr:String = ""{
        didSet{
            placehold.text = placeholdStr
        }
    }
    
    
    private lazy var placehold:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.text = placeholdStr
        return label
    }()
    
    private lazy var textView:UITextView = { [unowned self] in
        let text = UITextView.init()
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.black
        text.showsVerticalScrollIndicator = true
        // 内部container 偏移
        text.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        text.delegate = self
        text.inputAccessoryView = UIToolbar.NumberkeyBoardDone(title: "完成", view: self, selector: #selector(done))
        return text
        
        
    }()
    
    
    
    private lazy var words:UILabel = {
        let word = UILabel()
        word.font = UIFont.systemFont(ofSize: 12)
        word.textColor = UIColor.lightGray
        word.textAlignment = .left
        word.setSingleLineAutoResizeWithMaxWidth(100)
        word.text = "0/\(maxWords)"
        return word
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [textView,  words]
        self.contentView.sd_addSubviews(views)
        textView.addSubview(placehold)
        _ = placehold.sd_layout().leftSpaceToView(textView,15)?.topSpaceToView(textView,10)?.autoHeightRatio(0)
        _ = textView.sd_layout().topEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        _ = words.sd_layout().rightSpaceToView(self.contentView,10)?.bottomEqualToView(self.contentView)?.autoHeightRatio(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "TextAndPhontoCell"
    }
    
    class func cellHeight()->CGFloat{
        return 160
        
    }

}




extension TextAndPhontoCell{
    @objc private func done(){
        self.textView.resignFirstResponder()
    }
    
   
}


extension TextAndPhontoCell:UITextViewDelegate{
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        placehold.isHidden =  textView.text.isEmpty ? false : true
        let wordCount = textView.text.count
        words.text = "\(wordCount)/\(maxWords)"
        if wordCount > maxWords{
            let start = textView.text.startIndex
            let end = textView.text.index(start, offsetBy: maxWords)
            textView.text = String(textView.text[start..<end])
            words.text = "\(maxWords)/\(maxWords)"
            return
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: NSNotification.Name.init(feedBackEditNotify), object: nil, userInfo: ["edit":true])
        
        placehold.isHidden =  textView.text.isEmpty ? false : true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
         placehold.isHidden =  textView.text.isEmpty ? false : true
        if !textView.text.isEmpty{
            self.delegate?.getTextContent(text: textView.text)
        }
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        NotificationCenter.default.post(name: NSNotification.Name.init(feedBackEditNotify), object: nil, userInfo: ["edit":false])
        return true
    }
    
}
