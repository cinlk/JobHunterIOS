//
//  person_projectCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class person_projectCell: UITableViewCell {

    lazy private var title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.text = "实习/项目经历"
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.textAlignment = .left
        t.textColor = UIColor.black
        return t
        
    }()
    
    private lazy var line:UIView = {
        let v = UIView.init()
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
    
    
    
    private var cellHeight:CGFloat = 45
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
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
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,10)?.heightIs(20)
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,5)?.heightIs(1)
        
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(30)
        _ = contentV.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(0)
        
        
    }
    
    
    func setContentV(datas:[person_projectInfo]){
        guard datas.count > 0 else {
            defaultView.isHidden = false
            contentV.height = 0
            return
        }
        //
        self.contentV.subviews.forEach { (view) in
            if view.isKind(of: itemView.self){
                view.removeFromSuperview()
            }
        }
        
        defaultView.isHidden = true
        var preHeight:CGFloat = 0
        for (index, item) in datas.enumerated(){
            let v = itemView(frame: CGRect.init(x: 0, y: preHeight + 5, width: ScreenW, height: 0))
            v.mode = item
            preHeight += v.height
            self.contentV.addSubview(v)
            
        }
    
        self.contentV.height = preHeight
        
    }
    
    
    func caculateCellHeight(datas:[person_projectInfo])->CGFloat{
        guard datas.count > 0 else {
            return 65
        }
        var height:CGFloat = 0
        for (index, item) in datas.enumerated(){
            let v = itemView()
            height += v.getViewHeight(item: item)
            
        }
        
        return height + 40
        
        
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
    
    var viewHeight:CGFloat = 0
    
    var mode:person_projectInfo?{
        didSet{
            startEndTime.text = mode!.getTimes(c: "至")
            describtion.text = mode!.content
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
        
             self.height = textHeight.height + 60
             describtion.frame = CGRect.init(x: 40, y: 55, width: textHeight.width, height: textHeight.height)
             describtion.sizeToFit()
             return
        }
        
       
        
        self.height = 60
        describtion.height = 0
        
    }
    
    
    // 动态计算 itemview的高度
    func getViewHeight(item:person_projectInfo)->CGFloat{
        
        describtion.text = item.content
        if  let textHeight = describtion.text?.getStringCGRect(size: CGSize.init(width: describtion.frame.width, height: 0), font: describtion.font){
            return 60 + textHeight.height
        }
        //返回默认高度
        return 60
        
    }
    
    
    
}

