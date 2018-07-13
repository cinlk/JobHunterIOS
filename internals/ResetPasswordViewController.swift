//
//  ResetPasswordViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

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
    
    private lazy var resetBtn:UIButton = {
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
    
    private lazy var inputPassword:customerTextField = { [unowned self] in
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
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
        self.view.endEditing(true)
        // 测试登录
        let vc =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! MainTabBarViewController
        
        
        self.present(vc, animated: true, completion: nil)
        self.navigationController?.popvc(animated: true)

 
        
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
