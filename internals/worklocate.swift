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
    
    
    @IBOutlet weak var forward: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        forward.contentMode  = .scaleAspectFit
        
        
        forward.image  = UIImage(named: "rightforward")
        forward.backgroundColor = UIColor.white
        
        let line = UIView(frame: CGRect(x: 0, y: locate.frame.height+10, width: self.contentView.frame.width, height: 1))
        line.backgroundColor = UIColor.gray
        self.contentView.addSubview(line)
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
