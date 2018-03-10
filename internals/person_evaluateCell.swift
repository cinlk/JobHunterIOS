//
//  person_ evaluateCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let defaultViewH:CGFloat = 40

@objcMembers class person_evaluateCell: UITableViewCell {

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
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        let icon:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "chatMore"))
        icon.clipsToBounds = true
        icon.contentMode = .scaleToFill
        v.backgroundColor = UIColor.clear
        
        v.isHidden = true
        v.addSubview(title)
        v.addSubview(icon)
        _ = title.sd_layout().centerXEqualToView(v)?.centerYEqualToView(v)?.autoHeightRatio(0)
        _ = icon.sd_layout().leftSpaceToView(title,5)?.topEqualToView(title)?.bottomEqualToView(title)?.widthIs(25)
        return v
        
    }()
    
    private lazy var contentLable:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        label.textColor = UIColor.black
        return label
    }()
    
    
    
    dynamic var mode:String?{
        didSet{
            
            let content = mode?.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            
            
            guard content != nil,  !(content!.isEmpty) else{
                defaultView.isHidden = false
                contentLable.isHidden = true
                self.setupAutoHeight(withBottomView: defaultView, bottomMargin: 10)
                return
            }
            
            contentLable.text = content
            defaultView.isHidden = true
            self.setupAutoHeight(withBottomView: contentLable, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let views:[UIView] = [title, line, defaultView, contentLable]
        self.contentView.sd_addSubviews(views)
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,5)?.heightIs(1)
        
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(defaultViewH)
        
        _ = contentLable.sd_layout().leftEqualToView(title)?.topSpaceToView(line,5)?.autoHeightRatio(0)
        
        contentLable.setMaxNumberOfLinesToShow(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    class func identity()->String{
        return "person_evaluateCell"
        
    }

}


