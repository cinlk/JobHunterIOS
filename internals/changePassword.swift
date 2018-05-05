//
//  changePassword.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let oldPW:String = "请输入原密码"
fileprivate let newPW:String = "请输入6-16位新密码"

class changePassword: UIViewController {

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改密码"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension changePassword{
    
    private func initView(){
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor =  UIColor.init(r: 246, g: 246, b: 246)
        self.view.addSubview(oldPassWordView)
        self.view.addSubview(newPassWordView)
        self.view.addSubview(confirmBtn)
        _ = oldPassWordView.sd_layout().leftSpaceToView(self.view,20)?.rightSpaceToView(self.view,20)?.topSpaceToView(self.view,30 + NavH)?.heightIs(40)
        _ = newPassWordView.sd_layout().leftEqualToView(oldPassWordView)?.rightEqualToView(oldPassWordView)?.topSpaceToView(oldPassWordView,20)?.heightIs(40)
        _ = confirmBtn.sd_layout().leftEqualToView(newPassWordView)?.rightEqualToView(newPassWordView)?.topSpaceToView(newPassWordView,50)?.heightIs(30)
        
    }
    
    @objc func confirm(){
        self.view.endEditing(true)
    }
    
    @objc func tapClick(){
        self.view.endEditing(true)
    }
}


extension changePassword: UITextFieldDelegate{
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print(textField.text)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
