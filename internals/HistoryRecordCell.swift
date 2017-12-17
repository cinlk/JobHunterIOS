//
//  HistoryRecordCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/10.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class HistoryRecordCell: UITableViewCell {

    var leftImage:UIImageView!
    var item:UILabel!
    var deleteIcon:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftImage = UIImageView.init()
        leftImage.image = #imageLiteral(resourceName: "clock")
        leftImage.contentMode = .scaleAspectFit
        leftImage.clipsToBounds = true
        
        item = UILabel.init()
        item.text = ""
        item.textColor = UIColor.black
        
        
        deleteIcon = UIButton.init(type: .custom)
        deleteIcon.setImage(UIImage.init(named: "cancel"), for: .normal)
        deleteIcon.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(leftImage)
        self.contentView.addSubview(item)
        self.contentView.addSubview(deleteIcon)
        
        
        _ = leftImage.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(20)
        _ = item.sd_layout().leftSpaceToView(leftImage,20)?.topEqualToView(leftImage)?.bottomEqualToView(leftImage)?.widthIs(220)
        
        _ = deleteIcon.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftImage)?.bottomEqualToView(leftImage)?.widthIs(20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    static func identity()->String{
        return "recordName"
    }
    
    static func Height()->CGFloat{
        return 40
    }
    
    

}
