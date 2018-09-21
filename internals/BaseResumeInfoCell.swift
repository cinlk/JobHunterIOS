//
//  BaseResumeInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 25, height: 25)


@objcMembers class BaseResumeInfoCell<U>: UITableViewCell {

 
    internal lazy var modifyIcon:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "edit"))
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
    }()
    
    // 起止和结束时间
    internal lazy var startToEndTime:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 - iconSize.width)
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        return t
    }()
    
    // 学校-专业-学历 ()
    internal lazy  var multiValues:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 - iconSize.width)
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        
        return t
    }()
    
    // 内容描述
    internal lazy var describe:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.lightGray
        //t.numberOfLines = 0
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 - iconSize.width)
        t.font = UIFont.systemFont(ofSize: 12)
        t.textAlignment = .left
        
        return t
    }()
    
    internal var showResume:Bool = false{
        didSet{
            if showResume{
                self.modifyIcon.isHidden = true
                self.selectionStyle = .none
            }
        }
    }
    
    
    //dynamic var mode:U!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] =  [modifyIcon, startToEndTime, multiValues,describe]
        self.contentView.sd_addSubviews(views)
        self.clipsToBounds = true 
        _ = startToEndTime.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = modifyIcon.sd_layout().rightSpaceToView(self.contentView,20)?.topEqualToView(startToEndTime)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = multiValues.sd_layout().leftEqualToView(startToEndTime)?.topSpaceToView(startToEndTime,10)?.autoHeightRatio(0)
        _ = describe.sd_layout().leftEqualToView(multiValues)?.topSpaceToView(multiValues,5)?.autoHeightRatio(0)
        
        describe.setMaxNumberOfLinesToShow(5)
        startToEndTime.setMaxNumberOfLinesToShow(1)
        multiValues.setMaxNumberOfLinesToShow(1)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
