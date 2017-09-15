//
//  joblist.swift
//  internals
//
//  Created by ke.liang on 2017/9/10.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class joblist: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    
    
    @IBOutlet weak var locate: UILabel!
    
    
    
    @IBOutlet weak var times: UILabel!
    @IBOutlet weak var days: UILabel!
    
    
    
    @IBOutlet weak var money: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
