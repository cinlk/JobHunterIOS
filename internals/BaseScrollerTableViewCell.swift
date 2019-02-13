//
//  BaseScrollerTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseScrollerTableViewCell: UITableViewCell {

    
    internal lazy var scrollView:UIScrollView = {
        
        let scrollView = UIScrollView.init(frame: CGRect.zero)
        //scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator  = false
        scrollView.isUserInteractionEnabled = true
        scrollView.bounces = false
        scrollView.isPagingEnabled = false
        scrollView.scrollsToTop = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        scrollView.canCancelContentTouches  = true
        
        return scrollView
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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


