//
//  person_ evaluateCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class person_evaluateCell: UITableViewCell {

    private  lazy var  title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textAlignment = .left
        t.font = UIFont.boldSystemFont(ofSize: 15)
        t.text = "自我评价"
        return t
    }()
    
    
    private lazy var line:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    // 没有数据显示该view
    private lazy var defaultView:UIView = {
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
        _ = icon.sd_layout().rightSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(30)
        _ = title.sd_layout().leftSpaceToView(v,10)?.rightSpaceToView(icon,20)?.topEqualToView(icon)?.bottomEqualToView(icon)
        
        return v
        
    }()
    
    private lazy var contentLable:UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - 20, height: 0))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()
    
    
    var cellHeight:CGFloat = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(line)
        self.contentView.addSubview(defaultView)
        self.contentView.addSubview(contentLable)
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.heightIs(20)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,5)?.heightIs(1)
        
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(30)
        
        
    }
    
    func setContentV(content:inout String){
        content = content.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        guard !content.isEmpty else{
            defaultView.isHidden = false
            contentLable.height = 0
            cellHeight = 80
            return
        }
        contentLable.text = content
        defaultView.isHidden = true
        if let contentHeight = contentLable.text?.getStringCGRect(size: CGSize.init(width: contentLable.width, height: 0), font: contentLable.font){
            contentLable.frame = CGRect.init(x: 10, y: 35, width: contentHeight.width, height: contentHeight.height)
            self.height = 45 + contentHeight.height
            contentLable.sizeToFit()
            
        }
        
        cellHeight = self.height
        
    }
    
    class func identity()->String{
        return "person_evaluateCell"
        
    }

}


