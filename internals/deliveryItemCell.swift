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
    
    
    private lazy var jobName: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private lazy var company: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private lazy var type: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    private lazy var address: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    private lazy var resulte: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.blue
        
        return label
    }()
    
    private lazy var create_time: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        return label
    }()
    
    
    //var notRead:Bool = false

    dynamic var mode:DeliveredJobsModel?{
        didSet{
            icon.image = UIImage.init(named: mode?.picture ?? "default")
            jobName.text = mode?.jobName
            address.text = mode?.address
            company.text = mode?.company
            type.text = mode?.type
            create_time.text = mode?.create_time
            resulte.text = "【" + (mode?.checkStatus)!   + "】"
            self.setupAutoHeight(withBottomViewsArray: [address, type, resulte,icon], bottomMargin: 10)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, jobName, company, type, address, resulte, create_time]
        self.contentView.sd_addSubviews(views)
        _  = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = jobName.sd_layout().leftSpaceToView(icon, 10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = company.sd_layout().topSpaceToView(jobName,2.5)?.leftEqualToView(jobName)?.autoHeightRatio(0)
        _ = address.sd_layout().topSpaceToView(company,2.5)?.leftEqualToView(company)?.autoHeightRatio(0)
        _ = type.sd_layout().leftSpaceToView(address,10)?.topEqualToView(address)?.autoHeightRatio(0)
        _ = create_time.sd_layout().rightSpaceToView(self.contentView,20)?.topEqualToView(jobName)?.autoHeightRatio(0)
        _ = resulte.sd_layout().bottomEqualToView(type)?.rightEqualToView(create_time)?.autoHeightRatio(0)
        
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        jobName.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "delieveryItem"
    }
    
    
}
