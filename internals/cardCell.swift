//
//  cardCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


class cardModel:NSObject {
    
    var time:String
    var middle:String
    var bottom:String
    
    init(time:String, middle:String, bottom:String) {
        self.time = time
        self.middle = middle
        self.bottom = bottom
    }
}

@objcMembers class cardCell: UITableViewCell {

   
    private lazy var timeLabel:UILabel = {
        let st = UILabel.init(frame: CGRect.zero)
        st.font = UIFont.systemFont(ofSize: 13)
        st.textColor = UIColor.lightGray
        st.textAlignment = .left
        st.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return st
    }()
    
    
    
    private lazy var middleLabel:UILabel = {
        let st = UILabel.init(frame: CGRect.zero)
        st.font = UIFont.systemFont(ofSize: 15)
        st.textColor = UIColor.black
        st.textAlignment = .left
        st.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return st
    }()
    
    private lazy var bottomLable:UILabel = {
        let st = UILabel.init(frame: CGRect.zero)
        st.font = UIFont.systemFont(ofSize: 15)
        st.textColor = UIColor.black
        st.textAlignment = .left
        st.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return st
    }()
    
   dynamic var mode:cardModel?{
        didSet{
            self.timeLabel.text = mode?.time
            self.middleLabel.text = mode?.middle
            self.bottomLable.text = mode?.bottom
            self.setupAutoHeight(withBottomView: bottomLable, bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [timeLabel, middleLabel, bottomLable]
        self.contentView.sd_addSubviews(views)
        
        _ = timeLabel.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = middleLabel.sd_layout().leftEqualToView(timeLabel)?.topSpaceToView(timeLabel,5)?.autoHeightRatio(0)
        
        _ = bottomLable.sd_layout().leftEqualToView(timeLabel)?.topSpaceToView(middleLabel,5)?.autoHeightRatio(0)
        
        middleLabel.setMaxNumberOfLinesToShow(1)
        bottomLable.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
}

extension cardCell{
    
    class func identity()->String{
        return "cardCell"
    }
    
    
}
