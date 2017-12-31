//
//  introduction.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class introduction: UITableViewCell {

    
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
              
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
