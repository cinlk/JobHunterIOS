//
//  introduction.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers class CompanyDetailCell: TitleAndTextViewCell {

   
    dynamic var mode:String?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            self.content.text = mode
            let size = self.content.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW - 20, height: CGFloat(MAXFLOAT)))
            _ = self.content.sd_layout().heightIs(size.height + 10)
            
            self.setupAutoHeight(withBottomView: content, bottomMargin: 20)
        }
       
    }
    
    class func identity()->String{
        return  "contentAndTitleCell"
    }
    
}
