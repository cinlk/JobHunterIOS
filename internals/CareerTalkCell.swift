//
//  CareerTalkCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher


fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class CareerTalkCell: UITableViewCell {

    
    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var company:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var time:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var collage:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgSize.width - 100)
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(200)
        return label
    }()
    

    
   dynamic var mode: CareerTalkMeetingListModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            if let url = mode.collegeIconURL{
                  self.icon.kf.setImage(with: Source.network(url), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
          
            
            self.company.text = mode.companyName
            self.time.text = mode.startTimeStr
            self.collage.text = (mode.college ?? "" ) + " |"
            self.address.text = mode.simplifyAddress ?? ""
            //self.type.text = "宣讲会"
            self.setupAutoHeight(withBottomViewsArray: [icon,address], bottomMargin: 5)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, company, time, collage, address]
        self.contentView.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(imgSize.width)?.autoHeightRatio(1)
        _ = company.sd_layout().leftSpaceToView(icon,5)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = time.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        //_ = type.sd_layout().topSpaceToView(time,10)?.rightEqualToView(time)?.autoHeightRatio(0)
        
        _ = collage.sd_layout().leftEqualToView(company)?.topSpaceToView(company,10)?.autoHeightRatio(0)
        _ = address.sd_layout().leftSpaceToView(collage, 5)?.topEqualToView(collage)?.autoHeightRatio(0)
        
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
        
        company.setMaxNumberOfLinesToShow(2)
        collage.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "CareerTalkCell"
    }
}
