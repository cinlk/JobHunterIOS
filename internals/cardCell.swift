//
//  cardCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class cardCell: UITableViewCell {

   
    private lazy var timeLabel:UILabel = {
        let st = UILabel.init(frame: CGRect.zero)
        st.font = UIFont.systemFont(ofSize: 13)
        st.textColor = UIColor.lightGray
        st.textAlignment = .left
        return st
    }()
    
    
    
    private lazy var middleLabel:UILabel = {
        let st = UILabel.init(frame: CGRect.zero)
        st.font = UIFont.systemFont(ofSize: 15)
        st.textColor = UIColor.black
        st.textAlignment = .left
        return st
    }()
    
    private lazy var bottomLable:UILabel = {
        let st = UILabel.init(frame: CGRect.zero)
        st.font = UIFont.systemFont(ofSize: 15)
        st.textColor = UIColor.lightGray
        st.textAlignment = .left
        return st
    }()
    
    var mode:(time:String,middle:String,bottom:String)?{
        didSet{
            self.timeLabel.text = mode?.time
            self.middleLabel.text = mode?.middle
            self.bottomLable.text = mode?.bottom
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(middleLabel)
        self.contentView.addSubview(bottomLable)
        
        _ = timeLabel.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,10)?.heightIs(20)
        _ = middleLabel.sd_layout().leftEqualToView(timeLabel)?.rightEqualToView(timeLabel)?.topSpaceToView(timeLabel,5)?.heightIs(20)
        
        _ = bottomLable.sd_layout().leftEqualToView(timeLabel)?.rightEqualToView(timeLabel)?.topSpaceToView(middleLabel,5)?.heightIs(20)
        
    }
    
}


extension cardCell{
    
    class func identity()->String{
        return "cardCell"
    }
    
    
    class func ceilHeight()->CGFloat{
        return 80
    }
    
}
