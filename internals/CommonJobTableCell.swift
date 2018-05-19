//
//  jobdetailCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 40)

@objcMembers class CommonJobTableCell: UITableViewCell {
    
    
    
    private lazy var commonjobView: CommonJobDetailCellView =  CommonJobDetailCellView()
    


    private var deliver:Bool = false
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            self.commonjobView.mode = mode
            
            self.setupAutoHeight(withBottomView: commonjobView, bottomMargin: 0)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
        self.contentView.addSubview(commonjobView)
        _ = commonjobView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.heightIs(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "compuseJobs"
    }
    
    // MARK 区分cell 投递 和非
    
    class func cellHeight()->CGFloat{
        return  65
    }

}