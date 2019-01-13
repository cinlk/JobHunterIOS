//
//  CareerTalkContentCell.swift
//  internals
//
//  Created by ke.liang on 2018/9/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class CareerTalkContentCell: TitleAndTextViewCell {

  
    dynamic var mode: CareerTalkMeetingModel?{
        didSet{
            
            // 判断 内容格式
            guard let mode = mode else {
                return
            }
            if mode.contentType == "html"{
                self.content.attributedText = mode.content?.htmlToAttributedString
            }else{
                self.content.text = mode.content
            }
            
            
            let size = self.content.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW - 20, height: CGFloat(MAXFLOAT)))
            _ = self.content.sd_layout().heightIs(size.height + 10)
            
            self.setupAutoHeight(withBottomView: content, bottomMargin: 20)
        }
    }
    
    
    
    class func identity()->String{
        return "CareerTalkContentCell"
    }
    
    

}
