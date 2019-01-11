//
//  PasswordLoggingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordLoggingViewController: UITableViewController {
    
    weak var parentVC: UserLogginViewController?
    
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
    
    private lazy var lash:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.backgroundColor = UIColor.clear
        btn.setBackgroundImage(UIImage.init(named: "lash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setBackgroundImage(UIImage.flipImage(image: #imageLiteral(resourceName: "lash"), orientation: UIImage.Orientation.down).withRenderingMode(.alwaysTemplate), for: UIControl.State.selected)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
        
    }()
    
    
    private lazy var ForgetPasswordBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记密码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return btn
    }()
    
    // 注册账号
    private lazy var RegistryNewAccountBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册账号", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(registryAccount), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableFootView:UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 40))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 获取验证码界面
    private lazy var  resetpdVC = ResetPasswordViewController()
    
    //rxswift
    private var account:Variable<String> = Variable<String>("")
    private var pwd:Variable<String> = Variable<String>("")
    private var dispose:DisposeBag = DisposeBag()
    private var viewModel:AccountLoginViewModel = AccountLoginViewModel()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                cell.textFiled.placeholder = "请输入手机号或邮箱"
                cell.textFiled.leftImage = userIcon
                cell.textFiled.rx.text.orEmpty.bind(to: account).disposed(by: dispose)
                
            }else if indexPath.row == 1{
                cell.textFiled.placeholder = "请输入密码"
                cell.textFiled.leftImage = numberIcon
                cell.textFiled.rightBtn = lash
                cell.textFiled.showLine = false
                cell.textFiled.isSecureTextEntry = true
                cell.textFiled.rx.text.orEmpty.bind(to: pwd).disposed(by: dispose)
                //cell.textFiled
            }
            cell.textFiled.leftView?.tintColor = UIColor.orange
            cell.textFiled.leftPadding = 10
            return cell
        }
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}




extension PasswordLoggingViewController{
    @objc private func click(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.tintColor =  btn.isSelected ? UIColor.orange : UIColor.lightGray
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? innerTextFiledCell{
            cell.textFiled.isSecureTextEntry = btn.isSelected ? false : true
        }
        
    }
}

extension PasswordLoggingViewController{
    private func setViews(){
        
        tableFootView.addSubview(ForgetPasswordBtn)
        tableFootView.addSubview(RegistryNewAccountBtn)
        _ = ForgetPasswordBtn.sd_layout().rightSpaceToView(tableFootView,10)?.centerYEqualToView(tableFootView)?.widthIs(120)?.heightIs(20)
        _ = RegistryNewAccountBtn.sd_layout().leftSpaceToView(tableFootView,10)?.centerYEqualToView(tableFootView)?.widthRatioToView(ForgetPasswordBtn,1)?.heightRatioToView(ForgetPasswordBtn,1)
        
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = tableFootView
        self.tableView.isScrollEnabled = false
        self.tableView.bounces = false
        self.tableView.register(innerTextFiledCell.self, forCellReuseIdentifier: innerTextFiledCell.identity())
        self.tableView.backgroundColor = UIColor.white
        
    }
}

extension PasswordLoggingViewController{
    @objc private func resetPassword(){
        resetpdVC.isResetPwd = true 
        self.navigationController?.pushViewController(resetpdVC, animated: true)
    }
    @objc private func registryAccount(){
        let vc = ResetPasswordViewController()
        vc.inputPassword.placeholder = "输入密码（大于6位"
        vc.resetBtn.setTitle("确认", for: .normal)
        vc.isResetPwd = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//viewmodel
extension PasswordLoggingViewController{
    
    private func setViewModel(){
        

        
        let logBtnConfirm =  Observable.combineLatest(account.asDriver().map{
            self.isEmail(str: $0) ? true : self.isPhone(str: $0)
            }.asObservable(), pwd.asDriver().map{
                $0.count >= 6
        }.asObservable()) { $0 && $1 }.debug()

        logBtnConfirm.bind(to: self.parentVC!.loggingBtn.rx.rxEnable).disposed(by: dispose)
        
        self.parentVC?.loggingBtn.rx.tap.subscribe(onNext: {
           // print(self.account.value, self.pwd.value)
            self.viewModel.passwordLogin(accont: self.account.value, pwd: self.pwd.value).debug().subscribe(onNext: { (res) in
                print("res ", res.toJSON())
            }, onError: { (err) in
                
                // TODO 获取错误类型
                print("error is", err)
                showAlert(error: "账号密码错误", vc: self)
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }, onError: { (err) in
           
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
    }
    
    private func isEmail(str:String) -> Bool{
        return str.contains(Character.init("@"))
        
    }
    
    private func isPhone(str:String) -> Bool{
        if str.count == 11 {
            if let _ = UInt(str){
                return true
            }
        }
        return false
    }
}
