//
//  EndTimeTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/6/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class SubIconAndTitleCell: TitleTableViewCell {

    
    
    internal lazy var content:UILabel = {
        let lable = UILabel.init()
        lable.textAlignment = .left
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        return lable
    }()
    
    
    dynamic var mode:String?{
        didSet{
            guard let mode = mode  else {
                return
            }

            content.text = mode
            
            self.setupAutoHeight(withBottomView: content, bottomMargin: 5)

        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        self.selectionStyle = .none
         _ = content.sd_layout().topSpaceToView(line,5)?.leftSpaceToView(self.contentView, TableCellOffsetX)?.autoHeightRatio(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "subIconAndTitleCell"
    }
    
    

}
