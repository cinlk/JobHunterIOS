//
//  ViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let bottomH:CGFloat = 120

class LogViewController: UIViewController {

    
    
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var LogTitle: UILabel!
    
    @IBOutlet weak var accountIcon: UIButton!
    @IBOutlet weak var passwordIcon: UIButton!
    
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    // 第三方登录
    
    private lazy var tLogin:ThirdPartLoginView =  ThirdPartLoginView(frame: CGRect.init(x: 0, y: ScreenH-bottomH, width: ScreenW, height: bottomH))
    
    
    
    // 登录进度
    lazy var activiyIndicator:UIActivityIndicatorView = {
        let  aIndicator = UIActivityIndicatorView.init()
        aIndicator.activityIndicatorViewStyle = .white
        aIndicator.hidesWhenStopped = true
        return aIndicator
    }()
    
    
    private lazy var startImage:UIImageView = { [unowned self] in
        let image = UIImageView.init(image: UIImage.init(named: "QQStart"))
        image.bounds = self.view.bounds
        image.center = self.view.center
//        image.animationImages = [UIImage.init(named: "QQStart")!, UIImage.init(named: "qq")!]
//        image.animationDuration = 0.5
       
//        image.animationRepeatCount = LONG_MAX
        image.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        return image
    }()
    
    private let  disposeBag = DisposeBag.init()
    private let  loginServers = loginServer.shareInstance
    private let  userTable = DBFactory.shared.getUserDB()
    private let  personTable = DBFactory.shared.getPersonDB()
    
    
    // 验证手机号结果label
    private lazy var validatPhone:UILabel = {
        let vphone = UILabel.init()
        vphone.font  = UIFont.systemFont(ofSize: 10)
        return vphone
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tLogin.delegate = self
        self.initViews()
        self.touchView()
        self.setVM()
        
        //self.startImage.startAnimating()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //fetchUserFromDB()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
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
    
    
    
    private func loadDataFinished(){
        //self.startImage.stopAnimating()
        self.startImage.isHidden = true
        
    }
    
    private func fetchUserFromDB(){
        
        // 获取当前user 账号 和密码数据，判断自动登录
        let (account, password, auto) = userTable.currentUser()
        guard  !account.isEmpty, !password.isEmpty else{
            
            loadDataFinished()
            return
        }
        
       
        guard auto else {
            // texfield 显示账号 和密码
            self.phoneNumber.text = account
            self.password.text = password
            // 通知rx 值改变
            self.phoneNumber.sendActions(for: .valueChanged)
            self.password.sendActions(for: .valueChanged)
             loadDataFinished()
            return
        }
        
        
        
        // 登录判断
        self.loginServers.login(account, password: password).subscribe(onNext: { [unowned self] (result) in
            
            switch result{
            case let Result.success(account, _):
                
                self.showMainView(account,role: "admin")
                
                
            // 测试 假设成功
            case  let Result.error(message):
                //showAlert(error: message, vc: self)
                print(message)
            default:
                //showAlert(error: "未知错误", vc: self)
                  print()
            }
            
            self.loadDataFinished()

            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
    }
}

extension LogViewController{
    
    private func  initViews(){
        
        self.view.addSubview(tLogin)
        self.view.addSubview(validatPhone)
        self.loginButton.addSubview(activiyIndicator)
        
        unowned let weakSelf = self
        phoneNumber.inputAccessoryView = UIToolbar.NumberkeyBoardDone(title: "完成", vc: weakSelf, selector: #selector(closeKeyboard))
        phoneNumber.placeholder = "输入账号"
        phoneNumber.delegate = self
        password.delegate = self
        phoneNumber.keyboardAppearance = .dark
        phoneNumber.returnKeyType = .done
        phoneNumber.keyboardType = .numberPad
        
        password.keyboardAppearance = .dark
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        
        registerBtn.titleLabel?.textAlignment = .left
        forgetPasswordBtn.titleLabel?.textAlignment = .right
        
        LogTitle.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        
        _  = LogTitle.sd_layout().centerXEqualToView(self.view)?.topSpaceToView(self.view,NavH + 30)?.autoHeightRatio(0)
        _ = accountIcon.sd_layout().leftSpaceToView(self.view,60)?.widthIs(45)?.heightIs(45)?.topSpaceToView(LogTitle,80)
        _ = phoneNumber.sd_layout().leftSpaceToView(accountIcon,10)?.bottomEqualToView(accountIcon)?.rightSpaceToView(self.view,60)?.heightIs(25)
        
        
        _ = passwordIcon.sd_layout().topSpaceToView(accountIcon,20)?.leftEqualToView(accountIcon)?.widthIs(45)?.heightIs(45)
        _ = password.sd_layout().bottomEqualToView(passwordIcon)?.leftEqualToView(phoneNumber)?.rightEqualToView(phoneNumber)?.heightIs(25)
        
        _ = loginButton.sd_layout().topSpaceToView(passwordIcon, 45)?.leftEqualToView(passwordIcon)?.rightEqualToView(password)?.heightIs(25)
        
        _ = registerBtn.sd_layout().leftEqualToView(loginButton)?.topSpaceToView(loginButton,40)?.widthIs(120)?.heightIs(30)
        _ = forgetPasswordBtn.sd_layout().rightEqualToView(loginButton)?.topEqualToView(registerBtn)?.widthIs(120)?.heightIs(25)
        
        
        
        
        
        // 设置底部直线 距离和内部textfieldLabel 一样，（如何获取内部的lable??）
        let phoneBottomLine = CALayer()
        let passwordBottomLine = CALayer()
        phoneBottomLine.frame = CGRect(x: 0, y: phoneNumber.frame.height, width: phoneNumber.frame.width - 27, height: 1)
        passwordBottomLine.frame = CGRect(x: 0, y: password.frame.height, width: password.frame.width - 27, height: 1)
        
        phoneBottomLine.backgroundColor = UIColor.black.cgColor
        passwordBottomLine.backgroundColor = UIColor.black.cgColor
        
        phoneNumber.borderStyle = UITextBorderStyle.none
        phoneNumber.layer.addSublayer(phoneBottomLine)
        
        password.borderStyle = UITextBorderStyle.none
        password.layer.addSublayer(passwordBottomLine)
        
        
        //UIApplication.shared.windows.last?.addSubview(startImage)
        
        // 开始动画
        //self.view.addSubview(startImage)
        //self.startImage.isHidden = false
        //self.startImage.startAnimating()
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
                // 数据库操作 应该绑定Wie原子操作！！ MARK
                // 保存当前账号到数据库
                self.userTable.insertUser(account: self.phoneNumber.text!, password: self.password.text!, auto:true)
                // 个人信息存入person 表
                self.personTable.insertPerson(person: myself)
                // 跳转到主界面
                self.showMainView(account,role: "admin")
            // 测试 假设成功
            case  let Result.error(message):
                showAlert(error: message, vc: self)
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
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
}


// 第三方登录代理
extension LogViewController:SocialAppLoginDelegate{
    
    func verifyLoggable(view:UIView, type: UMSocialPlatformType, respons:UMSocialUserInfoResponse){
        // 与服务器交互，判断是否关联了 注册的手机号， 如果是就登录
        
        // 否则弹出界面 关联手机号，在登录
        // test
        let bindPhone = BindAccountVC()
        self.navigationController?.pushViewController(bindPhone, animated: true)
    }
    func showError(view:UIView,message:String){
        //let alertVC = UIAlertController.init(title: "test", message: nil, preferredStyle: .alert)
        
        //self.present(alertVC, animated: true, completion: nil)
    }
    
}
