//
//  introduction.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers class contentAndTitleCell: UITableViewCell {

    
    private lazy var desc: UILabel = {
        let lable = UILabel.init()
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textAlignment = .left
        return lable
        
    }()
    private lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    private lazy var title: UILabel = {
        let lable = UILabel.init()
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textAlignment = .left
        lable.text = "公司简介"
        return lable
    }()
    
   dynamic var des:String?{
        didSet{
            desc.text = des
            self.setupAutoHeight(withBottomView: desc, bottomMargin: 10)
        }
    }
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [desc, line,title]
        self.contentView.sd_addSubviews(views)
        _ = title.sd_layout().leftSpaceToView(self.contentView,20)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(title,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        _ = desc.sd_layout().topSpaceToView(line,5)?.leftEqualToView(title)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    class func identity()->String{
        return  "contentAndTitleCell"
    }
    
}
