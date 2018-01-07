//
//  deliveryItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class deliveryItemCell: UITableViewCell {

    
    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var resulte: UILabel!
    @IBOutlet weak var create_time: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func identity()->String{
        return "delieveryItem"
    }
    
    class func cellHeight()->CGFloat {
        return  68.0
    }
}
