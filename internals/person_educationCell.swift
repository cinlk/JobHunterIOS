//
//  person_educationCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let titleStr:String = "教育经历"

class person_educationCell: personBaseCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.title.text = titleStr
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   override dynamic var mode:[Any]?{
        didSet{
            guard let items = mode as? [person_education], items.count > 0  else {
                defaultView.isHidden = false
                contentV.isHidden = true
                // cell 自适应高度
                self.setupAutoHeight(withBottomView: defaultView, bottomMargin: 10)
                return
            }

            contentV.isHidden = false
            defaultView.isHidden = true
            
            self.contentV.subviews.forEach { (view) in
                if view.isKind(of: itemView.self){
                    view.removeFromSuperview()
                }
            }
            
            
            var tmp:[itemView] = []
            
            for (_,item) in items.enumerated(){
                
                let v = itemView.init()
                v.mode = item
                tmp.append(v)
                self.contentV.addSubview(v)
            }
            // contentV 设置元素布局
            self.contentV.setupAutoWidthFlowItems(tmp, withPerRowItemsCount: 1, verticalMargin: 10, horizontalMargin: 0, verticalEdgeInset: 5, horizontalEdgeInset: 5)
            // cell 高度自适应
            
            self.setupAutoHeight(withBottomView: contentV, bottomMargin: 10)
           
            
        }
        
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func identity()->String{
        return "person_educationCell"
    }
    
    

}


//
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
    
    
    lazy private var department:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left

        return t
    }()

    lazy private var combineLabel:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.textColor = UIColor.black
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left

        return t
    }()
    
    
    
    var mode:person_education?{
        didSet{
            startEndTime.text = mode!.startTime + "至" + mode!.endTime
            combineLabel.text = mode!.colleage + "-" + mode!.degree + "-" + mode!.city
            department.text = mode!.department
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let views:[UIView] = [doticon, startEndTime, combineLabel, department]
        self.sd_addSubviews(views)
        _ = doticon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(15)?.heightIs(15)
        _ = startEndTime.sd_layout().leftSpaceToView(doticon,10)?.topEqualToView(doticon)?.rightSpaceToView(self,5)?.autoHeightRatio(0)
        
        _ = combineLabel.sd_layout().leftEqualToView(startEndTime)?.topSpaceToView(startEndTime,5)?.rightSpaceToView(self,5)?.autoHeightRatio(0)
        _ = department.sd_layout().leftEqualToView(startEndTime)?.topSpaceToView(combineLabel,5)?.rightSpaceToView(self,5)?.autoHeightRatio(0)
        // 自动计算view 的高度
        self.setupAutoHeight(withBottomView: department, bottomMargin: 5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
