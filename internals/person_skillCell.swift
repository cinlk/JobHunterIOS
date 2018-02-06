//
//  person_skillCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class person_skillCell: UITableViewCell {

    
    
    private lazy var title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.lineBreakMode = .byTruncatingTail
        t.textAlignment = .left
        t.text = "技能/爱好"
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
    
    private lazy var contentV:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    
    
    
    
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
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(line)
        self.contentView.addSubview(defaultView)
        self.contentView.addSubview(contentV)
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.heightIs(20)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,5)?.heightIs(1)
        
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(30)
        _ = contentV.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(0)
    }
    
    func setContentV(items:[person_skills]){
        guard items.count > 0  else {
            defaultView.isHidden = false
            contentV.height = 0
            return
        }
        
        self.contentV.subviews.forEach { (view) in
            if view.isKind(of: itemView.self){
                view.removeFromSuperview()
            }
        }
        
        var preHeight:CGFloat = 0
        defaultView.isHidden = true
        
        for (index, item) in items.enumerated(){
            let itemV = itemView.init(frame: CGRect.init(x: 0, y: preHeight + 5, width: ScreenW , height: 0))
            itemV.mode = item
            preHeight += itemV.height
            self.contentV.addSubview(itemV)
            
        }
        
        contentV.height = preHeight
        
    }
    
    
    func caculateCellHeight(items:[person_skills])->CGFloat{
       
        guard items.count > 0 else {
            return 55
        }
        var height:CGFloat = 0
        for (index, item) in items.enumerated(){
            let v = itemView()
            height += v.getViewHeight(item: item)
            
        }
        
        return height + 55
    }
    
    class func identity()-> String {
        return "person_skillCell"
    }
    
}

private class itemView:UIView{
    
    lazy private var doticon:UIImageView = {
        let dot = UIImageView.init(frame: CGRect.zero)
        dot.clipsToBounds = true
        dot.image = UIImage.init(named: "singleDot")
        return dot
    }()
    
    
    private lazy var  type:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.lineBreakMode = .byTruncatingTail
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 14)
        return t
    }()
    
    
    private lazy var describe:UILabel = {
        let t = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - 20 , height: 0))
        t.textColor = UIColor.black
        t.lineBreakMode = .byWordWrapping
        t.numberOfLines = 0
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 14)
        return t
        
    }()
    
    
    var mode:person_skills?{
        didSet{
            type.text = mode!.type.rawValue
            describe.text = mode!.describe
            adjustDescribeHeight()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(type)
        self.addSubview(describe)
        self.addSubview(doticon)
        
        _ = doticon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(20)?.heightIs(20)
        
        _ = type.sd_layout().leftSpaceToView(doticon,10)?.topEqualToView(doticon)?.rightSpaceToView(self,10)?.heightIs(20)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func adjustDescribeHeight(){
        if let textHeight = describe.text?.getStringCGRect(size: CGSize.init(width: ScreenW - 50 , height: 0), font: describe.font){
            
            describe.frame = CGRect.init(x: 40, y: 30, width: textHeight.width, height: textHeight.height)
            self.height = describe.height + 35
            describe.sizeToFit()
            return
        }
        
        describe.height = 0
        self.height = 35
        
    }
    
    
    func getViewHeight(item:person_skills)->CGFloat{
        
        describe.text = item.describe
        if  let textHeight = describe.text?.getStringCGRect(size: CGSize.init(width: describe.frame.width, height: 0), font: describe.font){
            return 35 + textHeight.height
        }
        //返回默认高度
        return 35
    }
    
    
}
