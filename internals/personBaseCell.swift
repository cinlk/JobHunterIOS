//
//  personBaseCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class personBaseCell: UITableViewCell {

   
    lazy var title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.text = "教育经历"
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.textAlignment = .left
        t.textColor = UIColor.black
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
        title.font = UIFont.systemFont(ofSize: 16)
        let icon:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "chatMore"))
        icon.clipsToBounds = true
        icon.contentMode = .scaleToFill
        v.backgroundColor = UIColor.clear
        
        v.isHidden = true
        v.addSubview(title)
        v.addSubview(icon)
        _ = title.sd_layout().centerXEqualToView(v)?.centerYEqualToView(v)?.widthIs(100)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)
        _ = icon.sd_layout().leftSpaceToView(title,5)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(30)

        
        return v
        
    }()
    
     lazy var contentV:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    // 只有标题的高度
    var describeHeight:CGFloat = 40
    // 标题和defaultview 一起的高度
    var defaultViewHeight:CGFloat = 80
    
    var cellHeight:CGFloat = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.contentView.addSubview(title)
        self.contentView.addSubview(line)
        self.contentView.addSubview(contentV)
        self.contentView.addSubview(defaultView)
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,10)?.heightIs(20)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,2)?.heightIs(1)
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(40)
        
        _ = contentV.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(0)
    }

}
