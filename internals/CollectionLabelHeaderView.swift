//
//  CollectionLabelHeaderView.swift
//  internals
//
//  Created by ke.liang on 2018/4/25.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

// label header

class CollectionLabelHeaderView: UICollectionReusableView {


    internal var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.blue
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        _ = titleLabel.sd_layout().leftSpaceToView(self,10)?.centerYEqualToView(self)?.autoHeightRatio(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "sectionHeader"
    }

}
