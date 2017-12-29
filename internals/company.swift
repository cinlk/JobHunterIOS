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
        cimage.contentMode = .scaleAspectFit
        cimage.isUserInteractionEnabled = false
        self.selectionStyle = .none
        
        _ = cimage.sd_layout().leftSpaceToView(self.contentView,5)?.topSpaceToView(self.contentView,3)?.bottomSpaceToView(self.contentView,3)?.widthIs(40)
        _ = name.sd_layout().leftSpaceToView(cimage,10)?.topSpaceToView(self.contentView,10)?.widthIs(200)?.heightIs(20)
        _ = infos.sd_layout().leftEqualToView(name)?.topSpaceToView(name,2.5)?.widthIs(200)?.heightIs(15)
        
        
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellHeight() -> CGFloat{
        return 55
    }
}
