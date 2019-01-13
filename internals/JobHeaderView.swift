//
//  HeaderFoot.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let labelMaxWidth:CGFloat = 200
fileprivate let imgSize:CGSize = CGSize.init(width: 15, height: 15)
fileprivate let leftWidth:CGFloat = 30
fileprivate let topHeight:CGFloat = 10
fileprivate let internalLeft:CGFloat = 2




class JobDetailHeader:UIView {
    
    private lazy var jobName: UILabel = {
        let jobName = UILabel()
        jobName.font = UIFont.boldSystemFont(ofSize: 16)
        jobName.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 20 )
        jobName.textAlignment = .left
        return jobName
        
    }()
    private lazy var address: UILabel = {
        let address = UILabel()
        address.font = UIFont.systemFont(ofSize: 13)
        address.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40 )
        address.textAlignment = .left
        return address
        
    }()
    
    // 实习薪水 和 校招薪水
    private lazy var salary: UILabel = {
        let salary = UILabel()
        salary.font = UIFont.systemFont(ofSize: 13)
        salary.setSingleLineAutoResizeWithMaxWidth(labelMaxWidth)
        salary.textAlignment = .left
        return salary
        
    }()
    private lazy var education: UILabel = {
        let education = UILabel.init()
        education.font = UIFont.systemFont(ofSize: 13)
        education.setSingleLineAutoResizeWithMaxWidth(labelMaxWidth)
        education.textAlignment = .left
        return education
    }()
    private lazy var type: UILabel = {
        let type = UILabel()
        type.font = UIFont.systemFont(ofSize: 13)
        type.setSingleLineAutoResizeWithMaxWidth(labelMaxWidth)
        type.textAlignment = .left
        return type
    }()
    
    
    private lazy var des:UILabel = {
        let des = UILabel.init()
        des.font = UIFont.systemFont(ofSize: 14)
        des.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 20 )
        des.textAlignment = .left
        des.textColor = UIColor.lightGray
        return des
    }()
    
    // 实习 标记
    private lazy var month:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.setSingleLineAutoResizeWithMaxWidth(labelMaxWidth)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var perDay:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.setSingleLineAutoResizeWithMaxWidth(labelMaxWidth)
        label.textAlignment = .left
        return label
    }()
    
 
    
    private lazy var typeIcon:UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "clock"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    
    
    private lazy var locateIcon:UIImageView = {
        let img =  UIImageView.init(image: UIImage.init(named: "marker"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    private lazy var degreeIcon:UIImageView = {
       let img = UIImageView.init(image: UIImage.init(named: "degree"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var yuanIcon:UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "yuan"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var monthIcon:UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "month"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var dayIcon:UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "clock"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
 
    
    
    private lazy var internViews:[UIView] = []
    
    var mode:CompuseRecruiteJobs?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            createInfos(item: mode)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        internViews = [month, perDay,monthIcon, dayIcon]
        
        
        let views:[UIView] = [jobName,address,type,education,des, typeIcon,locateIcon,degreeIcon,yuanIcon,salary]
        self.sd_addSubviews(views)
        self.sd_addSubviews(internViews)
        
        
        _ = jobName.sd_layout().topSpaceToView(self,10)?.leftSpaceToView(self,10)?.autoHeightRatio(0)

        _ = degreeIcon.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName, topHeight + 5)?.widthIs(15)?.heightIs(15)
        _ = education.sd_layout().leftSpaceToView(degreeIcon,internalLeft)?.topEqualToView(degreeIcon)?.autoHeightRatio(0)
        
        _ = typeIcon.sd_layout().leftSpaceToView(education,leftWidth)?.topEqualToView(education)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
        _ = type.sd_layout().leftSpaceToView(typeIcon,internalLeft)?.topEqualToView(typeIcon)?.autoHeightRatio(0)
        
      
        
        
        jobName.setMaxNumberOfLinesToShow(2)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 实习还是校招？ MARK
    func createInfos(item:CompuseRecruiteJobs){

        guard  let kind = item.kind else {
            return
        }
        self.salary.text = item.salary
        self.jobName.text =  item.name
        self.address.text =  item.addressStr
        self.education.text = item.education
        if let des = item.benefits{
            self.des.text  = "职位诱惑: " +  des
        }
        
        // 社招
        if kind == .graduate{
            
            internViews.forEach{
                $0.isHidden = true
            }
            self.type.text = "校招"
        
            _ = yuanIcon.sd_layout().topEqualToView(type)?.leftSpaceToView(type,leftWidth)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
            
            _ = salary.sd_layout().leftSpaceToView(yuanIcon,internalLeft)?.topEqualToView(yuanIcon)?.autoHeightRatio(0)
            
            _ = locateIcon.sd_layout().leftEqualToView(jobName)?.topSpaceToView(type,topHeight)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
            
            _ = address.sd_layout().leftSpaceToView(locateIcon,internalLeft)?.topEqualToView(locateIcon)?.autoHeightRatio(0)
            
            
            address.setMaxNumberOfLinesToShow(2)

            _ = des.sd_layout().topSpaceToView(address,topHeight)?.leftEqualToView(jobName)?.autoHeightRatio(0)

            self.setupAutoHeight(withBottomViewsArray: [des,address], bottomMargin: 5)
            
        // 实习
        }else if kind == .intern{
            
             internViews.forEach{
                $0.isHidden = false
            }
            typeIcon.isHidden = true
            type.isHidden = true
            
            self.month.text = item.months
            self.perDay.text = item.perDay
            
            _ = yuanIcon.sd_layout().topEqualToView(education)?.leftSpaceToView(education,leftWidth)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
            
            _ = salary.sd_layout().leftSpaceToView(yuanIcon,internalLeft)?.topEqualToView(yuanIcon)?.autoHeightRatio(0)
            
            _ = monthIcon.sd_layout().topEqualToView(salary)?.leftSpaceToView(salary,leftWidth)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
            _ = month.sd_layout().leftSpaceToView(monthIcon,internalLeft)?.topEqualToView(monthIcon)?.autoHeightRatio(0)
            
            _ = dayIcon.sd_layout().leftEqualToView(degreeIcon)?.topSpaceToView(degreeIcon,topHeight)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
            
            _ = perDay.sd_layout().leftSpaceToView(dayIcon,internalLeft)?.topEqualToView(dayIcon)?.autoHeightRatio(0)
            
            
            
            _ = locateIcon.sd_layout().leftEqualToView(yuanIcon)?.topEqualToView(perDay)?.widthRatioToView(degreeIcon,1)?.heightRatioToView(degreeIcon,1)
            
            _ = address.sd_layout().leftSpaceToView(locateIcon,internalLeft)?.topEqualToView(locateIcon)?.autoHeightRatio(0)
            
            
            address.setMaxNumberOfLinesToShow(1)

            _ = des.sd_layout().topSpaceToView(perDay,topHeight)?.leftEqualToView(jobName)?.autoHeightRatio(0)
            self.setupAutoHeight(withBottomViewsArray: [des,address,perDay], bottomMargin: 5)

            
        }
    
    }
    


}
