//
//  deliveryItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let iconSize:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class deliveryItemCell: UITableViewCell {

    private lazy var icon: UIImageView = {
        let img = UIImageView.init()
        img.contentMode = UIView.ContentMode.scaleAspectFill
        
        img.clipsToBounds = true
        return img
    }()
    
    
    private lazy var titleName: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private lazy var company: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        
        return label
    }()
    
//    private lazy var type: UILabel = {
//        let label = UILabel.init()
//        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = UIColor.orange
//        return label
//    }()
    
    private lazy var status: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.blue
        
        return label
    }()
    
    private lazy var time: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
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

    dynamic var mode:DeliveryJobsModel?{
        didSet{
            guard let mode = mode else { return }
            
            if let url = mode.companyIcon{
                icon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            //icon.image = UIImage.init(named: mode.icon)
            titleName.text = mode.jobName
            company.text = mode.companyName
            //type.text = mode.type
            
            time.text = mode.createdTimeStr
            if   !mode.resumeStatue.describe.isEmpty{
                 status.text = "[" + mode.resumeStatue.describe + "]"
                 status.textColor = mode.resumeStatue.color
            }
            
            self.setupAutoHeight(withBottomViewsArray: [company,icon], bottomMargin: 10)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, titleName, company, status, time]
        self.contentView.sd_addSubviews(views)
        self.backgroundColor = UIColor.white
        
        _  = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        
        _ = titleName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,10)?.autoHeightRatio(0)
        _ = time.sd_layout().topSpaceToView(titleName,5)?.leftEqualToView(titleName)?.autoHeightRatio(0)
        //_ = type.sd_layout().topSpaceToView(company,5)?.leftEqualToView(company)?.autoHeightRatio(0)
        _ = company.sd_layout().topSpaceToView(time,5)?.leftEqualToView(time)?.autoHeightRatio(0)
        _ = status.sd_layout()?.centerYEqualToView(self.contentView)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
 
        company.setMaxNumberOfLinesToShow(1)
        titleName.setMaxNumberOfLinesToShow(1)
        icon.sd_cornerRadiusFromWidthRatio = 0.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "delieveryItem"
    }
    
    
}
