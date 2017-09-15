//
//  JobDescription.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class JobDescription: UITableViewCell {

    
    
    
    @IBOutlet weak var topdescription: UILabel!
    
    
    @IBOutlet weak var works: UILabel!
    
    
    
    @IBOutlet weak var workcontent: UILabel!
    
    
    
    @IBOutlet weak var demand: UILabel!
    
    
    @IBOutlet weak var demandInfo: UILabel!
    
    
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let line = UIView(frame: CGRect(x: 0, y: topdescription.frame.height+10, width: self.contentView.frame.width, height: 1))
        line.backgroundColor = UIColor.gray
        self.contentView.addSubview(line)
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
