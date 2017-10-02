//
//  messageItemCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class messageItemCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    
    
    @IBOutlet weak var rightarrow: UIImageView!
    
    
    
    @IBOutlet weak var category: UILabel!
    
    
    @IBOutlet weak var desc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
