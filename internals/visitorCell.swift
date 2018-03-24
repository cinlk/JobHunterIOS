//
//  visitorCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class visitorCell: UITableViewCell {

    private lazy var avartar: UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
        
    }()
    private lazy var visite_time: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
        
    }()
    private lazy var jobName: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private lazy var company: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    private lazy var position:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private lazy var action:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
   
  dynamic var mode:VisitorHRModel?{
        didSet{
            avartar.image = UIImage.init(named: mode?.iconURL ?? "default")
            visite_time.text = mode?.visit_time
            jobName.text = mode?.jobName
            company.text = mode?.company
            position.text = mode?.position
            action.text = mode?.tag
            
            self.setupAutoHeight(withBottomViewsArray: [avartar, position], bottomMargin: 10)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [avartar, visite_time, jobName, company, position, action]
        self.contentView.sd_addSubviews(views)
        _ = avartar.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(45)?.heightIs(45)
        _ = company.sd_layout().leftSpaceToView(avartar,10)?.topEqualToView(avartar)?.autoHeightRatio(0)
        _ = position.sd_layout().leftSpaceToView(company,5)?.topEqualToView(company)?.autoHeightRatio(0)
        _ = action.sd_layout().leftEqualToView(company)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = jobName.sd_layout().leftSpaceToView(action,10)?.topEqualToView(action)?.autoHeightRatio(0)
        _ = visite_time.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(company)?.autoHeightRatio(0)
        
        
        company.setMaxNumberOfLinesToShow(1)
        position.setMaxNumberOfLinesToShow(1)
        jobName.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "visitorCell"
    }
    

    
    
}
