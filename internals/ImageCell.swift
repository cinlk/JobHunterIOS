//
//  ImageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher



fileprivate let imageSize:CGSize = CGSize.init(width: 120, height: 135)

@objcMembers class ImageCell: UITableViewCell {

    private let appFileManger = AppFileManager.shared
    
    // 图片zoom 属性
    private var startingFrame:CGRect?
    private var blackBackgroundView:UIView?
    
    private lazy var avartar:UIImageView = {
        var v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
        
    }()
    
    // 图片 切角，和 可点击放大
    private lazy var imageV:UIImageView = { [unowned self] in
        var v = UIImageView()
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        v.isUserInteractionEnabled = true
        // 放大效果
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(startZoomImage(tap:)))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    
    
    // 存储图片到本地
    var storeImage:((_ image:UIImage)->Void)?
    
    
   dynamic var mode:PicutreMessage? {
        didSet{
            guard let mode = mode  else {
                avartar.isHidden = true
                imageV.isHidden = true
                return
            }
            
            guard let imageName = mode.imageFileName else {
                avartar.isHidden = true
                imageV.isHidden = true
                return
            }
            
            let url = URL.init(string: myself.icon ?? "")
            
            self.avartar.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            
            // 获取images
            if let imageData =  appFileManger.getImageDataBy(userID: (mode.receiver?.userID)!, fileName: imageName){
                self.imageV.image = UIImage.init(data: imageData)
            }
            imageV.sd_clearAutoLayoutSettings()
            
            // 背景图片拉伸
            let stretchInset = UIEdgeInsets(top: 30, left: 28, bottom: 23, right: 28)
            var stretchImage:UIImage!
            var bubbleMaskImage:UIImage!
            
            // 自己发的消息
            if mode.sender?.userID == myself.userID{
                
                stretchImage = UIImage.init(named: "senderImageMask")
                bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
                
                
                
                avartar.frame = CGRect.init(x: GlobalConfig.ScreenW - 45 - 5, y: 5, width: 45, height: 45)
                _ = imageV.sd_layout().rightSpaceToView(avartar,10)?.topEqualToView(self.avartar)?.widthIs(imageSize.width)?.heightIs(imageSize.height)
                
                
            }else{
                stretchImage = UIImage.init(named: "receiverImageMask")
                bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
                avartar.frame = CGRect.init(x: 5, y: 5, width: 45, height: 45)
                _ = imageV.sd_layout().leftSpaceToView(avartar,10)?.topEqualToView(self.avartar)?.widthIs(imageSize.width)?.heightIs(imageSize.height)
                
            }
            
            
            // 图片设置用裁减背景图片的图层
            let layer = CALayer()
            layer.contents = bubbleMaskImage?.cgImage
            layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage!)
            layer.frame = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            
            layer.contentsScale = UIScreen.main.scale
            layer.opacity = 1
            self.imageV.layer.mask = layer
            self.imageV.layer.masksToBounds = true
            
            
            
            
            self.setupAutoHeight(withBottomView: imageV, bottomMargin: 10)
            
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageV)
        self.contentView.addSubview(avartar)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        avartar.setCircle()
        
        
      

    }
    
    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func reuseIdentify()->String{
        return "imageCell"
    }
    
    // 由于背景图被拉伸过，告诉图层拉伸的比例
    private func  CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect{
        return CGRect(x: image.capInsets.left / image.size.width, y: image.capInsets.top / image.size.height, width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width, height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height)
    }
    
}



// 图片点击放大
extension ImageCell{
    
    
    @objc private func startZoomImage(tap: UITapGestureRecognizer){
        if let imageView = tap.view as? UIImageView{
            ShowBigImageView(imageView: imageView)
        }
    }
    
    private func ShowBigImageView(imageView:UIImageView){
        
        
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        
        let zoomImageView = UIImageView.init(frame: startingFrame!)
        zoomImageView.backgroundColor = UIColor.clear
        zoomImageView.image = imageView.image
        zoomImageView.contentMode = .scaleToFill
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow{
            
            self.imageV.isHidden = true
            blackBackgroundView = UIView.init(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.isUserInteractionEnabled = true
         
            // 保存
            let longpress = UILongPressGestureRecognizer.init(target: self, action: #selector(store(tap:)))
            longpress.minimumPressDuration = 2
            zoomImageView.addGestureRecognizer(longpress)
            
            keyWindow.addSubview(self.blackBackgroundView!)
            keyWindow.addSubview(zoomImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //根据屏幕计算放大后的尺寸
                self.blackBackgroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomImageView.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: height)
                zoomImageView.center = keyWindow.center
                
                
            }, completion: nil)
        }

        
      
    }
    
    
    //
    @objc private func zoomOut(tap: UITapGestureRecognizer){
        if  let  zoomoutImage = tap.view{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomoutImage.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }) { (completed) in
                zoomoutImage.removeFromSuperview()
                self.imageV.isHidden = false
            }
        }
    }
    
    
    @objc private func store(tap: UILongPressGestureRecognizer){
        // 结束状态才执行，不然present alertVC 多次 警告
        if  tap.state == .began{
            self.storeImage?(self.imageV.image!)
        }
    }
}



