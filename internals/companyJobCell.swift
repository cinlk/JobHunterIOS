//
//  companyJobCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/25.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers class companyJobCell: UITableViewCell {

   
    private lazy var jobName:UILabel = {
       let lable = UILabel.init()
       lable.font = UIFont.boldSystemFont(ofSize: 15)
       lable.textAlignment = .left
       lable.adjustsFontSizeToFitWidth = true
       lable.textColor = UIColor.black
       lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
       return lable
    }()
    
    private lazy var address:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    private lazy var type:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    private lazy var degree:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    private lazy var create_time:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .right
        lable.textColor = UIColor.lightGray
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    private lazy var salary:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .right
        lable.textColor = UIColor.red
        lable.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return lable
    }()
    
    
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            jobName.text = mode?.jobName
            address.text = mode?.address
            type.text = mode?.type
            degree.text =  mode?.education
            create_time.text = mode?.create_time
            salary.text = mode?.salary
            self.setupAutoHeight(withBottomViewsArray: [address, salary], bottomMargin: 10)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [jobName,address,type,degree,create_time,salary]
        self.contentView.sd_addSubviews(views)
        
        _ = jobName.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = create_time.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(jobName)?.autoHeightRatio(0)
        
        _ = address.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,10)?.autoHeightRatio(0)
        _ = type.sd_layout().leftSpaceToView(address,5)?.topEqualToView(address)?.autoHeightRatio(0)
        _ = degree.sd_layout().leftSpaceToView(type,5)?.topEqualToView(type)?.autoHeightRatio(0)
        _ = salary.sd_layout().rightEqualToView(create_time)?.topEqualToView(degree)?.autoHeightRatio(0)
        
        jobName.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        type.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        create_time.setMaxNumberOfLinesToShow(1)
        salary.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    static func identity()->String{
        return "jobCell"
    }
    

}
