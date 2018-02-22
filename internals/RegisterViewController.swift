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

class RegisterViewController: UIViewController{
    
    lazy var registerButton:UIButton = {
        let registerButton =  UIButton.init(title: ("注 册", .normal), fontSize: 16, alignment: .center, bColor: UIColor.blue)
       
        return registerButton
    }()
    
    lazy var indicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.red
        return indicator
    }()
    
    lazy var verifyButton:UIButton = {  [unowned self] in
        
        let verifyButton = UIButton.init(title: ("获取验证码", .normal), alignment: .center, bColor: .clear)
        verifyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        verifyButton.setTitleColor(UIColor.lightGray, for: .normal)
        verifyButton.addTarget(self, action: #selector(self.validateCode), for: UIControlEvents.touchUpInside)
        return verifyButton
        
    }()
    
    lazy var phoneImage:UIImageView = {
        let phoneImage = UIImageView.init()
        phoneImage.image = #imageLiteral(resourceName: "iPhoneIcon")
        return phoneImage
    }()
    
    var verifyImage:UIImageView = {
        let verifyImage = UIImageView.init()
        verifyImage.image = #imageLiteral(resourceName: "iPhoneIcon")
        return verifyImage
    }()
    
    var passwordImage:UIImageView = {
        let passwordImage = UIImageView.init()
        passwordImage.image = #imageLiteral(resourceName: "password")
        return passwordImage
    }()
    
    
    lazy var phoneText:UITextField = { [unowned self] in
        let phoneText = UITextField.init(placeholder: "输入手机号", keyboardType: .numberPad, clearButtonMode: .whileEditing, borderStyle: .none)
        phoneText.keyboardAppearance = .default
        phoneText.delegate = self
        return phoneText
    }()
    
    lazy var passwordText:UITextField = { [unowned self] in
        let passwordText = UITextField.init(placeholder: "输入密码", clearButtonMode: .whileEditing, borderStyle: .none)
        passwordText.delegate = self
        return passwordText
        
    }()
    
    var checkPassword:UILabel = {
        let checkPassword = UILabel.init()
        checkPassword.font = UIFont.systemFont(ofSize: 8)
        return checkPassword
        
    }()
    
    lazy var verifyText:UITextField = {  [unowned self] in
        let  verifyText = UITextField.init(placeholder: "输入密码", keyboardType: .numberPad, clearButtonMode: .whileEditing, borderStyle: .none)
        verifyText.delegate = self
        return verifyText
    }()
    
    lazy var checkVerify:UILabel = {
        let checkVerify = UILabel.init()
        checkVerify.font = UIFont.systemFont(ofSize: 8)
        checkVerify.textColor = UIColor.black
        return checkVerify
    }()
    
    private var bottom:CALayer?
    private var bottom2:CALayer?
    private var bottom3:CALayer?
    private var codeNumber:ValidateNumber?
    private var registerVM:RegistryViewModel?
    private let disposebag = DisposeBag()

    private var isRegistry = false
    
    
    override func viewDidLoad() {

       
        self.setViews()
        self.addTouchinSide()
        self.setViewModel()
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        _ = phoneImage.sd_layout().leftSpaceToView(self.view,40)?.topSpaceToView(self.view,NAV_BAR_FRAME_HEIGHT + 20)?.widthIs(25)?.heightIs(30)
        
        _ = verifyButton.sd_layout().rightSpaceToView(self.view,30)?.bottomEqualToView(phoneImage)?.heightIs(30)?.widthIs(100)
        
        _ = phoneText.sd_layout().leftSpaceToView(phoneImage,10)?.bottomEqualToView(phoneImage)?.heightIs(30)?.rightSpaceToView(verifyButton,5)
        
        _ = verifyImage.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(phoneText,20)?.widthIs(25)?.heightIs(30)
        
        _ = verifyText.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(verifyButton)?.heightIs(30)?.bottomEqualToView(verifyImage)
        
        _ = checkVerify.sd_layout().topSpaceToView(verifyText,2)?.leftEqualToView(verifyText)?.widthIs(100)?.heightIs(10)
        
        _ = passwordImage.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(verifyText,20)?.widthIs(25)?.heightIs(30)
        
        _ = passwordText.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(verifyButton)?.heightIs(30)?.bottomEqualToView(passwordImage)
        
        _ = checkPassword.sd_layout().topSpaceToView(passwordText,2)?.leftEqualToView(passwordText)?.widthIs(100)?.heightIs(10)
        
        
        
         _ = registerButton.sd_layout().topSpaceToView(passwordText,80)?.leftEqualToView(phoneImage)?.rightEqualToView(verifyButton)?.heightIs(40)
        
        _ = indicator.sd_layout().leftSpaceToView(self.registerButton,5)?.topSpaceToView(self.registerButton,2)?.bottomSpaceToView(self.registerButton,2)?.widthIs(20)
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        bottom?.frame = CGRect(x: 0.0, y: (phoneText.frame.height)-1, width: (phoneText.frame.width + verifyButton.frame.width), height: 1.0)
        bottom?.backgroundColor  = UIColor.black.cgColor
        bottom2?.frame = CGRect(x: 0.0, y: (verifyText.frame.height)-1, width: verifyText.frame.width, height: 1.0)
        bottom2?.backgroundColor  = UIColor.black.cgColor
        bottom3?.frame = CGRect(x: 0.0, y: (passwordText.frame.height)-1, width: passwordText.frame.width, height: 1.0)
        bottom3?.backgroundColor  = UIColor.black.cgColor
        
    }
    

}


