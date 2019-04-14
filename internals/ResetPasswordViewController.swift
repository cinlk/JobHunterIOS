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
import ObjectMapper
import Moya

class ResetPasswordViewController: UIViewController {

    
    private lazy var verifyBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 20))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
       // btn.addTarget(self, action: #selector(self.validateCode), for: UIControl.Event.touchUpInside)

        return btn
    }()
    
    private lazy var lash:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.backgroundColor = UIColor.clear
        btn.setBackgroundImage(UIImage.init(named: "lash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setBackgroundImage(UIImage.flipImage(image: #imageLiteral(resourceName: "lash"), orientation: UIImage.Orientation.down).withRenderingMode(.alwaysTemplate), for: UIControl.State.selected)
        btn.tintColor = UIColor.lightGray
        return btn
        
    }()
    
    lazy var resetBtn:UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.blue
        return btn
    }()
    
    
    private lazy var inputAccount:CustomerTextField = { [unowned self] in
        let tx = CustomerTextField()
        tx.placeholder = "输入账号(手机或邮箱)"
        return tx
        
    }()
    
    private lazy var inputVerifyCode:CustomerTextField = { [unowned self] in
        let tx = CustomerTextField()
        tx.placeholder = "输入验证码"
        tx.rightBtn = verifyBtn
        tx.righPadding = 10
        return tx
        
    }()
    
    lazy var inputPassword:CustomerTextField = { [unowned self] in
        let tx = CustomerTextField()
        tx.placeholder = "输入新的密码(6至20位)"
        tx.rightBtn = lash
        tx.righPadding = 10
        tx.showLine = false
        tx.isSecureTextEntry = true
        return tx
    }()
    
    private lazy var tapGestur:UITapGestureRecognizer = {  [unowned self] in
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired  = 1
        tap.addTarget(self, action: #selector(cancelEdit))
        
        return tap
    }()
    
    
    // 倒计时
    private  lazy var codeNumber:ValidateNumber =  ValidateNumber(button: verifyBtn)!
    
    var isResetPwd:Bool = false
    
    private lazy var dispose:DisposeBag = DisposeBag()
    
    private var loginViewModel =  LoginViewModel()
    
    
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


    deinit {
        print("deinit resetpassword \(String.init(describing: self))")
    }
}

extension ResetPasswordViewController{
    private func setViews(){
        
        self.view.backgroundColor = UIColor.viewBackColor()
        
        let views:[UIView] = [inputAccount, inputVerifyCode, inputPassword, resetBtn]
        self.view.sd_addSubviews(views)
        _ = inputAccount.sd_layout().topSpaceToView(self.view,GlobalConfig.NavH + 30)?.centerXEqualToView(self.view)?.widthIs(GlobalConfig.ScreenW - 40)?.heightIs(50)
        _ = inputVerifyCode.sd_layout().topSpaceToView(inputAccount,10)?.widthRatioToView(inputAccount,1)?.heightRatioToView(inputAccount,1)?.centerXEqualToView(inputAccount)
        _ = inputPassword.sd_layout().topSpaceToView(inputVerifyCode,10)?.widthRatioToView(inputVerifyCode,1)?.heightRatioToView(inputVerifyCode,1)?.centerXEqualToView(inputVerifyCode)
        _ = resetBtn.sd_layout().topSpaceToView(inputPassword, 30)?.centerXEqualToView(inputPassword)?.widthRatioToView(inputPassword,1)?.heightIs(40)
        
        
        
        // view 点击界面
        self.view.addGestureRecognizer(tapGestur)
        
    }
 
 
    
    @objc private func cancelEdit(){
        self.view.endEditing(true)
    }
    
}




// viewmodel
extension ResetPasswordViewController{
    
