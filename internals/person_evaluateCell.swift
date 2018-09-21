//
//  person_ evaluateCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 25, height: 25)

@objcMembers class person_evaluateCell: UITableViewCell {

    lazy var modifyIcon:UIImageView = {
        let icon = UIImageView.init(image: UIImage.init(named: "edit"))
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
    }()
    
    lazy var plusImage:UIImageView = {
        let icon = UIImageView.init()
        icon.contentMode = .scaleAspectFill
        icon.image = #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.blue
        
        return icon
    }()
    
    private  lazy var  celltitle:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 18)
        t.text = "自我评价"
        t.setSingleLineAutoResizeWithMaxWidth(100)
        t.textColor = UIColor.black
        return t
    }()
    
    private lazy var line:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    
    private lazy var contentLable:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width - 20)
        label.textColor = UIColor.black
        return label
    }()
    
    
    
    
    dynamic var mode:selfEstimateModel?{
        didSet{
            
            guard let mode = mode else {
                return
            }
            let content = mode.content.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            
            
            
            if mode.isOpen{
                self.modifyIcon.isHidden = true
                self.line.isHidden = true
                self.celltitle.isHidden = true
                self.plusImage.isHidden = true
                self.selectionStyle = .none
                self.contentLable.text = content
                
                //contentLable.sd_resetNewLayout()
                _ = contentLable.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
                contentLable.setMaxNumberOfLinesToShow(0)
                self.updateLayout()
                
                self.setupAutoHeight(withBottomView: contentLable, bottomMargin: 10)

                return
            }
            
           
            if content.isEmpty{
                line.isHidden = true
                contentLable.isHidden = true
                modifyIcon.isHidden = true
                plusImage.isHidden = false
                
                self.setupAutoHeight(withBottomView: celltitle, bottomMargin: 10)
                
            }else{
                plusImage.isHidden = true
                line.isHidden = false
                contentLable.isHidden = false
                modifyIcon.isHidden = false
                contentLable.text = content
                
                
                
                self.setupAutoHeight(withBottomViewsArray: [contentLable,modifyIcon], bottomMargin: 5)
                
                
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.clipsToBounds = true 
        let views:[UIView] = [modifyIcon,celltitle, line, plusImage,contentLable]
        self.contentView.sd_addSubviews(views)
        
        _ = celltitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        
        _ = plusImage.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(celltitle)?.bottomEqualToView(celltitle)?.widthIs(20)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(celltitle,5)?.heightIs(1)
        
        _ = modifyIcon.sd_layout().topSpaceToView(line,5)?.rightSpaceToView(self.contentView,10)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = contentLable.sd_layout().leftEqualToView(celltitle)?.topEqualToView(modifyIcon)?.autoHeightRatio(0)
        contentLable.setMaxNumberOfLinesToShow(5)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func identity()->String{
        return "person_evaluateCell"
        
    }

}


