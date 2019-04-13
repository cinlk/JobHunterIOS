//
//  NearCompanyTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2019/2/16.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let imgSize:CGSize = CGSize.init(width: 80, height: 80)


@objcMembers class NearCompanyTableViewCell: UITableViewCell {
    
    
    private lazy var companyIcon:UIImageView = {
        let im = UIImageView.init(frame: CGRect.zero)
        im.contentMode = .scaleAspectFit
        im.clipsToBounds = true
        return im
    }()
    
    private lazy var companyName:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    private lazy var businessField:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    private lazy var reviews:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    private lazy var distance:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    dynamic var mode:NeayByCompanyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            self.businessField.text =  self.mode?.businessFiled?.joined(separator: " ")
            if  let url = mode.companyIconURL{
                 self.companyIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
           
            
            self.companyName.text = mode.companyName
            self.distance.text = "\(String(describing: mode.distance))"
            self.reviews.text =  "\(String(describing: mode.reviewCounts))"
            
            self.setupAutoHeight(withBottomViewsArray: [companyIcon, businessField], bottomMargin: 10)
        }
    }
    
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [companyIcon, companyName, businessField, reviews,  distance]
        self.contentView.sd_addSubviews(views)
        
        _ = companyIcon.sd_layout()?.leftSpaceToView(self.contentView, 10)?.topSpaceToView(self.contentView, 10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = companyName.sd_layout()?.leftSpaceToView(companyIcon, 5)?.topEqualToView(companyIcon)?.autoHeightRatio(0)
        _ = businessField.sd_layout()?.leftEqualToView(companyName)?.topSpaceToView(companyName, 10)?.autoHeightRatio(0)
        _ = reviews.sd_layout()?.topEqualToView(self.companyIcon)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = distance.sd_layout()?.topSpaceToView(reviews,10)?.rightEqualToView(self.reviews)?.autoHeightRatio(0)
        
        self.companyName.setMaxNumberOfLinesToShow(2)
        self.businessField.setMaxNumberOfLinesToShow(2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

}


extension NearCompanyTableViewCell{
    
    class func identity() -> String{
        return "NearCompanyTableViewCell"
    }
}
