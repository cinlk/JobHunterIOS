//
//  ImageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit




fileprivate let imageSize:CGSize = CGSize.init(width: 120, height: 135)

@objcMembers class ImageCell: UITableViewCell {

    private let appFileManger = AppFileManager.shared
    
    // old imageFrame
    private var oldFrame:CGRect = CGRect.zero
    
    private lazy var avartar:UIImageView = {
        var v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
        
    }()
    
    // 图片 切角，和 可点击放大 （拉钩的效果）？？？
    private lazy var imageV:UIImageView = { [unowned self] in
        var v = UIImageView()
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        v.isUserInteractionEnabled = true
        // 放大效果
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showBig(tap:)))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    
    
    var storeImage:((_ image:UIImage)->Void)?
    
        
    
    
    
   dynamic  var mode:MessageBoby? {
        didSet{
            guard let mode = mode  else {
                return
            }
            
            setView(mode: mode)
            
            self.setupAutoHeight(withBottomView: imageV, bottomMargin: 10)
            
        }
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageV)
        self.contentView.addSubview(avartar)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        avartar.setCircle()
      

    }
    
    
    private func setView(mode: MessageBoby){
        
        guard let imageName = String.init(data: mode.content!, encoding: String.Encoding.utf8) else {
            return
        }
        
        
        self.avartar.image = UIImage.init(data: mode.sender!.icon!)
        // 获取images
        if let imageData =  appFileManger.getImageDataBy(userID: (mode.receiver?.userID)!, fileName: imageName){
            self.imageV.image = UIImage.init(data: imageData)
        }
        imageV.sd_clearAutoLayoutSettings()
        
        // 背景图片拉伸
        let stretchInset = UIEdgeInsetsMake(30, 28, 23, 28)
        var stretchImage:UIImage!
        var bubbleMaskImage:UIImage!
        
        // 自己发的消息
        if mode.sender?.userID == myself.userID{
            
            stretchImage = UIImage.init(named: "senderImageMask")
            bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
            
            
            
            avartar.frame = CGRect.init(x: ScreenW - 45 - 5, y: 5, width: 45, height: 45)
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
    
    
    @objc private func showBig(tap: UITapGestureRecognizer){
        if let imageView = tap.view as? UIImageView{
            ShowBigImageView(imageView: imageView)
        }
    }
    
    private func ShowBigImageView(imageView:UIImageView){
        
        let currentImage = imageView.image
        
 
        let windows = UIApplication.shared.keyWindow
        
        let backGroudView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        
        oldFrame = imageView.convert(imageView.bounds, to: windows)
 
        backGroudView.backgroundColor = UIColor.init(r: 107, g: 107, b: 99, alpha: 06)
        
        backGroudView.alpha = 0
        
        
        // 重新绘制imageView
        
        
        let  newImageView = UIImageView.init(frame: oldFrame)
        newImageView.image = currentImage
        newImageView.tag = 0
        backGroudView.addSubview(newImageView)
        
        windows?.addSubview(backGroudView)
        
        
        // backGround 点击事件
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideImageView(tap:)))
        tap.delegate = self
        backGroudView.addGestureRecognizer(tap)
        
        //
        // 长按 弹出保存
        let longpress = UILongPressGestureRecognizer.init(target: self, action: #selector(store(tap:)))
        longpress.minimumPressDuration = 2
        longpress.delegate = self
        backGroudView.addGestureRecognizer(longpress)
        
        // 放大imageView
        UIView.animate(withDuration: 0.4, animations: {
            var y:CGFloat = 0
            
            var width:CGFloat = 0
            var height:CGFloat = 0
            
            y = (ScreenH - (currentImage?.size.height)! * (ScreenW / (currentImage?.size.width)!))*0.5
            width =  ScreenW
            height = (currentImage?.size.height)! * (ScreenW / (currentImage?.size.width)!)
            newImageView.frame = CGRect.init(x: 0, y: y, width: width, height: height)
            backGroudView.alpha = 1
            
        }, completion: nil)
    }
    
    
    //
    @objc func hideImageView(tap: UITapGestureRecognizer){
        
        let backgroundView = tap.view
        
        // 原始imageView
        let imageView = tap.view?.viewWithTag(0)
        backgroundView?.alpha = 0
        //backgroundView?.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.5, animations: {
            imageView?.frame = self.oldFrame
            
        }) { (bool) in
            backgroundView?.removeFromSuperview()
            
        }
        
    }
    
    
    @objc private func store(tap: UILongPressGestureRecognizer){
        // 结束状态才执行，不然present alertVC 多次 警告
        if  tap.state == .began{
            self.storeImage?(self.imageV.image!)
        }
    }
}