extension RegisterViewController: UITextFieldDelegate {
    
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

extension RegisterViewController{
    
    private func setViews(){
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = "注册账号"
        // 消除bar的底部橫线条
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        
        // 倒计时
        codeNumber = ValidateNumber(button: verifyButton)
        
        bottom  = CALayer()
        bottom2  = CALayer()
        bottom3  = CALayer()
        
        self.view.addSubview(registerButton)
        self.registerButton.addSubview(indicator)
        self.view.addSubview(verifyButton)
        self.view.addSubview(phoneImage)
        self.view.addSubview(phoneText)
        
        self.view.addSubview(verifyImage)
        self.view.addSubview(verifyText)
        self.view.addSubview(checkVerify)
        
        self.view.addSubview(passwordImage)
        self.view.addSubview(passwordText)
        self.view.addSubview(checkPassword)
        
        phoneText.layer.addSublayer(bottom!)
        verifyText.layer.addSublayer(bottom2!)
        passwordText.layer.addSublayer(bottom3!)
    }
    
    private func addTouchinSide(){
        
        let touch = UITapGestureRecognizer(target:self, action: #selector(self.closeKeyBoard))
        self.view.isUserInteractionEnabled =  true
        self.view.addGestureRecognizer(touch)
        
    }
    
    @objc private func closeKeyBoard(){
        self.view.endEditing(true)
    }
    
    
}

extension RegisterViewController{
    
    // viewModel
    private func setViewModel(){
        let server = RegistryServer.instance
        
        self.registerVM = RegistryViewModel.init(input: (phoneText.rx.text.asDriver(),registerButton.rx.tap.asDriver(), server))
        
        
        
        //view to viewmodel
        _ = self.phoneText.rx.text.orEmpty.takeUntil(self.rx.deallocated).bind(to: self.registerVM!.phoneTextStr)
        _ = self.verifyText.rx.text.orEmpty.takeUntil(self.rx.deallocated).bind(to: self.registerVM!.verifyCodeStr)
        _ = self.passwordText.rx.text.orEmpty.takeUntil(self.rx.deallocated).bind(to: self.registerVM!.passwordStr)
        
        
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
            self.registerButton.isEnabled = bool
            self.registerButton.alpha = bool ? 1 : 0.5
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
        
        self.registerVM?.validateCode.asDriver().drive(self.checkVerify.rx.rxob).disposed(by: disposebag)
        self.registerVM?.validatePassword.asDriver().debug().drive(self.checkPassword.rx.rxob).disposed(by: disposebag)
        
        
        self.registerVM?.progress.drive(self.indicator.rx.isAnimating).disposed(by: disposebag)
        
        
        
        self.registerVM?.registeyResult.drive(onNext: { (response) in
            switch response{
            case  let .error(_, message):
                showAlert(error: message, vc: self)
                
            case .success(_, _):
                showAlert(error: "注册成功", vc: self)
            default:
                showAlert(error: "注册失败", vc: self)
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
    }
    
    
    // message code number
    @objc private func validateCode(){
        
        if self.isRegistry{
            RegistryServer.instance.getVerifyCode(phone: (self.phoneText.text)!).subscribe(onNext: { (res) in
                switch res{
                case .ok:
                    showAlert(error: "发送成功", vc: self)
                case let  .error(_, message):
                    showAlert(error: message, vc: self)
                    
                default:
                    showAlert(error: "未知错误", vc: self)
                    
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
            
            codeNumber?.start()
            
        }
        else{
            showAlert(error: "号码无效", vc: self)
            
        }
        
    }
    
}
