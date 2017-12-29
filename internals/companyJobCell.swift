//
//  companyJobCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/25.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class companyJobCell: UITableViewCell {

   
    lazy var jobName:UILabel = {
       let lable = UILabel.init()
       lable.font = UIFont.boldSystemFont(ofSize: 15)
       lable.textAlignment = .left
       lable.adjustsFontSizeToFitWidth = true
       lable.textColor = UIColor.black
       return lable
    }()
    
    lazy var address:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var type:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var degree:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var create_time:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .right
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var salary:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textAlignment = .right
        lable.textColor = UIColor.red
        return lable
    }()
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(jobName)
        self.contentView.addSubview(address)
        self.contentView.addSubview(type)
        self.contentView.addSubview(degree)
        self.contentView.addSubview(create_time)
        self.contentView.addSubview(salary)
        
        _ = jobName.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.widthIs(200)?.heightIs(20)
        _ = create_time.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(jobName)?.widthIs(100)?.heightIs(20)
        
        _ = address.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,10)?.bottomSpaceToView(self.contentView,10)?.widthIs(30)?.heightIs(10)
        _ = type.sd_layout().leftSpaceToView(address,5)?.topEqualToView(address)?.bottomEqualToView(address)?.widthIs(30)
        _ = degree.sd_layout().leftSpaceToView(type,5)?.topEqualToView(type)?.bottomEqualToView(type)?.widthIs(60)
        _ = salary.sd_layout().rightEqualToView(create_time)?.topEqualToView(degree)?.bottomEqualToView(degree)?.widthIs(100)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLabel(item:Dictionary<String,String>?){
        jobName.text = item?["jobName"]
        address.text = item?["address"]
        type.text = item?["type"]
        degree.text = item?["degree"]
        create_time.text = item?["create_time"]
        salary.text = item?["salary"]
    }
    
    static func cellHeight() -> CGFloat{
        return 60
    }
    
    static func identity()->String{
        return "jobCell"
    }
    

}
