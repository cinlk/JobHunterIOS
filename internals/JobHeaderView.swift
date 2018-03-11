//
//  HeaderFoot.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let labelMaxWidth:CGFloat = 80
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
    
    // 户口？
    
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
    
    
    var mode:CompuseRecruiteJobs?{
        didSet{
            createInfos(item: mode?.toJSON() ?? [:])
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views:[UIView] = [line,jobName,address,salary,type,education,des, typeIcon,locateIcon,degreeIcon,yuanIcon]
        self.sd_addSubviews(views)
        
        _ = line.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        //des.text = "职位诱惑(标签):"
        
        
        _ = jobName.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,10)?.autoHeightRatio(0)
        _ = locateIcon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(jobName,10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = address.sd_layout().leftSpaceToView(locateIcon,2)?.topEqualToView(locateIcon)?.autoHeightRatio(0)
        
        _ = degreeIcon.sd_layout().leftSpaceToView(address,20)?.topEqualToView(address)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = education.sd_layout().leftSpaceToView(degreeIcon,2)?.topEqualToView(degreeIcon)?.autoHeightRatio(0)
        
        _ = yuanIcon.sd_layout().leftSpaceToView(education,20)?.topEqualToView(education)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = salary.sd_layout().leftSpaceToView(yuanIcon,2)?.topEqualToView(yuanIcon)?.autoHeightRatio(0)
        
        _ = typeIcon.sd_layout().topSpaceToView(locateIcon,15)?.leftEqualToView(locateIcon)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = type.sd_layout().leftSpaceToView(typeIcon,2)?.topEqualToView(typeIcon)?.autoHeightRatio(0)
        
        _ = des.sd_layout().topSpaceToView(typeIcon,10)?.leftEqualToView(typeIcon)?.autoHeightRatio(0)
        
        jobName.setMaxNumberOfLinesToShow(1)
        des.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 实习还是校招？ MARK
    func createInfos(item:[String:Any]){

        
        if item["type"] as! String == "compuse"{
            
            jobName.text =  item["jobName"] as? String
            address.text = item["address"] as? String
            salary.text = item["salary"] as? String
            education.text = item["education"] as? String
            type.text = "社招"
            des.text = "这是公司描述 当前的群多群无多群当前为多群多无群多当前为多群无多群无多当前为多群多群无当前为多群无多单独!!!"
            
            self.setupAutoHeight(withBottomView: des, bottomMargin: 15)
            
        }else{
            
        }
        
    
    }
    
   
    



}
