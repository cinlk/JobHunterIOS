//
//  conversationCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 40, height: 40)
@objcMembers class conversationCell: UITableViewCell {

    private lazy var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 120)
        return label
    }()
    
    private lazy var content: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        return label
    }()
    
    private lazy var time: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 120)
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    
   dynamic var mode:conversationModel?{
        didSet{
            
            guard let user = mode?.user else { return }
            guard let mes = mode?.message else { return }
            
            guard let iconData = user.icon else { return }
            
            self.icon.image = UIImage.init(data: iconData) ?? #imageLiteral(resourceName: "default")
            self.name.text =  user.name! + "@" + user.company!
            
            self.content.text = mes.getContent(isConversion: true) as! String
            
            self.time.text =  mes.creat_time?.string()
            self.setupAutoHeight(withBottomViewsArray: [icon,content], bottomMargin: 10)
           
        }
    }
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [name, content, time, icon]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = content.sd_layout().leftEqualToView(name)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        _ = time.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        
        // 圆角是宽度的05倍
        icon.sd_cornerRadiusFromWidthRatio = 0.5
        content.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    class func identity()->String{
        return "conversationCell"
    }
    
    class func cellHeight()->CGFloat {
        return 60.0
    }
    
    
}
