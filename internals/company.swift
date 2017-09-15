//
//  company.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class company: UITableViewCell {

    
    
    
    
    @IBOutlet weak var cimage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var infos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cimage.contentMode = .scaleAspectFit
        cimage.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
