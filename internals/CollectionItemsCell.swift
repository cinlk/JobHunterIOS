//
//  CollectionItemsCell.swift
//  internals
//
//  Created by ke.liang on 2018/3/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import PPBadgeViewSwift


class CollectionItemsCell: UICollectionViewCell {
    
    
    private lazy var iconImage:UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    
    var mode:showitem?{
        didSet{
            titleLabel.text = mode?.name
            iconImage.image = UIImage.init(named: mode?.image ?? "default")
            self.setupAutoWidth(withRightView: titleLabel, rightMargin: 10)
            // 添加右上叫 气泡
            iconImage.pp.addBadge(number: mode?.bubbles ?? 0)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconImage)
        self.addSubview(titleLabel)
        
        _ = iconImage.sd_layout().centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(45)?.heightIs(45)
        _ = titleLabel.sd_layout().topSpaceToView(iconImage,5)?.centerXEqualToView(iconImage)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "CollectionItemsCell"
    }
    
    
}
