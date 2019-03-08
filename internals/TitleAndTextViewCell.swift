//
//  TitleAndTextViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/9/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class TitleAndTextViewCell: UITableViewCell {
    
    internal lazy var name:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.text = "招聘内容"
        return label
    }()
    
    internal lazy var content:UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        text.isEditable = false
        return text
        
    }()
    
    internal lazy var richView:RichTextView = {
        let rich = RichTextView.init(frame: CGRect.zero)
        rich.isScrollEnabled = false
        return rich
     }()
    
    // 分割线
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        self.contentView.addSubview(name)
        self.contentView.addSubview(line)
        self.contentView.addSubview(richView)
        
        _ = name.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = line.sd_layout().leftEqualToView(name)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(name,5)?.heightIs(1)
        // 高度？
        _ = content.sd_layout().leftEqualToView(name)?.topSpaceToView(line,10)?.rightEqualToView(line)?.heightIs(0)
        
        _ = richView.sd_layout().leftEqualToView(name)?.topSpaceToView(line,10)?.rightEqualToView(line)?.heightIs(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
}
