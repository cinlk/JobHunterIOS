//
//  person_skillCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let iconSize:CGSize = CGSize.init(width: 25, height: 25)

@objcMembers class person_skillCell: UITableViewCell {
    
    
    lazy var modifyIcon:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "edit"))
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var  type:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.textAlignment = .left
        t.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        t.font = UIFont.systemFont(ofSize: 14)
        return t
    }()
    
    
    private lazy var detail:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.lineBreakMode = .byWordWrapping
        t.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 14)
        return t
    }()
    
    
    internal var showResume:Bool = false{
        didSet{
            if showResume{
                self.modifyIcon.isHidden = true
                self.detail.setMaxNumberOfLinesToShow(0)
                self.selectionStyle = .none
            }
        }
    }
    
    dynamic var mode:SkillsTextResume?{
        didSet{
            guard let mode = mode else {
                return
            }
            self.type.text = mode.skill
            self.detail.text = mode.describe
            if mode.isOpen{
                self.detail.setMaxNumberOfLinesToShow(0)
            }else{
                self.detail.setMaxNumberOfLinesToShow(5)
                
            }
            
            self.setupAutoHeight(withBottomView: detail, bottomMargin: 10)
            
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(type)
        self.contentView.addSubview(detail)
        self.contentView.addSubview(modifyIcon)
        _ = type.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = modifyIcon.sd_layout().topEqualToView(type)?.rightSpaceToView(self.contentView,20)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = detail.sd_layout().leftEqualToView(type)?.topSpaceToView(type,10)?.autoHeightRatio(0)
        
        detail.setMaxNumberOfLinesToShow(5)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 
    

    class func identity()-> String {
        return "person_skillCell"
    }
    
}

