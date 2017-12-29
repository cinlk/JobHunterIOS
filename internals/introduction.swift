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
        
//        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.widthIs(120)?.heightIs(25)
//        _ = line.sd_layout().topSpaceToView(label,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
//        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
