//
//  CareerTalkCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 45)



@objcMembers class CareerTalkCell: UITableViewCell {

    
    
    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        
        return img
        
    }()
    
    private lazy var company:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
        
    }()
    
    private lazy var time:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var collage:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    // 显示标记
    internal lazy var type:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.blue
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.isHidden = true
        return label
    }()
    
   dynamic var mode:CareerTalkMeetingModel?{
        didSet{
            self.icon.image = UIImage.init(named: mode!.icon)
            self.company.text = mode?.companyModel?.name
            
            self.time.text = mode?.time
            self.collage.text = mode?.college
            self.address.text = mode?.address
            self.type.text = "宣讲会"
            self.setupAutoHeight(withBottomViewsArray: [icon,address], bottomMargin: 10)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, company, time, collage, address, type]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(imgSize.width)?.autoHeightRatio(1)
        _ = company.sd_layout().leftSpaceToView(icon,5)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = time.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = type.sd_layout().topSpaceToView(time,10)?.rightEqualToView(time)?.autoHeightRatio(0)
        
        _ = collage.sd_layout().leftEqualToView(company)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = address.sd_layout().leftSpaceToView(collage, 10)?.topEqualToView(collage)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "CareerTalkCell"
    }
}
