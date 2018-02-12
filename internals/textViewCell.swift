//
//  textViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

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
        label.text = "我是placeholder 值"
        label.numberOfLines = 0
        label.contentMode = .top
        label.textColor = UIColor.red
        return label
    }()
    
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(textView)
        self.textView.addSubview(placeHolderLabel)
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        _ = textView.frame = self.contentView.frame
    }

    
    class func identity()->String{
        return "textViewCell"
    }
    
    class func cellHeight()->CGFloat{
        return 160
    }
    
    
    

}
