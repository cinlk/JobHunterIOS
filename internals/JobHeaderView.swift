//
//  HeaderFoot.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let labelMaxWidth:CGFloat = 200
fileprivate let imgSize:CGSize = CGSize.init(width: 15, height: 20)

class JobDetailHeader:UIView {

    // 分割线
    private lazy var line:UIView = {
       let line = UIView.init()
       line.backgroundColor = UIColor.black
       return line
        
    }()
    
    
    private lazy var jobName: UILabel = {
        let jobName = UILabel()
        jobName.font = UIFont.boldSystemFont(ofSize: 16)
        jobName.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 )
        jobName.textAlignment = .left
        jobName.lineBreakMode = .byWordWrapping
        return jobName
        
    }()
    private lazy var address: UILabel = {
        let address = UILabel()
        address.font = UIFont.systemFont(ofSize: 13)
        address.setSingleLineAutoResizeWithMaxWidth(labelMaxWidth)
        address.textAlignment = .left
        return address
        
    }()
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
        des.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20 )
        des.textAlignment = .left
        des.lineBreakMode = .byWordWrapping
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
    
    private lazy var stuff:UILabel = {
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
    
    // 占时不用
    private lazy var stuffIcon:UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "me"))
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    
    private lazy var internViews:[UIView] = []
    
    var mode:CompuseRecruiteJobs?{
        didSet{
            
            createInfos(item: mode!)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        internViews = [month, perDay, monthIcon, dayIcon]
        
        
        let views:[UIView] = [line,jobName,address,salary,type,education,des, typeIcon,locateIcon,degreeIcon,yuanIcon]
        self.sd_addSubviews(views)
        self.sd_addSubviews(internViews)
        
        _ = line.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        //des.text = "职位诱惑(标签):"
        
        
        _ = jobName.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,10)?.autoHeightRatio(0)
        _ = locateIcon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(jobName,10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = address.sd_layout().leftSpaceToView(locateIcon,2)?.topEqualToView(locateIcon)?.autoHeightRatio(0)
        
        _ = degreeIcon.sd_layout().leftSpaceToView(address,20)?.topEqualToView(address)?.widthRatioToView(locateIcon,1)?.heightRatioToView(locateIcon,1)
        _ = education.sd_layout().leftSpaceToView(degreeIcon,2)?.topEqualToView(degreeIcon)?.autoHeightRatio(0)
        
        _ = yuanIcon.sd_layout().leftSpaceToView(education,20)?.topEqualToView(education)?.widthRatioToView(locateIcon,1)?.heightRatioToView(locateIcon,1)
        _ = salary.sd_layout().leftSpaceToView(yuanIcon,2)?.topEqualToView(yuanIcon)?.autoHeightRatio(0)
        
        _ = typeIcon.sd_layout().topSpaceToView(locateIcon,15)?.leftEqualToView(locateIcon)?.widthRatioToView(locateIcon,1)?.heightRatioToView(locateIcon,1)
        _ = type.sd_layout().leftSpaceToView(typeIcon,2)?.topEqualToView(typeIcon)?.autoHeightRatio(0)
        
        _ = monthIcon.sd_layout().topEqualToView(typeIcon)?.leftEqualToView(degreeIcon)?.widthRatioToView(typeIcon,1)?.heightRatioToView(typeIcon,1)
        _ = month.sd_layout().leftSpaceToView(monthIcon,2)?.topEqualToView(monthIcon)?.autoHeightRatio(0)
        
        _ = dayIcon.sd_layout().leftEqualToView(yuanIcon)?.topEqualToView(month)?.widthRatioToView(typeIcon,1)?.heightRatioToView(typeIcon,1)
        _ = perDay.sd_layout().leftSpaceToView(dayIcon,2)?.topEqualToView(dayIcon)?.autoHeightRatio(0)
        
        
        _ = des.sd_layout().topSpaceToView(typeIcon,10)?.leftEqualToView(typeIcon)?.autoHeightRatio(0)
        
        jobName.setMaxNumberOfLinesToShow(1)
        des.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 实习还是校招？ MARK
    func createInfos(item:CompuseRecruiteJobs){

        guard  let kind = item.kind else {
            return
        }
        
        self.jobName.text = mode?.name
        self.address.text = mode?.address
        self.education.text = mode?.education
        self.salary.text = mode?.salary
        
        // 社招
        if kind == .graduate{
            
            internViews.forEach{
                $0.isHidden = true
            }
              des.isHidden = false
              self.type.text = "全职"
              self.des.text = ""
            self.setupAutoHeight(withBottomView: des, bottomMargin: 10)
            
        // 实习
        }else if kind == .intern{
             des.isHidden = true
             internViews.forEach{
                $0.isHidden = false
            }
            self.type.text = "实习"
            self.month.text = mode?.months
            self.perDay.text = mode?.perDay
            self.setupAutoHeight(withBottomView: perDay, bottomMargin: 10)
            
            
            
        }
        
    
    }
    
   
    



}
