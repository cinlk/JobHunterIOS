//
//  extension+imge.swift
//  internals
//
//  Created by ke.liang on 2017/12/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
 

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
            
        }else{
            UIBezierPath(roundedRect: rect, cornerRadius: 5).addClip()
        }
        
        // 设置填充颜色
        ctx.setFillColor(backColor.cgColor)
        //ctx.setAlpha(0)
        // 填充绘制
        ctx.fill(rect)
        let attr = [ NSAttributedStringKey.foregroundColor : textColor, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 10)]
        // 写入文字
        (letter as NSString).draw(at: CGPoint(x: 2.5, y: 2.5), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    
    // 改变图片大小和render mode
    func changesize(size:CGSize, renderMode: UIImageRenderingMode = .alwaysTemplate) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(renderMode)
    }
    
    //拉伸图片
    class func resizeableImage(name:String)->UIImage{
        
        let image = UIImage.init(named: name)!

        return image.resizableImage(withCapInsets: UIEdgeInsets.init(top: 22, left: 26, bottom: 22, right: 26), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        
    }
    
    
}

// 翻转图片
extension UIImage{
    
    class func flipImage(image:UIImage,orientation:UIImageOrientation)->UIImage{
        return UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: orientation)
    }
    
   
    
}

// 图片颜色
extension UIImage {
    func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: rect, mask: self.cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let imageFromCurrentContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: imageFromCurrentContext!.cgImage!, scale: 1.0, orientation:.downMirrored)
    }
}




// tobase64
extension UIImage{
    
    func toBase64String()->String{
        // 只存储压缩的图片
        if let data = UIImageJPEGRepresentation(self, 0){
            return data.base64EncodedString()
        }
        
        // 判断为空的情况
        return ""
    }
    
}

