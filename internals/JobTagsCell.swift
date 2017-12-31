//
//  JobTagsCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let ROWITEMS = 4

class JobTagsCell: UITableViewCell {
    
    
    var sub:UIView!
    
    var onece  = true
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.gray
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension JobTagsCell{
    
    // 保证 item 的左右上下与 contentview 间距一致
    func  interTagView(_ tags:[String]?){
        
        guard  onece  else {
            return
        }
        guard tags != nil && !(tags!.isEmpty) else {
            return
        }
        // cell 复用后，保存tag button 不变
        onece = false
        sub  = UIView.init()
        sub.backgroundColor = UIColor.clear
        self.contentView.addSubview(sub)
        
        _ = sub.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        var res:CGFloat = 0
        var row:CGFloat = 0
        var x:CGFloat = 0
        var y:CGFloat = 0
        for (index, item) in (tags?.enumerated())!{
            
            if (index %  ROWITEMS == 0  && index != 0) {
                row += 1
            }
            // 默认选择第一个
            
            let btn = UIButton.init(type: .custom)
            btn.setTitle(item, for: .normal)
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.white, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            if index == 0{
                btn.isSelected = true
                btn.backgroundColor = UIColor.blue
            }
            btn.addTarget(self, action: #selector(chooseTag(sender:)), for: .touchUpInside)
            res = CGFloat(index  % ROWITEMS)
            switch res{
            case 0:
                x = 12.5
            case 1:
                x = 102.5
            case 2:
                x = 192.5
            case 3:
                x = 282.5
            default:
                break
            }
            y = row*35 + 10
            btn.frame = CGRect.init(x: x, y: y, width: 80, height: 30)
            sub.addSubview(btn)
        }
        
       
        
        
    }
    
    @objc func chooseTag(sender:UIButton){
        self.sub.subviews.forEach { (view) in
            if view.isKind(of: UIButton.self){
                let btn = view as! UIButton
                if  btn == sender{
                    btn.isSelected = true
                    btn.backgroundColor = UIColor.blue
                }else{
                    btn.isSelected = false
                    btn.backgroundColor = UIColor.white
                }
            }
        }
        if let tag = sender.titleLabel?.text{
            NotificationCenter.default.post(name: NSNotification.Name.init("whichTag"), object: tag)
        }
      
        
    }
    
    static func identity()->String{
        return "jobtags"
    }
}
