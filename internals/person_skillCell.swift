//
//  person_skillCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let titleStr:String = "技能/爱好"

class person_skillCell: personBaseCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.title.text = titleStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override dynamic var mode: [Any]?{
        didSet{
            guard let items = mode as? [person_skills], items.count > 0 else {
                defaultView.isHidden = false
                contentV.isHidden = true
                self.setupAutoHeight(withBottomView: defaultView, bottomMargin: 10)
                return
            }
            
            
            
            contentV.isHidden = false
            defaultView.isHidden = true
            
            // 去掉重复view，由于cell复用
            self.contentV.subviews.forEach { (view) in
                if view.isKind(of: itemView.self){
                    view.removeFromSuperview()
                }
            }
            
            var tmp:[itemView] = []
            for (_, item) in items.enumerated(){
                let v = itemView.init()
                v.mode = item
                tmp.append(v)
                self.contentV.addSubview(v)
            }
            
            self.contentV.setupAutoWidthFlowItems(tmp, withPerRowItemsCount: 1, verticalMargin: 10, horizontalMargin: 0, verticalEdgeInset: 5, horizontalEdgeInset: 5)
            self.setupAutoHeight(withBottomView: contentV, bottomMargin: 10)
        
        }
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
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.lineBreakMode = .byWordWrapping
        t.numberOfLines = 0
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 14)
        return t
        
    }()
    
    
    var mode:person_skills?{
        didSet{
            type.text = mode!.skillType
            describe.text = mode!.describe
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        let views:[UIView] = [doticon, type, describe]
        self.sd_addSubviews(views)
        
        _ = doticon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(15)?.heightIs(15)
        
        _ = type.sd_layout().leftSpaceToView(doticon,10)?.topEqualToView(doticon)?.rightSpaceToView(self,10)?.autoHeightRatio(0)
        _ = describe.sd_layout().leftEqualToView(type)?.rightSpaceToView(self,10)?.topSpaceToView(type,10)?.autoHeightRatio(0)

        type.setMaxNumberOfLinesToShow(1)
        describe.setMaxNumberOfLinesToShow(0)
        self.setupAutoHeight(withBottomView: describe, bottomMargin: 10)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
