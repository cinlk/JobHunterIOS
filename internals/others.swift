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
    @IBOutlet weak var weburl: UILabel!

    
    @IBOutlet weak var webDetail: UILabel!
    
    @IBOutlet weak var adressDetail: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let line = UIView()
        line.backgroundColor = UIColor.black
        self.contentView.addSubview(line)
        _ = line.sd_layout().topSpaceToView(label,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
