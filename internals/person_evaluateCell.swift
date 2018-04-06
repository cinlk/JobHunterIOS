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
    
    private  lazy var  title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textAlignment = .left
        t.font = UIFont.boldSystemFont(ofSize: 15)
        t.text = "自我评价"
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
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textColor = UIColor.black
        return label
    }()
    
    var close:Bool? = false{
        didSet{
            self.modifyIcon.isHidden = true
            self.line.isHidden = true
            self.title.isHidden = true
        }
    }
    
    dynamic var mode:String?{
        didSet{
            
            guard let mode = mode else {
                return
            }
            
            let content = mode.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            contentLable.sd_resetNewLayout()
            // 简历预览界重新布局
            if close!{
                _ = contentLable.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
            }else{
                _ = contentLable.sd_layout().leftEqualToView(title)?.topEqualToView(modifyIcon)?.autoHeightRatio(0)
            }
            
            contentLable.text = content
            self.setupAutoHeight(withBottomViewsArray: [contentLable,modifyIcon], bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let views:[UIView] = [modifyIcon,title, line, contentLable]
        self.contentView.sd_addSubviews(views)
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,5)?.heightIs(1)
        
        _ = modifyIcon.sd_layout().topSpaceToView(line,5)?.rightSpaceToView(self.contentView,10)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = contentLable.sd_layout().leftEqualToView(title)?.topEqualToView(modifyIcon)?.autoHeightRatio(0)

        contentLable.setMaxNumberOfLinesToShow(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func identity()->String{
        return "person_evaluateCell"
        
    }

}


