//
//  myextension.swift
//  internals
//
//  Created by ke.liang on 2017/9/20.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation




func  build_image(size: CGSize, alpha:CGFloat)->UIImage{
    
    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let color = UIColor.gray
    
    
    UIGraphicsBeginImageContext(frame.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(frame)
    
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
    
    
    
}




private let  v = UIImage()
private let bm = build_image(size: CGSize(width: NAV_BAR_FRAME_WIDTH,height:NAV_BAR_FRAME_HEIGHT), alpha: 1)

extension UINavigationBar{
    
    
    
    // change to translucent
    func settranslucent(_ tag: Bool){
        
        // 显示 lable
        self.tintColor  = UIColor.black
        
        if tag == true{
            self.setBackgroundImage(v, for: .default)
            self.shadowImage = v
            self.isTranslucent = true
            self.backgroundColor =  nil
            
           

        }
        else{
            print("nav bar \(self.size)")
            self.setBackgroundImage(bm, for: .default)
            self.isTranslucent = false
            

          
        }
    }
    
    // 控制backimage 来设置背景
    func backgroudImage(alpha:CGFloat){
        self.setBackgroundImage(build_image(size: CGSize(width: NAV_BAR_FRAME_WIDTH,height:NAV_BAR_FRAME_HEIGHT), alpha: alpha), for: .default)
        self.isTranslucent = true
    }
    
    //
}


extension UIImage{
    
    
    // gif 图片解析, gif 多个图片片段按时间顺序组成
    static func animationImageWithData(data:NSData?) -> UIImage {
        
        if data != nil {
            
            let source:CGImageSource = CGImageSourceCreateWithData(data as! CFData, nil)!
            
            let count:size_t = CGImageSourceGetCount(source)
            
            var animatedImage:UIImage?
            
            if count <= 1 {
                
                animatedImage = UIImage.init(data: data! as Data)
                
            }else {
                
                var images = [UIImage]()
                
                var duration:TimeInterval = 0.0;
                
                for i:size_t in size_t(0.0) ..< count {
                    
                    let image:CGImage? = CGImageSourceCreateImageAtIndex(source, i, nil)!
                    
                    if image == nil {
                        
                        continue
                    }
                    
                    duration = TimeInterval(frameDuration(index: i, source: source)) + duration;
                    
                    images.append(UIImage.init(cgImage: image!))
                }
                if (duration == 0.0) {
                    
                    duration = Double(1.0 / 10.0) * Double(count);
                }
                animatedImage = UIImage.animatedImage(with: images, duration: 2.0);
            }
            
            return animatedImage!
        }else {
            
            return UIImage()
        }
        
    }

    // 获取每一帧延时时间
    static func frameDuration(index:Int,source:CGImageSource) -> Float {
        
        
        var frameDuration:Float = 0.1;
        
        let cfFrameProperties:CFDictionary = CGImageSourceCopyPropertiesAtIndex(source, index, nil)!
        
        let frameProperties:NSDictionary = cfFrameProperties as CFDictionary
        
        let gifProperties:NSDictionary = frameProperties.object(forKey: kCGImagePropertyGIFDictionary as NSString) as! NSDictionary
        
        let delayTimeUnclampedProp:NSNumber? = gifProperties.object(forKey: kCGImagePropertyGIFUnclampedDelayTime as NSString) as? NSNumber
        
        if delayTimeUnclampedProp != nil {
            
            frameDuration = (delayTimeUnclampedProp?.floatValue)!
        }else {
            
            let delayTimeProp:NSNumber? = gifProperties.object(forKey: kCGImagePropertyGIFDelayTime as NSString) as? NSNumber
            
            if delayTimeProp != nil {
                
                frameDuration = (delayTimeProp?.floatValue)!
            }
            
            if frameDuration < 0.011{
                
                frameDuration = 0.100;
            }
        }
        return frameDuration
    }

    
    
    func str_image(_ text:String,size:(CGFloat,CGFloat),backColor:UIColor=UIColor.white,textColor:UIColor=UIColor.black,isCircle:Bool=false) -> UIImage?{
        // 过滤空""
        if text.isEmpty { return nil }
        // TODO 去字符串长度， 设置 images 长度？？？
        let letter = (text as NSString).substring(to: 2)
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide*0.5).addClip()
        }
        // 设置填充颜色
        //ctx.setFillColor(backColor.cgColor)
        ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 0)
        //ctx.setAlpha(0)
        // 填充绘制
        ctx.fill(rect)
        let attr = [ NSAttributedStringKey.foregroundColor : textColor, NSAttributedStringKey.font : UIFont.systemFont(ofSize: minSide*0.5)]
        // 写入文字
        (letter as NSString).draw(at: CGPoint(x: 3, y: 10), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    func barImage(size:CGSize, offset:CGPoint) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: CGRect(x: offset.x, y: offset.y, width: size.width - offset.x, height: size.height - offset.y))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return newImage
        
    }
    
    //拉伸图片
    class func resizeableImage(name:String)->UIImage{
        let image = UIImage.init(named: name)
        let top = (image?.size.height)! * 0.6
        let bottom = (image?.size.height)! * 0.5
        let lr = (image?.size.height)! * 0.5
        
        return (image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: top, left: lr, bottom: bottom, right: lr), resizingMode: .stretch))!
        
    }
    
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

