//
//  extension+button.swift
//  internals
//
//  Created by ke.liang on 2017/12/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
 
extension UIButton {
    
    convenience init(title:(name:String, type:UIControl.State), fontSize:CGFloat = 10, alignment: NSTextAlignment = .left, bColor:UIColor = UIColor.clear) {
        self.init(type: .custom)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.titleLabel?.textAlignment = alignment
        self.backgroundColor = bColor
        self.setTitle(title.0, for: title.1)
    }
    

    public func showBadges(x:CGFloat){
        self.imageView?.clipsToBounds = false
        self.imageView?.pp.addBadge(number: 99)
        //  这里无法获取imageView的大小,初始为0，传入固定值
        self.imageView?.pp.moveBadge(x: x, y: 0)
    }
}



// 调整image 和title 位置


extension UIButton {
    
    func setPositionWith(image anImage: UIImage?, title: String,
                         titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State, offsetY: CGFloat = 0){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
        self.layoutIfNeeded()
        
        positionLabelRespectToImage(position: titlePosition, spacing: additionalSpacing, offsetY: offsetY)

    }
    
    private func positionLabelRespectToImage(position: UIView.ContentMode,
                                             spacing: CGFloat, offsetY:CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleSize = self.titleLabel?.bounds.size ?? CGSize.zero
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing + offsetY),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: offsetY, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + spacing), bottom: 0, right: (imageSize.width + spacing))
            imageInsets = UIEdgeInsets(top: 0, left: (titleSize.width  + spacing), bottom: 0,
                                       right: -(titleSize.width  + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    
    //
    
    
}


