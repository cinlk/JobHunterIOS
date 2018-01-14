//
//  JobMessageCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class JobMessageCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var tags: UILabel!
    
    @IBOutlet weak var salary: UILabel!
    // 重写frame
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.origin.y += 10
            newFrame.size.height -= 20
            super.frame = newFrame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
    
        
    }
    
    class func identitiy()->String{
        return "jobMessageCard"
    }
    
    class func cellHeight()->CGFloat{
        return 100.0
    }
    
    private func setViews(){
        _ = self.icon.sd_layout().topSpaceToView(self.contentView,5)?.leftEqualToView(self.contentView)?.widthIs(40)?.heightIs(30)
        _ = self.jobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,5)?.widthIs(200)?.heightIs(20)
        
        _ = self.company.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,2.5)?.widthIs(120)?.heightIs(15)
        _ = self.tags.sd_layout().leftEqualToView(company)?.topSpaceToView(company,2.5)?.widthIs(200)?.heightIs(15)
        
        _ = salary.sd_layout().topEqualToView(icon)?.rightSpaceToView(self.contentView,5)?.widthIs(100)?.heightIs(15)
        
        
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
