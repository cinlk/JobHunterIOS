//
//  subjobitem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let iconSize:CGSize = CGSize.init(width: 20, height: 18)

@objcMembers class subjobitemCell: UITableViewCell {

    
    private lazy var des: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var locate: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var localicon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = UIImage.init(named: "locate")
        return img
        
    }()
    
    private lazy var salary: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var salaryIcon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = UIImage.init(named: "dolor")
        return img
    }()
    
    private lazy var business: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var businessIcon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = UIImage.init(named: "briefcase")
        return img
    }()
    
    private lazy var internMonth: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var internMonthIcon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = UIImage.init(named: "month")
        return img
    }()
    
    private lazy var degree: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var degreeIcon:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = UIImage.init(named: "degree")
        return img
    }()
    
    
    private lazy var internDay: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var interdayIcon: UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = UIImage.init(named: "clock")
        return img
    }()
    
    
    
    dynamic var mode:subscribeConditionModel?{
        didSet{
            
            des.text  = mode?.des?.joined(separator: "+")
            locate.text = mode?.locate
            degree.text = mode?.degree
            business.text = mode?.business
            
            if mode?.type == "实习"{
                internDay.isHidden = false
                interdayIcon.isHidden = false
                internMonthIcon.isHidden = false
                internMonth.isHidden = false
                internMonth.text = mode?.internMonth
                internDay.text = mode?.internDay
                salary.text = mode?.internSalary
                
            }else{
                internDay.isHidden = true
                interdayIcon.isHidden = true
                internMonthIcon.isHidden = true
                internMonth.isHidden = true
                salary.text = mode?.salary
            }
            self.setupAutoHeight(withBottomView: degreeIcon, bottomMargin: 10)
            //self.setupAutoHeight(withBottomViewsArray: [degree, degreeIcon], bottomMargin: 10)
            //self.setupAutoHeight(withBottomViewsArray: [degree,internMonth,business], bottomMargin: 10)
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.clipsToBounds = true
        setLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    private func  setLayout(){
        
        let views:[UIView] = [des,locate,salary, business, interdayIcon, internDay, salaryIcon, businessIcon, localicon, degree,degreeIcon,internMonth,internMonthIcon]
        
        self.contentView.sd_addSubviews(views)
        
        
        _ = des.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        _ = localicon.sd_layout().topSpaceToView(des,10)?.leftEqualToView(des)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        
        
        _ = locate.sd_layout().topEqualToView(localicon)?.leftSpaceToView(localicon,5)?.autoHeightRatio(0)
        _ = salaryIcon.sd_layout().topEqualToView(localicon)?.bottomEqualToView(localicon)?.widthIs(iconSize.width)?.leftSpaceToView(locate,10)
        _ = salary.sd_layout().topEqualToView(salaryIcon)?.leftSpaceToView(salaryIcon,5)?.autoHeightRatio(0)
        
        
        _ = businessIcon.sd_layout().leftSpaceToView(salary,10)?.topEqualToView(salaryIcon)?.bottomEqualToView(salaryIcon)?.widthIs(iconSize.width)
        
        _ = business.sd_layout().leftSpaceToView(businessIcon,5)?.topEqualToView(businessIcon)?.autoHeightRatio(0)
        
        _ = degreeIcon.sd_layout().topSpaceToView(locate,10)?.leftEqualToView(localicon)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = degree.sd_layout().leftSpaceToView(degreeIcon,5)?.topEqualToView(degreeIcon)?.autoHeightRatio(0)
        
        _ = internMonthIcon.sd_layout().leftSpaceToView(degree,10)?.topEqualToView(degreeIcon)?.bottomEqualToView(degreeIcon)?.widthIs(iconSize.width)
        
        _ = internMonth.sd_layout().leftSpaceToView(internMonthIcon,5)?.topEqualToView(internMonthIcon)?.autoHeightRatio(0)
        
        _ = interdayIcon.sd_layout().leftSpaceToView(internMonth,10)?.topEqualToView(internMonthIcon)?.bottomEqualToView(internMonthIcon)?.widthIs(iconSize.width)

        _ = internDay.sd_layout().leftSpaceToView(interdayIcon,5)?.topEqualToView(interdayIcon)?.autoHeightRatio(0)

        
        des.setMaxNumberOfLinesToShow(2)
        
        locate.setMaxNumberOfLinesToShow(1)
        salary.setMaxNumberOfLinesToShow(1)
        business.setMaxNumberOfLinesToShow(1)
        internDay.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        internMonth.setMaxNumberOfLinesToShow(1)
        
    }
    
    
    static  func identity()->String{
        return "subscribeCondition"
    }
    

    
}



