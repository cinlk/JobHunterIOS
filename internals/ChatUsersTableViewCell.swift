//
//  ChatUsersTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/19.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import PPBadgeViewSwift
import Kingfisher

fileprivate let iconSize:CGSize = CGSize.init(width: 55, height: 55)


@objcMembers class ChatUsersTableViewCell: UITableViewCell {
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        return label
    }()
    
    private lazy var content: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width - 40)
        return label
    }()
    
    private lazy var time: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(160)
        return label
    }()
    
    
    // outer wrapper 来设置未读消息字数
    private lazy var outerIconView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.clipsToBounds = false 
        return v
    }()
    internal lazy var icon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = false
        return img
    }()
    
    
    
    dynamic var mode:ChatListModel?{
        didSet{
            
            //guard let user = mode? else { return }
            guard let mes = mode?.lastMessage else { return }
            
            
            if let num = mode?.unreadCount, num > 0{
                self.outerIconView.pp.addBadge(number: num)
                self.outerIconView.pp.setBadge(height: 15)
                self.outerIconView.pp.moveBadge(x: -5, y: 5)
            }else{
                self.outerIconView.pp.hiddenBadge()
            }
            
            
            if let url = mode?.recruiterIconURL {
                self.icon.kf.indicatorType = .activity
                self.icon.kf.setImage(with: Source.network(url), placeholder: #imageLiteral(resourceName: "picture"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            // 加入hr 的公司名称 ?
            self.name.text =  mode?.recruiterName
            
            self.content.text = mes.getDescribe()
            
            self.time.text =  mes.talkTime
            //print(mes.toJSON())
            self.setupAutoHeight(withBottomViewsArray: [icon,content], bottomMargin: 10)
           
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [name, content, time, outerIconView]
        self.outerIconView.addSubview(icon)
        _ = icon.sd_layout().leftEqualToView(outerIconView)?.rightEqualToView(outerIconView)?.topEqualToView(outerIconView)?.bottomEqualToView(outerIconView)
        
        self.contentView.sd_addSubviews(views)
        _ = outerIconView.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        
        _ = name.sd_layout().leftSpaceToView(outerIconView,10)?.topEqualToView(outerIconView)?.autoHeightRatio(0)
        _ = content.sd_layout().leftEqualToView(name)?.topSpaceToView(name,10)?.autoHeightRatio(0)
        _ = time.sd_layout().rightSpaceToView(self.contentView,10)?.centerYEqualToView(name)?.autoHeightRatio(0)
        
        // 圆角是宽度的05倍
        icon.sd_cornerRadiusFromWidthRatio = 0.5
        
        content.setMaxNumberOfLinesToShow(1)
        name.setMaxNumberOfLinesToShow(2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    class func identity()->String{
        return "ChatUsersTableViewCell"
    }
    
    class func cellHeight()->CGFloat {
        return 60.0
    }
    
    
}
