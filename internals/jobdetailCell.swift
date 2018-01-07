//
//  jobdetailCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class jobdetailCell: UITableViewCell {
    
   
    var model:[String:String]?
    
    
    lazy var jobView:JobItemInfoView = { [unowned self] in
       return JobItemInfoView.init(frame: CGRect.zero)
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.build()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private  func build(){
        self.contentView.addSubview(jobView)
        _ = jobView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
      
       
    }
    
    static func cellHeight() -> CGFloat {
        return 70.0
    }
    
    static func identity()->String{
        return "compuseJobs"
    }
    
    func createCells(items:[String:Any]?){
        
        guard  let  model = items as? [String:String] else {return}
        
        self.model = model
        guard let icon = model["picture"] else {return}
        guard let jobname = model["jobName"] else {return}
        guard let company = model["company"] else {return}
        guard let address = model["address"] else {return}
        guard let degree = model["education"] else {return}

       // guard let type = model["type"] else {return}
        guard let create_time = model["create_time"] else {return}
        guard let salary = model["salary"] else {return}

        
        //self.model = items as? [String:String]?
            // 判断校招 还是实习
        
        self.jobView.setTexts(icon: icon, jobName: jobname, company: company, address: address, type: "社招", degree: degree, internDay: "", create_time: create_time, salary: salary)
        
        
        
        
    }
    
   
    
    

}
