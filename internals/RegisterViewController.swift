//
//  RegisterViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import SDAutoLayout
import RxSwift

class RegisterViewController: UIViewController,UITextFieldDelegate{
    
    var registerButton:UIButton?
    var indicator:UIActivityIndicatorView?
    
    var verifyButton:UIButton?
    
    var phoneImage:UIImageView?
    var verifyImage:UIImageView?
    var passwordImage:UIImageView?
    
    
    var phoneText:UITextField?
    var passwordText:UITextField?
    var checkPassword:UILabel?
    
    var verifyText:UITextField?
    var checkVerify:UILabel?
    
    
    var bottom:CALayer?
    var bottom2:CALayer?
    var bottom3:CALayer?
    

    var codeNumber:ValidateNumber?
    
    
    var registerVM:RegistryViewModel?
    
    let disposebag = DisposeBag()

    var isRegistry = false
    
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
        
        indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator?.hidesWhenStopped = true
        indicator?.color = UIColor.red
        
        
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
        
        checkVerify = UILabel.init()
        checkVerify?.font = UIFont.systemFont(ofSize: 8)
        checkVerify?.textColor = UIColor.black
        
        
        passwordImage = UIImageView.init()
        passwordImage?.image = #imageLiteral(resourceName: "password")
        
        passwordText = UITextField.init()
        passwordText?.placeholder = "输入密码"
        passwordText?.clearButtonMode = .whileEditing
        passwordText?.delegate = self
        passwordText?.borderStyle = UITextBorderStyle.none
        
        checkPassword = UILabel.init()
        checkPassword?.font = UIFont.systemFont(ofSize: 8)
        
        
        bottom  = CALayer()
        bottom2  = CALayer()
        bottom3  = CALayer()
        
        self.view.addSubview(registerButton!)
        self.registerButton?.addSubview(indicator!)
        self.view.addSubview(verifyButton!)
        self.view.addSubview(phoneImage!)
        self.view.addSubview(phoneText!)
        
        self.view.addSubview(verifyImage!)
        self.view.addSubview(verifyText!)
        self.view.addSubview(checkVerify!)
        
        self.view.addSubview(passwordImage!)
        self.view.addSubview(passwordText!)
        self.view.addSubview(checkPassword!)
        
        phoneText?.layer.addSublayer(bottom!)
        verifyText?.layer.addSublayer(bottom2!)
        passwordText?.layer.addSublayer(bottom3!)

        self.addTouchinSide()
        self.setViewModel()
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
    // viewModel
    private func setViewModel(){
        let server = RegistryServer.instance
        
        self.registerVM = RegistryViewModel.init(input: (phoneText!.rx.text.asDriver(),registerButton!.rx.tap.asDriver(), server))
        
        
        
        //view to viewmodel
        _ = self.phoneText!.rx.text.orEmpty.takeUntil(self.rx.deallocated).bind(to: self.registerVM!.phoneTextStr)
        _ = self.verifyText?.rx.text.orEmpty.takeUntil(self.rx.deallocated).bind(to: self.registerVM!.verifyCodeStr)
        _ = self.passwordText?.rx.text.orEmpty.takeUntil(self.rx.deallocated).bind(to: self.registerVM!.passwordStr)
        
        
        
        
        
        //viewmode to view
        _ = self.registerVM?.validatePhone.asDriver().drive(onNext: { (result) in
            switch result{
            case .pass:
                self.isRegistry = true
            default:
                self.isRegistry = false
            }
        }, onCompleted: nil, onDisposed: nil)
        
        
        self.registerVM?.registryEnable.asDriver().debug().drive(onNext: { (bool) in
                self.registerButton?.isEnabled = bool
                self.registerButton?.alpha = bool ? 1 : 0.5
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
        
        self.registerVM?.validateCode.asDriver().drive(self.checkVerify!.rx.rxob).disposed(by: disposebag)
        self.registerVM?.validatePassword.asDriver().debug().drive(self.checkPassword!.rx.rxob).disposed(by: disposebag)
        
        
        self.registerVM?.progress.drive(self.indicator!.rx.isAnimating).disposed(by: disposebag)
        
        
        
        self.registerVM?.registeyResult.drive(onNext: { (response) in
            switch response{
            case  let .error(_, message):
                self.showAlert(error: message)
            case .success(_, _):
                self.register()
            default:
                self.showAlert(error: "注册失败")
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
    }
    
    @objc private func touchs(){
        self.view.endEditing(true)
    }
    
    
    override func viewWillLayoutSubviews() {
        
        _ = phoneImage?.sd_layout().leftSpaceToView(self.view,40)?.topSpaceToView(self.view,NAV_BAR_FRAME_HEIGHT + 20)?.widthIs(25)?.heightIs(30)
        
        _ = verifyButton?.sd_layout().rightSpaceToView(self.view,30)?.bottomEqualToView(phoneImage)?.heightIs(30)?.widthIs(100)
        
        _ = phoneText?.sd_layout().leftSpaceToView(phoneImage,10)?.bottomEqualToView(phoneImage)?.heightIs(30)?.rightSpaceToView(verifyButton,5)
        
       
        
        
        _ = verifyImage?.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(phoneText,20)?.widthIs(25)?.heightIs(30)
        
        _ = verifyText?.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(verifyButton)?.heightIs(30)?.bottomEqualToView(verifyImage)
        
        _ = checkVerify?.sd_layout().topSpaceToView(verifyText,2)?.leftEqualToView(verifyText)?.widthIs(100)?.heightIs(10)
        
        _ = passwordImage?.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(verifyText,20)?.widthIs(25)?.heightIs(30)
        
        _ = passwordText?.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(verifyButton)?.heightIs(30)?.bottomEqualToView(passwordImage)
        
        _ = checkPassword?.sd_layout().topSpaceToView(passwordText,2)?.leftEqualToView(passwordText)?.widthIs(100)?.heightIs(10)
        
        
        
         _ = registerButton?.sd_layout().topSpaceToView(passwordText,80)?.leftEqualToView(phoneImage)?.rightEqualToView(verifyButton)?.heightIs(40)
        
        _ = indicator?.sd_layout().leftSpaceToView(self.registerButton,5)?.topSpaceToView(self.registerButton,2)?.bottomSpaceToView(self.registerButton,2)?.widthIs(20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
        
        if self.isRegistry{
            RegistryServer.instance.getVerifyCode(phone: (self.phoneText?.text)!).subscribe(onNext: { (res) in
                switch res{
                case .ok:
                    print("")
                case let  .error(_, message):
                    self.showAlert(error: message)
                default:
                    self.showAlert(error: "")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        codeNumber?.start()
            
        }
        else{
            self.showAlert(error: "号码无效")
        }
        
    }
  
    
   private func register(){
        print("注册成功")
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
    
    
    private func showAlert(error:String){
        let action = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        let alertView = UIAlertController.init(title: nil, message: error, preferredStyle: .alert)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    

}
