//
//  ForgetPasswordController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



class ForgetPasswordController: UIViewController,UITextFieldDelegate {

    
    
    var getVerify:UIButton?
    var phoneImage:UIButton?
    var phoneInput:UITextField?


    var phoneImage2:UIButton?
    var verifyInput:UITextField?
    
    var passwordLabel:UILabel?
    var password:UITextField?
    
    var confirmPasswordLabel:UILabel?
    var confirmPasswordInput:UITextField?
    
    
    var submit:UIButton?
    
    var codeNumber:ValidateNumber?
    
    
    override func viewDidLoad() {
        print("forget password View")
        self.view.backgroundColor = UIColor.white
       
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        
        self.addTouchinSide()

        
        self.initLayout()
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    
    
    func backToPrevious(){
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
    

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initLayout(){
        
        phoneImage = UIButton()
        phoneImage?.setBackgroundImage(UIImage(named: "iPhoneIcon"), for: UIControlState.normal)
        
        phoneImage2 = UIButton()
        phoneImage2?.setBackgroundImage(UIImage(named: "lock"), for: UIControlState.normal)
        
        phoneInput = UITextField()
        phoneInput?.placeholder = "手机号"
        
        phoneInput?.keyboardType = .numberPad
        phoneInput?.keyboardAppearance = .dark
        phoneInput?.delegate = self
        phoneInput?.clearButtonMode = UITextFieldViewMode.whileEditing
        
        getVerify = UIButton()
        getVerify?.setTitle("获取验证码", for: UIControlState.normal)
        getVerify?.backgroundColor  = UIColor.white
        getVerify?.setTitleColor(UIColor.black, for: UIControlState.normal)
        getVerify?.addTarget(self, action: #selector(verify), for: UIControlEvents.touchUpInside)
        
        codeNumber =  ValidateNumber(button: self.getVerify)

        
        
        verifyInput = UITextField()
        verifyInput?.placeholder = "验证码"
        verifyInput?.keyboardType = .numberPad
        verifyInput?.keyboardAppearance = .dark
        verifyInput?.delegate = self
        verifyInput?.clearButtonMode = UITextFieldViewMode.whileEditing
        
        
        passwordLabel = UILabel()
        passwordLabel?.text = "密码"
        
        password = UITextField()
        password?.placeholder = "新密码"
        password?.isSecureTextEntry = true
        password?.delegate = self
        password?.clearButtonMode = UITextFieldViewMode.whileEditing
        
        
        
        
        confirmPasswordLabel = UILabel()
        confirmPasswordLabel?.text = "确认"
        
        confirmPasswordInput = UITextField()
        confirmPasswordInput?.placeholder = "再次输入密码"
        confirmPasswordInput?.delegate = self
        confirmPasswordInput?.isSecureTextEntry = true
        confirmPasswordInput?.clearButtonMode = UITextFieldViewMode.whileEditing

        
        
        submit = UIButton()
        submit?.setTitle("提  交", for: UIControlState.normal)
        submit?.backgroundColor = UIColor.gray
        
        submit?.setTitleColor(UIColor.blue, for: UIControlState.normal)
        submit?.addTarget(self, action: #selector(submited), for: UIControlEvents.touchUpInside)
        
        
        
        
        self.view.addSubview(getVerify!)
        self.view.addSubview(phoneInput!)
        self.view.addSubview(phoneImage!)
        
        self.view.addSubview(phoneImage2!)
        self.view.addSubview(verifyInput!)
        
        self.view.addSubview(password!)
        self.view.addSubview(passwordLabel!)
        
        self.view.addSubview(confirmPasswordInput!)
        self.view.addSubview(confirmPasswordLabel!)
        
        self.view.addSubview(submit!)
        
        
        
        
        // auto sdlayput
        
        _ = phoneImage?.sd_layout().leftSpaceToView(self.view,30)?.topSpaceToView(self.navigationController?.navigationBar,40)?.widthIs(30)?.heightIs(30)
        _ = phoneInput?.sd_layout().leftSpaceToView(phoneImage,5)?.topEqualToView(phoneImage)?.widthIs(120)?.heightIs(30)
        
        _ = getVerify?.sd_layout().leftSpaceToView(phoneInput,5)?.topEqualToView(phoneImage)?.widthIs(120)?.heightIs(30)
        
        
        _ = phoneImage2?.sd_layout().leftSpaceToView(self.view,30)?.topSpaceToView(phoneImage,15)?.widthIs(30)?.heightIs(30)
        
        _ = verifyInput?.sd_layout().leftSpaceToView(phoneImage2,5)?.topEqualToView(phoneImage2)?.widthIs(140)?.heightIs(30)
        
        _ = passwordLabel?.sd_layout().leftSpaceToView(self.view,15)?.topSpaceToView(phoneImage2,15)?.widthIs(50)?.heightIs(30)
        
        _ = password?.sd_layout().leftSpaceToView(passwordLabel,5)?.topEqualToView(passwordLabel)?.widthIs(140)?.heightIs(30)
        
        
        _ = confirmPasswordLabel?.sd_layout().leftSpaceToView(self.view,15)?.topSpaceToView(password,15)?.widthIs(50)?.heightIs(30)
        
        _ = confirmPasswordInput?.sd_layout().leftSpaceToView(confirmPasswordLabel,5)?.topEqualToView(confirmPasswordLabel)?.widthIs(140)?.heightIs(30)
        
        _ = submit?.sd_layout().leftSpaceToView(self.view,30)?.topSpaceToView(confirmPasswordInput,60)?.widthIs(240)?.heightIs(30)
        
        
        
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
        
        
        let bottom3  = CALayer()
        bottom3.frame = CGRect(x: 0.0, y: (confirmPasswordInput?.frame.height)!-1, width: (confirmPasswordInput?.frame.width)!, height: 1.0)
        bottom3.backgroundColor  = UIColor.black.cgColor
        confirmPasswordInput?.borderStyle = UITextBorderStyle.none
        confirmPasswordInput?.layer.addSublayer(bottom3)
        
        
        
        
        
        
        
    }
    
    @objc private func submited(){
        
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

    // vertify number
    @objc private func verify(){
        codeNumber?.start()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
