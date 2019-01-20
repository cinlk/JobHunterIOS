//
//  innerTextFiledCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class InnerTextFiledCell: UITableViewCell {

    
    internal lazy var textFiled:CustomerTextField = {  [unowned self ] in
        let field = CustomerTextField.init(frame: CGRect.zero)
        field.keyboardType = UIKeyboardType.asciiCapable
        return field
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none 
        self.contentView.addSubview(textFiled)
        
        
        _ = textFiled.sd_layout().leftEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.rightEqualToView(self.contentView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "innerTextFiledCell"
    }
    
    

}


extension InnerTextFiledCell{
    @objc private func done(){
        self.textFiled.resignFirstResponder()
    }
}

