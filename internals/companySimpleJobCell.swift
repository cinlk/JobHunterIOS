//
//  companyJobCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/25.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers class companySimpleJobCell: UITableViewCell {

   
    private lazy var jobName:UILabel = {
       let lable = UILabel.init()
       lable.font = UIFont.boldSystemFont(ofSize: 15)
       lable.textAlignment = .left
       lable.adjustsFontSizeToFitWidth = true
       lable.textColor = UIColor.black
       lable.setSingleLineAutoResizeWithMaxWidth(300)
       return lable
    }()
    
    private lazy var address:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        lable.setSingleLineAutoResizeWithMaxWidth(300)
        return lable
    }()
    
    private lazy var internTag:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .center
        lable.backgroundColor = UIColor.orange
        lable.textColor = UIColor.white
        lable.isHidden = true
        lable.text = "实习"
        lable.setSingleLineAutoResizeWithMaxWidth(100)
        return lable
    }()
    
    private lazy var degree:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        lable.setSingleLineAutoResizeWithMaxWidth(100)
        return lable
    }()
    
    private lazy var create_time:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .right
        lable.textColor = UIColor.blue
        lable.setSingleLineAutoResizeWithMaxWidth(160)
        return lable
    }()
    

    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            jobName.text = mode.name
            address.text = mode.addressStr
            degree.text =  mode.education + " |"
            create_time.text = mode.creatTimeStr
            // TODO 改成 attache image ？？
            internTag.isHidden =  mode.kind! == .intern ? false : true
           
            self.setupAutoHeight(withBottomViewsArray: [address,degree], bottomMargin: 10)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [jobName,address,internTag,degree,create_time]
        self.contentView.sd_addSubviews(views)
        
        _ = jobName.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = internTag.sd_layout().leftSpaceToView(jobName,5)?.centerYEqualToView(jobName)?.autoHeightRatio(0)
        _ = create_time.sd_layout().topEqualToView(jobName)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = degree.sd_layout().topSpaceToView(jobName,10)?.leftEqualToView(jobName)?.autoHeightRatio(0)
        _ = address.sd_layout().leftSpaceToView(degree,5)?.topEqualToView(degree)?.autoHeightRatio(0)
        
        jobName.setMaxNumberOfLinesToShow(2)
        address.setMaxNumberOfLinesToShow(2)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    static func identity()->String{
        return "companySimpleJobCell"
    }
    

}
