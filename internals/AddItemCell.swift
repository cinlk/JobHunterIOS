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
        textField.rightViewMode = UITextFieldViewMode.always
        return textField
    }()
    
    
    
    private let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
   
  
    var mode:(name:String,title:String)?{
        didSet{
            self.textFiled.placeholder = mode!.name
            self.textFiled.text = mode!.title
            if mode?.name == "能力/技能" || mode?.name == "开始时间" ||
                mode?.name == "结束时间" || mode?.name == "学位"{
                img.image = #imageLiteral(resourceName: "arrow_xl")
                textFiled.rightView = img
            }else{
                textFiled.rightView = UIView.init()
            }
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
        _ = textFiled.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.bottomSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,20)
        
       
        
        
        
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


