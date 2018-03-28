//
//  contactlist.swift
//  internals
//
//  Created by ke.liang on 2017/10/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class contactlist: UITableViewCell {

    
    // 背景阴影
    var cellBackGroud:UIView!
    
    @IBOutlet weak var avarta: UIImageView!
    
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var lastmessage: UILabel!
    
    @IBOutlet weak var days: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 类型方法 resueidentifire
    class func resueIdentifier()->String{
        return  "friends"
    }
    
    class func height()->CGFloat{
        return 56
    }
    
    
    func setupFriendCell(user:PersonModel){
      
    }
    
}
