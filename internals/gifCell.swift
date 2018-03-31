//
//  gifCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class gifCell: UITableViewCell {

    
    private var avatar:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
    
    private lazy var gif:UIImageView =  {
        let img = UIImageView.init(frame: CGRect.zero)
        img.backgroundColor = UIColor.clear
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        avatar.setCircle()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(gif)
        self.backgroundColor = UIColor.clear


        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func heightForCell(messageInfo:MessageBoby)->CGFloat{
        if messageInfo.messageType == .bigGif{
            return  120
        }
        return 80
        
    }
    
    class func reuseidentify()->String{
        return "gifCell"
    }
    
    func setupPictureCell(messageInfo:MessageBoby, chatUser:PersonModel){
        
        guard let gifName = String.init(data: messageInfo.content!, encoding: String.Encoding.utf8) else {
            return
        }
        
        var gifPath:String?
        // 根据名字 找到 gifImage 路径
        if messageInfo.messageType == .smallGif{
                gifPath = GetChatEmotion.shared.findGifImage(gifName: gifName, type: .smallGif)
            
        }else if messageInfo.messageType == .bigGif{
                gifPath = GetChatEmotion.shared.findGifImage(gifName: gifName, type: .bigGif)
        }
        guard let path = gifPath else {
            return
        }
   
        let data = NSData.init(contentsOf: NSURL.init(fileURLWithPath: path) as URL)
        // 动态图
        let animationImage = UIImage.animationImageWithData(data: data)
        gif.image = animationImage
        
        // 自己
        if myself.userID  == messageInfo.sender?.userID{
            if let icon = myself.icon {
                self.avatar.image = UIImage.init(data: icon)
            }else{
                // default 头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            
            
            //self.avatar.image = UIImage.init(named:  messageInfo.sender?.iconURL ?? "default")
            self.avatar.frame = CGRect.init(x: UIScreen.main.bounds.width-avatarSize.width-5 , y: 5, width: avatarSize.width, height: avatarSize.height)
            if messageInfo.type == MessgeType.bigGif.rawValue{
                self.gif.frame = CGRect.init(x: UIScreen.main.bounds.width-5-self.avatar.frame.width-5-110, y: 15, width: 100, height: 100)
            }else{
                self.gif.frame = CGRect.init(x: UIScreen.main.bounds.width-5-self.avatar.frame.width-5-70, y: 15, width: 60, height: 60)
            }
            
            
        }else{
            if let icon = chatUser.icon {
                self.avatar.image = UIImage.init(data: icon)
            }else{
                // default 头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            
            //self.avatar.image = UIImage.init(named: messageInfo.sender?.iconURL  ?? "default")
            self.avatar.frame = CGRect.init(x: 5, y: 5, width: avatarSize.width, height: avatarSize.height)
            if messageInfo.type == MessgeType.bigGif.rawValue{
                self.gif.frame = CGRect.init(x: self.avatar.frame.width+5+10, y: 15, width: 100, height: 100)
            }else{
                self.gif.frame = CGRect.init(x: self.avatar.frame.width+5+10, y: 15, width: 60, height: 60)
            }
        }
        
        
    }
}
