//
//  person_educationCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 25, height: 25)

@objcMembers class person_educationCell: UITableViewCell {

    
    
    lazy var modifyIcon:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "edit"))
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
    }()
    
    
    private lazy var startToEndTime:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 - iconSize.width)
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        return t
    }()
    
    // 学校-学历-城市
    private lazy  var multiValues:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 - iconSize.width)
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        
        return t
    }()
    // 专业
    private lazy var department:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 - iconSize.width)
        return t
    }()
    
    dynamic var mode:personEducationInfo?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            startToEndTime.text = mode.startTimeString + "至" + mode.endTimeString
            
            multiValues.text = mode.colleage + "-" + mode.degree + "-" + mode.city
            department.text = mode.department
            
            self.setupAutoHeight(withBottomView: department, bottomMargin: 10)
            
            
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] =  [modifyIcon, startToEndTime, multiValues, department]
        self.contentView.sd_addSubviews(views)
        
        _ = startToEndTime.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
         _ = modifyIcon.sd_layout().rightSpaceToView(self.contentView,20)?.topEqualToView(startToEndTime)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = multiValues.sd_layout().leftEqualToView(startToEndTime)?.topSpaceToView(startToEndTime,10)?.autoHeightRatio(0)
        _ = department.sd_layout().leftEqualToView(multiValues)?.topSpaceToView(multiValues,10)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   
    class func identity()->String{
        return "person_educationCell"
    }

}


