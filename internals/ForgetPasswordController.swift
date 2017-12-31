//
//  ForgetPasswordController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ForgetPasswordController: UIViewController {


    lazy var verifyButton:UIButton = {
       
        let  button = UIButton.init(title: ("获取验证码", .normal))
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
        
    }()
    
    lazy var phoneImage:UIImageView = {
            let imageView = UIImageView.init()
            imageView.image = #imageLiteral(resourceName: "iPhoneIcon")
            return imageView
        
    }()
    
    lazy var phoneText:UITextField = { [unowned self] in
        let text = UITextField.init(placeholder: "输入手机号", keyboardType: .numberPad, clearButtonMode: .whileEditing, borderStyle: .none)
        text.delegate = self
        return text
    }()


    lazy var verifyImage:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "iPhoneIcon")
        return imageView
    }()
    
    lazy var verifyText:UITextField = { [unowned self] in
        let text = UITextField.init(placeholder: "输入验证码", keyboardType: .numberPad, clearButtonMode: .whileEditing, borderStyle: .none)
        text.delegate = self
        return text
        
    }()
    
    lazy var passwordImage:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "password")
        return imageView
    }()
    
    lazy var passwordText:UITextField = { [unowned self] in
        let text = UITextField.init(placeholder: "新密码", clearButtonMode: .whileEditing, borderStyle: .none)
        text.delegate = self
        return text
    }()
    
    lazy var confirmPasswordImage:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "password")
        return imageView
    }()
    
    lazy var confirmPasswordText:UITextField = { [unowned self] in
    
        let text = UITextField.init(placeholder: "确认新密码", clearButtonMode: .whileEditing, borderStyle: .none)
        text.delegate = self
        return text
    }()
    
    lazy var submit:UIButton = {
        let  button = UIButton.init(title: ("提 交", .normal), alignment: .center, bColor: UIColor.blue)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
        
    }()
    
    lazy var bottomLine1:CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.black.cgColor
        return line
    }()
    
    lazy var bottomLine2:CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.black.cgColor
        return line
    }()
    
    lazy var bottomLine3:CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.black.cgColor
        return line
    }()
    
    lazy var bottomLine4:CALayer = {
        let line = CALayer()
        line.backgroundColor = UIColor.black.cgColor
        return line
    }()
    
    lazy var indicatory:UIActivityIndicatorView = {
        var indicatory = UIActivityIndicatorView.init()
        indicatory.hidesWhenStopped = true
        indicatory.activityIndicatorViewStyle = .gray
        return indicatory
    }()
    
    private var codeNumber:ValidateNumber?
    
    private let request = ChangePasswordService.instance
    
    private var verifyButtonEnable = true
    
    private let disposebag = DisposeBag.init()

    override func viewDidLoad() {
        
       
        self.setViews()
        self.addTouchinSide()
        self.setViewModel()
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        _ = phoneImage.sd_layout().topSpaceToView(self.view,NAV_BAR_FRAME_HEIGHT + 20)?.leftSpaceToView(self.view,20)?.widthIs(25)?.heightIs(30)
        _ = verifyButton.sd_layout().rightSpaceToView(self.view,30)?.bottomEqualToView(phoneImage)?.widthIs(100)?.heightIs(30)
        _ = phoneText.sd_layout().leftSpaceToView(phoneImage,10)?.bottomEqualToView(phoneImage)?.rightSpaceToView(verifyButton,1)?.heightIs(30)
        
        _ = verifyImage.sd_layout().leftEqualToView(phoneImage)?.topSpaceToView(phoneText,20)?.heightIs(30)?.widthIs(25)
        _ = verifyText.sd_layout().leftEqualToView(phoneText)?.rightEqualToView(verifyButton)?.bottomEqualToView(verifyImage)?.heightIs(30)
        
        _ = passwordImage.sd_layout().leftEqualToView(verifyImage)?.topSpaceToView(verifyImage,20)?.widthIs(25)?.heightIs(30)
        _ = passwordText.sd_layout().leftEqualToView(verifyText)?.bottomEqualToView(passwordImage)?.rightEqualToView(verifyButton)?.heightIs(30)
        
        _ = confirmPasswordImage.sd_layout().leftEqualToView(passwordImage)?.topSpaceToView(passwordImage,20)?.widthIs(25)?.heightIs(30)
        _ = confirmPasswordText.sd_layout().leftEqualToView(passwordText)?.rightEqualToView(verifyButton)?.bottomEqualToView(confirmPasswordImage)?.heightIs(30)
        
        _ = submit.sd_layout().topSpaceToView(confirmPasswordText,80)?.leftEqualToView(confirmPasswordImage)?.rightEqualToView(verifyButton)?.heightIs(40)
        
        _ = indicatory.sd_layout().leftSpaceToView(submit,5)?.topSpaceToView(submit,2)?.bottomSpaceToView(submit,2)?.widthIs(20)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        bottomLine1.frame = CGRect(x: 0.0, y: phoneText.frame.height-1, width: (phoneText.frame.width + verifyButton.frame.width), height: 1.0)
        
        bottomLine2.frame = CGRect.init(x: 0, y: verifyText.frame.height-1, width: verifyText.frame.width, height: 1)
        
        bottomLine3.frame = CGRect.init(x: 0, y: passwordText.frame.height-1, width: passwordText.frame.width, height: 1)
        bottomLine4.frame = CGRect.init(x: 0, y: confirmPasswordText.frame.height-1, width: confirmPasswordText.frame.width, height: 1)
        
        
        
    }
    

   
}

