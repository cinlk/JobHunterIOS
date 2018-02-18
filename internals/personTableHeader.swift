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
        
        //let img = UIImageView.init(frame: CGRect.init(x: (self.width - avatarSize.width - 15)/2, y: (self.height - avatarSize.height - 15)/2, width: avatarSize.width + 15, height: avatarSize.height + 15))
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width + 15, height: avatarSize.height + 15))
        
        img.contentMode = .scaleToFill
        return img
        }()
    
    lazy var nameTitle:UILabel = {
        let name = UILabel.init(frame: CGRect.zero)
        name.textAlignment = .center
        name.textColor = UIColor.white
        name.font = UIFont.systemFont(ofSize: 16)
        return name
    }()
    
    // 根据 hr 还是求职者 展示不同消息
    lazy var introduce:UILabel = {
        let intr = UILabel.init(frame: CGRect.zero)
        intr.textAlignment = .center
        intr.textColor = UIColor.white
        intr.font = UIFont.systemFont(ofSize: 14)
        intr.text = ""
        intr.backgroundColor = UIColor.clear
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
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.widthIs(100)?.centerXEqualToView(avatarImg)?.heightIs(20)
        
        //nameTitle.frame = CGRect.init(x: 10, y: avatarImg.origin.y + avatarImg.height + 10, width: ScreenW - 20, height: 30)
        //introduce.frame = CGRect.init(x: 10, y: nameTitle.origin.y + , width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        _ = introduce.sd_layout().leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.topSpaceToView(nameTitle,5)?.heightIs(25)?.centerXEqualToView(avatarImg)
        avatarImg.setCircle()
        nameTitle.sizeToFit()
    }

    private func normallayout(){
        self.backgroundColor = UIColor.orange
      
        
        _ = avatarImg.sd_layout().centerXEqualToView(self)?.centerYEqualToView(self)
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.widthIs(100)?.centerXEqualToView(avatarImg)?.heightIs(15)
        
        //nameTitle.frame = CGRect.init(x: 10, y: avatarImg.origin.y + avatarImg.height + 10, width: ScreenW - 20, height: 30)
        //introduce.frame = CGRect.init(x: 10, y: nameTitle.origin.y + , width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        _ = introduce.sd_layout().leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.topSpaceToView(nameTitle,5)?.heightIs(20)?.centerXEqualToView(avatarImg)
        
        avatarImg.setCircle()
        nameTitle.sizeToFit()
    }
}
