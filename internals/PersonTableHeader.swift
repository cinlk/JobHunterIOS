//
//  personTableHeader.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher


class PersonTableHeader: UIView {

    
    internal var touch:(()->Void)?
    
    private lazy var avatarImg:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        
        let tap = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(touchAvatar))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tap)
        return img
    }()
    
    private lazy var nameTitle:UILabel = {
        let name = UILabel.init(frame: CGRect.zero)
        name.textAlignment = .center
        name.textColor = UIColor.black
        name.font = UIFont.systemFont(ofSize: 16)
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
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
        intr.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
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
    // 从 global user 获取数据 TODO
    var  mode:(image:URL?, name:String, introduce:String)?{
        didSet{
            guard let mode = mode else { return }
            if let iconURL = mode.image{
                self.avatarImg.kf.setImage(with: Source.network(iconURL), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                self.avatarImg.image = #imageLiteral(resourceName: "selectedPerson")
            }
            //self.avatarImg.image = UIImage.init(named: mode.image)
            self.nameTitle.text = mode.name
            self.introduce.text = mode.introduce
            
            self.setupAutoHeight(withBottomViewsArray: [introduce,nameTitle], bottomMargin: 10)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [avatarImg, nameTitle, introduce]
        self.sd_addSubviews(views)
        
        NotificationCenter.default.rx.notification(NotificationName.updateBriefInfo, object: nil).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (notify) in
            self?.nameTitle.text = GlobalUserInfo.shared.getName()
            if let iconURL = GlobalUserInfo.shared.getIcon(){
                self?.avatarImg.kf.setImage(with: Source.network(iconURL), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
      
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


extension PersonTableHeader{
    @objc private func touchAvatar(sender:UITapGestureRecognizer){
        if sender.state == .ended{
            self.touch?()
        }
    }
    
    
    internal func setData(image:URL?, name:String, introduce:String){
        
        _ = avatarImg.sd_layout().centerXEqualToView(self)?.topSpaceToView(self,15)?.widthIs(45)?.heightIs(45)
        _ = nameTitle.sd_layout().topSpaceToView(avatarImg,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        _ = self.introduce.sd_layout().topSpaceToView(nameTitle,5)?.centerXEqualToView(avatarImg)?.autoHeightRatio(0)
        
        avatarImg.sd_cornerRadiusFromWidthRatio = 0.5
        nameTitle.setMaxNumberOfLinesToShow(1)
        self.introduce.setMaxNumberOfLinesToShow(2)
        
        
        if let iconURL = image{
            self.avatarImg.kf.setImage(with: Source.network(iconURL), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }else{
            self.avatarImg.image = #imageLiteral(resourceName: "selectedPerson")
        }
        //self.avatarImg.image = UIImage.init(named: mode.image)
        self.nameTitle.text = name
        self.introduce.text = introduce
    }
}
