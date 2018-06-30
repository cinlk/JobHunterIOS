
//
//  ForumBaseCell
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let iconSize:CGSize = CGSize.init(width: 30, height: 30)

@objcMembers class ForumBaseCell: UITableViewCell {
    
    
    internal lazy var postTitle:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 30 - 30)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    internal lazy var authorName:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 30 - 30)
        label.textAlignment = .left
        label.isAttributedContent = true 
        label.font = UIFont.systemFont(ofSize: 14)
        return label
        
    }()
    
    internal lazy var authorIcon:UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    internal lazy var creatTime:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(120)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    internal lazy var postType:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(120)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    internal lazy var thumbs:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.tintColor = UIColor.lightGray
        label.isAttributedContent = true
        return label
    }()
    
    internal lazy var reply:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.isAttributedContent = true
        label.tintColor = UIColor.lightGray
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [postTitle, postType, creatTime, authorName, authorIcon, thumbs, reply]
        self.contentView.sd_addSubviews(views)
        
        _ = authorIcon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.heightEqualToWidth()
        
        _ = authorName.sd_layout().topSpaceToView(self.contentView,12)?.leftSpaceToView(authorIcon,10)?.autoHeightRatio(0)
        _ = postType.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(authorIcon)?.autoHeightRatio(0)
        _ = postTitle.sd_layout().leftEqualToView(authorName)?.topSpaceToView(authorName,5)?.autoHeightRatio(0)
        _ = creatTime.sd_layout().topSpaceToView(postTitle,10)?.leftEqualToView(postTitle)?.autoHeightRatio(0)
        _ = thumbs.sd_layout().topEqualToView(creatTime)?.rightSpaceToView(self.contentView,10)?.widthIs(0)?.heightIs(15)
        _ = reply.sd_layout().rightSpaceToView(thumbs,5)?.topEqualToView(thumbs)?.widthIs(0)?.heightIs(15)
        
        authorName.setMaxNumberOfLinesToShow(2)
        postTitle.setMaxNumberOfLinesToShow(3)
        authorIcon.sd_cornerRadiusFromWidthRatio = 0.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
