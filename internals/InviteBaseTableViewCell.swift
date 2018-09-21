//
//  InviteBaseTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



class InviteBaseTableViewCell: UITableViewCell {

    internal lazy var titleName: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 100)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        return label
    }()
    
    internal lazy var content: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        
        return label
    }()
    
    internal var rightArrow:UIImageView = {
        let arrow = UIImageView()
        arrow.clipsToBounds = true
        arrow.contentMode = .scaleToFill
        arrow.image = #imageLiteral(resourceName: "forward").changesize(size: CGSize.init(width: 15, height: 15))
        arrow.tintColor = UIColor.blue
        return arrow
    }()
    
    
    
    internal lazy var time: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            //newFrame.origin.y += 10
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [titleName, content, time,rightArrow]
        self.contentView.sd_addSubviews(views)
        self.backgroundColor = UIColor.white
        _ = rightArrow.sd_layout().centerYEqualToView(self.contentView)?.rightSpaceToView(self.contentView,10)?.widthIs(15)?.heightEqualToWidth()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}



