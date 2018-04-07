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
        bubleBackGround.isUserInteractionEnabled = true
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    class func reuseidentify()->String{
        return "messageCell"
    }
    
    class func heightForCell(messageInfo:MessageBoby)->CGFloat{
        
        guard let content = messageInfo.content else { return 0 }
        guard let strs = String.init(data:  content, encoding: String.Encoding.utf8) else { return  0 }
        
        let labelSize:CGSize = UILabel.sizeOfString(string: strs as! NSString, font: UIFont.systemFont(ofSize: 16), maxWidth: ScreenW-10-20-avatarSize.width * 2)
        
        
        
        if labelSize.height < avatarSize.height + 10{
            return avatarSize.height + 10
        }
        return labelSize.height + 10
        
    }
    
    // picture message setup
    // text message setup
    
    
    func setupMessageCell(messageInfo:MessageBoby,chatUser:PersonModel){
        
        guard let content = messageInfo.content else { return }
        
        guard let strs = String.init(data: content, encoding: String.Encoding.utf8) else { return   }
        
        self.messageLabel.attributedText = GetChatEmotion.shared.findAttrStr(text: strs, font: messageLabel.font)
        
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
        if messageInfo.sender?.userID  ==  myself.userID{
            
            if let icon = myself.icon {
                self.avatar.image = UIImage.init(data: icon)
            }else{
                // default 头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            
            self.avatar.frame = CGRect.init(x: ScreenW-avatarSize.width-5 , y: 0, width: avatarSize.width, height: avatarSize.height)
            
           
            // 图片左边15 不拉伸 上25不拉伸，其他部分拉伸
            self.bubleBackGround.image = UIImage.init(named: "mebubble")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 25)
            
            self.bubleBackGround.frame = CGRect.init(x: ScreenW-5-self.avatar.frame.width-5-bubleSize.width, y: 0, width: bubleSize.width, height: bubleSize.height)
            self.messageLabel.frame = CGRect.init(x: ScreenW-5-self.avatar.frame.width-5-bubleSize.width + 10 , y: y, width: labelSize.width, height: labelSize.height)
            
        }
        // 别人发的消息 chatUserID
            
        else{
            
            if let icon = chatUser.icon {
                self.avatar.image = UIImage.init(data: icon)
            }else{
                // default 头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            self.avatar.frame = CGRect.init(x: 5, y: 0, width: avatarSize.width, height: avatarSize.height)
            
            
            //self.bubleBackGround.image = UIImage.resizeableImage(name: "leftmessage")
            
            self.bubleBackGround.image = UIImage.init(named: "yoububble")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 25)
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
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(copyText))
        gesture.minimumPressDuration = 3
        gesture.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(gesture)
    }

     @objc private  func clickLable(){
        
        // 这里会 影藏键盘？？ 怎么禁止影藏？
        becomeFirstResponder()
        let menu = UIMenuController.shared
        let copy = UIMenuItem.init(title: "复制", action: #selector(copyText))
        menu.menuItems = [copy]
        menu.setTargetRect(bounds, in: self)
        menu.setMenuVisible(true, animated: true)
        
        
    }
    
    
    @objc private func copyText(){
        
        // 长按自动复制 文本
        
        // 复制富文 表情用[xxx] 表示的表情消息
        UIPasteboard.general.string = self.getEmotionString()
        // label 所在的viewController
        if let view = self.getParentViewController()?.view{
            showOnlyTextHub(message: "已复制到剪切板", view: view)
        }
    }
    
    
    // 除了复制功能以外 其他交换禁止
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText){
            return true
        }
        return false
    }
}



extension messageCell{
    // bubble view 能点击
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let bubbleCGRect = self.contentView.convert(point, to: bubleBackGround)
        if self.bubleBackGround.point(inside: bubbleCGRect, with: event){
            return super.hitTest(point, with: event)
        }
        return nil
    }
}
