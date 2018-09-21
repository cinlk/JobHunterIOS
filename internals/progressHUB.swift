//
//  progressHUB.swift
//  CandySearch
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 Peartree Developers. All rights reserved.
//

import UIKit
import SDAutoLayout

class progressHUB: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.text = "加载数据"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.black
        self.backgroundColor = UIColor.white
        
        indicator.frame = CGRect(x:0, y:0, width:60, height:60)
        indicator.center = self.center
        label.frame = CGRect(x: 0, y: 60, width: 60, height: 10)
        self.addSubview(indicator)
        indicator.bringSubviewToFront(self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.addSubview(label)
        //_ = indicator.sd_layout().topEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(50)
        //_ = label.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(10)
        _ = label.sd_layout().centerXEqualToView(indicator)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
