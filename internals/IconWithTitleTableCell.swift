//
//  TitleTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/6/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class IconWithTitleTableViewCell: UITableViewCell {

    

    internal lazy var wrapperIcon:UIView = {
        let v = UIView.init()
        v.clipsToBounds = false
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    
    internal lazy var  icon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "message")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = false
        return img
    }()
    internal lazy var iconName: UILabel = {
        let lable = UILabel.init()
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        return lable
    }()
    
    internal lazy var line:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.black
        return v
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] =  [wrapperIcon,iconName,line]
        
        wrapperIcon.addSubview(icon)
        
        _ = icon.sd_layout()?.leftEqualToView(wrapperIcon)?.topEqualToView(wrapperIcon)?.bottomEqualToView(wrapperIcon)?.rightEqualToView(wrapperIcon)
        
        self.contentView.sd_addSubviews(views)
        
        _ = wrapperIcon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(20)?.heightIs(20)
        
        _ = iconName.sd_layout().leftSpaceToView(self.wrapperIcon,5)?.topEqualToView(wrapperIcon)?.autoHeightRatio(0)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(iconName,5)?.heightIs(1)
        
        icon.sd_cornerRadiusFromWidthRatio = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
