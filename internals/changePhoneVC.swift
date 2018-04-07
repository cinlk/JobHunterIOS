//
//  changePhoneVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let des:String = "当前绑定手机号"
fileprivate let inputPhone:String = "请输入新手机号"
fileprivate let inputVerifyCode:String = "请输入验证码"
fileprivate let confirmStr:String = "确定"

class changePhoneVC: UIViewController {

    
    private lazy var topLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = des
        return label
    }()
    
    
    lazy var  currentPhoneLabel:UILabel = {
        let lable = UILabel.init(frame: CGRect.zero)
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textAlignment = .center
        lable.textColor = UIColor.black
        return lable
    }()
    
    
    private lazy var inputPhoneView:UIView = {  [unowned self] in
        let outView = UIView.init(frame: CGRect.zero)
        outView.backgroundColor = UIColor.white
        let textfiled = UITextField.init(frame: CGRect.zero)
        textfiled.placeholder = inputPhone
        textfiled.textAlignment = .left
        textfiled.delegate = self
        textfiled.tag = 10
        textfiled.keyboardType = .numberPad
        outView.addSubview(textfiled)
        _ = textfiled.sd_layout().leftSpaceToView(outView,10)?.rightEqualToView(outView)?.topEqualToView(outView)?.bottomEqualToView(outView)
        
        return outView
        
    }()
    
    
    private lazy var inputCodeView:UIView = {  [unowned self] in
        let outView = UIView.init(frame: CGRect.zero)
        outView.backgroundColor = UIColor.white
        let textfiled = UITextField.init(frame: CGRect.zero)
        textfiled.placeholder = inputVerifyCode
        textfiled.delegate = self
        textfiled.tag = 11
        textfiled.keyboardType = .numberPad
        textfiled.textAlignment = .left
        
        
        outView.addSubview(textfiled)
        _ = textfiled.sd_layout().leftSpaceToView(outView,10)?.rightSpaceToView (outView,100)?.topEqualToView(outView)?.bottomEqualToView(outView)
        
        let codeBtn = UIButton.init(frame: CGRect.zero)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        codeBtn.setTitleColor(UIColor.green, for: .normal)
        codeBtn.backgroundColor = UIColor.clear
        codeBtn.layer.cornerRadius = 10
        codeBtn.layer.borderColor = UIColor.blue.cgColor
        codeBtn.layer.borderWidth = 1
        
        codeBtn.addTarget(self, action: #selector(receiveCode), for: .touchUpInside)
        self.refBtn = codeBtn
        outView.addSubview(codeBtn)
        _ = codeBtn.sd_layout().rightSpaceToView(outView,10)?.topSpaceToView(outView,5)?.bottomSpaceToView(outView,5)?.widthIs(80)
        
        
        return outView
        
    }()
    
    
    private lazy var confirmBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.blue
        btn.setTitle(confirmStr, for: .normal)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.white, for: .normal)
        
        return btn
        
    }()
    
    private lazy var tap:UITapGestureRecognizer = { [unowned self] in
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(tapClick))
        return tap
    }()
    
    
    // 倒计时
    private var refBtn:UIButton?
    private var countNumber:ValidateNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        countNumber = ValidateNumber(button: refBtn)
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改手机号"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension changePhoneVC{
    
    private func initView(){
        self.view.backgroundColor = UIColor.init(r: 246, g: 246, b: 246)
        self.view.addGestureRecognizer(tap)
        self.view.addSubview(topLabel)
        self.view.addSubview(currentPhoneLabel)
        self.view.addSubview(inputPhoneView)
        self.view.addSubview(inputCodeView)
        self.view.addSubview(confirmBtn)
        _ = topLabel.sd_layout().centerXEqualToView(self.view)?.topSpaceToView(self.view,20 + NavH)?.widthIs(200)?.heightIs(10)
        _ = currentPhoneLabel.sd_layout().centerXEqualToView(self.view)?.topSpaceToView(topLabel,5)?.widthIs(300)?.heightIs(20)
        _ = inputPhoneView.sd_layout().leftSpaceToView(self.view,20)?.rightSpaceToView(self.view,20)?.topSpaceToView(currentPhoneLabel,20)?.heightIs(40)
        _ = inputCodeView.sd_layout().leftEqualToView(inputPhoneView)?.rightEqualToView(inputPhoneView)?.topSpaceToView(inputPhoneView,10)?.heightIs(40)
        _ = confirmBtn.sd_layout().leftEqualToView(inputCodeView)?.rightEqualToView(inputCodeView)?.topSpaceToView(inputCodeView,30)?.heightIs(40)
        
        
    }

    // 确认修改phone
    @objc func confirm(){
        self.view.endEditing(true)
    }
    
    // 获取验证码
    @objc func receiveCode(){
        countNumber?.start()
    }
    // 点击空白处 收齐键盘
    @objc func tapClick(){
        self.view.endEditing(true)
    }
}



extension changePhoneVC: UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }
    
}
