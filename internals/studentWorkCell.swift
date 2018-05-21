//
//  studentWorkCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class studentWorkCell: BaseResumeInfoCell {

   
    dynamic var mode:studentWorkInfo?{
        didSet{
            guard let mode = mode else{
                return
            }
            
            self.startToEndTime.text = mode.startTimeString + "至" + mode.endTimeString
            self.multiValues.text = mode.colleage + "-" +  mode.orgName
            self.describe.text = mode.describe
            
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
        return "studentWorkCell"
    }
    

}