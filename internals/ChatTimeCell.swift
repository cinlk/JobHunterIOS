//
//  ChatTimeCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ChatTimeCell: UITableViewCell {

    
    var model: TimeMessage?{
        didSet{
            setModel()
        }
    }
    
    lazy var timeLabel:UILabel = {
        let time = UILabel.init(frame: CGRect.zero)
        time.textColor = UIColor.white
        time.font = UIFont.systemFont(ofSize: 12.0)
        return time
    }()
    
    lazy var bgView:UIView = {
        let bg = UIView.init(frame: CGRect.zero)
        bg.layer.cornerRadius = 4
        bg.layer.masksToBounds = true
        bg.backgroundColor = UIColor.init(r: 190.0, g: 190.0, b: 190.0)
        return bg
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(bgView)
        self.contentView.addSubview(timeLabel)
        
        
        
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    class func identity()->String{
        return "ChatTimeCell"
    }
    
    class func cellHeight()->CGFloat{
        return 25.0
    }
   

}

extension ChatTimeCell{
    fileprivate func setModel(){
        guard model != nil else {
            return
        }
        
        timeLabel.text = model?.timeStr
        timeLabel.sizeToFit()
        _ = timeLabel.sd_layout().centerXEqualToView(self.contentView)?.widthIs(timeLabel.width)?.heightIs(timeLabel.height)?.centerYEqualToView(self.contentView)
        
         _ = bgView.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)?.widthIs(timeLabel.width + 10)?.heightIs(timeLabel.height + 6)
        
    }
}
