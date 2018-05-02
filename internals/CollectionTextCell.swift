//
//  CollectionTextCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

 class CollectionTextCell:UICollectionViewCell{
    
    lazy var name:UILabel = { [unowned self] in
        
        let name = UILabel.init()
        
        name.backgroundColor = UIColor.init(r: 245, g: 245, b: 245)
        name.font = UIFont.systemFont(ofSize: 16)
        name.textAlignment = .center
        name.textColor = UIColor.black
        //name.setSingleLineAutoResizeWithMaxWidth(self.frame.width)
        name.layer.borderWidth = 0.7
        name.layer.cornerRadius = 5
        name.layer.masksToBounds = true
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(name)
        _ = name.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
       
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "CollectionTextCell"
    }
}
