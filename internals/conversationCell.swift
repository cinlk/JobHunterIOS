//
//  conversationCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class conversationCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var touxiang: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    class func identity()->String{
        return "conversationCell"
    }
    
    class func cellHeight()->CGFloat {
        return 60.0
    }
    
    
}
