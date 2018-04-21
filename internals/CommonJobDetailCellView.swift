//
//  CommonJobDetailCellView.swift
//  internals
//
//  Created by ke.liang on 2018/4/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 40)

@objcMembers class CommonJobDetailCellView: UIView{

    
    
    private lazy var icon:UIImageView = {
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    private lazy var JobName:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var company:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20 )
        return label
        
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var type:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var  degree:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var  internDay:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    private lazy var  create_time:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var  salary:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        label.sizeToFit()
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    // 实习标签view （图片左上角）
    private lazy var internTagImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.image = UIImage.init(named: "pbackimg")?.str_image("实习", size: (30,20), backColor: UIColor.blue, textColor: UIColor.white, isCircle: false)
        return imgView
    }()
    
    
    private lazy var rightArrow:UIImageView = {
        let right = UIImageView.init(image: #imageLiteral(resourceName: "rightforward") )
        right.clipsToBounds = true
        right.contentMode  = .scaleAspectFit
        return right
        
    }()
    
    
    private var deliver:Bool = false
    
    
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            icon.image = UIImage.init(named: (mode?.picture)!)
            JobName.text = mode?.jobName
            company.text = mode?.company
            address.text = mode?.address
            type.text = "校招"
            degree.text = mode?.education
            if type.text == "校招"{
                internDay.isHidden = true
                // 测试
                internTagImageView.isHidden = false
            }
            else{
                internDay.isHidden = false
                internDay.text = "0"
                internTagImageView.isHidden = false
                
            }
            salary.text = mode?.salary
            create_time.text = mode?.create_time
            
            self.setupAutoHeight(withBottomViewsArray: [address, type, degree], bottomMargin: 10)
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views:[UIView] = [icon, JobName, company, address, type, degree, internDay, create_time, salary,rightArrow, internTagImageView]
        
        //icon.addSubview(internTagImageView)
        self.sd_addSubviews(views)
        setLayout()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func cellHeight()->CGFloat{
        return  65
    }
    
}


extension  CommonJobDetailCellView{
    
    private func setLayout(){
        
        
        _ = icon.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,5)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
       
        
        _ = JobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,10)?.autoHeightRatio(0)
        _ = internTagImageView.sd_layout().leftSpaceToView(JobName,5)?.centerYEqualToView(JobName)?.widthIs(25)?.heightRatioToView(JobName,0.9)
        _ = company.sd_layout().leftEqualToView(JobName)?.topSpaceToView(JobName,3)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(JobName)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = type.sd_layout().topEqualToView(address)?.leftSpaceToView(address,5)?.autoHeightRatio(0)
        _ = degree.sd_layout().topEqualToView(type)?.leftSpaceToView(type,5)?.autoHeightRatio(0)
        _ = internDay.sd_layout().topEqualToView(degree)?.leftSpaceToView(degree,5)?.autoHeightRatio(0)
        _ = salary.sd_layout().topEqualToView(JobName)?.rightSpaceToView(self,10)?.autoHeightRatio(0)
        _ = create_time.sd_layout().rightEqualToView(salary)?.topSpaceToView(salary,15)?.autoHeightRatio(0)
        
        
        if deliver{
            _ = rightArrow.sd_layout().rightEqualToView(salary)?.centerYEqualToView(self)?.widthIs(20)?.heightIs(20)
        }else{
            rightArrow.frame = CGRect.zero
        }
        
        JobName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        type.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        internDay.setMaxNumberOfLinesToShow(1)
        salary.setMaxNumberOfLinesToShow(1)
        create_time.setMaxNumberOfLinesToShow(1)
    }
    
    
}
