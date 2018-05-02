//
//  TableContentCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class TableContentCell: UITableViewCell {

    lazy var name:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        return label
    }()
    
    private lazy var content:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return label
    }()
    
    // 分割线
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    dynamic var mode:String?{
        didSet{
            self.content.text = mode
            
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
        _ = content.sd_layout().leftEqualToView(name)?.topSpaceToView(line,5)?.autoHeightRatio(0)
        content.setMaxNumberOfLinesToShow(0)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "tableCellView"
    }
}


