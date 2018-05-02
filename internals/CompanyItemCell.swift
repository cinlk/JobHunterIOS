//
//  CompanyItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 45)


@objcMembers class CompanyItemCell: UITableViewCell {

    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    private lazy var company:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
        
    }()
    
    private lazy var types:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
   dynamic var mode:CompanyModel?{
        didSet{
            self.icon.image = UIImage.init(named: mode?.icon ?? "default")
            self.company.text = mode?.name
            self.types.text = mode?.type?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [icon,types], bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, company, types]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(imgSize.width)?.autoHeightRatio(1)
        _ = company.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = types.sd_layout().leftEqualToView(company)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func identity()->String{
        return "CompanyItemCell"
    }
}
