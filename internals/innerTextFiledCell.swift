//
//  innerTextFiledCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class innerTextFiledCell: UITableViewCell {

    
    private lazy var label:UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = .left
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = UIColor.black
        lb.setSingleLineAutoResizeWithMaxWidth(120)
        return lb
    }()
    
    private lazy var textFiled:UITextField = {  [unowned self ] in
        let field = UITextField.init()
        field.delegate = self
        field.textAlignment = .left
        field.clearButtonMode = .whileEditing
        field.keyboardType = UIKeyboardType.default
        field.font = UIFont.systemFont(ofSize: 16)
        field.inputAccessoryView = UIToolbar.NumberkeyBoardDone(title: "完成", view: self, selector: #selector(done))
        field.placeholder = ""
        return field
    }()
    
    
    internal var mode:(placeholder:String, title:String, content:String)?{
        didSet{
            self.textFiled.placeholder = mode?.placeholder
            self.label.text = mode?.title
            self.textFiled.text = mode?.content
            
            
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.contentView.addSubview(textFiled)
        
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
        _ = textFiled.sd_layout().leftSpaceToView(label,10)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.rightSpaceToView(self.contentView,10)
        
        label.setMaxNumberOfLinesToShow(1)
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
extension innerTextFiledCell:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            self.textFiled.placeholder = mode?.placeholder
            return
        }
        self.textFiled.placeholder = text.isEmpty ? mode?.placeholder : ""
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            self.textFiled.placeholder = mode?.placeholder
            return
        }
        self.textFiled.placeholder = text.isEmpty ? mode?.placeholder : ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
}
