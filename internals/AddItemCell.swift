//
//  AddItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class AddItemCell: UITableViewCell {

    
    lazy var textFiled:UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect.zero)
        textField.borderStyle = UITextBorderStyle.none
        textField.placeholder = ""
        textField.textColor = UIColor.black
        textField.textAlignment = .right
        textField.adjustsFontSizeToFitWidth = false
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.textAlignment = .left
        return textField
    }()
    
 
    var mode:(name:String,title:String)?{
        didSet{
            self.textFiled.placeholder = mode!.name
            self.textFiled.text = mode!.title
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(textFiled)
        _ = textFiled.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.bottomSpaceToView(self.contentView,10)?.widthIs(200)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func identity()->String{
        return "AddItemCell"
    }
    
    class func cellHeight()->CGFloat{
        return 50
    }
    
   
}


