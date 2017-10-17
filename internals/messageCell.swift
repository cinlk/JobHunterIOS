//
//  messageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/14.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


let avatarSize:CGSize = CGSize.init(width: 45, height: 45)

class messageCell: UITableViewCell {

    
    var avatar:UIImageView!
    var messageLabel:UILabel!
    var bubleBackGround: UIImageView!
    
    // 代码初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        avatar = UIImageView.init()
        messageLabel = UILabel()
        bubleBackGround = UIImageView()
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = UIColor.black
        // 分行
        messageLabel.numberOfLines = 0
        
        
        
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(bubleBackGround)
        self.contentView.addSubview(messageLabel)

        
        //
        self.backgroundColor = UIColor.clear
        
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // nib 初始化
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func reuseidentify()->String{
        return "messageCell"
    }
    
    class func heightForCell(messageInfo:MessageBoby)->CGFloat{
        
        let screenRect:CGRect = UIScreen.main.bounds
//        let str:NSString  = NSString.init(cString: messageInfo.content.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!
        // 对话框大小计算
        let labelSize:CGSize = UILabel.sizeOfString(string: messageInfo.content! as NSString, font: UIFont.systemFont(ofSize: 16), maxWidth: screenRect.width-10-20-avatarSize.width * 2)
        
        if labelSize.height < avatarSize.height + 10{
            return avatarSize.height + 10
        }
        return labelSize.height + 5
        
        
    }
    
    func setupMessageCell(messageInfo:MessageBoby,user:FriendData){
        
       
        
        let screenRect:CGRect = UIScreen.main.bounds
            
        let labelSize:CGSize = UILabel.sizeOfString(string: messageInfo.content! as NSString, font: UIFont.systemFont(ofSize: 16), maxWidth: screenRect.width-10-20-avatarSize.width*2)
        
        let bubleSize:CGSize = CGSize.init(width: labelSize.width+10, height: labelSize.height)
        
        // 自己发的消息
        if messageInfo.sender.name  ==  user.name{
            self.avatar.frame = CGRect.init(x: screenRect.width-avatarSize.width-5 , y: 5, width: avatarSize.width, height: avatar.height)
            // 设置image 高度约束，不然cell 初始化后有概率 变成0
            _ = avatar.sd_layout().leftSpaceToView(self.contentView,320-50)?.topSpaceToView(self.contentView,5)?.widthIs(45)?.heightIs(45)
            
            
            self.avatar.image = UIImage.init(named: "lk")
            
            self.messageLabel.text = messageInfo.content
            self.messageLabel.frame = CGRect.init(x: screenRect.width-5-self.avatar.frame.width-2.5-labelSize.width, y: 5, width: labelSize.width, height: labelSize.height)
            
            self.messageLabel.textAlignment = .left
            
            self.bubleBackGround.image = UIImage.resizeableImage(name: "rightmessage")

            self.bubleBackGround.frame = CGRect.init(x: screenRect.width-5-self.avatar.frame.width-5-bubleSize.width, y: 5, width: bubleSize.width, height: bubleSize.height)
            
            // 取消动画，不然显示动画 不好看
            avatar.layer.removeAllAnimations()
            messageLabel.layer.removeAllAnimations()
            bubleBackGround.layer.removeAllAnimations()
            
            
            
        
        }
        // 别人发的消息
        else{
            self.avatar.frame = CGRect.init(x: 5, y: 5, width: avatarSize.width, height: avatarSize.height)
             _ = avatar.sd_layout().leftSpaceToView(self.contentView,5)?.topSpaceToView(self.contentView,5)?.widthIs(45)?.heightIs(45)
            
            self.avatar.image = UIImage.init(named: "avartar")
            
            self.messageLabel.text = messageInfo.content
            
            self.messageLabel.frame = CGRect.init(x: self.avatar.frame.origin.x + self.avatar.frame.width + 5 + 12.5, y: 5, width: labelSize.width, height: labelSize.height)
            
            self.messageLabel.textAlignment = .left
            self.bubleBackGround.image = UIImage.resizeableImage(name: "leftmessage")

            self.bubleBackGround.frame = CGRect.init(x: self.avatar.frame.origin.x + self.avatar.frame.width+5, y: 5, width: bubleSize.width, height: bubleSize.height)
            // 取消动画，不然显示动画 不好看
            avatar.layer.removeAllAnimations()
            messageLabel.layer.removeAllAnimations()
            bubleBackGround.layer.removeAllAnimations()
            
            

            
            
            
        }
        
       
        
        
    }
    
    
    
        
        
    

}
