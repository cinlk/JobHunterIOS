//
//  OnlineApplyCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let imgIcon:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class OnlineApplyCell: UITableViewCell {

    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    
    private lazy var company:UILabel = {
        let company = UILabel()
        company.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgIcon.width - 20 )
        company.textAlignment = .left
        company.font = UIFont.boldSystemFont(ofSize: 16)
        company.textColor = UIColor.black
        return company
    }()
    
    
    
    private lazy var publishTime:UILabel = {
        
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgIcon.width - 20 )
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgIcon.width - 20 )
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var position:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgIcon.width - 20 )
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // 是否过期
    private lazy var validate:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgIcon.width - 20 )
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.text = "已过期"
        label.isHidden = true
        return label
    }()
    
    // 外部标签
    private lazy var outerTagImageView :UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.image = UIImage.init(named: "pbackimg")?.str_image("外链", size: (35,20), backColor: UIColor.blue, textColor: UIColor.white, isCircle: false)
        imgView.isHidden = true
        return imgView
    }()
    
    // 类型标记lable 提醒
    internal lazy var type:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.textColor = UIColor.blue
        label.textAlignment = .left
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    dynamic var mode:OnlineApplyModel?{
        didSet{
           
            self.validate.isHidden = (mode?.isValidate ?? true)
            self.publishTime.isHidden = !(mode?.isValidate ?? true)
            self.outerTagImageView.isHidden = !(mode?.outer ?? false)
            self.type.text = "网申"
            self.icon.image = UIImage.init(named:  mode!.companyModel!.icon)
            self.company.text = mode?.companyModel?.name
            self.publishTime.text = mode?.creatTimeStr
            self.address.text = mode?.positionAddress?.joined(separator: " ")
            self.position.text = mode?.positions?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [icon,position], bottomMargin: 10)
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [icon, company, publishTime, address, position,validate,outerTagImageView,type]
        self.contentView.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(imgIcon.width)?.autoHeightRatio(1)
        _ = company.sd_layout().leftSpaceToView(icon,5)?.topEqualToView(icon)?.autoHeightRatio(0)
        
        _ = outerTagImageView.sd_layout().leftSpaceToView(company,10)?.topEqualToView(company)?.widthIs(35)?.heightIs(20)
        
        _ = publishTime.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.autoHeightRatio(0)
        _ = type.sd_layout().topSpaceToView(publishTime,10)?.rightEqualToView(publishTime)?.autoHeightRatio(0)
        
        _ = address.sd_layout().leftEqualToView(company)?.topSpaceToView(company,10)?.autoHeightRatio(0)
        _ = position.sd_layout().leftEqualToView(address)?.topSpaceToView(address,10)?.autoHeightRatio(0)
        _ = validate.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        
        address.setMaxNumberOfLinesToShow(1)
        position.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "OnlineApplyCell"
    }
    

}
