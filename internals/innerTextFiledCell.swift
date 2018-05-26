//
//  innerTextFiledCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class innerTextFiledCell: UITableViewCell {

    
   
    
    internal lazy var textFiled:customerTextField = {  [unowned self ] in
        let field = customerTextField.init(frame: CGRect.zero)
        //field.delegate = self
        field.textAlignment = .left
        field.clearButtonMode = .whileEditing
        field.keyboardType = UIKeyboardType.default
        field.font = UIFont.systemFont(ofSize: 16)
        //field.inputAccessoryView = UIToolbar.NumberkeyBoardDone(title: "完成", view: self, selector: #selector(done))
       
        
        
        return field
    }()
    
    
    internal var mode:(placeholder:String, title:String, content:String)?{
        didSet{
            //let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
            //v.backgroundColor = UIColor.randomeColor()
            //textFiled.rightView = v
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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


extension innerTextFiledCell{
    @objc private func done(){
        self.textFiled.resignFirstResponder()
    }
}

