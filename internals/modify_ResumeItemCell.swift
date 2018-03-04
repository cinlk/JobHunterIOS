//
//  modify_educationCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

class modify_ResumeItemCell: UITableViewCell {

    
    private lazy var leftTitle:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .left
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return title
        
    }()
    
    private lazy var rightLabel:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .right
        return title
    }()
    
    
    lazy var textView:UITextField = { [unowned self] in
        let textField = UITextField.init(frame: CGRect.zero)
        textField.borderStyle = UITextBorderStyle.none
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.black
        textField.textAlignment = .right
        textField.adjustsFontSizeToFitWidth = false
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.delegate = self
        return textField
    }()
    
    
    private lazy var describeTitle:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .left
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        
        return title
    }()
    lazy var describeText:UITextView = {
        let texView = UITextView.init()
        texView.textAlignment = .left
        texView.font = UIFont.systemFont(ofSize: 14)
        texView.textColor = UIColor.black
        texView.backgroundColor = UIColor.white
        texView.backgroundColor = UIColor.lightGray
        texView.layer.masksToBounds = true
        texView.layer.cornerRadius = 10
        return texView
    }()
    
    // 数字键盘 的tabbutton
    private lazy var doneButton:UIToolbar = { [unowned self] in
        
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(endEdit))
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
        }()
    
    private var pManager:personModelManager = personModelManager.shared

    weak var delegate:changeDataDelegate?

    
    var mode:(viewType:resumeViewType, InfoType:personBaseInfo, row:Int)?{
        didSet{
            
            self.contentView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            
            switch mode!.viewType {
            case .education:
                buildEducationView(InfoType:mode!.InfoType,row: mode!.row)
            case .project:
                buildProjectView(InfoType: mode!.InfoType, row: mode!.row)
            case .skill:
                buildSkillsView(InfoType: mode!.InfoType, row: mode!.row)
            default:
                break
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        describeText.inputAccessoryView = doneButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return  "modify_educationCell"
    }
}


extension modify_ResumeItemCell: UITextFieldDelegate{
    
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
            //self.delegate?.changeDataByName!(name: self.title, value: text)
            self.delegate?.changeEducationInfo(viewType: mode!.viewType, type: mode!.InfoType, row: mode!.row, value: text)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension modify_ResumeItemCell{
    
    @objc func endEdit() {
        self.describeText.endEditing(true)
    }
}

extension modify_ResumeItemCell{
    
    
    private func buildSkillsView(InfoType:personBaseInfo, row:Int){
        let value = pManager.skillInfos[row].getItemByType(type: InfoType)
        
        switch InfoType {
            
        case .skill:
            self.rightLabel.isHidden = false
            self.describeText.isHidden = true
            describeTitle.isHidden = true
            self.leftTitle.text = InfoType.rawValue
            self.rightLabel.text = value
            
        case .describe:
            self.describeText.isHidden = false
            self.rightLabel.isHidden = true
            self.leftTitle.isHidden = true
            describeTitle.isHidden = false
            self.describeText.text = value
            describeTitle.text = "爱好/技能描述"
            
        default:
            break
        }
        let views:[UIView] = [leftTitle, rightLabel, describeText, describeTitle]
        self.contentView.sd_addSubviews(views)
       
        
        _ = leftTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.bottomSpaceToView(self.contentView,15)?.autoHeightRatio(0)
        
        _ = rightLabel.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)?.autoHeightRatio(0)
        
        
        _ = describeTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = describeText.sd_layout().leftEqualToView(self.describeTitle)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(describeTitle,5)?.bottomSpaceToView(self.contentView,10)
        
        
        
    }
    
    private func buildEducationView(InfoType:personBaseInfo, row:Int){
        
        let value =  pManager.educationInfos[row].getItemByType(type: InfoType)
        switch InfoType {
        case .startTime,.endTime,.degree:
            self.textView.isHidden = true
            self.rightLabel.isHidden = false
            self.leftTitle.text = InfoType.rawValue
            self.rightLabel.text = value
        default:
            self.textView.isHidden = false
            self.rightLabel.isHidden = true
            self.leftTitle.text = InfoType.rawValue
            self.textView.text = value
        }
        let views:[UIView] = [leftTitle, rightLabel, textView]
        self.contentView.sd_addSubviews(views)
       
        
        _ = leftTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.autoHeightRatio(0)
        
        _ = rightLabel.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)?.autoHeightRatio(0)
        
        _ = textView.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)
        
        
        
        
        
    }
    
    private func buildProjectView(InfoType:personBaseInfo, row:Int){
        let value =  pManager.projectInfo[row].getItemByType(type: InfoType)
        
        switch InfoType {
        case .startTime,.endTime:
            self.textView.isHidden = true
            self.rightLabel.isHidden = false
            self.describeText.isHidden = true
            describeTitle.isHidden = true
            self.leftTitle.text = InfoType.rawValue
            self.rightLabel.text = value
        case .describe:
            
            self.describeText.isHidden = false
            self.textView.isHidden = true
            self.rightLabel.isHidden = true
            self.leftTitle.isHidden = true
            describeTitle.isHidden = false
            self.describeText.text = value
            describeTitle.text = "实习/项目经历描述"
        default:
            self.textView.isHidden = false
            self.rightLabel.isHidden = true
            self.describeText.isHidden = true
            describeTitle.isHidden = true

            self.leftTitle.text = InfoType.rawValue
            self.textView.text = value
        }
        let views:[UIView] = [leftTitle, rightLabel, textView, describeText, describeTitle]
        self.contentView.sd_addSubviews(views)

        
        _ = leftTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,15)?.autoHeightRatio(0)
        
        _ = rightLabel.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)?.autoHeightRatio(0)
        
        _ = textView.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftTitle)?.bottomEqualToView(leftTitle)?.leftSpaceToView(leftTitle,20)
        
        _ = describeTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = describeText.sd_layout().leftEqualToView(self.describeTitle)?.rightSpaceToView(self.contentView,10)?.topSpaceToView(describeTitle,5)?.bottomSpaceToView(self.contentView,10)
        
        
    }
    
   
}
