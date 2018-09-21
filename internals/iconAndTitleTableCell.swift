//
//  TitleTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/6/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    
    
    internal lazy var  icon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "locate")
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    internal lazy var iconName: UILabel = {
        let lable = UILabel.init()
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    internal lazy var line:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.black
        return v
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] =  [icon,iconName,line]
        self.contentView.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(20)?.heightIs(20)
        
        _ = iconName.sd_layout().leftSpaceToView(self.icon,5)?.topEqualToView(icon)?.autoHeightRatio(0)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(iconName,5)?.heightIs(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
