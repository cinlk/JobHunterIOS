//
//  gifCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class gifCell: UITableViewCell {

    
    var avatar:UIImageView!
    // gif
    var gif:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        avatar = UIImageView.init()
        gif = UIImageView()
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(gif!)
        self.backgroundColor = UIColor.clear


        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func heightForCell(messageInfo:MessageBoby)->CGFloat{
        if messageInfo.type == .bigGif{
            return  120
        }
        return 80
        
    }
    
    class func reuseidentify()->String{
        return "gifCell"
    }
    
    func setupPictureCell(messageInfo:imageMessageBody, user:FriendModel){
        
        
 
        // image path file
        let path  = messageInfo.imgPath
        let data = NSData.init(contentsOf: NSURL.init(fileURLWithPath: path) as URL)
        // 动态图
        let animationImage = UIImage.animationImageWithData(data: data)
        gif?.image = animationImage
        
        if user.id  == messageInfo.sender.id{
            
            
            self.avatar.image = UIImage.init(named:  messageInfo.sender.avart)
            self.avatar.frame = CGRect.init(x: UIScreen.main.bounds.width-avatarSize.width-5 , y: 5, width: avatarSize.width, height: avatarSize.height)
            if messageInfo.type == .bigGif{
                self.gif?.frame = CGRect.init(x: UIScreen.main.bounds.width-5-self.avatar.frame.width-5-110, y: 15, width: 100, height: 100)
            }else{
                self.gif?.frame = CGRect.init(x: UIScreen.main.bounds.width-5-self.avatar.frame.width-5-70, y: 15, width: 60, height: 60)
            }
            
            
        }else{
            self.avatar.image = UIImage.init(named: messageInfo.sender.avart)
            self.avatar.frame = CGRect.init(x: 5, y: 5, width: avatarSize.width, height: avatarSize.height)
            if messageInfo.type == .bigGif{
                self.gif?.frame = CGRect.init(x: self.avatar.frame.width+5+10, y: 15, width: 100, height: 100)
            }else{
                self.gif?.frame = CGRect.init(x: self.avatar.frame.width+5+10, y: 15, width: 60, height: 60)
            }
        }
        
        
    }
}
