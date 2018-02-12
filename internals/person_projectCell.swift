//
//  person_projectCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class person_projectCell: personBaseCell {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.title.text = "实习/项目经历"
        
    }
    
    func setContentV(datas:[person_projectInfo]){
        
        self.contentV.subviews.forEach { (view) in
            if view.isKind(of: itemView.self){
                view.removeFromSuperview()
            }
        }
        
        guard datas.count > 0 else {
            defaultView.isHidden = false
            contentV.height = 0
            cellHeight = defaultViewHeight
            return
        }
        // 显示数据
        
        defaultView.isHidden = true
        var preHeight:CGFloat = 0
        
        for (_, item) in datas.enumerated(){
            let v = itemView(frame: CGRect.init(x: 0, y: preHeight + 5, width: ScreenW, height: 0))
            v.mode = item
            preHeight += v.height
            self.contentV.addSubview(v)
        }
        self.contentV.height = preHeight
        
        cellHeight = describeHeight + preHeight
    }
    
    
    class func identity()->String{
        return "person_projectCell"
    }
}



private class itemView:UIView{
    
    
    lazy private var doticon:UIImageView = {
        let dot = UIImageView.init(frame: CGRect.zero)
        dot.clipsToBounds = true
        dot.image = UIImage.init(named: "singleDot")
        return dot
    }()
    
    lazy private var startEndTime:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        return t
    }()
    
    
    lazy private var describtion:UILabel = {
        let t = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 0))
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.lineBreakMode = .byWordWrapping
        t.numberOfLines = 0
        
        return t
    }()
    
    
    lazy private var combineLabel:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        return t
    }()
    
    private var defaultH:CGFloat = 60
    
    var mode:person_projectInfo?{
        didSet{
            startEndTime.text = mode!.getTimes(c: "至")
            describtion.text = mode!.describe
            combineLabel.text = mode!.getOthers()
            describelHeight()
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(doticon)
        self.addSubview(startEndTime)
        self.addSubview(combineLabel)
        self.addSubview(describtion)
        
        _ = doticon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(20)?.heightIs(20)
        _ = startEndTime.sd_layout().leftSpaceToView(doticon,10)?.topEqualToView(doticon)?.rightSpaceToView(self,10)?.heightIs(20)
        
        _ = combineLabel.sd_layout().leftEqualToView(startEndTime)?.rightEqualToView(startEndTime)?.topSpaceToView(startEndTime,5)?.heightIs(20)
        
        //_ = describtion.sd_layout().topSpaceToView(combineLabel,5)?.leftEqualToView(combineLabel)?.widthIs(ScreenW - 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // describe label 固定frame 大小，不能用约束才能设置动态高度和换行??? 与其他组件固定距离
    private func describelHeight(){
        if  let textHeight = describtion.text?.getStringCGRect(size: CGSize.init(width: ScreenW - 50, height: 0), font: describtion.font){
        
             self.height = textHeight.height + defaultH
             describtion.frame = CGRect.init(x: 40, y: 55, width: textHeight.width, height: textHeight.height)
             describtion.sizeToFit()
             return
        }
        
        self.height = defaultH
        describtion.height = 0
        
    }
    

    
    
    
}

