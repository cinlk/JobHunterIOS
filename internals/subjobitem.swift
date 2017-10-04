//
//  subjobitem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class subjobitem: UITableViewCell {

    
    @IBOutlet weak var leibie: UILabel!
    
    
    
    @IBOutlet weak var locatelogo: UIImageView!
    
    
    @IBOutlet weak var locate: UILabel!
    
    @IBOutlet weak var salarylog: UIImageView!
    
    
    @IBOutlet weak var salary: UILabel!
    
    
    @IBOutlet weak var hangyelogo: UIImageView!
    
    
    @IBOutlet weak var hangye: UILabel!
    
    
    
    
    @IBOutlet weak var shixidaylog: UIImageView!
    
    @IBOutlet weak var shixiday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
