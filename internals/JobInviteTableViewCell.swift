//
//  JobInviteTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class JobInviteTableViewCell: InviteBaseTableViewCell {


    
    internal var  type:UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.orange
        
        return label
    }()
    
    internal var check:UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(100)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        label.text = "查看"
        
        return label
    }()
    
    dynamic var mode:JobInviteModel?{
        didSet{
            guard let mode = mode else { return }
            titleName.text = mode.title
            content.text = mode.content
            time.text = mode.creatTimeStr
            type.text = mode.type.describe
            
            self.setupAutoHeight(withBottomView: type, bottomMargin: 10)
            
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(type)
        self.contentView.addSubview(check)
        
        _ = titleName.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        _ = content.sd_layout().leftEqualToView(titleName)?.topSpaceToView(titleName,10)?.autoHeightRatio(0)
        
        _ = time.sd_layout().topEqualToView(titleName)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
    
        _ = type.sd_layout().leftEqualToView(content)?.topSpaceToView(content,10)?.autoHeightRatio(0)
        rightArrow.sd_resetNewLayout()
        _ = rightArrow.sd_layout().topEqualToView(type)?.rightSpaceToView(self.contentView,10)?.widthIs(15)?.heightEqualToWidth()
        _ = check.sd_layout().rightSpaceToView(rightArrow,5)?.topEqualToView(rightArrow)?.autoHeightRatio(0)
        
        titleName.setMaxNumberOfLinesToShow(2)
        content.setMaxNumberOfLinesToShow(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "JobInviteTableViewCell"
    }
    
    
    

}
