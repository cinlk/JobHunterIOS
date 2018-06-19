//
//  TableContentCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class applyJobsCell: UITableViewCell {

    lazy var name:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.text = "招聘内容"
        return label
    }()
    
    private lazy var content:UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        text.isEditable = false
        return text
        
    }()
    
    // 分割线
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    dynamic var mode:String?{
        didSet{
            
           
          
            // 判断 内容格式
            //self.content.attributedText = mode?.htmlToAttributedString
            //self.content.text = mode?.htmlToString
            self.content.text =  mode
            let size = self.content.sizeThatFits(CGSize.init(width: ScreenW - 20, height: CGFloat(MAXFLOAT)))
            _ = self.content.sd_layout().heightIs(size.height + 40)
            
            self.setupAutoHeight(withBottomView: content, bottomMargin: 20)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        self.contentView.addSubview(name)
        self.contentView.addSubview(line)
        
        _ = name.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = line.sd_layout().leftEqualToView(name)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(name,5)?.heightIs(1)
        // 高度？
        _ = content.sd_layout().leftEqualToView(name)?.topSpaceToView(line,10)?.rightEqualToView(line)?.heightIs(0)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "applyJobsCell"
    }
}


