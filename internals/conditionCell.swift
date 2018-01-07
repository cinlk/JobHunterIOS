//
//  conditionCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class conditionCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
  
    
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func identity()->String{
        return "conditin"
    }
    
    class func cellHeight()->CGFloat{
        return 45.0
    }
    
}
