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
    var getVerify:UIButton?
    var phoneImage:UIButton?
    var phoneImage2:UIButton?

    var passwordLabel:UILabel?
    
    
    var phoneInput:UITextField?
    var password:UITextField?
    var verifyInput:UITextField?
    
    
    
    var codeNumber:ValidateNumber?
    
    
    override func viewDidLoad() {

        
        self.view.backgroundColor = UIColor.white
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
       
        
        self.layoutInit()
        
        self.addTouchinSide()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    
    private func addTouchinSide(){
    
        let touch = UITapGestureRecognizer(target:self, action: #selector(self.touchs))
        self.view.isUserInteractionEnabled =  true
        self.view.addGestureRecognizer(touch)
        
        
    }
    
    @objc private func touchs(){
        self.view.endEditing(true)
    }
    
    
    private func layoutInit(){
        // x 30 y 40 width 40
        
        
        phoneImage = UIButton()
        phoneImage?.setBackgroundImage(UIImage(named:"iPhoneIcon"), for: UIControlState.normal)
        
        
        phoneInput = UITextField()

        getVerify = UIButton()
        
        phoneImage2 = UIButton()
        
        phoneImage2?.setBackgroundImage(UIImage(named:"lock"), for: UIControlState.normal)
        
        verifyInput = UITextField()
        
        passwordLabel  = UILabel()
        password = UITextField()
        
        registerButton = UIButton()

        
        phoneInput?.placeholder = "手机号"
        phoneInput?.keyboardType = .numberPad
        phoneInput?.keyboardAppearance  = .dark
        phoneInput?.delegate = self
        phoneInput?.clearButtonMode = UITextFieldViewMode.whileEditing

       
        

        
        verifyInput?.placeholder = "验证码"
        verifyInput?.keyboardType = .numberPad
        verifyInput?.keyboardAppearance = .dark
        verifyInput?.clearButtonMode = UITextFieldViewMode.whileEditing

        verifyInput?.delegate = self
        
        
        
        
        
        password?.placeholder = "输入密码"
        password?.isSecureTextEntry = true
        password?.clearButtonMode = UITextFieldViewMode.whileEditing
        password?.delegate = self
        
    
        
        
        getVerify?.setTitle("获取验证码", for: UIControlState.normal)
        getVerify?.setTitleColor(UIColor.black, for: UIControlState.normal)
        getVerify?.backgroundColor = UIColor.white
        getVerify?.addTarget(self, action: #selector(validateCode), for: UIControlEvents.touchUpInside)
        codeNumber = ValidateNumber(button: getVerify)

        passwordLabel?.text = "密码"
        passwordLabel?.textColor = UIColor.black
        
        
       
        
        
        registerButton?.setTitle("注 册", for: UIControlState.normal)
        registerButton?.setTitleColor(UIColor.blue, for: UIControlState.normal)
        registerButton?.backgroundColor = UIColor.gray
        registerButton?.addTarget(self, action: #selector(register), for: UIControlEvents.touchUpInside)
        
        
        //
        self.view.addSubview(phoneImage!)
        self.view.addSubview(getVerify!)
        self.view.addSubview(phoneImage2!)
        
        self.view.addSubview(registerButton!)
        self.view.addSubview(phoneInput!)
        self.view.addSubview(passwordLabel!)
        self.view.addSubview(password!)
        self.view.addSubview(verifyInput!)
        
        // auto 布局
        
        _ = phoneImage?.sd_layout().leftSpaceToView(self.view,30)?.topSpaceToView(self.navigationController?.navigationBar,30)?.widthIs(30)?.heightIs(30)
        
        _ = phoneInput?.sd_layout().topEqualToView(phoneImage)?.leftSpaceToView(phoneImage,5)?.widthIs(140)?.heightIs(30)
        
        _ = getVerify?.sd_layout().topEqualToView(phoneImage)?.leftSpaceToView(phoneInput,5)?.widthIs(100)?.heightIs(30)
        
        _ = phoneImage2?.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(phoneImage,15)?.widthIs(30)?.heightIs(30)
        
        _ = verifyInput?.sd_layout().leftSpaceToView(phoneImage2,5)?.topEqualToView(phoneImage2)?.widthIs(140)?.heightIs(30)
        
        
        _ = passwordLabel?.sd_layout().leftSpaceToView(self.view,20)?.topSpaceToView(phoneImage2,15)?.widthIs(50)?.heightIs(30)
        
        _ = password?.sd_layout().leftSpaceToView(passwordLabel,1)?.topEqualToView(passwordLabel)?.widthIs(140)?.heightIs(30)
        
        
        _ =  registerButton?.sd_layout().leftSpaceToView(self.view,30)?.topSpaceToView(password,60)?.widthIs(240)?.heightIs(30)
        

        
        
        let bottom  = CALayer()
        bottom.frame = CGRect(x: 0.0, y: (phoneInput?.frame.height)!-1, width: (phoneInput?.frame.width)!, height: 1.0)
        bottom.backgroundColor  = UIColor.black.cgColor
        phoneInput?.borderStyle = UITextBorderStyle.none
        phoneInput?.layer.addSublayer(bottom)
        
        
        let bottom1  = CALayer()
        bottom1.frame = CGRect(x: 0.0, y: (verifyInput?.frame.height)!-1, width: (verifyInput?.frame.width)!, height: 1.0)
        bottom1.backgroundColor  = UIColor.black.cgColor
        verifyInput?.borderStyle = UITextBorderStyle.none
        verifyInput?.layer.addSublayer(bottom1)

        let bottom2  = CALayer()
        bottom2.frame = CGRect(x: 0.0, y: (password?.frame.height)!-1, width: (password?.frame.width)!, height: 1.0)
        bottom2.backgroundColor  = UIColor.black.cgColor
        password?.borderStyle = UITextBorderStyle.none
        password?.layer.addSublayer(bottom2)
        
        
        
        
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
        
        //        textField.becomeFirstResponder()
        let frame: CGRect = textField.frame
        
        let offset: CGFloat = frame.origin.y+32-(self.view.frame.size.height-216)
        let animationDuration : TimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        
        UIView.setAnimationDuration(animationDuration)
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset>0) {
            self.view.frame = CGRect(x:0.0, y: -offset, width:self.view.frame.size.width,
                                     height:self.view.frame.size.height)
            
        }
        
        UIView.commitAnimations()
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        self.restorationIdentifier = "RegisterViewController"
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
