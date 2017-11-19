//
//  RegisterViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import SDAutoLayout

class RegisterViewController: UIViewController,UITextFieldDelegate{
    
    var registerButton:UIButton?
    var verifyButton:UIButton?
    
    var phoneImage:UIImageView?
    var verifyImage:UIImageView?
    var passwordImage:UIImageView?
    
    
    var phoneText:UITextField?
    var passwordText:UITextField?
    var verifyText:UITextField?
    
    var bottom:CALayer?
    var bottom2:CALayer?
    var bottom3:CALayer?
    

    var codeNumber:ValidateNumber?
    
    
    override func viewDidLoad() {

       
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = "注册账号"
        // 消除bar的底部橫线条
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        
        //init view
        registerButton = UIButton.init(type: .custom)
        registerButton?.setTitle("注 册", for: .normal)
        registerButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        registerButton?.backgroundColor = UIColor.blue
        registerButton?.titleLabel?.textAlignment = .center
        
        verifyButton = UIButton.init(type: .custom)
        verifyButton?.setTitle("获取验证码", for: .normal)
        verifyButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        verifyButton?.setTitleColor(UIColor.lightGray, for: .normal)
        verifyButton?.titleLabel?.textAlignment = .center
        
        verifyButton?.addTarget(self, action: #selector(validateCode), for: UIControlEvents.touchUpInside)
        // 倒计时
        codeNumber = ValidateNumber(button: verifyButton)
        
        phoneImage = UIImageView.init()
        phoneImage?.image = #imageLiteral(resourceName: "iPhoneIcon")
        
        phoneText = UITextField.init()
        phoneText?.placeholder = "输入手机号"
        phoneText?.keyboardType = .numberPad
        phoneText?.keyboardAppearance = .default
        phoneText?.clearButtonMode = .whileEditing
        phoneText?.delegate = self
        phoneText?.borderStyle = UITextBorderStyle.none

        
        
        verifyImage = UIImageView.init()
        verifyImage?.image = #imageLiteral(resourceName: "iPhoneIcon")
        verifyText = UITextField.init()
        verifyText?.placeholder = "输入验证码"
        verifyText?.keyboardType = .numberPad
        verifyText?.clearButtonMode = .whileEditing
        verifyText?.delegate = self
        verifyText?.borderStyle = UITextBorderStyle.none
        
        
        passwordImage = UIImageView.init()
        passwordImage?.image = #imageLiteral(resourceName: "password")
        
        passwordText = UITextField.init()
        passwordText?.placeholder = "输入密码"
        passwordText?.keyboardType = .numberPad
        passwordText?.clearButtonMode = .whileEditing
        passwordText?.delegate = self
        passwordText?.borderStyle = UITextBorderStyle.none
        
        
        
        bottom  = CALayer()
        bottom2  = CALayer()
        bottom3  = CALayer()
        
        
        self.view.addSubview(registerButton!)
        self.view.addSubview(verifyButton!)
        self.view.addSubview(phoneImage!)
        self.view.addSubview(phoneText!)
        
        self.view.addSubview(verifyImage!)
        self.view.addSubview(verifyText!)
        
        self.view.addSubview(passwordImage!)
        self.view.addSubview(passwordText!)
        
        
        phoneText?.layer.addSublayer(bottom!)
        verifyText?.layer.addSublayer(bottom2!)
        passwordText?.layer.addSublayer(bottom3!)


        self.addTouchinSide()
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addTouchinSide(){
    
        let touch = UITapGestureRecognizer(target:self, action: #selector(self.touchs))
        self.view.isUserInteractionEnabled =  true
        self.view.addGestureRecognizer(touch)
        
        
    }
    
    @objc private func touchs(){
        self.view.endEditing(true)
    }
    
    
    override func viewWillLayoutSubviews() {
        
        _ = phoneImage?.sd_layout().leftSpaceToView(self.view,40)?.topSpaceToView(self.navigationController?.navigationBar,20)?.widthIs(25)?.heightIs(30)
        
        _ = verifyButton?.sd_layout().rightSpaceToView(self.view,30)?.bottomEqualToView  (phoneImage)?.heightIs(30)?.widthIs(100)
        
        _ = phoneText?.sd_layout().leftSpaceToView(phoneImage,10)?.bottomEqualToView(phoneImage)?.heightIs(30)?.rightSpaceToView(verifyButton,5)
        
       
        
        
        _ = verifyImage?.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(phoneText,20)?.widthIs(25)?.heightIs(30)
        
        _ = verifyText?.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(registerButton)?.heightIs(30)?.bottomEqualToView(verifyImage)
        
        _ = passwordImage?.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(verifyText,20)?.widthIs(25)?.heightIs(30)
        
        _ = passwordText?.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(registerButton)?.heightIs(30)?.bottomEqualToView(passwordImage)
        
        
        
        
         _ = registerButton?.sd_layout().topSpaceToView(passwordText,80)?.leftEqualToView(phoneImage)?.rightEqualToView(verifyButton)?.heightIs(40)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        bottom?.frame = CGRect(x: 0.0, y: (phoneText?.frame.height)!-1, width: ((phoneText?.frame.width)! + (verifyButton?.frame.width)!), height: 1.0)
        bottom?.backgroundColor  = UIColor.black.cgColor
        bottom2?.frame = CGRect(x: 0.0, y: (verifyText?.frame.height)!-1, width: (verifyText?.frame.width)!, height: 1.0)
        bottom2?.backgroundColor  = UIColor.black.cgColor
        bottom3?.frame = CGRect(x: 0.0, y: (passwordText?.frame.height)!-1, width: (passwordText?.frame.width)!, height: 1.0)
        bottom3?.backgroundColor  = UIColor.black.cgColor
        
    }
    
    // message code number
    @objc private func validateCode(){
        codeNumber?.start()
        
    }
  
    
    @objc private func register(sender:UIEvent){
        print("注册")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.scrollUpView(view: self.view)
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    

}
