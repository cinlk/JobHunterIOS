//
//  projectInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class projectInfoCell: BaseResumeInfoCell<personProjectInfo> {

     dynamic var mode:personProjectInfo?{
        didSet{
            guard let mode = mode else{
                return
            }
            
            self.startToEndTime.text = mode.startTimeString + "至" + mode.endTimeString
            self.multiValues.text = mode.pName + "-" +  mode.position
            self.describe.text = mode.describe
            if mode.isOpen{
                self.describe.setMaxNumberOfLinesToShow(0)
            }else{
                self.describe.setMaxNumberOfLinesToShow(5)
                
            }
            self.setupAutoHeight(withBottomView: describe, bottomMargin: 10)
            
            
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func identity()->String{
        return "projectInfoCell"
    }
    
    

}
