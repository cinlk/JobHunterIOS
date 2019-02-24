//
//  jobdetailCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


@objcMembers class CommonJobTableCell: UITableViewCell {
    
    private lazy var commonjobView: CommonJobDetailCellView =  CommonJobDetailCellView()

    internal var showTag:Bool = false{
        didSet{
            commonjobView.showInternTag = showTag
        }
    }
    
    dynamic var mode:JobListModel?{
        didSet{
            self.commonjobView.mode = mode
            
            self.setupAutoHeight(withBottomView: commonjobView, bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
        self.contentView.addSubview(commonjobView)
        _ = commonjobView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.heightIs(0)
        //self.conte
        // 下拉菜单 背景view 滑动是，所有cell自动变成选中状态
        //  会出现该view默认为w灰色，设置无色
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "compuseJobs"
    }
    
    // MARK 区分cell 投递 和非
    

}
