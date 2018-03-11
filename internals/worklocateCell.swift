//
//  worklocate.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers  class worklocateCell: UITableViewCell {

    
    private lazy var locate: UILabel = {
        let lable = UILabel.init()
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    
    private lazy var details: UILabel = {
        let lable = UILabel.init()
        lable.textAlignment = .left
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    private lazy var line:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.black
        return v
    }()
    
    dynamic var mode:jobDetails?{
        didSet{
            locate.text = "工作地址"
            details.text = mode?.address
            self.setupAutoHeight(withBottomView: details, bottomMargin: 10)
        }
    }
     override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [locate, line, details]
        self.contentView.sd_addSubviews(views)
        
        _  = locate.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
    
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(locate,5)?.heightIs(1)
        
        _ = details.sd_layout().topSpaceToView(line,5)?.leftEqualToView(locate)?.autoHeightRatio(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
