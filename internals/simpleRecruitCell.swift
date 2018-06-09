//
//  simpleRecruitCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 45)

// 这是collectioncell
@objcMembers class simpleRecruitCell: UICollectionViewCell {

    private lazy var collegeIcon:UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
        
    }()
    
    private lazy var times:UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var collegeName:UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(160)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var company:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 160)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
   dynamic var mode:CareerTalkMeetingModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            
            self.times.text = mode.time
            self.collegeIcon.image = UIImage.init(named: mode.icon)
            self.collegeName.text = mode.college! + " |"
            self.company.text = mode.companyModel?.name
            
            self.address.text = mode.address
            self.setupAutoHeight(withBottomViewsArray: [self.collegeIcon,self.address], bottomMargin: 10)
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [times, collegeIcon, collegeName, company,address]
        self.contentView.sd_addSubviews(views)
        _ = collegeIcon.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = company.sd_layout().leftSpaceToView(collegeIcon,10)?.topEqualToView(collegeIcon)?.autoHeightRatio(0)
        
        _ = collegeName.sd_layout().leftEqualToView(company)?.topSpaceToView(company,10)?.autoHeightRatio(0)
        _ = address.sd_layout().leftSpaceToView(collegeName,5)?.topEqualToView(collegeName)?.autoHeightRatio(0)
        _ = times.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        company.setMaxNumberOfLinesToShow(2)
        collegeName.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "simpleRecruitCell"
    }
}


