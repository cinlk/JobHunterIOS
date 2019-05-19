//
//  SetFourItemTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/19.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let imageSize:CGSize = CGSize.init(width: 40, height: 45)



class SetFourItemTableViewCell: UITableViewCell {

    
   // weak var delegate:selectedItemDelegate?
    
    
    internal var navToVc:((_:UIViewController)->Void)?
    
    private lazy var stack:UIStackView = {
        let sk = UIStackView.init()
        sk.axis = .horizontal
        sk.alignment = .fill
        sk.distribution = .fillEqually
        sk.backgroundColor = UIColor.clear
        sk.spacing = 0
        sk.tintColor = UIColor.black
        return sk
    }()
    
    
    internal var mode:[(UIImage, String, UIViewController)]?{
        didSet{
            guard  let m = mode else {
                return
            }
            
            for (index, item) in m.enumerated(){
                let v = UIView.init()
                let btn = UIButton.init()
                btn.setImage(item.0.changesize(size: imageSize), for: .normal)
                btn.setImage(item.0.changesize(size: imageSize), for: .highlighted)
                btn.tag = index
                btn.addTarget(self, action: #selector(nav), for: .touchUpInside)
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                label.text = item.1
                v.addSubview(label)
                v.addSubview(btn)
                
                _ = btn.sd_layout().centerXEqualToView(label)?.bottomSpaceToView(label,5)?.heightIs(45)?.widthRatioToView(v,1)
                _ = label.sd_layout().bottomSpaceToView(v,5)?.widthRatioToView(v,1)?.heightIs(20)

                stack.addArrangedSubview(v)
                
            }
        }
    }
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        self.contentView.addSubview(stack)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        _ = stack.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func identity()->String{
        return "SetFourItemTableViewCell"
    }
    
    class func cellHeight()->CGFloat{
        return 80
    }
}

extension SetFourItemTableViewCell{
    
   @objc private func nav(btn:UIButton){
        guard  let vc = self.mode?[btn.tag].2 else {
            return
        }
            self.navToVc?(vc)
        }
}


