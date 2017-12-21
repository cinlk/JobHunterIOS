//
//  worklocate.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class worklocate: UITableViewCell {

    
    
    @IBOutlet weak var locate: UILabel!
    
    
    @IBOutlet weak var details: UILabel!
    
    var line:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        locate.font = UIFont.boldSystemFont(ofSize: 16)
        details.font = UIFont.systemFont(ofSize: 12)
        details.textColor = UIColor.gray
        locate.textColor = UIColor.black
        
        _  = locate.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(200)?.heightIs(25)
        
        line = UIView.init()
        
        line.backgroundColor = UIColor.gray
        self.contentView.addSubview(line)
        
          _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(locate,5)?.heightIs(1)
        
        _ = details.sd_layout().topSpaceToView(line,5)?.leftEqualToView(locate)?.widthIs(260)?.heightIs(20)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
