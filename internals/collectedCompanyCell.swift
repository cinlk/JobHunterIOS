//
//  collectedCompanyCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class collectedCompanyCell: UITableViewCell {

    
    private lazy var  icon:UIImageView = {
        let image = UIImageView.init(frame: CGRect.zero)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var companyName:UILabel = {
        let name = UILabel.init(frame: CGRect.zero)
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = UIColor.black
        name.textAlignment = .left
        return name
    }()
    
    private lazy var describle:UILabel = {
        let des = UILabel.init(frame: CGRect.zero)
        des.font = UIFont.systemFont(ofSize: 14)
        des.textColor = UIColor.lightGray
        des.lineBreakMode = .byTruncatingTail
        des.textAlignment = .left
        return des
    }()
    
    var mode:(img:String, name:String, des:String)?{
        didSet{
            self.icon.image = UIImage.init(named: (mode?.img)!)
            self.companyName.text = mode?.name
            self.describle.text = mode?.des
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(icon)
        self.contentView.addSubview(companyName)
        self.contentView.addSubview(describle)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(40)
        _ = companyName.sd_layout().leftSpaceToView(icon,5)?.topEqualToView(icon)?.rightSpaceToView(self.contentView,10)?.heightIs(20)
        _ = describle.sd_layout().leftEqualToView(companyName)?.rightEqualToView(companyName)?.topSpaceToView(companyName,5)?.heightIs(20)
    }

}


extension collectedCompanyCell{
    
    class func identity()->String{
        return "collectedCompanyCell"
    }
    
    class func cellHeight()->CGFloat{
        
        return 60
    }
    
}