    private func setViewModel(){
        
        
        // 验证码 btn 可用
        let enableverifyBtn = Observable.combineLatest(self.inputAccount.rx.text.orEmpty .map{
            $0.count > 6
        }, codeNumber.obCount.asObservable(), resultSelector: { $0 && $1}).distinctUntilChanged()
        
        enableverifyBtn.bind(to: verifyBtn.rx.rxEnable).disposed(by: dispose)
        
        // 明文密码 显示
        _ = self.lash.rx.tap.takeUntil(self.rx.deallocated).debug().subscribe(onNext: {  [weak self] in
            guard let `self` = self else {
                return
            }
            self.lash.isSelected = !self.lash.isSelected
            self.lash.tintColor =  self.lash.isSelected ? UIColor.orange : UIColor.lightGray
            self.inputPassword.isSecureTextEntry = !self.lash.isSelected
        })
        
        // 获取验证码
        self.verifyBtn.rx.tap.map({  [weak self] in
            self?.codeNumber.start()
        }).flatMapLatest {   [unowned self]  _ in
            self.loginViewModel.sendCode(phone: self.inputAccount.text ?? "", self.isResetPwd).asDriver(onErrorJustReturn: Mapper<ResponseModel<CodeSuccess>>().map(JSON: [:])!)
            }.subscribe(onNext: {   [weak self] res in
                
                if  let code = res.code,  HttpCodeRange.filterSuccessResponse(target: code){
                    return
                }
                self?.codeNumber.stop()
                self?.view.showToast(title: res.returnMsg ??  "获取验证码失败", customImage: nil, mode: .text)
                
            }).disposed(by: self.dispose)
    
        // 确认按钮
        
        let enableResetBtn = Observable.combineLatest(self.inputAccount.rx.text.orEmpty.map({
            $0.count > 6
        }), self.inputVerifyCode.rx.text.orEmpty.map({
            $0.count == 6
        }), self.inputPassword.rx.text.orEmpty.map({
            $0.count >= 6 && $0.count < 20
        })) { $0 && $1 && $2
        }
       
        enableResetBtn.bind(to: resetBtn.rx.rxEnable).disposed(by: dispose)
        
      
        
        if isResetPwd{
            // 重置密码
            _ = resetBtn.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).filter({  [weak self] in
                self?.isResetPwd ?? false
            }).flatMapLatest {    [unowned self] _ in
                
                self.loginViewModel.resetPassword(account: self.inputAccount.text ?? "", code: self.inputVerifyCode.text ?? "", pwd: self.inputPassword.text ?? "").asDriver(onErrorJustReturn: ResponseModel<LoginSuccess>(JSON: [:])!)
                }.takeUntil(self.rx.deallocated).subscribe(onNext: {  [weak self]  res in
                    guard let `self` = self else {
                        return
                    }
                    
                    guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code), let token = res.body?.token else {
                        self.view.showToast(title: res.returnMsg ?? "设置密码失败", customImage: nil, mode: .text)
                        return
                    }
                    self.loginViewModel.getUserInfo(token: token).asDriver(onErrorJustReturn: "").drive(onNext: {  [weak self] json in
                        guard let j = json as? [String:Any], let  data = j["body"] as? [String:Any] else {
                            self?.view.showToast(title: "获取用户信息失败", customImage: nil, mode: .text)
                            return
                        }
                        GlobalUserInfo.shared.baseInfo(token: token, account: self?.inputAccount.text ?? "" , pwd: self?.inputPassword.text ?? "", lid: res.body?.leanCloudId ?? "", data: data)
                        
                    }).disposed(by: self.dispose)
                    
              
            })
            
  
        }else{
            // 注册账号
            _ = resetBtn.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).filter({  [weak self] in
                !(self?.isResetPwd ?? true)
            }).flatMapLatest({  [unowned self] _ in
                self.loginViewModel.registryAccount(account: self.inputAccount.text ?? "", code: self.inputVerifyCode.text ?? "", pwd: self.inputPassword.text ?? "").asDriver(onErrorJustReturn: Mapper<ResponseModel<LoginSuccess>>().map(JSON: [:])!)
            }).takeUntil(self.rx.deallocated).subscribe(onNext: {  [weak self]res in
                guard let `self` = self else{
                    return
                }
                guard let code = res.code, let token = res.body?.token, HttpCodeRange.filterSuccessResponse(target: code) else  {
                    //self.view.showToast(title: "注册失败", customImage: nil, mode: .text)
                    // 跳转
                    self.view.showToast(title: res.returnMsg ?? "注册失败", customImage: nil, mode: .text)
                    return
                }
                // 注册成功
                
                self.loginViewModel.getUserInfo(token: token).asDriver(onErrorJustReturn: "").drive(onNext: {  [weak self] json in
                    guard let j = json as? [String:Any], let  data = j["body"] as? [String:Any] else {
                        self?.view.showToast(title: "获取用户信息失败", customImage: nil, mode: .text)
                        return
                    }
                    GlobalUserInfo.shared.baseInfo(token: token, account: self?.inputAccount.text ?? "" , pwd: self?.inputPassword.text ?? "", lid: res.body?.leanCloudId ?? "", data: data)
                    
                }).disposed(by: self.dispose)
                
                
                
            })
        }
        
        
        // 加载效果
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loginViewModel.loginIn.map {  !$0
        }.drive(hud.rx.isHidden).disposed(by: self.dispose)
        
    }
    
}
