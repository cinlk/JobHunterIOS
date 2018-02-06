//
//  person_educationCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let itemViewH:CGFloat = 80

class person_educationCell: UITableViewCell {

   
     lazy private var title:UILabel = {
        let t = UILabel.init(frame: CGRect.zero)
        t.text = "教育经历"
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
   
    
    var contentVHeigh:CGFloat = 0
    private var cellHeight:CGFloat = 0
    
    
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
        self.contentView.addSubview(contentV)
        self.contentView.addSubview(defaultView)
        _ = title.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,10)?.heightIs(20)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(title,2)?.heightIs(1)
        _ = defaultView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(40)
        
        _ = contentV.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(0)
        
    }
    
    
    
    class func identity()->String{
        return "person_educationCell"
    }
    
    open func setContentItemView(datas:[person_education]?){
        
        guard let items = datas, items.count > 0  else{
            defaultView.isHidden = false
            contentV.height = 0
            cellHeight = 80
            return
        }
        defaultView.isHidden = true
        
        // 有数据
        self.contentV.subviews.forEach { (view) in
            if view.isKind(of: itemView.self){
                view.removeFromSuperview()
            }
        }
        // 计算contentv 的高度
        contentVHeigh =  CGFloat(items.count)*itemViewH + CGFloat(5 * (items.count - 1))
        cellHeight = contentVHeigh + 40
        
        contentV.height = contentVHeigh
        
        for (index,item) in items.enumerated(){
            
            let v = itemView.init(frame: CGRect.init(x: 0, y:  index*Int(itemViewH) + 5 , width: Int(ScreenW), height: Int(itemViewH)))
            v.mode = item
            self.contentV.addSubview(v)
            
        }
        
    }
    
    
    open func caculateCellHeight(datas:[person_education])->CGFloat{
        guard datas.count > 0  else {
            return 80
        }
        // 计算contentv 的高度
        let  h  =  CGFloat(datas.count)*itemViewH + CGFloat(5 * (datas.count - 1))
        return h + 40
        
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
            department.text = mode!.department
            combineLabel.text = mode!.colleage + "-" + mode!.degree + "-" + mode!.city
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