extension ForgetPasswordController: UITextFieldDelegate{
    
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

extension ForgetPasswordController{
    
    private func setViews(){
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "重置密码"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.addSubview(phoneImage)
        self.view.addSubview(phoneText)
        self.view.addSubview(verifyButton)
        verifyButton.addTarget(self, action: #selector(verify), for: .touchUpInside)
        codeNumber = ValidateNumber.init(button: verifyButton)
        
        
        self.view.addSubview(verifyImage)
        self.view.addSubview(verifyText)
        
        self.view.addSubview(passwordImage)
        self.view.addSubview(passwordText)
        
        self.view.addSubview(confirmPasswordImage)
        self.view.addSubview(confirmPasswordText)
        
        
        self.view.addSubview(submit)
        self.submit.addSubview(indicatory)
        
        phoneText.layer.addSublayer(bottomLine1)
        verifyText.layer.addSublayer(bottomLine2)
        passwordText.layer.addSublayer(bottomLine3)
        confirmPasswordText.layer.addSublayer(bottomLine4)
    }
    
    private func addTouchinSide(){
        
        let touch = UITapGestureRecognizer(target:self, action: #selector(self.touchs))
        self.view.isUserInteractionEnabled =  true
        self.view.addGestureRecognizer(touch)
        
        
    }
    
    @objc private func touchs(){
        self.view.endEditing(true)
    }
    
    // vertify number
    @objc private func verify(){
        if self.verifyButtonEnable{
            _ = self.request.getVerifyCode(phone: self.phoneText.text!).subscribe(onNext: { (res) in
                switch res{
                case .ok:
                   showAlert(error: "成功", vc: self)
                case let  .error(_, message):
                   showAlert(error: message, vc: self)
                default:
                    showAlert(error: "", vc: self)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            //
            codeNumber?.start()
        }else{
            
        }
    }
    
}

extension ForgetPasswordController{
    
    private func setViewModel(){
        
        let vm = ChangePasswordVM.init(input: (tap: submit.rx.tap.asDriver().debug(), request: request))
        
        // view to model
        self.phoneText.rx.text.orEmpty.bind(to: vm.phoneText).disposed(by: disposebag)
        self.verifyText.rx.text.orEmpty.bind(to: vm.verifyCode).disposed(by: disposebag)
        self.passwordText.rx.text.orEmpty.bind(to: vm.newPassword).disposed(by: disposebag)
        self.confirmPasswordText.rx.text.orEmpty.bind(to: vm.confirmPassword).disposed(by: disposebag)
        
        // model to view
        
        vm.showProgress.debug().drive(self.indicatory.rx.isAnimating).disposed(by: disposebag)
        
        vm.validatePhone.subscribe(onNext: { (res) in
            self.verifyButtonEnable = res.validate
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
        
        vm.submitEnable.asDriver().drive(onNext: { (bool) in
            self.submit.isEnabled = bool
            self.submit.alpha = bool ? 1 : 0.5
            print(self.submit)
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
        
        vm.submitResult.drive(onNext: { (res) in
            switch res{
            case  let .error(_, message):
                showAlert(error: message, vc: self)
            case .success(_, _):
                showAlert(error: "success", vc: self)
            default:
                showAlert(error: "", vc: self)
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
        
    }
    
    
}
