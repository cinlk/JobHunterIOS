//
//  company.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher

@objcMembers class CompanySimpleCell: UITableViewCell {

    
    private lazy var icon:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var name:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textAlignment = .left
        
        return lb
    }()
    
    private lazy var detail:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.isAttributedContent = true
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 60)
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    
    dynamic var mode:SimpleCompanyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            if let url = mode.iconURL{
                icon.kf.setImage(with: Source.network(url), placeholder: UIImage.init(named: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            
            name.text = mode.name
            let address = "地址:" +  (mode.citys?.joined(separator: " ")  ?? "")
            let industry = "行业:" + (mode.businessField?.joined(separator: " ") ?? "")
            let staff  = "\n人员数:\(mode.staff ?? "")"
            let res = [address, industry, staff]
           
            let para = NSMutableParagraphStyle.init()
            para.lineSpacing = 5
            detail.attributedText = NSAttributedString.init(string: res.joined(separator: " "), attributes: [NSAttributedString.Key.paragraphStyle:para])
            self.setupAutoHeight(withBottomViewsArray: [icon, detail], bottomMargin: 5)
            
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, name, detail]
        self.selectionStyle = .none
        self.contentView.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,5)?.topSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(50)
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = detail.sd_layout().leftEqualToView(name)?.topSpaceToView(name,2.5)?.autoHeightRatio(0)
        
        name.setMaxNumberOfLinesToShow(1)
        detail.setMaxNumberOfLinesToShow(3)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "CompanySimpleCell"
    }
    
}
