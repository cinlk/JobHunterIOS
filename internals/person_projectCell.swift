//
//  person_projectCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let iconSize:CGSize = CGSize.init(width: 25, height: 25)

@objcMembers class person_projectCell: UITableViewCell {

    
    lazy var modifyIcon:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "edit"))
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
    }()
    
    
    private lazy var startToEndTime:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 25)
        return t
    }()
    
    
    private lazy var company:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.lineBreakMode = .byWordWrapping
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return t
    }()
    
    
    private lazy var detail:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return t
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [modifyIcon, startToEndTime, company, detail]
        self.contentView.sd_addSubviews(views)
        _ = startToEndTime.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView, 10)?.autoHeightRatio(0)
        _ = modifyIcon.sd_layout().topEqualToView(startToEndTime)?.rightSpaceToView(self.contentView,20)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = company.sd_layout().leftEqualToView(startToEndTime)?.topSpaceToView(startToEndTime,10)?.autoHeightRatio(0)
        _ = detail.sd_layout().leftEqualToView(company)?.topSpaceToView(company,10)?.autoHeightRatio(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    dynamic var mode:personInternInfo?{
        didSet{
            guard let mode = mode else{
                return
            }
            
            self.startToEndTime.text = mode.startTimeString + "至" + mode.endTimeString
            self.company.text = mode.position + "-" +  mode.company + "-" +  mode.city
            self.detail.text = mode.describe

            self.setupAutoHeight(withBottomView: detail, bottomMargin: 10)
            
            
        }
    }
    
    class func identity()->String{
        return "person_projectCell"
    }
}



