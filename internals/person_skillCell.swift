//
//  person_skillCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class person_skillCell: personBaseCell {
    
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.title.text = "技能/爱好"
    }
    
    
    
    func setContentV(items:[person_skills]){
        
        self.contentV.subviews.forEach { (view) in
            if view.isKind(of: itemView.self){
                view.removeFromSuperview()
            }
        }
        
        guard items.count > 0  else {
            defaultView.isHidden = false
            contentV.height = 0
            cellHeight = defaultViewHeight
            return
        }
        
        
        var preHeight:CGFloat = 0
        defaultView.isHidden = true
        
        for (_, item) in items.enumerated(){
            let itemV = itemView.init(frame: CGRect.init(x: 0, y: preHeight + 5, width: ScreenW , height: 0))
            itemV.mode = item
            preHeight += itemV.height
            self.contentV.addSubview(itemV)
            
        }
        contentV.height = preHeight
        cellHeight = describeHeight + preHeight
        
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
    
    private var defaultH:CGFloat = 35
    
    var mode:person_skills?{
        didSet{
            type.text = mode!.skillType
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
            self.height = describe.height + defaultH
            describe.sizeToFit()
            return
        }
        
        describe.height = 0
        self.height = defaultH
        
    }
    
    
    
}
