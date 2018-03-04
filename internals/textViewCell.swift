//
//  textViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let placeholdStr:String = "输入技能，100字以内"
class textViewCell: UITableViewCell {
    
    // textview
    lazy var textView:UITextView = {
        let tv = UITextView.init(frame: CGRect.zero)
        tv.textColor = UIColor.black
        tv.textAlignment = .left
        tv.backgroundColor = UIColor.lightGray
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    
    lazy var placeHolderLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: ScreenW, height: 20))
        label.text = placeholdStr
        label.numberOfLines = 0
        label.contentMode = .top
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var doneBtn:UIToolbar = {
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(done))
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重写frame
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.origin.y += 10
            newFrame.size.height -= 20
            super.frame = newFrame
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(textView)
        self.textView.addSubview(placeHolderLabel)
        self.textView.inputAccessoryView = doneBtn
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        _ = textView.frame = self.contentView.frame
    }

    
    class func identity()->String{
        return "textViewCell"
    }
    
    class func cellHeight()->CGFloat{
        return 200
    }
    

}

extension textViewCell{
    @objc func done(){
        self.textView.endEditing(true)
    }
}
