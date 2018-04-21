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

    private lazy var companyIcon:UIImageView = {
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
    
    private lazy var companyName:UILabel = {
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
    
   dynamic var mode:simpleRecruitModel?{
        didSet{
            
            self.times.text = mode?.startTime
            self.companyIcon.image = UIImage.init(named: mode?.image ?? "default")
            self.companyName.text = mode?.title
            self.des.text = mode?.des
            self.setupAutoHeight(withBottomViewsArray: [self.companyIcon,self.des], bottomMargin: 10)
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [times, companyIcon, companyName, des]
        self.contentView.sd_addSubviews(views)
        _ = companyIcon.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = companyName.sd_layout().leftSpaceToView(companyIcon,5)?.topEqualToView(companyIcon)?.autoHeightRatio(0)
        _ = des.sd_layout().topSpaceToView(companyName,5)?.leftEqualToView(companyName)?.autoHeightRatio(0)
        _ = times.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        
        companyIcon.sd_cornerRadiusFromWidthRatio = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "simpleRecruitCell"
    }
}


