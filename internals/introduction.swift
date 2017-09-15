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
        // Initialization code
//        _ = label.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,5)?.widthIs(120)?.heightIs(40)
//        _ = line.sd_layout().topSpaceToView(label,5)?.leftEqualToView(self.contentView)?.widthIs(self.frame.width)?.heightIs(1)
//        _ = desc.sd_layout().topSpaceToView(line,10)?.leftSpaceToView(self.contentView,10)?.bottomSpaceToView(self.contentView,5)?.autoHeightRatio(0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
