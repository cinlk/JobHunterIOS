//
//  sectionCellView.swift
//  internals
//
//  Created by ke.liang on 2018/3/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class sectionCellView: UITableViewCell {

    private lazy var SectionTitle:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return label
    }()
    
   dynamic var mode:String?{
        didSet{
            self.SectionTitle.text = mode ?? ""
            self.setupAutoHeight(withBottomView: SectionTitle, bottomMargin: 5)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(SectionTitle)
        _ = SectionTitle.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
        SectionTitle.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "sectionCellView"
    }
}
