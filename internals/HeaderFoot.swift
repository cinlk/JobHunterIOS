//
//  HeaderFoot.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class HeaderFoot: UITableViewHeaderFooterView {

    
    
    var categoryName: UILabel!
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        print("header cell \(self.frame)")

        categoryName = UILabel()
        categoryName.font = UIFont.boldSystemFont(ofSize: 12)
        categoryName.textAlignment = .center
        categoryName.textColor = UIColor.black
        self.contentView.addSubview(categoryName)
        
        self.contentView.backgroundColor = UIColor.gray
        self.contentView.clipsToBounds = true
        _ = categoryName.sd_layout().topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.widthIs(CGFloat(FRAME_WIDTH_320))?.heightRatioToView(self.contentView,1)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createInfos(jobstring:String?,locatestring:String?,salarystring:String?,timestring:String?,day:String?,
                     scholars:String?,hires:String?){
        
        
        // 在job详细页面头部描述-使用
        var jobName: UILabel!
        var locate: UILabel!
        var salary: UILabel!
        var time: UILabel!
        var days: UILabel!
        var scholar: UILabel!
        var hired: UILabel!
        
        jobName = UILabel()
        jobName.font = UIFont.boldSystemFont(ofSize: 16)
        jobName.text = jobstring ?? ""
        
        locate = UILabel()
        locate.font = UIFont.systemFont(ofSize: 10)
        locate.text = locatestring ?? ""
        salary = UILabel()
        salary.font = UIFont.systemFont(ofSize: 10)
        salary.text = salarystring ?? ""
        time = UILabel()
        time.font = UIFont.systemFont(ofSize: 10)
        time.text = timestring ?? ""
        
        days = UILabel()
        days.font = UIFont.systemFont(ofSize: 10)
        days.text = day ?? ""
        
        scholar = UILabel()
        scholar.font = UIFont.systemFont(ofSize: 10)
        scholar.text = scholars ?? ""
        
        hired = UILabel()
        hired.font = UIFont.systemFont(ofSize: 10)
        hired.text = hires ?? ""
        
        self.contentView.addSubview(jobName)
        self.contentView.addSubview(locate)
        self.contentView.addSubview(salary)
        self.contentView.addSubview(time)
        self.contentView.addSubview(days)
        self.contentView.addSubview(scholar)
        self.contentView.addSubview(hired)
        _ = jobName.sd_layout().topSpaceToView(self.contentView,4)?.leftSpaceToView(self.contentView,5)?.widthIs(200)?.heightIs(20)
        _ = locate.sd_layout().topSpaceToView(jobName,10)?.leftSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(10)
        _ = salary.sd_layout().topSpaceToView(jobName,10)?.leftSpaceToView(locate,10)?.widthIs(60)?.heightIs(10)
        _ = time.sd_layout().topSpaceToView(jobName,10)?.leftSpaceToView(salary,10)?.widthIs(60)?.heightIs(10)
        
        _ = days.sd_layout().topSpaceToView(locate,10)?.leftSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(10)
        
        _ = scholar.sd_layout().topSpaceToView(locate,10)?.leftSpaceToView(days,10)?.widthIs(60)?.heightIs(10)
        
        _ = hired.sd_layout().topSpaceToView(locate,10)?.leftSpaceToView(scholar,10)?.widthIs(60)?.heightIs(10)
    }
    
    



}
