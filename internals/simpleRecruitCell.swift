//
//  simpleRecruitCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 45)

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
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var collegeName:UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var des:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
   dynamic var mode:CareerTalkMeetingModel?{
        didSet{
            
            self.times.text = mode?.time
            self.collegeIcon.image = UIImage.init(named: mode!.icon)
            self.collegeName.text = mode?.college
            self.des.text = mode?.address
            self.setupAutoHeight(withBottomViewsArray: [self.collegeIcon,self.des], bottomMargin: 10)
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [times, collegeIcon, collegeName, des]
        self.contentView.sd_addSubviews(views)
        _ = collegeIcon.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = collegeName.sd_layout().leftSpaceToView(collegeIcon,5)?.topEqualToView(collegeIcon)?.autoHeightRatio(0)
        _ = des.sd_layout().topSpaceToView(collegeName,5)?.leftEqualToView(collegeName)?.autoHeightRatio(0)
        _ = times.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "simpleRecruitCell"
    }
}


