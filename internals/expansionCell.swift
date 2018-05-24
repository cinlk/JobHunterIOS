//
//  expansionCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



@objcMembers class expansionCell: UITableViewCell {

    
  private lazy var title:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 30)
        return label
    }()
    
   private lazy var icon:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        return img
    }()
    
   private lazy var detailLabel:UILabel = {
        
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 )
        return label
    }()
    
   dynamic var mode:HelpItemsModel?{
        didSet{
            self.title.text = mode?.title
            if mode!.selected{
                self.icon.image = UIImage.init(named: "arrow_xl")
                self.title.textColor = UIColor.green
                detailLabel.text = mode?.content
                self.setupAutoHeight(withBottomView: detailLabel, bottomMargin: 5)
            }else{
                self.title.textColor = UIColor.black
                self.icon.image = UIImage.init(named: "arrow_mr")
                self.setupAutoHeight(withBottomView: title, bottomMargin: 5)
            }
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [title, icon, detailLabel]
        self.contentView.sd_addSubviews(views)
        _ = title.sd_layout().leftSpaceToView(self.contentView,16)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = icon.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(title)?.widthIs(15)?.heightIs(10)
        _ = detailLabel.sd_layout().leftEqualToView(title)?.topSpaceToView(title,10)?.autoHeightRatio(0)
        
        title.setMaxNumberOfLinesToShow(0)
        detailLabel.setMaxNumberOfLinesToShow(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "expansionCell"
        
    }

    
}
