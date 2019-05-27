//
//  newGroupName.swift
//  internals
//
//  Created by ke.liang on 2019/5/27.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit


class newGroupName:UIView{
    
    
    private var content:String = ""
    
    internal var addName: ((_:String) -> Void)?
    
    private var name:UILabel = {
        let l = UILabel.init(frame: CGRect.zero)
        l.text = "输入分类名称"
        l.textAlignment = .center
        l.setSingleLineAutoResizeWithMaxWidth(200)
        //l.setSingleLineAutoResizeWithMaxWidth(self.frame.width)
        l.font = UIFont.systemFont(ofSize: 16)
        return l
        
    }()
    
    private lazy var backGround:UIButton = {
        let b = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH))
        b.addTarget(self, action: #selector(cancels), for: .touchUpInside)
        b.backgroundColor = UIColor.lightGray
        b.alpha = 0.5
        
        return b
    }()
    
    internal lazy var textField:UITextField = {
        let t = UITextField.init(frame: CGRect.zero)
        //t.delegate = self
        t.borderStyle = UITextField.BorderStyle.roundedRect
        t.placeholder = "最多10个字"
        t.delegate = self
        return t
    }()
    
    private lazy var bottomView:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        let cancel  = UIButton.init(frame: CGRect.zero)
        let confirm = UIButton.init(frame: CGRect.zero)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.lightGray, for: .normal)
        cancel.addTarget(self, action: #selector(cancels), for: .touchUpInside)
        cancel.titleLabel?.textAlignment = .center
        confirm.setTitle("确定", for: .normal)
        confirm.setTitleColor(UIColor.orange, for: .normal)
        confirm.titleLabel?.textAlignment = .center
        confirm.addTarget(self, action: #selector(confirms), for: .touchUpInside)
        
        
        v.addSubview(cancel)
        v.addSubview(confirm)
        _ = cancel.sd_layout()?.leftEqualToView(v)?.topEqualToView(v)?.bottomEqualToView(v)?.widthRatioToView(v,0.5)
        _ = confirm.sd_layout()?.leftSpaceToView(cancel,0)?.topEqualToView(v)?.bottomEqualToView(v)?.widthRatioToView(v,0.5)
        
        return v
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(name)
        self.addSubview(textField)
        self.addSubview(bottomView)
        _ = name.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(self,10)?.autoHeightRatio(0)
        _ = textField.sd_layout()?.topSpaceToView(name,10)?.leftSpaceToView(self,10)?.rightSpaceToView(self, 10)?.heightIs(40)
        _ = bottomView.sd_layout()?.leftSpaceToView(self, 10)?.rightSpaceToView(self, 10)?.bottomSpaceToView(self, 5)?.heightIs(40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension newGroupName{
    internal func show(withBacgroud:Bool = false, editText:String = ""){
        if withBacgroud{
            UIApplication.shared.keyWindow?.addSubview(self.backGround)
        }
        if !editText.isEmpty{
            self.textField.text = editText
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.textField.becomeFirstResponder()
        self.isHidden = false
    }
    
    internal func dissmiss(){
        self.removeFromSuperview()
        self.textField.resignFirstResponder()
        self.isHidden = true
        self.backGround.removeFromSuperview()
    }
    
    @objc private func cancels(btn: UIButton){
        self.dissmiss()
        content = ""
        self.addName?(content)
    }
    
    @objc private func confirms(btn: UIButton){
        self.dissmiss()
        //获取输入内容
        self.addName?(content)
    }
    
    
}


extension newGroupName: UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty{
            content = text
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}

