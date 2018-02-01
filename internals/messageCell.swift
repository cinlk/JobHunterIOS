//
//  messageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/14.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {

    private var avatar:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
    
    private lazy var messageLabel:MessageLabel = {
        let ml = MessageLabel.init(frame: CGRect.zero)
        ml.font = UIFont.systemFont(ofSize: 16)
        ml.textColor = UIColor.black
        ml.numberOfLines = 0
        ml.textAlignment = .left
        ml.lineBreakMode = .byWordWrapping
        return ml
    }()
    private var bubleBackGround: UIImageView = UIImageView.init(frame: CGRect.zero)
 
    
    
    // 代码初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
       
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear

    
    }
    
    override func layoutSubviews() {
        
        avatar.setCircle()
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(bubleBackGround)
        self.contentView.addSubview(messageLabel)
        // 取消view动画， 影藏keyboard后 table 向上滑动 出现cell 动画？
        avatar.layer.removeAllAnimations()
        messageLabel.layer.removeAllAnimations()
        bubleBackGround.layer.removeAllAnimations()
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
        
        let labelSize:CGSize = UILabel.sizeOfString(string: messageInfo.content as NSString, font: UIFont.systemFont(ofSize: 16), maxWidth: ScreenW-10-20-avatarSize.width * 2)
        
        
        if labelSize.height < avatarSize.height + 10{
            return avatarSize.height + 10
        }
        return labelSize.height + 10
        
    }
    
    // picture message setup
    // text message setup
    func setupMessageCell(messageInfo:MessageBoby,user:FriendModel){
        
        
        self.messageLabel.attributedText = GetChatEmotion.shared.findAttrStr(text: messageInfo.content, font: messageLabel.font)
        let labelSize = messageLabel.sizeThatFits(CGSize(width: ScreenW-10-20-avatarSize.width * 2, height: CGFloat(Float.greatestFiniteMagnitude)))
        
       
        var h:CGFloat = 0
        var y:CGFloat = 5
        
        // 只有一行字 居中显示
        if labelSize.height < 20 {
            h = avatarSize.height - 10
            y = (avatarSize.height - labelSize.height) / 2
            
            
        }else{
            h = labelSize.height
            y = 5
        }
        
        
        
        // 让labe 左右两边间隔5 像素 (25)
        let bubleSize:CGSize = CGSize.init(width: labelSize.width + 20 + 5, height: h + 10)

        // 自己发的消息
        if messageInfo.sender.id  ==  user.id{
            
            self.avatar.image = UIImage.init(named: messageInfo.sender.avart)
            self.avatar.frame = CGRect.init(x: ScreenW-avatarSize.width-5 , y: 0, width: avatarSize.width, height: avatarSize.height)
           
            
           
            //self.bubleBackGround.image = UIImage.resizeableImage(name: "rightmessage")
            self.bubleBackGround.image = UIImage.init(named: "mebubble")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 25)
            
            self.bubleBackGround.frame = CGRect.init(x: ScreenW-5-self.avatar.frame.width-5-bubleSize.width, y: 0, width: bubleSize.width, height: bubleSize.height)
            self.messageLabel.frame = CGRect.init(x: ScreenW-5-self.avatar.frame.width-5-bubleSize.width + 10 , y: y, width: labelSize.width, height: labelSize.height)
            
        }
        // 别人发的消息
        else{
            
            self.avatar.image = UIImage.init(named: messageInfo.sender.avart)
            self.avatar.frame = CGRect.init(x: 5, y: 0, width: avatarSize.width, height: avatarSize.height)
            
            
            //self.bubleBackGround.image = UIImage.resizeableImage(name: "leftmessage")
            
            self.bubleBackGround.image = UIImage.init(named: "yoububble")?.stretchableImage(withLeftCapWidth: 21, topCapHeight: 25)
            self.bubleBackGround.frame = CGRect.init(x: 5 + self.avatar.frame.width + 5, y: 0, width: bubleSize.width, height: bubleSize.height)
            self.messageLabel.frame = CGRect.init(x: 5 + self.avatar.frame.width + 5 + 10, y: y, width: labelSize.width, height: labelSize.height)
            
            
            
        }
        
     

       
        
        
    }
    
    

}


// 自定义可复制的uilabe
fileprivate class MessageLabel:UILabel{
    
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addGesture(){
        isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(clickLable))
        gesture.minimumPressDuration = 3
        gesture.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(gesture)
    }

     @objc private  func clickLable(){
        
        becomeFirstResponder()
        
        let menu = UIMenuController.shared
        
        let copy = UIMenuItem.init(title: "复制", action: #selector(copyText))
        menu.menuItems = [copy]
        menu.setTargetRect(bounds, in: self)
        menu.setMenuVisible(true, animated: true)
        
        
    }
    
    
    @objc private func copyText(){
        
        UIPasteboard.general.string = self.text
        
    }
    
    // 除了复制功能以外 其他交换禁止
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText){
            return true
        }
        return false
    }
}



