//
//  company.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class CompanySimpleCell: UITableViewCell {

    @IBOutlet weak var cimage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var infos: UILabel!
    
    
    
    var mode:CompanyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            
            cimage.image = UIImage.init(named: mode.icon)
            name.text = mode.name
            let address = mode.address?.joined(separator: " ")  ?? "--"
            let industry = mode.industry?.joined(separator: " ") ?? "--"
            let staff  = mode.staffs ?? "--"
            let res = [address, industry, staff]
            infos.text = res.joined(separator: "|")
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        infos.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        infos.font = UIFont.systemFont(ofSize: 12)
        
        cimage.contentMode = .scaleAspectFit
        self.selectionStyle = .none
        
        _ = cimage.sd_layout().leftSpaceToView(self.contentView,5)?.topSpaceToView(self.contentView,3)?.bottomSpaceToView(self.contentView,3)?.widthIs(40)
        _ = name.sd_layout().leftSpaceToView(cimage,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = infos.sd_layout().leftEqualToView(name)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        
        name.setMaxNumberOfLinesToShow(1)
        infos.setMaxNumberOfLinesToShow(1)
        
        //self.setupAutoHeight(withBottomView: cimage, bottomMargin: 10)
    }

   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func identity()->String{
        return "CompanySimpleCell"
    }
    
    class func cellHeight()->CGFloat{
        
        return 60
    }
}
