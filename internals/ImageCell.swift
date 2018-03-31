//
//  ImageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let imageSize:CGSize = CGSize.init(width: 100, height: 100)

@objcMembers class ImageCell: UITableViewCell {

    private let appFileManger = AppFileManager.shared
    
    private lazy var avartar:UIImageView = {
        var v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        return v
        
    }()
    
    // 图片 切角，和 可点击放大 （拉钩的效果）？？？
    private lazy var imageV:UIImageView = {
        var v = UIImageView()
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
    }()
    
    
   dynamic  var mode:MessageBoby? {
        didSet{
            guard let mode = mode  else {
                return
            }
            guard let imageName = String.init(data: mode.content!, encoding: String.Encoding.utf8) else {
                return
            }
            self.avartar.image = UIImage.init(data: mode.sender!.icon!)
    
            // 获取images
            if let imageData =  appFileManger.getImageDataBy(userID: (mode.receiver?.userID)!, fileName: imageName){
                self.imageV.image = UIImage.init(data: imageData)
            }
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
        avartar.frame = CGRect.init(x: ScreenW - 45 - 5, y: 5, width: 45, height: 45)
        
        _ = imageV.sd_layout().rightSpaceToView(avartar,10)?.topSpaceToView(self.contentView,20)?.widthIs(imageSize.width)?.autoHeightRatio(4/3)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func reuseIdentify()->String{
        return "imageCell"
    }
    
    
}


