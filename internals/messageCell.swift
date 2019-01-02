//
//  messageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/14.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher


fileprivate let textWidth:CGFloat = 250
// 根据文字计算的宽度不够，加上这
fileprivate let extraWitdhTextView:CGFloat = 10
fileprivate let fontSize:CGFloat = 16


class messageCell: UITableViewCell {

    private lazy  var avatar:UIImageView = {
       let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
        img.clipsToBounds = true
        img.backgroundColor = UIColor.clear
        return img 
        
    }()
    
    private lazy var messgeText:UITextView = {
        let text = UITextView.init(frame: CGRect.zero)
        text.isScrollEnabled = false
        text.isEditable = false
        text.font = UIFont.systemFont(ofSize: fontSize)
        text.textAlignment = .left
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.clear
        text.delegate = self
        text.clipsToBounds = true
        // 取消与顶部的距离
        text.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        // 取消拖动
        if #available(iOS 11.0, *){
            text.textDragInteraction?.isEnabled = false
        }
        
        
        return text
        
        
    }()
    
    
    private var bubleBackGround: UIImageView = UIImageView.init(frame: CGRect.zero)
 

    // 代码初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        let views:[UIView] = [avatar,bubleBackGround,messgeText]
        self.contentView.sd_addSubviews(views)
        avatar.setCircle()


        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        messgeText.layer.removeAllAnimations()
        avatar.layer.removeAllAnimations()
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
        
        
        let replaceStr =  GetChatEmotion.shared.findAttrStr(text: strs, font: UIFont.systemFont(ofSize: fontSize), replace:  true )
        
        let labelSize:CGSize = UITextView.sizeOfString(string: replaceStr?.string as! NSString , font: UIFont.systemFont(ofSize: fontSize), maxWidth: textWidth)
        
        if labelSize.height < avatarSize.height && labelSize.height <= UIFont.systemFont(ofSize: fontSize).lineHeight{
            
            return avatarSize.height + 10 + 5
        }
        return labelSize.height + 15 + 5 + 20
        
    }
    
    
    
    func setupMessageCell(messageInfo:MessageBoby,chatUser:PersonModel){
        
        guard let content = messageInfo.content, let strs = String.init(data: content, encoding: String.Encoding.utf8), let attrStr =  GetChatEmotion.shared.findAttrStr(text: strs, font: UIFont.systemFont(ofSize: fontSize)) else {
            
            avatar.isHidden = true
            messgeText.isHidden = true
            return
            
        }
        
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.lineBreakMode = .byCharWrapping
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: paragrahStyle], range: NSRange.init(location: 0, length: attrStr.length))
        self.messgeText.attributedText = attrStr
        
        
        let replaceStr =  GetChatEmotion.shared.findAttrStr(text: strs, font: UIFont.systemFont(ofSize: fontSize), replace:  true )
        
        
        
        var labelSize = UITextView.sizeOfString(string: replaceStr?.string as! NSString , font: UIFont.systemFont(ofSize: fontSize), maxWidth: textWidth)
        
        // 高度加5 textview 换行后内容正常显示
        labelSize = CGSize.init(width: labelSize.width, height: labelSize.height + CGFloat(5))
        
        var h:CGFloat = 0
        var y:CGFloat = 0
        let line =  Int(labelSize.height / (messgeText.font?.lineHeight)!)
        // 只有一行字 居中显示
        if  line == 1 {
            y = (avatarSize.height - labelSize.height) / 2
 
        }else{
            // 内容向下偏移
            y = 5
            if line >= 3 {
                messgeText.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)

            }
        }
        
        h = labelSize.height
        
        
        let bubleSize:CGSize = CGSize.init(width: labelSize.width + 10 + 5 + extraWitdhTextView, height: h + 10)

        // 自己发的消息
        if messageInfo.sender?.userID  ==  myself.userID{
            
            if let icon = myself.icon {
                let url = URL.init(string: icon)
                self.avatar.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                // 使用默认头像
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            
            self.avatar.frame = CGRect.init(x: ScreenW-avatarSize.width-5 , y: 0, width: avatarSize.width, height: avatarSize.height)
            
            // 拉伸图片
            self.bubleBackGround.image = UIImage.resizeableImage(name: "mebubble")
            self.bubleBackGround.tintColor = UIColor.init(r: 136, g: 211, b: 67)
            
            
            self.bubleBackGround.frame = CGRect.init(x: ScreenW-5-self.avatar.frame.width-5-bubleSize.width, y: y-5, width: bubleSize.width, height: bubleSize.height)
            self.messgeText.frame = CGRect.init(x: ScreenW-5-self.avatar.frame.width-5-bubleSize.width + 5 , y: y, width: labelSize.width + extraWitdhTextView, height: h)
            
        }
        // 别人发的消息
        else{
            
            if let icon = chatUser.icon {
                let url = URL.init(string: icon)
                self.avatar.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                self.avatar.image =  #imageLiteral(resourceName: "default")
            }
            self.avatar.frame = CGRect.init(x: 5, y: 0, width: avatarSize.width, height: avatarSize.height)
            
            
            // 拉伸图片
            self.bubleBackGround.image = UIImage.resizeableImage(name: "yoububble")
            self.bubleBackGround.tintColor = UIColor.init(r: 50, g: 195, b: 51)
            
            
            self.bubleBackGround.frame = CGRect.init(x: 5 + self.avatar.frame.width + 5, y: y-5, width: bubleSize.width, height: bubleSize.height)
            
            self.messgeText.frame = CGRect.init(x: 5 + self.avatar.frame.width + 5 + 5, y: y, width: labelSize.width, height: labelSize.height)
            
        }
        
    }
    

}



extension messageCell: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if textAttachment.isKind(of: ChatEmotionAttachment.self){
            return false
        }
        
        return true 
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
