//
//  modify_personInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/6.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



protocol changeDataDelegate:class {
    
    func changeBaseInfo(type:personBaseInfo, value:String)
    func changeEducationInfo(viewType:resumeViewType,type:personBaseInfo, row:Int, value:String)
    
    
    //@objc optional func changeDataByName(name:String, value:String)
}


class modify_personInfoCell: UITableViewCell {

    
    private lazy var leftTitle:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .left
        return title
        
    }()
    
    private lazy var rightLabel:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.isHidden = true
        title.textAlignment = .right
        return title
    }()
    
    
    lazy var textView:UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect.zero)
        textField.borderStyle = UITextBorderStyle.none
        textField.placeholder = ""
        textField.textColor = UIColor.black
        textField.textAlignment = .right
        textField.adjustsFontSizeToFitWidth = false
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.isHidden = true
        textField.delegate = self
        return textField
    }()
    
    
    private lazy var tx:UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize.width, height: avatarSize.height))
        img.clipsToBounds = true
        img.isHidden = true
        return img
    }()
    // 数字键盘 的tabbutton
    private lazy var doneButton:UIToolbar = { [unowned self] in
        
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneNum))
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
    }()
    
    
    weak var delegate:changeDataDelegate?
    
    // cell 数据
    var mode:(type:personBaseInfo,value:String)?{
        didSet{
            buildCell()
            
        }
    }
    
   
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
        tx.setCircle()
        self.contentView.addSubview(leftTitle)
        self.contentView.addSubview(rightLabel)
        self.contentView.addSubview(tx)
        self.contentView.addSubview(textView)
        
        _ = leftTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.bottomSpaceToView(self.contentView,15)?.widthIs(100)
        
        _ = rightLabel.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)
        
        _ = textView.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)
        
        _ = tx.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(40)
        
        
        
        
    }

    
    private func buildCell(){
        
        
        leftTitle.text = mode!.type.rawValue
        
        if mode!.type == personBaseInfo.tx{
            tx.isHidden = false
            rightLabel.isHidden = true
            tx.image = UIImage.init(named: mode!.value)
            
        }else{
            rightLabel.isEnabled = true 
            tx.isHidden = true
            if mode!.type  == personBaseInfo.name
            || mode!.type == personBaseInfo.email{
                textView.isHidden = false
                textView.text = mode!.value
                textView.inputAccessoryView?.removeFromSuperview()
                
            }else if mode!.type == personBaseInfo.phone{
                textView.isHidden = false
                textView.text = mode!.value
                textView.keyboardType = .numberPad
                textView.inputAccessoryView = doneButton
                
            }
            else{
                rightLabel.isHidden = false
                rightLabel.text = mode!.value
            }
        }
        
    }
    
    class func identity()->String{
        return "modify_personInfoCell"
    }
}


extension modify_personInfoCell {
    
    
    @objc func doneNum() {
        self.endEditing(true)
    }
 
}

extension modify_personInfoCell: UITextFieldDelegate{
    
   
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            self.delegate?.changeBaseInfo(type: mode!.type, value: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



