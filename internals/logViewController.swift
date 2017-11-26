//
//  ViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var activiyIndicator:UIActivityIndicatorView?
    
    
    
    var  phoneBottomLine:CALayer?
    var  passwordBottomLine:CALayer?
    let  disposeBag = DisposeBag.init()
    let  loginServers = loginServer.shareInstance
    
    // warn label
    var validatPhone:UILabel?
    
    override func viewDidLoad() {

        super.viewDidLoad()

        validatPhone = UILabel.init()
        validatPhone?.font  = UIFont.systemFont(ofSize: 10)
        self.view.addSubview(validatPhone!)
        
        activiyIndicator = UIActivityIndicatorView.init()
        activiyIndicator?.activityIndicatorViewStyle = .white
        activiyIndicator?.hidesWhenStopped = true
        
        self.loginButton.addSubview(activiyIndicator!)
        
        loginButton.setTitleColor(UIColor.black, for: .normal)
        
        
        phoneNumber.delegate = self
        password.delegate = self
        phoneNumber.keyboardAppearance = .dark
        phoneNumber.returnKeyType = .done
        phoneNumber.keyboardType = .numberPad
        
        password.keyboardAppearance = .dark
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        
        phoneBottomLine = CALayer()
        passwordBottomLine = CALayer()
        phoneBottomLine?.backgroundColor = UIColor.black.cgColor
        passwordBottomLine?.backgroundColor = UIColor.black.cgColor
        
        
        phoneNumber.borderStyle = UITextBorderStyle.none
        phoneNumber.layer.addSublayer(phoneBottomLine!)
        
        password.borderStyle = UITextBorderStyle.none
        password.layer.addSublayer(passwordBottomLine!)
        
         self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        
        
        
        self.touchDefine()
        self.setUpObserver()
        

        
    }

    func setUpObserver(){
        
        let mv =  loginVM(input: (self.loginButton.rx.tap.asDriver(),loginServer:self.loginServers))
        
        
        phoneNumber.rx.text.orEmpty.bind(to: mv.phoneNumberText).disposed(by: disposeBag)
        password.rx.text.orEmpty.bind(to: mv.passowordText).disposed(by: disposeBag)
        
        
        
        // 不能用option 显示 没有实现reactive协议
       _ =  mv.validatePhone?.bind(to: self.validatPhone!.rx.rxob)
        mv.loginbuttonEnable?.subscribe( onNext: {
            [unowned self ]  valid in
            self.loginButton.isEnabled = valid
            self.loginButton.alpha = valid ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        // progress
        mv.progressEnable.debug().drive(self.activiyIndicator!.rx.isAnimating)
        .disposed(by: disposeBag)
        
        //
        mv.loginProcess.drive(onNext: {
            [unowned self] result  in
            
            switch result{
            case let Result.success(account, password):
                self.showMainView(account,role: "admin")
            // 测试 假设成功
            case let Result.error(message):
                self.showMainView("admin", role: "admin")
            default:
                print("")
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        
        phoneBottomLine!.frame = CGRect(x: 0, y: phoneNumber.frame.height-1, width: phoneNumber.frame.width-30, height: 1)
        passwordBottomLine!.frame = CGRect(x: 0, y: password.frame.height-1, width: password.frame.width-30, height: 1)
        
        _ = self.validatPhone?.sd_layout().topSpaceToView(self.phoneNumber,5)?.widthIs(self.phoneNumber.width)?.heightIs(10)?.leftEqualToView(self.phoneNumber)
        
        _ = self.activiyIndicator?.sd_layout().topSpaceToView(self.loginButton,2)?.widthIs(15)?.bottomSpaceToView(self.loginButton,2)?.leftSpaceToView(self.loginButton,15)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: UIButton) {

        let registerView =  RegisterViewController()
       
        self.navigationController?.pushViewController(registerView, animated: true)
    }

    
    func showMainView(_ account:String, role:String) {

        let user = ["name":account,"role":role]
        print("forward to main")
        self.performSegue(withIdentifier: "showMain", sender: user)
        
    
    }
    
    
    
    
    @IBAction func forgetPassword(_ sender: Any) {
        
        let passwordView = ForgetPasswordController()
        
        self.navigationController?.pushViewController(passwordView, animated: true)
        
    }
    
    func touchDefine(){
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(self.closeKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)

    }
    
    @objc private func  closeKeyboard(){
        self.view.endEditing(true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMain"{
            let controller = segue.destination as? MainTabBarViewController
            //传入用户信息
            //MARK 存储或更新个人信息到本地
           
        }
        
    }
    
    //textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
            textField.scrollUpView(view: self.view)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.30) {
            self.view.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,
                                     height:self.view.frame.size.height)
        }
        
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

