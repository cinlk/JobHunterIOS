//
//  RecruiterCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let imgSize:CGSize = CGSize.init(width: 40, height: 40)

@objcMembers class RecruiterCell: UITableViewCell {

    
    private lazy var title: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    private lazy var icon: UIImageView = {
        let img = UIImageView.init()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    private lazy var position: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var onlineTime: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        return v
    }()
    
    
    dynamic var mode:HRPersonModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            
            title.text = "职位发布者"
            // 头像？？
            
            let url = URL.init(string: mode.icon ?? "")
            self.icon.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            name.text = mode.name
            position.text = mode.position
            onlineTime.text = "最近活跃:" + mode.ontimeStr
            self.setupAutoHeight(withBottomViewsArray: [icon,position], bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [line,title,icon,name,position,onlineTime]
        self.contentView.sd_addSubviews(views)
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        
        _ = line.sd_layout().topSpaceToView(title,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        
        _ = icon.sd_layout().leftEqualToView(title)?.topSpaceToView(line,5)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        
        _ = position.sd_layout().leftEqualToView(name)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        
        _ = onlineTime.sd_layout().centerYEqualToView(icon)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        icon.sd_cornerRadiusFromWidthRatio = 0.5 
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "RecruiterCell"
    }
}
