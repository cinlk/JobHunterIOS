//
//  deliveryItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class deliveryItemCell: UITableViewCell {

    private lazy var icon: UIImageView = {
        let img = UIImageView.init()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    
    private lazy var titleName: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private lazy var company: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private lazy var type: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.orange
        return label
    }()
    
    private lazy var status: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.blue
        
        return label
    }()
    
    private lazy var time: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        
        return label
    }()
    
    
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            //newFrame.origin.y += 10
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
    
    
    //var notRead:Bool = false

    dynamic var mode:DeliveredJobsModel?{
        didSet{
            guard let mode = mode else { return }
            
            icon.image = UIImage.init(named: mode.icon)
            titleName.text = mode.title
            company.text = mode.companyName
            type.text = mode.jobtype.describe
            time.text = mode.createTimeStr
            if   !mode.deliveryStatus.describe.isEmpty{
                 status.text = "[" + mode.deliveryStatus.describe + "]"
            }
            
            self.setupAutoHeight(withBottomViewsArray: [type,icon], bottomMargin: 10)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, titleName, company, type, status, time]
        self.contentView.sd_addSubviews(views)
        self.backgroundColor = UIColor.white
        
        _  = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        
        _ = titleName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,10)?.autoHeightRatio(0)
        _ = company.sd_layout().topSpaceToView(titleName,5)?.leftEqualToView(titleName)?.autoHeightRatio(0)
        _ = type.sd_layout().topSpaceToView(company,5)?.leftEqualToView(company)?.autoHeightRatio(0)
        _ = time.sd_layout().topEqualToView(icon)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = status.sd_layout().topSpaceToView(time,15)?.rightEqualToView(time)?.autoHeightRatio(0)
 
        company.setMaxNumberOfLinesToShow(1)
        titleName.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "delieveryItem"
    }
    
    
}
