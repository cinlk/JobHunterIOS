//
//  person_educationCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


// 一条内容的高度
fileprivate let itemViewH:CGFloat = 80

class person_educationCell: personBaseCell {

    
    private var contentVHeigh:CGFloat = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.title.text = "教育经历"
    }
    
    // 设置内容view
    open func setContentItemView(datas:[person_education]?){
        
        // 即使设置contetV 的高度为0,但是内部view 高度不为0 任然会显示出来
        self.contentV.subviews.forEach { (view) in
            if view.isKind(of: itemView.self){
                view.removeFromSuperview()
            }
        }
        
        // 没有数据显示defaultview
        guard let items = datas, items.count > 0  else{
            defaultView.isHidden = false
            contentV.height = 0
            cellHeight = defaultViewHeight
            return
        }
        
        // 显示数据
        defaultView.isHidden = true
        // 计算contentv 高度： 内容高度 加上 内容之间的间歇
        contentVHeigh =  CGFloat(items.count)*itemViewH + CGFloat(5 * (items.count - 1))
        
        cellHeight = contentVHeigh + describeHeight
        
        contentV.height = contentVHeigh
        
        for (index,item) in items.enumerated(){
            
            let v = itemView.init(frame: CGRect.init(x: 0, y:  index*Int(itemViewH) + 5 , width: Int(ScreenW), height: Int(itemViewH)))
            v.mode = item
            self.contentV.addSubview(v)
            
        }
        
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
    
    
    
    //
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
        self.addSubview(doticon)
        self.addSubview(startEndTime)
        self.addSubview(combineLabel)
        self.addSubview(department)
        
        _ = doticon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(20)?.heightIs(20)
        _ = startEndTime.sd_layout().leftSpaceToView(doticon,10)?.topEqualToView(doticon)?.rightSpaceToView(self,10)?.heightIs(20)
        
        _ = combineLabel.sd_layout().leftEqualToView(startEndTime)?.topSpaceToView(startEndTime,5)?.rightSpaceToView(self,10)?.heightIs(20)
        _ = department.sd_layout().leftEqualToView(startEndTime)?.topSpaceToView(combineLabel,5)?.rightEqualToView(combineLabel)?.heightIs(20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 约束放在这里没有效果？？？
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
    
    
}
