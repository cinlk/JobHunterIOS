//
//  ResetPasswordViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ResetPasswordViewController: UIViewController {

    
    private lazy var verifyBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 20))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(self.validateCode), for: UIControlEvents.touchUpInside)

        return btn
    }()
    
    private lazy var lash:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.backgroundColor = UIColor.clear
        btn.setBackgroundImage(UIImage.init(named: "lash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setBackgroundImage(UIImage.flipImage(image: #imageLiteral(resourceName: "lash"), orientation: UIImageOrientation.down).withRenderingMode(.alwaysTemplate), for: UIControlState.selected)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
        
    }()
    
    lazy var resetBtn:UIButton = {
        let btn = UIButton.init()
        btn.setTitle("重置密码", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        return btn
    }()
    
    
    private lazy var inputAccount:customerTextField = { [unowned self] in
        let tx = customerTextField()
        tx.placeholder = "输入账号(手机或邮箱)"
        tx.borderStyle = .roundedRect
        tx.clearButtonMode = .whileEditing
        return tx
        
    }()
    
    private lazy var inputVerifyCode:customerTextField = { [unowned self] in
        let tx = customerTextField()
        tx.placeholder = "输入验证码"
        tx.borderStyle = .roundedRect
        tx.rightBtn = verifyBtn
        tx.righPadding = 10
        tx.clearButtonMode = .whileEditing
        tx.keyboardType = .numberPad
        
        return tx
        
    }()
    
    lazy var inputPassword:customerTextField = { [unowned self] in
        let tx = customerTextField()
        tx.placeholder = "输入新的密码(6至20位)"
        tx.borderStyle = .roundedRect
        tx.rightBtn = lash
        tx.righPadding = 10
        tx.showLine = false
        tx.clearButtonMode = .whileEditing
        tx.isSecureTextEntry = true
        return tx
    }()
    
    private lazy var tapGestur:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired  = 1
        tap.addTarget(self, action: #selector(cancelEdit))
        
        return tap
    }()
    
    
    // 倒计时
    private  lazy var codeNumber:ValidateNumber =  ValidateNumber(button: verifyBtn)!
    
    
    var isResetPwd:Bool = false
    
    //rxswift
    private var account:Variable<String> = Variable<String>("")
    private var verifyCode:Variable<String> = Variable<String>("")
    private var password:Variable<String> = Variable<String>("")
    private var dispose:DisposeBag = DisposeBag()
    
    private var loginViewModel =  QuickLoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }


}

extension ResetPasswordViewController{
    private func setViews(){
        self.view.backgroundColor = UIColor.viewBackColor()
        
        let views:[UIView] = [inputAccount, inputVerifyCode, inputPassword, resetBtn]
        self.view.sd_addSubviews(views)
        _ = inputAccount.sd_layout().topSpaceToView(self.view,NavH + 30)?.centerXEqualToView(self.view)?.widthIs(ScreenW - 40)?.heightIs(50)
        _ = inputVerifyCode.sd_layout().topSpaceToView(inputAccount,10)?.widthRatioToView(inputAccount,1)?.heightRatioToView(inputAccount,1)?.centerXEqualToView(inputAccount)
        _ = inputPassword.sd_layout().topSpaceToView(inputVerifyCode,10)?.widthRatioToView(inputVerifyCode,1)?.heightRatioToView(inputVerifyCode,1)?.centerXEqualToView(inputVerifyCode)
        _ = resetBtn.sd_layout().topSpaceToView(inputPassword, 30)?.centerXEqualToView(inputPassword)?.widthRatioToView(inputPassword,1)?.heightIs(40)
        
        
        
        // view 点击界面
        self.view.addGestureRecognizer(tapGestur)
        
    }
    
    
    @objc private func click(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.tintColor =  btn.isSelected ? UIColor.orange : UIColor.lightGray
        inputPassword.isSecureTextEntry = btn.isSelected ? false : true
    }
    @objc  private func reset(){
//        self.view.endEditing(true)
//        // 测试登录
//        let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! MainTabBarViewController
//
//
//        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.popvc(animated: true)

 
        
    }
    
    @objc private func cancelEdit(){
        self.view.endEditing(true)
    }
    
}


extension ResetPasswordViewController{
    @objc private func validateCode(){
        
        codeNumber.start()
    }
  
}



// viewmodel
extension ResetPasswordViewController{
    
    private func setViewModel(){
        
        inputAccount.rx.text.orEmpty.bind(to: account).disposed(by: dispose)
        
        let verifyBtnConfirm = Observable.combineLatest(account.asObservable().map{
            $0.count > 6
            }.share(), codeNumber.obCount.asObservable(), resultSelector: { $0 && $1}).share()
        
        verifyBtnConfirm.bind(to: verifyBtn.rx.rxEnable).disposed(by: dispose)
        
        inputVerifyCode.rx.text.orEmpty.bind(to: verifyCode).disposed(by: dispose)
        
        inputPassword.rx.text.orEmpty.bind(to: password).disposed(by: dispose)
        
        
        let resetBtnConfirm = Observable.combineLatest(account.asObservable().map{
            $0.count > 6
            }.share(), verifyCode.asObservable().map{
                if $0.count == 6 {
                    if let _ = Int($0){
                        return true
                    }
                }
                return false
                }.share(), password.asObservable().map{
                 $0.count >= 6 && $0.count < 20}.share(), resultSelector: {$0 && $1 && $2})
        
        resetBtnConfirm.bind(to: resetBtn.rx.rxEnable).disposed(by: dispose)
        
        
        // 发送验证码
        verifyBtn.rx.tap.asDriver().drive(onNext: {
            // test
            self.loginViewModel.sendAccountCode(account:self.account.value, type:"email").subscribe(onNext: { res in
                print("code model \(res)")
            }, onError: { (err) in
                print("send code error \(err)")
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
        if isResetPwd{
            // 重置密码
            resetBtn.rx.tap.asDriver().drive(onNext: {
                self.loginViewModel.resetPassword(account: self.account.value, code: self.verifyCode.value, pwd: self.password.value).debug().subscribe(onNext: { (res) in
                    print(res)
                    // TODO 自动登录
                }, onError: { (err) in
                    print("update password error \(err)")
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
            
        }else{
            // 注册账号
            resetBtn.rx.tap.asDriver().drive(onNext: {
                self.loginViewModel.registryAccount(account: self.account.value, code: self.verifyCode.value, pwd: self.password.value).subscribe(onNext: { (res) in
                    print("registry success \(res)")
                }, onError: { (err) in
                    print("registry failed \(err)")
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        }
        
        
        
        
    }
    
}
