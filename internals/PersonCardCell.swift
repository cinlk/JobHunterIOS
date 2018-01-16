//
//  PersonCardCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/28.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class PersonCardCell: UITableViewCell {

    
    //avartar
    lazy var avartar:UIImageView = {
        var v = UIImageView.init()
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        return v
        
    }()
    
    // bubble
    lazy var bubbleBackGround:UIImageView =  {
       
        var bubble = UIImageView.init()
        return bubble
        
        
    }()
    
    // view
    lazy var title: UILabel =  {
       var label = UILabel.init()
       label.text = "个人名片"
       label.textColor = UIColor.white
       label.font = UIFont.systemFont(ofSize: 10)
      
       return label
        
    }()
    
    lazy var line:UIView = {
       var line = UIView.init()
        line.backgroundColor = UIColor.white
        return line
    }()
    
    lazy var imageV:UIImageView = {
        var im = UIImageView.init()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        
        return im
    }()
    
    lazy var name:UILabel = {
       var n = UILabel.init()
       n.textColor = UIColor.white
       n.font = UIFont.boldSystemFont(ofSize: 10)
       n.numberOfLines = 0
       return n
    }()
    
    var mode:(name:String, image:String)?{
        
        didSet{
            imageV.image = UIImage.init(named: mode!.image)
            name.text = mode!.name
            avartar.image = UIImage.init(named: mode!.image)
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
   
    
    override func layoutSubviews() {
        
        self.addSubview(avartar)
        avartar.frame = CGRect.init(x: ScreenW - 45 - 5, y: 5, width: 45, height: 45)
        
        self.addSubview(bubbleBackGround)
        
        bubbleBackGround.addSubview(title)
        bubbleBackGround.addSubview(line)
        bubbleBackGround.addSubview(imageV)
        bubbleBackGround.addSubview(name)
        
        bubbleBackGround.image =  UIImage.resizeableImage(name: "rightmessage")
        bubbleBackGround.frame = CGRect.init(x:ScreenW-5-45-5-160 , y: 5, width: 165, height: 80)
        
        _ = title.sd_layout().leftSpaceToView(bubbleBackGround,15)?.topSpaceToView(bubbleBackGround,10)?.widthIs(120)?.heightIs(15)
        
        _ = line.sd_layout().leftEqualToView(self.title)?.topSpaceToView(self.title,3)?.rightSpaceToView(bubbleBackGround,10)?.heightIs(1)
        
        _ = imageV.sd_layout().leftEqualToView(title)?.bottomSpaceToView(bubbleBackGround,10)?.topSpaceToView(line,5)?.widthIs(45)
        
        _ = name.sd_layout().leftSpaceToView(imageV,5)?.topSpaceToView(line,10)?.widthIs(80)?.heightIs(20)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func reuseidentity()->String{
        return "personCardCell"
    }
    
    class func  heightForCell()->CGFloat{
        return 85
        
    }

    
    
}
