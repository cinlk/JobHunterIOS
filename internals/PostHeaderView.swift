//
//  PostHeaderView.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class PostHeaderView: UIView {

  
    internal lazy var userIcon:UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    internal lazy var userName:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        label.font = UIFont.systemFont(ofSize: 14)
        label.isAttributedContent = true 
        return label
    }()
    
    // 预览次数
    internal lazy var readCount: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.font = UIFont.systemFont(ofSize: 12)
        label.isAttributedContent = true
        return label
    }()
    
    internal lazy var createTime:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    internal lazy var contentText:UITextView = {
        let text = UITextView()
        text.showsVerticalScrollIndicator = false
        text.isScrollEnabled = false
        text.isEditable = false
        text.font = UIFont.systemFont(ofSize: 16)
        
        return text
    }()
    
    internal lazy var lines:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.5
        return v
    }()
    // 赞 回帖 和 分享btn
    internal lazy var thumbUP:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "thumbup")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage.init(named: "selectedthumbup")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .selected)
        
        btn.semanticContentAttribute = .forceLeftToRight
        btn.setTitle("", for: .normal)
        btn.clipsToBounds = true
        btn.contentHorizontalAlignment = .left
        //btn.tintColor = UIColor.lightGray
        btn.contentMode = .left
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        return btn
        
    }()
    
    
    internal lazy var reply:UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage.init(named: "comment")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        btn.semanticContentAttribute = .forceLeftToRight
        btn.setTitle("", for: .normal)
        // 左对齐
        btn.contentHorizontalAlignment = .left
        btn.contentMode = .right
        btn.imageView?.contentMode = .scaleAspectFit
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        return btn
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let views:[UIView] =  [userIcon, userName,createTime,contentText, lines,thumbUP, reply, readCount]
        self.sd_addSubviews(views)
        
        
        _ = userIcon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(30)?.heightIs(30)
        _ = userName.sd_layout().leftSpaceToView(userIcon,10)?.topEqualToView(userIcon)?.autoHeightRatio(0)
        _ = createTime.sd_layout().leftEqualToView(userName)?.topSpaceToView(userName,5)?.autoHeightRatio(0)
        
        _ = readCount.sd_layout()?.rightSpaceToView(self, 20)?.topEqualToView(createTime)?.autoHeightRatio(0)
        
        _ = contentText.sd_layout().topSpaceToView(createTime,10)?.leftEqualToView(userName)?.rightSpaceToView(self,10)?.heightIs(0)
        _ = lines.sd_layout().topSpaceToView(contentText,15)?.leftEqualToView(contentText)?.rightEqualToView(contentText)?.heightIs(1)
        
        _ = thumbUP.sd_layout().leftEqualToView(contentText)?.topSpaceToView(contentText,20)?.widthIs(0)?.heightIs(25)
        _ = reply.sd_layout().leftSpaceToView(thumbUP,5)?.topEqualToView(thumbUP)?.heightRatioToView(thumbUP,1)?.widthIs(0)
        
        
        userIcon.sd_cornerRadiusFromWidthRatio = 0.5
        userName.setMaxNumberOfLinesToShow(1)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
