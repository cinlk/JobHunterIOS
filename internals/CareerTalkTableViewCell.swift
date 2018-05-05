//
//  CareerTalkTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class CareerTalkTableViewCell: InviteBaseTableViewCell {

    
   dynamic var mode:CarrerTalkInviteModel?{
        didSet{
            guard let mode = mode  else {
                return
            }
            self.titleName.text = mode.company
            self.content.text = mode.content
            self.time.text = mode.creatTimeStr
            self.setupAutoHeight(withBottomView: content, bottomMargin: 10)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = titleName.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        _ = content.sd_layout().leftEqualToView(titleName)?.topSpaceToView(titleName,10)?.autoHeightRatio(0)
        
        _ = time.sd_layout().topEqualToView(titleName)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        titleName.setMaxNumberOfLinesToShow(2)
        content.setMaxNumberOfLinesToShow(0)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "CareerTalkTableViewCell"
    }
    

}
