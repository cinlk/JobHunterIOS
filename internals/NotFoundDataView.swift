//
//  NotFoundDataView.swift
//  internals
//
//  Created by ke.liang on 2019/5/5.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotFoundDataView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var tap: Driver<Void> {
        return self.btn.rx.tap.asDriver()
    }
    private  lazy var btn:UIButton = {
        let b = UIButton.init(frame: CGRect.zero)
        b.setTitle("点击刷新", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.setTitleColor(UIColor.blue, for: .normal)
        b.backgroundColor = UIColor.lightGray
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        self.addSubview(btn)
        _ = btn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
        super.layoutSubviews()
        
    }
}
