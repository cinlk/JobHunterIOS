//
//  myextension.swift
//  internals
//
//  Created by ke.liang on 2017/9/20.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation



private let  v =  UIImage.init()
private let defaulImg = build_image(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH), color: UIColor.navigationBarColor())
//private let bm = build_image(size: CGSize.init(width: NAV_BAR_FRAME_WIDTH, height: NAV_BAR_FRAME_HEIGHT), alpha: 1)

extension UINavigationBar{
    
    
    
    // change to translucent
    func settranslucent(_ tag: Bool){
        
        // MARK 如何保证 取消背景后的navigationbar，在恢复背景后 和以前效果一直。且
        // translate 为透明
        // 显示 lable
        //self.tintColor  = UIColor.black
        if tag == true{
            //self.settranslucent(<#T##tag: Bool##Bool#>)
            self.setBackgroundImage(v, for: .default)
            self.shadowImage = v
            //self.backgroundColor =  UIColor.clear
            self.isTranslucent = true
        }
        else{
            // 背景image为 navigationbar系统默认颜色？？
            
            self.setBackgroundImage(defaulImg, for: .default)
            //self.shadowImage = self.shadowImage
            self.isTranslucent = false
            
            
        }
    }
    
    // 控制backimage 来设置背景
    func backgroudImage(alpha:CGFloat){
        //self.setBackgroundImage(build_image(size: CGSize(width: NAV_BAR_FRAME_WIDTH,height:NAV_BAR_FRAME_HEIGHT), alpha: alpha), for: .default)
        self.isTranslucent = true
    }
    
    //
}


// viwe  对应的 uiviewcontroller
extension UIView{
    
    
    func viewController(aClass: AnyClass) -> UIViewController?{
        var next=self.superview;
        while(next != nil){
            let nextResponder = next?.next
            if((nextResponder?.isKind(of:aClass)) != nil){
                return nextResponder as? UIViewController
            }
            next=next?.superview
        }
        return nil
    }

    
}


extension UILabel{
    class func sizeOfString(string:NSString,font:UIFont,maxWidth:CGFloat)->CGSize{
        
        let size = string.boundingRect(with: CGSize.init(width: maxWidth, height: 1200), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
        // 与边框的距离
        return CGSize.init(width: size.width + 15, height: size.height + 20)
        
    }
}

//  MARK 图文混排?

extension UITextView {
    // MARK:- 获取textView属性字符串,换成对应的表情字符串
    func getEmotionString() -> String {
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedStringKey.attachment] as? ChatEmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.text!)
            }
        }
        
        return attrMStr.string
    }
    
    func insertEmotion(emotion: MChatEmotion) {
        // 空白
        if emotion.isEmpty {
            return
        }
        
        // 删除表情
        if emotion.isRemove {
            deleteBackward()
            return
        }
        
        // 表情
        let attachment = ChatEmotionAttachment()
        attachment.text = emotion.text
        attachment.image = UIImage(contentsOfFile: emotion.imgPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        attributedText = attrMStr
        self.font = font
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}

