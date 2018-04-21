//
//  BaseScrollerTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseScrollerTableViewCell: UITableViewCell {

    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.contentView.frame)
        //scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.bounces = true
        scrollView.isPagingEnabled = false
        scrollView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        //scrollView?.height = self.frame.height
        scrollView.canCancelContentTouches  = true
        return scrollView
        
    }()
    
    var selectedItem:((_ btn:UIButton)->Void)?
    
    
    // image url strings and title
    var mode:[String:String]?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(scrollView)
        _ = scrollView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


