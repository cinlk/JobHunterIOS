//
//  personTableHeader.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



class personTableHeader: UIView {

    
    lazy var avatarImg:UIImageView = { [unowned self] in
        
 
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width + 15, height: avatarSize.height + 15))
        img.contentMode = .scaleToFill
        return img
        }()
    
    lazy var nameTitle:UILabel = {
        let name = UILabel.init(frame: CGRect.zero)
        name.textAlignment = .center
        name.textColor = UIColor.black
        name.font = UIFont.systemFont(ofSize: 16)
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return name
    }()
    
    // 根据 hr 还是求职者 展示不同消息
    lazy var introduce:UILabel = {
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
            self.avatarImg.image = UIImage.init(named: mode?.image ?? "")
            self.nameTitle.text = mode?.name
            self.introduce.text = mode?.introduce
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarImg)
        self.addSubview(nameTitle)
        self.addSubview(introduce)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hrlayout(){
        
        self.backgroundColor = UIColor.clear
        _ = avatarImg.sd_layout().centerXEqualToView(self)?.topSpaceToView(self,10)
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        _ = introduce.sd_layout().topSpaceToView(nameTitle,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        avatarImg.setCircle()

    }

    private func normallayout(){
        
        self.backgroundColor = UIColor.orange
        _ = avatarImg.sd_layout().centerXEqualToView(self)?.centerYEqualToView(self)
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        _ = introduce.sd_layout().topSpaceToView(nameTitle,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        avatarImg.setCircle()
    }
}
