//
//  collectedCompanyCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




fileprivate let imgSize:CGSize = CGSize.init(width: 40, height: 45)

@objcMembers  class collectedCompanyCell: UITableViewCell {

    
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
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return name
    }()
    
    private lazy var describle:UILabel = {
        let des = UILabel.init(frame: CGRect.zero)
        des.font = UIFont.systemFont(ofSize: 14)
        des.textColor = UIColor.lightGray
        des.lineBreakMode = .byTruncatingTail
        des.textAlignment = .left
        des.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 65)
        return des
    }()
    
   dynamic var mode:comapnyInfo?{
        didSet{
            self.icon.image = UIImage.init(named: (mode?.icon)!)
            self.companyName.text = mode?.name
            self.describle.text = mode?.describe
            self.setupAutoHeight(withBottomViewsArray: [describle,icon], bottomMargin: 5)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [icon, companyName, describle]
        self.contentView.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.heightIs(imgSize.height)?.widthIs(imgSize.width)
        _ = companyName.sd_layout().leftSpaceToView(icon,5)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = describle.sd_layout().leftEqualToView(companyName)?.topSpaceToView(companyName,5)?.autoHeightRatio(0)
        
        companyName.setMaxNumberOfLinesToShow(1)
        describle.setMaxNumberOfLinesToShow(3)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension collectedCompanyCell{
    
    class func identity()->String{
        return "collectedCompanyCell"
    }
    
    
}
