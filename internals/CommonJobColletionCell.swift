//
//  CommonJobColletionCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class CommonJobColletionCell: UICollectionViewCell {
    
    
    
    private lazy var commonjobView: CommonJobDetailCellView =  CommonJobDetailCellView()
    
    
    
    private var deliver:Bool = false
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            self.commonjobView.mode = mode
            self.setupAutoHeight(withBottomView: commonjobView, bottomMargin: 10)
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(commonjobView)
        _ = commonjobView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.heightIs(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension CommonJobColletionCell{
    class func identity()->String{
        return "CommonJobColletionCell"
    }
    
    class func cellHeight()->CGFloat{
        return 65
    }
}
