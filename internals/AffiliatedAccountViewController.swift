//
//  AffiliatedAccountViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let navTitle:String = "验证账号"
fileprivate let describe:String = "填写你已经注册的账号或注册新的账号, 绑定后登陆"

class AffiliatedAccountViewController: UIViewController {

    
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(self.validateCode), for: UIControl.Event.touchUpInside)
        
        return btn
    }()
    
    private lazy var introduce:UILabel = {
        let lb = UILabel()
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        lb.textAlignment = .left
        lb.textColor = UIColor.black
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = describe
        return lb
    }()
    
    
    private lazy var accountText:customerTextField = { [unowned self] in
        let field = customerTextField.init(frame: CGRect.zero)
        field.delegate = self
        field.textAlignment = .left
        field.clearButtonMode = .whileEditing
        field.keyboardType = UIKeyboardType.default
        field.font = UIFont.systemFont(ofSize: 16)
        field.borderStyle = .roundedRect
        field.placeholder = "输入手机号或邮箱"
        field.leftImage = userIcon
        field.leftPadding = 10
        return field
    }()
    
    private lazy var verifyCode:customerTextField = { [unowned self] in
        let field = customerTextField.init(frame: CGRect.zero)
        field.delegate = self
        field.textAlignment = .left
        field.clearButtonMode = .whileEditing
        field.keyboardType = UIKeyboardType.numberPad
        field.font = UIFont.systemFont(ofSize: 16)
        field.borderStyle = .roundedRect
        field.placeholder = "输入验证码"
        field.leftImage = numberIcon
        field.leftPadding = 10
        field.righPadding = 10
        field.rightBtn = verifyBtn
        return field
    }()
    
    private lazy var confirmBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.backgroundColor = UIColor.lightGray
        btn.setTitle("确 定", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var tapGestur:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired  = 1
        tap.addTarget(self, action: #selector(cancelEdit))
        
        return tap
    }()
    
    
    private  lazy var codeNumber:ValidateNumber =  ValidateNumber(button: verifyBtn)!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()

    }
    
    


}

extension AffiliatedAccountViewController{
    private func serViews(){
        
        self.view.backgroundColor = UIColor.viewBackColor()
        self.title = navTitle
        let views:[UIView] = [accountText, verifyCode, confirmBtn, introduce]
        self.view.sd_addSubviews(views)
        
        _ = accountText.sd_layout().topSpaceToView(self.view, NavH + 30)?.centerXEqualToView(self.view)?.widthIs(GlobalConfig.ScreenW - 40)?.heightIs(50)
        _ = verifyCode.sd_layout().topSpaceToView(accountText, 15)?.centerXEqualToView(self.view)?.widthRatioToView(accountText,1)?.heightRatioToView(accountText,1)
        _ = confirmBtn.sd_layout().topSpaceToView(verifyCode,40)?.centerXEqualToView(self.view)?.widthRatioToView(verifyCode,1)?.heightIs(40)
        
        _ = introduce.sd_layout().topSpaceToView(confirmBtn,20)?.leftEqualToView(confirmBtn)?.autoHeightRatio(0)
        
        
        // view 点击界面
        self.view.addGestureRecognizer(tapGestur)
        
    }
}



extension AffiliatedAccountViewController{
    
    
    @objc private func validateCode(){
         codeNumber.start()
    }
    
    @objc private func confirm(){
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



extension AffiliatedAccountViewController:UITextFieldDelegate{
    
    
}
