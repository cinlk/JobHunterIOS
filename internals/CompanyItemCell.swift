//
//  CompanyItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 45)


@objcMembers class CompanyItemCell: UITableViewCell {

    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var company:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
        
    }()
    
    private lazy var types:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    
    private lazy var follows:UILabel = {
        let label = UILabel()
        label.isAttributedContent = true
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
   dynamic var mode:CompanyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            let url = URL.init(string: mode.icon)
            self.icon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            
            //self.icon.image = UIImage.init(named: mode.icon)
            self.company.text = mode.name
            self.types.text = mode.industry!.joined(separator: " ")
            self.address.text = mode.address!.joined(separator: " ")
            
            let fs = NSMutableAttributedString(string: String.init(describing: mode.follows) , attributes: [NSAttributedStringKey.foregroundColor:UIColor.blue])
            fs.append(NSAttributedString.init(string: "人关注", attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
            
            self.follows.attributedText = fs
            self.setupAutoHeight(withBottomViewsArray: [icon,address], bottomMargin: 10)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, company, types, address, follows]
        
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(imgSize.width)?.autoHeightRatio(1)
        _ = company.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = types.sd_layout().leftEqualToView(company)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(company)?.topSpaceToView(types,5)?.autoHeightRatio(0)
        _ = follows.sd_layout().centerYEqualToView(company)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        company.setMaxNumberOfLinesToShow(2)
        types.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func identity()->String{
        return "CompanyItemCell"
    }
}
