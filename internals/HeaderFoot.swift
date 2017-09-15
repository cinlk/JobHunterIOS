//
//  HeaderFoot.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class HeaderFoot: UITableViewHeaderFooterView {

    
    
    var jobName: UILabel!
    
    
    var locate: UILabel!
    
    
    
    var salary: UILabel!
    
    
    
    var time: UILabel!
    
    
    
    var days: UILabel!
    
    
    var scholar: UILabel!
    
    
    
    var hired: UILabel!
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        jobName = UILabel()
        jobName.font = UIFont.boldSystemFont(ofSize: 16)
        locate = UILabel()
        locate.font = UIFont.systemFont(ofSize: 10)
        salary = UILabel()
        salary.font = UIFont.systemFont(ofSize: 10)
        
        time = UILabel()
        time.font = UIFont.systemFont(ofSize: 10)
        
        
        days = UILabel()
        days.font = UIFont.systemFont(ofSize: 10)

        
        scholar = UILabel()
        scholar.font = UIFont.systemFont(ofSize: 10)
        
        hired = UILabel()
        hired.font = UIFont.systemFont(ofSize: 10)

        
        self.contentView.addSubview(jobName)
        self.contentView.addSubview(locate)
        self.contentView.addSubview(salary)
        self.contentView.addSubview(time)
        self.contentView.addSubview(days)
        self.contentView.addSubview(scholar)
        self.contentView.addSubview(hired)
        
        _ = jobName.sd_layout().topSpaceToView(self.contentView,4)?.leftSpaceToView(self.contentView,5)?.widthIs(200)?.heightIs(20)
        _ = locate.sd_layout().topSpaceToView(jobName,10)?.leftSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(10)
        _ = salary.sd_layout().topSpaceToView(jobName,10)?.leftSpaceToView(self.locate,10)?.widthIs(60)?.heightIs(10)
        _ = time.sd_layout().topSpaceToView(jobName,10)?.leftSpaceToView(self.salary,10)?.widthIs(60)?.heightIs(10)
        
        
        
        _ = days.sd_layout().topSpaceToView(self.locate,10)?.leftSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(10)
        
        _ = scholar.sd_layout().topSpaceToView(self.locate,10)?.leftSpaceToView(self.days,10)?.widthIs(60)?.heightIs(10)

        _ = hired.sd_layout().topSpaceToView(self.locate,10)?.leftSpaceToView(self.scholar,10)?.widthIs(60)?.heightIs(10)

        
        

        
        self.contentView.backgroundColor = UIColor.white
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    



}
