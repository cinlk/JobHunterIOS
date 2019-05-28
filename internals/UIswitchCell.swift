//
//  UIswitchCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/21.
//  Copyright © 2018年 lk. All rights reserved.
//

class switchCell:UITableViewCell{
    
    private lazy var leftLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    lazy var switchOff:UISwitch = { [unowned self] in 
        let sw = UISwitch.init(frame: CGRect.zero)
        sw.isOn = true
        sw.addTarget(self, action: #selector(change(_:)), for: .valueChanged)
        return sw
    }()
    
    
    var callChange:((_ name:String, _ sender: UISwitch)->Void)?
    
    var mode:(on:Bool, tag:Int, name:String)?{
        didSet{
            self.switchOff.isOn = mode!.on
            self.switchOff.tag = mode!.tag
            self.leftLabel.text = mode!.name
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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


extension switchCell{
    @objc private func change(_ sender:UISwitch){
        self.callChange?(mode!.name,sender)
    }
}
