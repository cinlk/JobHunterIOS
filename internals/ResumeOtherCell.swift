//
//  ResumeOtherCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 25, height: 25)


@objcMembers class ResumeOtherCell: UITableViewCell {

    
    lazy var modifyIcon:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "edit"))
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
    }()
    
    
    private lazy var lableTitle:UILabel = {
        let lb = UILabel()
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width - 20)
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    private lazy var content:UILabel = {
        
        let lb = UILabel()
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width - 20)
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    internal var showResume:Bool = false{
        didSet{
            if showResume{
                self.modifyIcon.isHidden = true
                self.selectionStyle = .none
            }
        }
    }
    
    
    dynamic var mode:resumeOther?{
        didSet{
            
            self.lableTitle.text = mode?.title
            self.content.text = mode?.describe
            if (mode?.isOpen)!{
                self.content.setMaxNumberOfLinesToShow(0)
            }else{
                self.content.setMaxNumberOfLinesToShow(5)
                
            }
            self.setupAutoHeight(withBottomView: content, bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(lableTitle)
        self.contentView.addSubview(content)
        self.content.addSubview(modifyIcon)
        
        _ = lableTitle.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
         _ = modifyIcon.sd_layout().topEqualToView(lableTitle)?.rightSpaceToView(self.contentView,20)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = content.sd_layout().topSpaceToView(lableTitle,10)?.leftEqualToView(lableTitle)?.autoHeightRatio(0)
        
        content.setMaxNumberOfLinesToShow(5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "ResumeOtherCell"
    }
}
