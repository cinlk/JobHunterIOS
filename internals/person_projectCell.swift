//
//  person_projectCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let titleStr:String = "实习/项目经历"

class person_projectCell: personBaseCell {

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.title.text = titleStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override dynamic var mode: [Any]?{
        didSet{
            guard let datas = mode as? [person_projectInfo], datas.count > 0 else{
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
            for (_, item) in datas.enumerated(){
                
                let v = itemView()
                v.mode = item
                tmp.append(v)
                self.contentV.addSubview(v)
            }
           
            self.contentV.setupAutoWidthFlowItems(tmp, withPerRowItemsCount: 1, verticalMargin: 10, horizontalMargin: 0, verticalEdgeInset: 5, horizontalEdgeInset: 5)
            self.setupAutoHeight(withBottomView: contentV, bottomMargin: 10)
            
        }
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
        //t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return t
    }()
    
    
    lazy private var describtion:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.lineBreakMode = .byWordWrapping
        //t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return t
    }()
    
    
    lazy private var combineLabel:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        //t.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return t
    }()
    
    var mode:person_projectInfo?{
        didSet{
            startEndTime.text = mode!.getTimes(c: "至")
            describtion.text = mode!.describe
            combineLabel.text = mode!.getOthers()
            self.setupAutoHeight(withBottomView: describtion, bottomMargin: 10)
            
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views:[UIView] = [doticon, startEndTime, combineLabel, describtion]
        self.sd_addSubviews(views)
        
        _ = doticon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(15)?.heightIs(15)
        _ = startEndTime.sd_layout().leftSpaceToView(doticon,10)?.topEqualToView(doticon)?.rightSpaceToView(self,5)?.autoHeightRatio(0)
        _ = combineLabel.sd_layout().leftEqualToView(startEndTime)?.topSpaceToView(startEndTime,5)?.rightSpaceToView(self,5)?.autoHeightRatio(0)
        _ = describtion.sd_layout().leftEqualToView(combineLabel)?.topSpaceToView(combineLabel,10)?.rightSpaceToView(self,5)?.autoHeightRatio(0)
        
        combineLabel.setMaxNumberOfLinesToShow(1)
        describtion.setMaxNumberOfLinesToShow(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

