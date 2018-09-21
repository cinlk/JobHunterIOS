//
//  PersonCardCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/28.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher

@objcMembers class PersonCardCell: UITableViewCell {

    
    //头像
    private lazy var avartar:UIImageView = {
        var v = UIImageView.init(frame: CGRect.init(x: ScreenW - 45 - 5, y: 5, width: 45, height: 45))
        
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        return v
        
    }()
    
    // 背景气泡
    private lazy var bubbleBackGround:UIImageView =  {
        
        var bubble = UIImageView.init()
        bubble.image =  UIImage.resizeableImage(name: "rightmessage")
        bubble.isUserInteractionEnabled = true 
        return bubble
    }()
    
    // 名片 title
    private lazy var title: UILabel =  {
       var label = UILabel.init()
       label.text = "个人名片"
       label.textAlignment = .left
       label.setSingleLineAutoResizeWithMaxWidth(180)
       label.textColor = UIColor.white
       label.font = UIFont.systemFont(ofSize: 10)
       return label
    }()
    
    private lazy var line:UIView = {
       var line = UIView.init()
        line.backgroundColor = UIColor.white
        return line
    }()
    
    // 名片里的头像
    private lazy var imageV:UIImageView = {
        var im = UIImageView.init()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    
    private  lazy var name:UILabel = {
       var n = UILabel.init()
       n.textColor = UIColor.white
       n.setSingleLineAutoResizeWithMaxWidth(100)
       n.textAlignment = .left
       n.font = UIFont.boldSystemFont(ofSize: 10)
       return n
    }()
    
   dynamic  var mode:MessageBoby?{
    
    
        didSet{
        
            let url = URL.init(string: mode?.sender?.icon ?? "")
            self.imageV.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            
            name.text = mode?.sender?.name
            self.avartar.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            //avartar.image = UIImage.init(data: (mode?.sender?.icon)!)
            bubbleBackGround.setupAutoHeight(withBottomView: imageV, bottomMargin: 10)
            // 获取计算后的高度
            bubbleBackGround.layoutSubviews()
            
            self.setupAutoHeight(withBottomView: bubbleBackGround, bottomMargin: 15)
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        avartar.sd_cornerRadiusFromWidthRatio = 0.5
        
        self.contentView.addSubview(avartar)
        self.contentView.addSubview(bubbleBackGround)
        
        let views:[UIView] = [title, line, imageV, name]
        bubbleBackGround.sd_addSubviews(views)
        
        
        
        //bubbleBackGround.frame = CGRect.init(x:ScreenW-5-45-5-160 , y: 5, width: 165, height: 80)
        _ = bubbleBackGround.sd_layout().rightSpaceToView(self.contentView, 45+10)?.topSpaceToView(self.contentView,5)?.widthIs(170)
        
        _ = title.sd_layout().centerXEqualToView(bubbleBackGround)?.topSpaceToView(bubbleBackGround,10)?.autoHeightRatio(0)
        
        _ = line.sd_layout().leftEqualToView(bubbleBackGround)?.topSpaceToView(self.title,3)?.rightEqualToView(bubbleBackGround)?.heightIs(1)
        
        _ = imageV.sd_layout().leftSpaceToView(bubbleBackGround,10)?.topSpaceToView(line,5)?.widthIs(45)?.autoHeightRatio(1)
        _ = name.sd_layout().leftSpaceToView(imageV,5)?.topEqualToView(imageV)?.autoHeightRatio(0)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    class func reuseidentity()->String{
        return "personCardCell"
    }
    

    
    
}


// bubble view 能点击
extension PersonCardCell{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let bubbleCGRect = self.contentView.convert(point, to: bubbleBackGround)
        if self.bubbleBackGround.point(inside: bubbleCGRect, with: event){
            return super.hitTest(point, with: event)
        }
        return nil
    }
}
