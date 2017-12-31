//
//  HeaderFoot.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class JobDetailHeader:UIView {

//    lazy  var categoryName: UILabel = {
//        let categoryName = UILabel()
//        categoryName.font = UIFont.boldSystemFont(ofSize: 12)
//        categoryName.textAlignment = .center
//        categoryName.textColor = UIColor.black
//        return categoryName
//    }()
    
    lazy var line:UIView = {
       let line = UIView.init()
       line.backgroundColor = UIColor.black
       
       return line
    }()
    
    var jobName: UILabel!
    var address: UILabel!
    var salary: UILabel!
    var education: UILabel!
    var type: UILabel!
    var des:UILabel!
    
    
    // 户口？
    
    let typeIcon = UIImageView.init(image: UIImage.init(named: "clock"))
    let locateIcon =  UIImageView.init(image: UIImage.init(named: "marker"))
    let degreeIcon =  UIImageView.init(image: UIImage.init(named: "degree"))
    let yuanIcon =  UIImageView.init(image: UIImage.init(named: "yuan"))
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(line)
        _ = line.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        
        jobName = UILabel()
        jobName.font = UIFont.boldSystemFont(ofSize: 16)
        address = UILabel()
        address.font = UIFont.systemFont(ofSize: 13)
        salary = UILabel()
        salary.font = UIFont.systemFont(ofSize: 13)
        type = UILabel()
        type.font = UIFont.systemFont(ofSize: 13)
        education = UILabel.init()
        education.font = UIFont.systemFont(ofSize: 13)
        des = UILabel.init()
        des.font = UIFont.systemFont(ofSize: 14)
        
        
        self.addSubview(jobName)
        self.addSubview(address)
        self.addSubview(salary)
        self.addSubview(type)
        self.addSubview(education)
        self.addSubview(des)
        // 留2行
        des.text = "职位诱惑(标签):"
        typeIcon.clipsToBounds = true
        locateIcon.clipsToBounds = true
        locateIcon.contentMode = .scaleToFill
        degreeIcon.clipsToBounds = true
        yuanIcon.clipsToBounds = true
        self.addSubview(typeIcon)
        self.addSubview(locateIcon)
        self.addSubview(degreeIcon)
        self.addSubview(yuanIcon)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 实习还是校招？ MARK
    func createInfos(item:[String:String]){
        
        if item["类型"] == "社招"{
            
            jobName.text =  item["jobName"]
            address.text = item["address"]
            salary.text = item["salary"]
            education.text = "本科"
            type.text = "社招"
            
            
            _ = jobName.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,10)?.widthIs(200)?.heightIs(20)
            _ = locateIcon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(jobName,10)?.widthIs(20)?.heightIs(10)
            _ = address.sd_layout().leftSpaceToView(locateIcon,2)?.topEqualToView(locateIcon)?.widthIs(30)?.bottomEqualToView(locateIcon)
            
            _ = degreeIcon.sd_layout().leftSpaceToView(address,20)?.topEqualToView(address)?.bottomEqualToView(address)?.widthIs(20)
            _ = education.sd_layout().leftSpaceToView(degreeIcon,2)?.topEqualToView(degreeIcon)?.bottomEqualToView(degreeIcon)?.widthIs(30)
            
            _ = yuanIcon.sd_layout().leftSpaceToView(education,20)?.topEqualToView(education)?.bottomEqualToView(education)?.widthIs(20)
            _ = salary.sd_layout().leftSpaceToView(yuanIcon,2)?.bottomEqualToView(yuanIcon)?.topEqualToView(yuanIcon)?.widthIs(100)
            
            _ = typeIcon.sd_layout().topSpaceToView(locateIcon,15)?.leftEqualToView(locateIcon)?.widthIs(20)?.heightIs(10)
            _ = type.sd_layout().leftSpaceToView(typeIcon,2)?.topEqualToView(typeIcon)?.bottomEqualToView(typeIcon)?.widthIs(30)
            
            
            _ = des.sd_layout().topSpaceToView(typeIcon,10)?.leftEqualToView(typeIcon)?.widthIs(100)?.heightIs(20)
            
            
        }else{
            
        }
       
        
    
    }
    
   
    



}
