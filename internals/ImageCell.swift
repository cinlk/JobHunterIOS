//
//  ImageCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    
    lazy var avartar:UIImageView = {
        var v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        return v
        
    }()
    
    lazy var imageV:UIImageView = {
        var v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    
    var mode:(avartarStr:String, imageData:NSData)? {
        didSet{
            self.avartar.image = UIImage.init(named: mode!.avartarStr)
            self.imageV.image = UIImage.init(data: mode!.imageData as Data)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageV)
        self.contentView.addSubview(avartar)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        avartar.setCircle()
        avartar.frame = CGRect.init(x: ScreenW - 45 - 5, y: 5, width: 45, height: 45)
        
        _ = imageV.sd_layout().rightSpaceToView(avartar,10)?.topSpaceToView(self.contentView,10)?.widthIs(75)?.heightIs(80)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 100
    }

    class func reuseIdentify()->String{
        return "imageCell"
    }
    
    
}


// image operations


