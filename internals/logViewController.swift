//
//  ViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift

class LogViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var activiyIndicator:UIActivityIndicatorView = {
        let  aIndicator = UIActivityIndicatorView.init()
        aIndicator.activityIndicatorViewStyle = .white
        aIndicator.hidesWhenStopped = true
        return aIndicator
    }()
    
    
    
    private let  disposeBag = DisposeBag.init()
    private let  loginServers = loginServer.shareInstance
    
    // 验证手机号结果label
    lazy var validatPhone:UILabel = {
        let vphone = UILabel.init()
        vphone.font  = UIFont.systemFont(ofSize: 10)
        return vphone
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.initViews()
        self.touchView()
        self.setVM()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        
        _ = self.validatPhone.sd_layout().topSpaceToView(self.phoneNumber,5)?.widthIs(self.phoneNumber.width)?.heightIs(10)?.leftEqualToView(self.phoneNumber)
        
        _ = self.activiyIndicator.sd_layout().topSpaceToView(self.loginButton,2)?.widthIs(15)?.bottomSpaceToView(self.loginButton,2)?.leftSpaceToView(self.loginButton,15)
        
    }
    
    
    @IBAction func register(_ sender: UIButton) {

        let registerView =  RegisterViewController()
        self.navigationController?.pushViewController(registerView, animated: true)
    }

    
    @IBAction func forgetPassword(_ sender: Any) {
        
        let passwordView = ForgetPasswordController()
        self.navigationController?.pushViewController(passwordView, animated: true)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMain"{
            let _ = segue.destination as? MainTabBarViewController
            //传入用户信息
            //MARK 存储或更新个人信息到本地
           
        }
        
    }
    
    
}


extension LogViewController{
    private func  initViews(){
    
        
        self.view.addSubview(validatPhone)
        self.loginButton.addSubview(activiyIndicator)
        
        
        phoneNumber.delegate = self
        password.delegate = self
        phoneNumber.keyboardAppearance = .dark
        phoneNumber.returnKeyType = .done
        phoneNumber.keyboardType = .numberPad
        
        password.keyboardAppearance = .dark
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        
        // 设置底部直线
        let phoneBottomLine = CALayer()
        let passwordBottomLine = CALayer()
        phoneBottomLine.frame = CGRect(x: 0, y: phoneNumber.frame.height-1, width: phoneNumber.frame.width-30, height: 1)
        passwordBottomLine.frame = CGRect(x: 0, y: password.frame.height-1, width: password.frame.width-30, height: 1)
        
        phoneBottomLine.backgroundColor = UIColor.black.cgColor
        passwordBottomLine.backgroundColor = UIColor.black.cgColor
        
        phoneNumber.borderStyle = UITextBorderStyle.none
        phoneNumber.layer.addSublayer(phoneBottomLine)
        
        password.borderStyle = UITextBorderStyle.none
        password.layer.addSublayer(passwordBottomLine)
    }
    
    // ViewModel
    private func setVM(){
        
        let vm =  loginVM(input: (self.loginButton.rx.tap.asDriver(),loginServer:self.loginServers))
        
        
        phoneNumber.rx.text.orEmpty.bind(to: vm.phoneNumberText).disposed(by: disposeBag)
        password.rx.text.orEmpty.bind(to: vm.passowordText).disposed(by: disposeBag)
        
        
        _ =  vm.validatePhone?.bind(to: self.validatPhone.rx.rxob)
        vm.loginbuttonEnable?.subscribe( onNext: {
            [unowned self ]  valid in
            self.loginButton.isEnabled = valid
            self.loginButton.alpha = valid ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        // progress
        vm.progressEnable.debug().drive(self.activiyIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        //
        vm.loginProcess.drive(onNext: {
            [unowned self] result  in
            
            switch result{
            case let Result.success(account, _):
                self.showMainView(account,role: "admin")
            // 测试 假设成功
            case Result.error(_):
                self.showMainView("admin", role: "admin")
            default:
                showAlert(error: "未知错误", vc: self)
            }
            
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
    }
    
    private func showMainView(_ account:String, role:String) {
        
        let user = ["name":account,"role":role]
        self.performSegue(withIdentifier: "showMain", sender: user)
        
        
    }
    
}

extension LogViewController {
    
    // 点击空白处关闭keyboard
    private func touchView(){
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(self.closeKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc private func  closeKeyboard(){
        self.view.endEditing(true)
        
    }
    
}

extension LogViewController: UITextFieldDelegate{
    
    
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

