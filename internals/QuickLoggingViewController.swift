//
//  QuickLoggingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let text = "登录代表你同意 "

class QuickLoggingViewController: UITableViewController {

   
    
    weak var parentVC:UserLogginViewController?
    
    
    private lazy var userIcon:UIImageView = {
        let imageV = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageV.contentMode = .scaleAspectFill
        imageV.image  = #imageLiteral(resourceName: "me").withRenderingMode(.alwaysTemplate)
        return imageV
    }()
    
    private lazy var numberIcon:UIImageView = {
        let imageV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageV.contentMode = .scaleAspectFill
        imageV.image = #imageLiteral(resourceName: "password").withRenderingMode(.alwaysTemplate)
        return imageV
    }()
    
    
    private lazy var verifyBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 20))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(self.validateCode), for: UIControl.Event.touchUpInside)

        
        return btn
    }()
    
    
    // 倒计时
    private  lazy var codeNumber:ValidateNumber =  ValidateNumber(button: verifyBtn)!
    
    
    
    private lazy var tableFootView:UIView = {  [unowned self] in 
        let v = UIView(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40))
        v.isUserInteractionEnabled = true 
        let lb = UILabel()
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .center
        lb.textColor = UIColor.black
        lb.text = text
        v.addSubview(lb)
        
        let userProtocal = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30))
        userProtocal.backgroundColor = UIColor.white
        userProtocal.setTitle("<<app用户协议>>", for: .normal)
        userProtocal.setTitleColor(UIColor.blue, for: .normal)
        userProtocal.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        userProtocal.titleLabel?.textAlignment = .left
        userProtocal.addTarget(self, action: #selector(showProtocal), for: .touchUpInside)
        v.addSubview(userProtocal)
        _ = userProtocal.sd_layout().rightSpaceToView(v,10)?.centerYEqualToView(v)?.widthIs(118)
        _ = lb.sd_layout().rightSpaceToView(userProtocal,10)?.centerYEqualToView(userProtocal)?.autoHeightRatio(0)
        
        
        return v
        
        
    }()
    
    
    
    // rxSwift
    private var dispose = DisposeBag()
    private var phoneNumber:Variable<String> = Variable<String>("")
    private var verifyCode:Variable<String> = Variable<String>("")
    
    private var quickVM = QuickLoginViewModel()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
    
    }
    
    
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: innerTextFiledCell.identity()) as? innerTextFiledCell{
            if indexPath.row == 0 {
                cell.textFiled.placeholder = "请输入手机号"
                 
                cell.textFiled.leftImage = userIcon
                // 监听账号值
                cell.textFiled.rx.text.orEmpty.share().bind(to: phoneNumber).disposed(by: dispose)
                
                
            }else if indexPath.row == 1{
                cell.textFiled.placeholder = "请输入验证码"
                cell.textFiled.leftImage = numberIcon
                cell.textFiled.rightBtn = verifyBtn
                cell.textFiled.righPadding = 10
                cell.textFiled.rx.text.orEmpty.share().bind(to: verifyCode).disposed(by: dispose)

            }
            cell.textFiled.leftView?.tintColor = UIColor.orange
            cell.textFiled.keyboardType = .numberPad
            cell.textFiled.leftPadding = 10
            
            
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}




extension QuickLoggingViewController{
    private func setViews(){
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = tableFootView
        self.tableView.isScrollEnabled = false
        self.tableView.bounces = false
        
        self.tableView.register(innerTextFiledCell.self, forCellReuseIdentifier: innerTextFiledCell.identity())
        self.tableView.backgroundColor = UIColor.white
        
        
        
    }
}


extension QuickLoggingViewController{
    @objc private func showProtocal(){
        // webview
        let webVc = baseWebViewController()
        webVc.mode = "http://www.immomo.com/agreement.html"
        webVc.showRightBtn = false
        self.navigationController?.pushViewController(webVc, animated: true)
    }
}

//
extension QuickLoggingViewController{
    @objc private func validateCode(){
         codeNumber.start()
    }
}


// viewmodel

extension QuickLoggingViewController{
    
    private func setViewModel(){
        
        let verifyBtnValid =  Observable.combineLatest(phoneNumber.asObservable().map{
            $0.count > 6
        }.share(), codeNumber.obCount.asObservable()){ $0 && $1 }.share()
        
        // 验证码btn 可用
        verifyBtnValid.asObservable().debug().bind(to: self.verifyBtn.rx.rxEnable).disposed(by: dispose)
        
        // 发送验证码
        self.verifyBtn.rx.tap.subscribe(onNext: {
            _ = self.quickVM.sendCode(phone: self.phoneNumber.value).subscribe(onNext: { (obj:CodeSuccess) in
                self.view.showToast(title: "发送成功", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "发送成功", view: self.view)
            }, onError: { (err) in
                //showOnlyTextHub(message: "发送失败", view: self.view)
                self.view.showToast(title: "发送失败", customImage: nil, mode: .text)
                self.codeNumber.stop()
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
    
        
        // 登录按钮可用
        let obCode = verifyCode.asObservable().map{ (v) -> Bool in
            if v.count == 6{
                if let _ = Int(v){
                    return true
                }
            }
            return false
        }.share()
        
        
        let verifyLoginBtn = Observable.combineLatest(self.phoneNumber.asObservable().map{
                $0.count > 6
        }.share(), obCode) { $0 && $1 }.share()
        
        verifyLoginBtn.asObservable().debug().bind(to: self.parentVC!.loggingBtn.rx.rxEnable).disposed(by: dispose)
        
        // 验证码登录
        
        self.parentVC?.loggingBtn.rx.tap.subscribe(onNext: {
            self.quickVM.quickLogin(phone:self.phoneNumber.value, code: self.verifyCode.value).subscribe(onNext: { (res) in
                // TODO 判断账号是否绑定了身份，没有显示界面绑定身份
                self.parentVC?.quickLogin(token: res.token ?? "")
            }, onError: { (err) in
                print("err \(err)")
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
    
    }
    
}


