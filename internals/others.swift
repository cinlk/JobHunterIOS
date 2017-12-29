//
//  others.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class others: UITableViewCell {


    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var adressDetail: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let line = UIView.init()
        line.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(line)
        _ = line.sd_layout().leftEqualToView(label)?.rightEqualToView(self.contentView)?.topSpaceToView(label,5)?.heightIs(1)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
