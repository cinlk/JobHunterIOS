//
//  RecruiterCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class RecruiterCell: UITableViewCell {

    
    @IBOutlet weak var contact: UILabel!
    
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var position: UILabel!
    
    
    @IBOutlet weak var onlineTime: UILabel!
    var line:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        line = UIView.init()
        line.backgroundColor = UIColor.lightGray
        contact.text = "职位发布者"
        contact.font = UIFont.systemFont(ofSize: 16)
        name.font = UIFont.systemFont(ofSize: 10)
        position.font = UIFont.systemFont(ofSize: 10)
        onlineTime.font = UIFont.systemFont(ofSize: 10)
        onlineTime.textAlignment = .left
        
        self.contentView.addSubview(line)
        _ = contact.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,2.5)?.widthIs(120)?.heightIs(20)
        _ = line.sd_layout().topSpaceToView(contact,2)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        
        
        _ = icon.sd_layout().leftEqualToView(contact)?.topSpaceToView(line,5)?.widthIs(40)?.heightIs(45)
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.widthIs(100)?.heightIs(15)
        
        _ = position.sd_layout().leftEqualToView(name)?.topSpaceToView(name,5)?.widthIs(200)?.heightIs(15)
        
        _ = onlineTime.sd_layout().centerYIs(icon.centerY)?.rightSpaceToView(self.contentView,10)?.widthIs(100)?.heightIs(15)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
