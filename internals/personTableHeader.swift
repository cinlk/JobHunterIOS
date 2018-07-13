//
//  personTableHeader.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



class personTableHeader: UIView {

    
    private lazy var avatarImg:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var nameTitle:UILabel = {
        let name = UILabel.init(frame: CGRect.zero)
        name.textAlignment = .center
        name.textColor = UIColor.black
        name.font = UIFont.systemFont(ofSize: 16)
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return name
    }()
    
    // 根据 hr 还是求职者 展示不同消息
    private lazy var introduce:UILabel = {
        let intr = UILabel.init(frame: CGRect.zero)
        intr.textAlignment = .center
        intr.textColor = UIColor.black
        intr.font = UIFont.systemFont(ofSize: 14)
        intr.text = ""
        intr.backgroundColor = UIColor.clear
        intr.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return intr
    }()
    
    var isHR:Bool?{
        didSet{
            
            if isHR!{
                hrlayout()
            }else{
                normallayout()
            }
        }
    }
    var  mode:(image:String,name:String, introduce:String)?{
        didSet{
            guard let mode = mode else { return }
            self.avatarImg.image = UIImage.init(named: mode.image)
            self.nameTitle.text = mode.name
            self.introduce.text = mode.introduce
            
            self.setupAutoHeight(withBottomViewsArray: [introduce,nameTitle], bottomMargin: 20)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [avatarImg, nameTitle, introduce]
        self.sd_addSubviews(views)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hrlayout(){
        
        
        _ = avatarImg.sd_layout().centerXEqualToView(self)?.topSpaceToView(self,10)?.widthIs(60)?.heightIs(60)
        
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        _ = introduce.sd_layout().topSpaceToView(nameTitle,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        
        avatarImg.sd_cornerRadiusFromWidthRatio = 0.5
        nameTitle.setMaxNumberOfLinesToShow(1)
        introduce.setMaxNumberOfLinesToShow(2)


    }

    private func normallayout(){
        
       
        _ = avatarImg.sd_layout().centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(45)?.heightIs(45)
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        _ = introduce.sd_layout().topSpaceToView(nameTitle,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        
        avatarImg.sd_cornerRadiusFromWidthRatio = 0.5
        nameTitle.setMaxNumberOfLinesToShow(1)
        introduce.setMaxNumberOfLinesToShow(2)
    }
}
