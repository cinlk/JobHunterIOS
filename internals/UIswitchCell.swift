//
//  UIswitchCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/21.
//  Copyright © 2018年 lk. All rights reserved.
//

class switchCell:UITableViewCell{
    
    lazy var leftLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    lazy var switchOff:UISwitch = {
        let sw = UISwitch.init(frame: CGRect.zero)
        sw.isOn = true 
        return sw
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        //self.isUserInteractionEnabled = false
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(switchOff)
        _ = leftLabel.sd_layout().leftSpaceToView(self.contentView,16)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(200)
        _ = switchOff.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "switchCell"
    }
    
    // 实现switch View部分点击
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let newp = self.contentView.convert(point, to: switchOff)
        if switchOff.point(inside: newp, with: event){
            // 继续找到switchOff 的某个子view来响应事件
            return super.hitTest(point, with: event)
        }
        return  nil
        
    }
    
}