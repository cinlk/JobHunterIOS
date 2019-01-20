//
//  UserGuideLogginCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class UserGuideLogginCell: UICollectionViewCell {
    
    
    private lazy var backGroundImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage.init(named: "ali")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var loggingBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.blue
        
        btn.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(backGroundImage)
        self.contentView.addSubview(loggingBtn)
        _ = backGroundImage.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(self.contentView,GlobalConfig.NavH + 60)?.widthIs(200)?.heightIs(200)
        
        _ = loggingBtn.sd_layout().bottomSpaceToView(self.contentView,100)?.centerXEqualToView(self.contentView)?.heightIs(35)?.widthIs(200)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "UserGuideLogginCell"
    }
    
    
    @objc fileprivate func loginHandler() {
        
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let enter = rootViewController as? EnterAppViewController else {return}
        enter.finishShowGuide()
        
        
    }
    
}
