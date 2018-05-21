//
//  modify_personInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/6.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



protocol changeDataDelegate:class {
    
    func changeBasicInfo(type:ResumeInfoType, value:String)
    
}


// 全局变量 保存不同类型的picker的位置
fileprivate var pickPosition:[ResumeInfoType:[Int:Int]] = [:]


class modifyPersonInfoCell: UITableViewCell {

    
    internal var onlyPickerResumeType:[ResumeInfoType] = []

    
    private lazy var leftTitle:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .left
        title.setSingleLineAutoResizeWithMaxWidth(100)

        return title
        
    }()
    
    
    private lazy var textField:UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect.zero)
        textField.borderStyle = UITextBorderStyle.none
        textField.placeholder = ""
        textField.textColor = UIColor.black
        textField.textAlignment = .right
        textField.adjustsFontSizeToFitWidth = false
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.delegate = self
        
        
        return textField
    }()
    
    
    //
    private lazy var pickView:itemPickerView = {
        let pick = itemPickerView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: 200))
        pick.backgroundColor = UIColor.white
        pick.pickerDelegate = self
        return pick
        
    }()
    
    
    
    
    private lazy var tx:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.isHidden = true
        return img
    }()
    
    
    
    // 修改texfield 对应的数据
    weak var delegate:changeDataDelegate?
    
   
    var mode:(type:ResumeInfoType, title:String)?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            self.leftTitle.text = mode.type.describe
            
           
            if mode.type == .tx{
                textField.isHidden = true
                tx.isHidden = false
                self.tx.image = UIImage.init(named: mode.title)
                return
            }
            
            self.textField.text = mode.title
            self.textField.inputView =  onlyPickerResumeType.contains(mode.type) ? pickView : nil
            self.textField.keyboardType =  mode.type == .phone ? .numberPad : .default
            self.textField.inputAccessoryView =  onlyPickerResumeType.contains(mode.type) ?  nil : UIToolbar.NumberkeyBoardDone(title: "完成", view: self, selector: #selector(endEdit))
            
            if onlyPickerResumeType.contains(mode.type){
                pickView.mode = (mode.type.describe, SelectItemUtil.shared.getItems(name: mode.type.describe)!)
                
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
        let views:[UIView] = [leftTitle, tx, textField]
        self.contentView.sd_addSubviews(views)
        
        _ = leftTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.autoHeightRatio(0)
        
        
        _ = textField.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)
        
        _ = tx.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(30)?.autoHeightRatio(1)
        
        tx.sd_cornerRadiusFromWidthRatio = 0.5
        
        
    }

    
    class func identity()->String{
        return "modifyPersonInfoCell"
    }
    
    class func cellHeight()->CGFloat{
        return 45
    }
}



extension modifyPersonInfoCell: itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.textField.resignFirstResponder()
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
        guard  let mode = mode  else {
            return
        }
        
        pickPosition[mode.type] = position
        delegate?.changeBasicInfo(type: mode.type, value: value)
        self.textField.resignFirstResponder()
    }
}

extension modifyPersonInfoCell {
    
    // 结束编辑
    @objc func endEdit() {
        self.endEditing(true)
    }
}

extension modifyPersonInfoCell: UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if onlyPickerResumeType.contains(mode!.type){
            return
        }
        
        if let text = textField.text, !text.isEmpty{
            self.delegate?.changeBasicInfo(type: mode!.type, value: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


