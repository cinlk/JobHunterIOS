//
//  personBaseCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let defaultViewH:CGFloat = 40

@objcMembers  class personBaseCell: UITableViewCell {

   
    lazy var title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.textAlignment = .left
        t.textColor = UIColor.black
        t.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return t
        
    }()
    
     lazy var line:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    // 没有数据显示该view
     lazy var defaultView:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        let title:UILabel = UILabel.init(frame: CGRect.zero)
        title.text = "添加数据"
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20)
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        
        let icon:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "chatMore"))
        
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        v.backgroundColor = UIColor.clear
        
        v.isHidden = true
        v.addSubview(title)
        v.addSubview(icon)
        _ = title.sd_layout().centerXEqualToView(v)?.centerYEqualToView(v)?.autoHeightRatio(0)
        _ = icon.sd_layout().leftSpaceToView(title,5)?.topEqualToView(title)?.bottomEqualToView(title)?.widthIs(25)
        
        return v
        
    }()
    
     lazy var contentV:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.clear
        
        return v
    }()
    
    dynamic var mode:[Any]?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let views = [title, line, contentV, defaultView]
        self.contentView.sd_addSubviews(views)
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,2)?.heightIs(1)
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(defaultViewH)
        
        _ = contentV.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
