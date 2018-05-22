//
//  person_educationCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


@objcMembers class educationInfoCell: BaseResumeInfoCell {
    
    
    dynamic var mode:personEducationInfo?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            startToEndTime.text = mode.startTimeString + "至" + mode.endTimeString
            multiValues.text = mode.colleage + "-" + mode.department + "-" + mode.degree
            describe.text = mode.describe
            if mode.isOpen{
                self.describe.setMaxNumberOfLinesToShow(0)
            }else{
                self.describe.setMaxNumberOfLinesToShow(5)
                
            }
            self.setupAutoHeight(withBottomView: describe, bottomMargin: 10)
            
            
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func identity()->String{
        return "person_educationCell"
    }
    
    
}


