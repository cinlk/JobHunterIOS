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
    // gif
    var gif:UIImageView?
    
    
    
    // 代码初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        avatar = UIImageView.init()
        messageLabel = UILabel()
        bubleBackGround = UIImageView()
        gif = UIImageView()
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = UIColor.black
        // 分行
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        
        
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(bubleBackGround)
        self.contentView.addSubview(gif!)
        self.bubleBackGround.addSubview(messageLabel)

        
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
        return labelSize.height + 10
        
        
    }
    
    // picture message setup
 
    
    
    // text message setup
    func setupMessageCell(messageInfo:MessageBoby,user:FriendData){
        
        self.gif?.frame = CGRect.zero
        self.messageLabel.attributedText = GetChatEmotion.shared.findAttrStr(text: messageInfo.content, font: messageLabel.font)
        
        
        var labelSize = messageLabel.sizeThatFits(CGSize(width: 200.0, height: CGFloat(FLT_MAX)))
        labelSize  = CGSize.init(width: labelSize.width, height: labelSize.height)
        
        _ = avatar.sd_layout().heightIs(45)?.topSpaceToView(self.contentView,5)?.widthIs(45)
        
        _ = messageLabel.sd_layout().widthIs(labelSize.width)?.heightIs(labelSize.height)
        
        
        let screenRect:CGRect = UIScreen.main.bounds
            
        //let labelSize:CGSize = UILabel.sizeOfString(string: messageInfo.content! as NSString, font: UIFont.systemFont(ofSize: 16), maxWidth: screenRect.width-10-20-avatarSize.width*2)
        
        let bubleSize:CGSize = CGSize.init(width: labelSize.width+20, height: labelSize.height+20)
        
        _ = bubleBackGround.sd_layout().topSpaceToView(self.contentView,5)?.heightIs(bubleSize.height)?.widthIs(bubleSize.width)

        // 自己发的消息
        if messageInfo.sender.name  ==  user.name{
            
            self.avatar.image = UIImage.init(named: "lk")
            self.avatar.frame = CGRect.init(x: screenRect.width-avatarSize.width-5 , y: 5, width: avatarSize.width, height: avatarSize.height)
           
            
            self.bubleBackGround.image = UIImage.resizeableImage(name: "rightmessage")

             self.bubleBackGround.frame = CGRect.init(x: screenRect.width-5-self.avatar.frame.width-5-bubleSize.width, y: 5, width: bubleSize.width, height: bubleSize.height)
            
             //_ = bubleBackGround.sd_layout().rightSpaceToView(avatar,5)?.widthIs(bubleSize.width)
            
             _ = self.messageLabel.sd_layout().topSpaceToView(self.bubleBackGround,10)?.rightSpaceToView(self.bubleBackGround,10)
            
            // 取消动画，不然显示动画 不好看
            avatar.layer.removeAllAnimations()
            messageLabel.layer.removeAllAnimations()
            bubleBackGround.layer.removeAllAnimations()
            print("self \(messageLabel)")
            
        
        }
        // 别人发的消息
        else{
            
            self.avatar.image = UIImage.init(named: "avartar")
            self.avatar.frame = CGRect.init(x: 5, y: 5, width: avatarSize.width, height: avatarSize.height)
            
            
            
 
            self.bubleBackGround.image = UIImage.resizeableImage(name: "leftmessage")

            self.bubleBackGround.frame = CGRect.init(x: self.avatar.frame.origin.x + self.avatar.frame.width+5, y: 5, width: bubleSize.width, height: bubleSize.height)
            // 用约束有bug?
            //_ = bubleBackGround.sd_layout().leftSpaceToView(avatar,55)?.widthIs(bubleSize.width)
            
            _ = self.messageLabel.sd_layout().topSpaceToView(self.bubleBackGround,10)?.leftSpaceToView(self.bubleBackGround,10)
            
            // 取消动画，不然显示动画 不好看
            avatar.layer.removeAllAnimations()
            messageLabel.layer.removeAllAnimations()
            bubleBackGround.layer.removeAllAnimations()
            
            
             print("other \(messageLabel) ")
            
            
            
        }
        
       
        
        
    }
    
    
    
        
        
    

}
