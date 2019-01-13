//
//  MagineTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let iconSize:CGSize = CGSize.init(width: 100, height: 45)

@objcMembers class MagineTableViewCell: UITableViewCell {

    
    
    
    private lazy var titleName:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textAlignment = .left
        lb.textColor = UIColor.black
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width - 30)
        return lb
    }()
    
    private lazy var author:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .left
        lb.textColor = UIColor.black
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width - 30)
        return lb
    }()
    
    private lazy var time:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .left
        lb.textColor = UIColor.lightGray
        lb.setSingleLineAutoResizeWithMaxWidth(200)
        return lb
    }()
    
    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    
   dynamic var mode:MagazineModel?{
        didSet{
            guard let mode = mode  else {
                return
            }
            
            icon.image = UIImage.init(named: mode.icon)
            titleName.text = mode.title
            author.text = mode.author
            time.text = mode.timeStr
            
            self.setupAutoHeight(withBottomViewsArray: [time,icon], bottomMargin: 10)
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [titleName, author, time, icon]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(3/4)
        _ = titleName.sd_layout().rightSpaceToView(icon,10)?.leftSpaceToView(self.contentView,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = author.sd_layout().topSpaceToView(titleName,20)?.leftEqualToView(titleName)?.autoHeightRatio(0)
        _ = time.sd_layout().topEqualToView(author)?.rightSpaceToView(icon,20)?.autoHeightRatio(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func identity()->String{
        return "MagineTableViewCell"
    }
}
