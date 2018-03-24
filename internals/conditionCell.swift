//
//  conditionCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class conditionCell: UITableViewCell {

    private lazy var name: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var value: UILabel = {
        let value = UILabel()
        value.setSingleLineAutoResizeWithMaxWidth(ScreenW - 120)
        value.textAlignment = .right
        
        value.font = UIFont.systemFont(ofSize: 14)
        value.textColor = UIColor.lightGray
        return value
    }()
    
    private lazy var arrow:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "rightforward"))
        icon.clipsToBounds = true
        icon.contentMode = .scaleToFill
        return icon
    }()
    
    
    var mode:(String,String)?{
        didSet{
            self.name.text = mode?.0
            self.value.text = mode?.1
             
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(name)
        self.contentView.addSubview(value)
        self.contentView.addSubview(arrow)
        
        _ = name.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
        _ = arrow.sd_layout().rightSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(20)?.heightIs(20)
        _ = value.sd_layout().rightSpaceToView(arrow,5)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
        
        
        value.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func identity()->String{
        return "conditin"
    }
    
    
}
