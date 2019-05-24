//
//  AddItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


// 全局变量 保存不同类型的picker的位置
fileprivate var pickPosition:[ResumeInfoType:[Int:Int]] = [:]

protocol AddItemCellUpdate:class {
    func updateTextfield(value: String, type: ResumeInfoType)
}

class AddItemCell: UITableViewCell {

    
    weak var delegate:AddItemCellUpdate?

    // picker 占时的 元素
    internal var onlyPickerResumeType:[ResumeInfoType] = []

    
    private lazy var  upImage:UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        img.image = #imageLiteral(resourceName: "arrow_mr")
        return img
    }()
    
    
    private lazy var  downImage:UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        img.image = #imageLiteral(resourceName: "arrow_xl")
        return img
    }()
    
    
    lazy var pickView:itemPickerView = { [unowned self] in
        let pick = itemPickerView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: 200))
        pick.backgroundColor = UIColor.white
        pick.pickerDelegate = self
        return pick
        
    }()
    
    
    
    lazy var textFiled:UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect.zero)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.placeholder = ""
        textField.textColor = UIColor.black
        textField.textAlignment = .right
        textField.adjustsFontSizeToFitWidth = false
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.textAlignment = .left
        textField.rightViewMode = UITextField.ViewMode.always
        textField.delegate = self
        
        return textField
    }()
    
    
    
    private let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
   
  
    var mode:(type:ResumeInfoType,title:String)?{
        didSet{
            guard  let mode = mode else {
                return
            }
            self.textFiled.placeholder = mode.type.describe
            
            self.textFiled.text = mode.title
            
            if onlyPickerResumeType.contains(mode.type){
                
                img.image = #imageLiteral(resourceName: "arrow_xl")
                textFiled.rightView = img
                textFiled.inputView = pickView
                pickView.mode =  (mode.type.describe, SelectItemUtil.shared.getItems(name: mode.type.describe)!)
                
                
            }else{
                textFiled.rightView = UIView.init()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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

extension AddItemCell: itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        
        self.textFiled.rightView = downImage
        self.textFiled.resignFirstResponder()
        
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
     
        guard let mode = mode  else {
            return
        }
        // 保留当前选择位置
        pickPosition[mode.type] = position
        delegate?.updateTextfield(value: value, type: mode.type)
        self.textFiled.resignFirstResponder()

    }
    
}

extension AddItemCell: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard  let mode = mode  else {
            return false
        }
        
        if onlyPickerResumeType.contains(mode.type){
            textFiled.rightView = upImage
            
            pickView.setPosition(position: pickPosition[mode.type])
        }
        
        return true
    }
    
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
         NotificationCenter.default.post(name: NotificationName.addResumSubItem, object: nil, userInfo: ["edit":false])
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NotificationName.addResumSubItem, object: nil, userInfo: ["edit":true])
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard  let mode = mode,let text = textField.text  else {
            return
        }
        if onlyPickerResumeType.contains(mode.type){
            textFiled.rightView = downImage
            return
        }
        delegate?.updateTextfield(value: text, type: mode.type)
     }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        NotificationCenter.default.post(name: NotificationName.addResumSubItem, object: nil, userInfo: ["edit":false])
        return true 
    }
    
    
}


