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
        // 完成按钮
        
        textField.inputAccessoryView = UIToolbar.NumberkeyBoardDone(title: "完成", view: self, selector: #selector(endEdit))
        return textField
    }()
    
    
    private lazy var tx:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.isHidden = true
        return img
    }()
    
    
    
    // 修改texfield 对应的数据
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
        setlayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

    private func setlayout(){
        
        let views:[UIView] = [leftTitle, rightLabel, tx, textView]
        self.contentView.sd_addSubviews(views)
        
        _ = leftTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.bottomSpaceToView(self.contentView,15)
        
        _ = rightLabel.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,10)
        _ = textView.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)
        
        _ = tx.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(30)?.autoHeightRatio(1)
        
        tx.setCircle()
        leftTitle.setSingleLineAutoResizeWithMaxWidth(100)
        
        
    }
    
    private func buildCell(){
        
        
        leftTitle.text = mode!.type.rawValue
        
        if mode!.type == personBaseInfo.tx{
            tx.isHidden = false
            rightLabel.isHidden = true
            tx.image = UIImage.init(named: mode!.value)
            return
        }
        
        rightLabel.isEnabled = true
        tx.isHidden = true
        
        if mode!.type  == .name
        || mode!.type == .email || mode?.type == .phone{
            textView.isHidden = false
            textView.text = mode!.value
            textView.keyboardType =  (mode?.type == .phone) ? .numberPad : .default
        }
        else{
            rightLabel.isHidden = false
            rightLabel.text = mode!.value
        }
    
    }
    
    class func identity()->String{
        return "modify_personInfoCell"
    }
    
    class func cellHeight()->CGFloat{
        return 45
    }
}


extension modify_personInfoCell {
    
    // 结束编辑
    @objc func endEdit() {
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



