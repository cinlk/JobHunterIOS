//
//  deliveredJobs.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class deliveredJobs: UITableViewCell {

    
    
    @IBOutlet weak var logo: UIImageView!
    
    
    @IBOutlet weak var jobname: UILabel!
    
    
    
    @IBOutlet weak var locateAndCompany: UILabel!
    
    
    @IBOutlet weak var creattime: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // 固定imageview 大小， cell 会根据image 改变imageview的大小
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
//        let image = self.imageView?.image
//        self.imageView?.image =  UIImage(named: "warn")
//        super.layoutSubviews()
//        self.imageView?.image = image
        
        
    }
    
}
