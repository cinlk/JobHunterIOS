//
//  changePassword.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let oldPW:String = "请输入原密码"
fileprivate let newPW:String = "请输入6-16位新密码"
fileprivate let navTitle:String = "修改密码"

class changePassword: UIViewController {

    
    private lazy var vm: LoginViewModel = LoginViewModel.init()
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    
    private var oldPwd:String = ""
    private var newPwd:String = ""
    
    
    private lazy var oldPassWordView:UIView = {  [unowned self] in
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        let img = UIImageView.init(image: UIImage.init(named: "private"))
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        v.addSubview(img)
        _ = img.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(20)
        
        let textFiled = UITextField.init(frame: CGRect.zero)
        textFiled.placeholder = oldPW
        textFiled.textAlignment = .left
        textFiled.delegate = self
        textFiled.keyboardType = .default
        textFiled.isSecureTextEntry = true
        textFiled.tag  = 10
        v.addSubview(textFiled)
        _ = textFiled.sd_layout().leftSpaceToView(img,10)?.rightSpaceToView(v,10)?.topEqualToView(v)?.bottomEqualToView(v)
        
        return v
    }()
    
    private lazy var newPassWordView:UIView = { [unowned self] in
        
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        let img = UIImageView.init(image: UIImage.init(named: "private"))
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        v.addSubview(img)
        _ = img.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(20)
        
        let textFiled = UITextField.init(frame: CGRect.zero)
        textFiled.placeholder = newPW
        textFiled.delegate = self
        textFiled.textAlignment = .left
        textFiled.keyboardType = .default
        textFiled.isSecureTextEntry = true
        textFiled.tag  = 11
        v.addSubview(textFiled)
        _ = textFiled.sd_layout().leftSpaceToView(img,10)?.rightSpaceToView(v,10)?.topEqualToView(v)?.bottomEqualToView(v)
        
        return v
    }()
    
    private lazy var confirmBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("确认", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var tap:UITapGestureRecognizer = { [unowned self] in
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(tapClick))
        return tap
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

    
    

}
extension changePassword{
    
    private func initView(){
        self.title =  navTitle
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor =  UIColor.init(r: 246, g: 246, b: 246)
        self.view.addSubview(oldPassWordView)
        self.view.addSubview(newPassWordView)
        self.view.addSubview(confirmBtn)
        _ = oldPassWordView.sd_layout().leftSpaceToView(self.view,20)?.rightSpaceToView(self.view,20)?.topSpaceToView(self.view,30 + GlobalConfig.NavH)?.heightIs(40)
        _ = newPassWordView.sd_layout().leftEqualToView(oldPassWordView)?.rightEqualToView(oldPassWordView)?.topSpaceToView(oldPassWordView,20)?.heightIs(40)
        _ = confirmBtn.sd_layout().leftEqualToView(newPassWordView)?.rightEqualToView(newPassWordView)?.topSpaceToView(newPassWordView,50)?.heightIs(30)
        
    }
    
    @objc func confirm(){
        self.view.endEditing(true)
        if self.oldPwd.isEmpty || self.newPwd.isEmpty {
            self.view.showToast(title: "密码不能为空", customImage: nil, mode: .text)
            return
        }
        
        
        
        self.vm.newPassword(oldPwd: self.oldPwd, newPwd: self.newPwd).subscribe(onNext: { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                
                UserDefaults.init().setValue(self.newPwd, forKey: UserDefaults.userPassword)
                self.view.showToast(title: "修改密码成功", customImage: nil, mode: .text)
                self.navigationController?.popvc(animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        //Validate.password(<#T##String#>)
        
        //self.vm.resetPassword(account: <#T##String#>, code: <#T##String#>, pwd: <#T##String#>)
        
    }
    
    @objc func tapClick(){
        self.view.endEditing(true)
    }
}


extension changePassword: UITextFieldDelegate{
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print(textField.text)
        if textField.tag == 10{
            self.oldPwd = textField.text ?? ""
        }else if textField.tag == 11{
            self.newPwd = textField.text ?? ""
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
