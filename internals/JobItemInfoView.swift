//
//  JobItemInfoView.swift
//  internals
//
//  Created by ke.liang on 2018/1/6.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class JobItemInfoView: UIView {

    lazy var icon:UIImageView = {
       let image = UIImageView.init()
       image.contentMode = .scaleAspectFit
       image.clipsToBounds = true
       image.backgroundColor = UIColor.clear
       return image
    }()
    
    lazy var JobName:UILabel = {
       let label = UILabel.init()
       label.font = UIFont.systemFont(ofSize: 15)
       label.sizeToFit()
       label.textAlignment = .left
       return label
    }()
    
    lazy var company:UILabel = {
       let label = UILabel.init()
       label.font = UIFont.systemFont(ofSize: 10)
       label.textColor = UIColor.lightGray
       label.sizeToFit()
       label.textAlignment = .left

       return label
        
    }()
    
    lazy var address:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left

        return label
    }()
    
    lazy var type:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left

        return label
    }()
    
    lazy var  degree:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left

        return label
    }()
    
    lazy var  internDay:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left

        return label
    }()
    
    
    lazy var  create_time:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .right

        return label
    }()
    
    lazy var  salary:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        label.sizeToFit()
        label.textAlignment = .right

        return label
    }()
    
    
    
    //
    lazy var rightArrow:UIImageView = {
       let right = UIImageView.init(image: #imageLiteral(resourceName: "rightforward") )
       right.clipsToBounds = true
       right.contentMode  = .scaleAspectFit
       return right
        
    }()
    
    
   
    
    init(frame: CGRect, isDelivery:Bool = false) {
        
    
        super.init(frame: frame)
        self.addSubview(icon)
        self.addSubview(JobName)
        self.addSubview(company)
        self.addSubview(address)
        self.addSubview(type)
        self.addSubview(degree)
        self.addSubview(internDay)
        self.addSubview(create_time)
        self.addSubview(salary)
        
        if isDelivery{
            self.setLayout()
        }else {
            self.setNormalLayout()
        }
        
  
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setNormalLayout(){
       
        
        _ = icon.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,5)?.widthIs(50)?.heightIs(45)
        _ = JobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,10)?.widthIs(200)?.heightIs(20)
        _ = company.sd_layout().leftEqualToView(JobName)?.topSpaceToView(JobName,3)?.widthIs(200)?.heightIs(15)
        _ = address.sd_layout().leftEqualToView(JobName)?.topSpaceToView(company,5)?.widthIs(40)?.heightIs(15)
        _ = type.sd_layout().topEqualToView(address)?.leftSpaceToView(address,5)?.widthIs(30)?.heightIs(15)
        _ = degree.sd_layout().topEqualToView(type)?.leftSpaceToView(type,5)?.widthIs(30)?.heightIs(15)
        _ = internDay.sd_layout().topEqualToView(degree)?.leftSpaceToView(degree,5)?.widthIs(60)?.heightIs(15)
        _ = salary.sd_layout().topSpaceToView(self,20)?.rightSpaceToView(self,10)?.widthIs(100)?.heightIs(10)
        _ = create_time.sd_layout().rightEqualToView(salary)?.topSpaceToView(salary,10)?.widthIs(100)?.heightIs(15)
        
    }
    private func setLayout(){
       
        self.addSubview(rightArrow)
        
        _ = icon.sd_layout().topSpaceToView(self,10)?.leftSpaceToView(self,5)?.widthIs(50)?.heightIs(45)
        _ = JobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,10)?.widthIs(200)?.heightIs(20)
        _ = company.sd_layout().leftEqualToView(JobName)?.topSpaceToView(JobName,3)?.widthIs(200)?.heightIs(15)
        _ = address.sd_layout().leftEqualToView(JobName)?.topSpaceToView(company,5)?.widthIs(40)?.heightIs(15)
        _ = type.sd_layout().topEqualToView(address)?.leftSpaceToView(address,5)?.widthIs(30)?.heightIs(15)
        _ = degree.sd_layout().topEqualToView(type)?.leftSpaceToView(type,5)?.widthIs(30)?.heightIs(15)
        _ = internDay.sd_layout().topEqualToView(degree)?.leftSpaceToView(degree,5)?.widthIs(60)?.heightIs(15)
        
        _ = salary.sd_layout().topSpaceToView(self,10)?.rightSpaceToView(self,10)?.widthIs(100)?.heightIs(10)
        _ = rightArrow.sd_layout().rightEqualToView(salary)?.centerYEqualToView(self)?.widthIs(20)?.heightIs(20)
        
        _ = create_time.sd_layout().rightEqualToView(salary)?.bottomSpaceToView(self,10)?.widthIs(100)?.heightIs(15)
        
    }
    
    
    func setTexts(icon:String,jobName:String?,company:String?,address:String?,type:String?,
                  degree:String?,internDay:String?,create_time:String?,salary:String?){
        
        self.icon.image = UIImage.init(named: icon)
        self.JobName.text = jobName
        self.company.text = company
        self.address.text = address
        self.type.text = type
        self.degree.text = degree
        self.internDay.text = internDay
        self.create_time.text = create_time
        self.salary.text = salary
        
        
    }
    
}
