//
//  gifCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher


class GifCell: UITableViewCell {

    
    private var avatar:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height))
    
    private lazy var gif:UIImageView =  {
        let img = UIImageView.init(frame: CGRect.zero)
        img.backgroundColor = UIColor.clear
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(gif)
        avatar.setCircle()

        self.backgroundColor = UIColor.clear


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    class func reuseidentify()->String{
        return "gifCell"
    }
    
    func setupPictureCell(messageInfo:GifImageMessage, chatUser:PersonModel?){
        
        guard let gifName =  messageInfo.localGifName else {
            return
        }
        
        // 根据名字 找到 gifImage 路径
        guard let gifPath = GetChatEmotion.shared.findGifImage(gifName: gifName, type: messageInfo.messageType) else {
            avatar.isHidden = true
            gif.isHidden = true 
            return
        }
        
        // 图片数据  本地file  或者网络url??
        let data = NSData.init(contentsOf: NSURL.init(fileURLWithPath: gifPath) as URL)
        // 组合gif动态图
        let animationImage = UIImage.animationImageWithData(data: data)
        gif.image = animationImage
        
        
        // 图片宽度
        let gifWidth:CGFloat =  messageInfo.messageType == .bigGif ? 100 : 60
        
        
        
        if GlobalUserInfo.shared.getId()  == messageInfo.senderId{
            if let iconURL = GlobalUserInfo.shared.getIcon() {
                self.avatar.kf.indicatorType = .activity
                self.avatar.kf.setImage(with: Source.network(iconURL), placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                // default 头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            
            
            self.avatar.frame = CGRect.init(x: GlobalConfig.ScreenW - GlobalConfig.AvatarSize.width - 5 , y: 5, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height)
            
            self.gif.frame = CGRect.init(x: GlobalConfig.ScreenW - 5 - self.avatar.frame.width - 5 - gifWidth - 10, y: 10, width: gifWidth, height: gifWidth)
            
            
        }else{
            if let iconURL = chatUser?.icon {
                self.avatar.kf.indicatorType = .activity
                self.avatar.kf.setImage(with: Source.network(iconURL), placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                // default 头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            
            self.avatar.frame = CGRect.init(x: 5, y: 5, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height)
            self.gif.frame = CGRect.init(x: self.avatar.frame.width+5+10, y: 15, width: gifWidth, height: gifWidth)

        }
        
        
    }
}
