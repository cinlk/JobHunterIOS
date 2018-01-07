//
//  visitorCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class visitorCell: UITableViewCell {

    @IBOutlet weak var avartar: UIImageView!
    
    @IBOutlet weak var visite_time: UILabel!
    
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var company_title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.avartar.contentMode = .scaleAspectFit
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
    class func identity()->String{
        return "visitorCell"
    }
    
    class func cellHeight()->CGFloat{
        return 65.0
    }
    
    
}
