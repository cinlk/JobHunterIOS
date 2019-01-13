//
//  OnlineApplyCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let imgIcon:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class OnlineApplyCell: UITableViewCell {

    internal lazy var icon:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    
    private lazy var jobName:UILabel = {
        let label = UILabel()
        label.isAttributedContent = true
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgIcon.width - 20 )
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
       
        return label
    }()
    
    
    
    private lazy var endTime:UILabel = {
        
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgIcon.width - 20 )
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.isAttributedContent = true 
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - imgIcon.width - 20 )
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    

    
    dynamic var mode:OnlineApplyModel?{
        didSet{
           
            guard let mode = mode else {
                return
            }
            let jobName = NSMutableAttributedString.init(string: mode.name!)
            if mode.outer{
                let attchment = NSTextAttachment()
                // image 对齐
                attchment.bounds = CGRect.init(x: 0, y: (self.jobName.font.capHeight - 15).rounded()/2, width: 15, height: 15)

                attchment.image = UIImage.init(named: "links")
                let imageStr = NSAttributedString.init(attachment: attchment)
                
                // 间隔距离
                jobName.append(NSAttributedString.init(string: " "))
                jobName.append(imageStr)

            

            }
            
            if mode.isSimple{
                 _ = self.icon.sd_layout().leftSpaceToView(self.contentView,0)?.topSpaceToView(self.contentView,5)?.widthIs(0)?.autoHeightRatio(1)
                
            }else{
                let url = URL.init(string: mode.companyIcon)
                
                self.icon.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
           
            
            self.jobName.attributedText = jobName
            
            
            let endStr = NSMutableAttributedString.init(string: mode.endTimeStr, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            endStr.insert(NSAttributedString.init(string:"截止 ") , at: 0)
            self.endTime.attributedText =  endStr
            
            self.address.text = mode.address?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [icon, address], bottomMargin: 5)
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [icon, jobName, endTime, address]
        self.contentView.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(imgIcon.width)?.autoHeightRatio(1)
        _ = jobName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,10)?.autoHeightRatio(0)
        _ = endTime.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
     
        
        jobName.setMaxNumberOfLinesToShow(2)
        address.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "OnlineApplyCell"
    }
    

}
