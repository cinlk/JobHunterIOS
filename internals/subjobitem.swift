//
//  subjobitem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class subjobitem: UITableViewCell {

    
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var locate: UILabel!
    
    @IBOutlet weak var localicon: UIImageView!
    
    @IBOutlet weak var salary: UILabel!
    
    @IBOutlet weak var salaryIcon: UIImageView!
    
    @IBOutlet weak var business: UILabel!
    
    
    @IBOutlet weak var businessIcon: UIImageView!
    
    
    @IBOutlet weak var internDay: UILabel!
    
    @IBOutlet weak var interdayIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    private func  setLayout(){
        _ = category.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,10)?.heightIs(20)
        _ = localicon.sd_layout().topSpaceToView(category,5)?.bottomSpaceToView(self.contentView,5)?.leftEqualToView(category)?.widthIs(10)?.heightIs(15)
        _ = locate.sd_layout().topEqualToView(localicon)?.leftSpaceToView(localicon,5)?.widthIs(60)?.heightIs(15)
        _ = salaryIcon.sd_layout().topEqualToView(localicon)?.bottomEqualToView(localicon)?.widthIs(15)?.leftSpaceToView(locate,2)
        _ = salary.sd_layout().topEqualToView(salaryIcon)?.bottomEqualToView(salaryIcon)?.widthIs(60)?.leftSpaceToView(salaryIcon,2)
        
        _ = businessIcon.sd_layout().leftSpaceToView(salary,2)?.topEqualToView(salary)?.bottomEqualToView(salary)?.widthIs(10)
        _ = business.sd_layout().leftSpaceToView(businessIcon,2)?.topEqualToView(businessIcon)?.bottomEqualToView(businessIcon)?.widthIs(60)
        
        _ = interdayIcon.sd_layout().leftSpaceToView(business,2)?.topEqualToView(business)?.bottomEqualToView(business)?.widthIs(10)
        
        _ = internDay.sd_layout().leftSpaceToView(interdayIcon,2)?.topEqualToView(interdayIcon)?.bottomEqualToView(interdayIcon)?.widthIs(60)
        
        
        
    }
    static  func identity()->String{
        return "subscribeCondition"
    }
    
    static func cellHeight()->CGFloat{
        return 65
    }
    
}
