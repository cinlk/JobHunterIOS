//
//  UserGuideItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class UserGuideItemCell: UICollectionViewCell {
    
    
    
    private lazy var imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private lazy var contentTitle:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        
        return lb
    }()
    
    private lazy var content:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        lb.textAlignment  = .center
        
        return lb
    }()
    
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        
        return v
    }()
    
    var mode:UserGuidePageItem?{
        didSet{
            guard let mode = mode else {
                return
            }
            self.imageView.image = UIImage.init(named: mode.imageName!)
            self.contentTitle.text = mode.title
            self.content.text = mode.detail
            
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [imageView, content, line, contentTitle]
        self.contentView.sd_addSubviews(views)
        self.contentView.backgroundColor = UIColor.white
        
        _ = imageView.sd_layout().topSpaceToView(self.contentView,NavH + 30)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(300)
        
        _ = line.sd_layout().topSpaceToView(imageView,1)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        
        _ = contentTitle.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(line,30)?.autoHeightRatio(0)
        
        _ = content.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(contentTitle,20)?.autoHeightRatio(0)
        
        contentTitle.setMaxNumberOfLinesToShow(2)
        content.setMaxNumberOfLinesToShow(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "UserGuideItemCell"
    }
    
    
}
