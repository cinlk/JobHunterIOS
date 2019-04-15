//
//  RichLoadingView.swift
//  internals
//
//  Created by ke.liang on 2019/4/15.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit

class RichLoadingView: UIView {

    private lazy var label: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.text = "别着急，正在加载中..."
        label.textColor = UIColor.gray
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI(){
        backgroundColor = .white
        
        
        addSubview(indicatorView)
        addSubview(label)
        
        _ = indicatorView.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.heightIs(40)?.widthEqualToHeight()
        _ = label.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(indicatorView, 10)?.autoHeightRatio(0)
        
        indicatorView.startAnimating()
    }
    
    deinit {
        print("deinit RichLoadingView")
    }

}
