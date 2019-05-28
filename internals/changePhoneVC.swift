//
//  changePhoneVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


//fileprivate let des:String = GlobalUserInfo.shared.getPhoneNumber().isEmpty ? "绑定新手机号码" : "当前绑定手机号"
fileprivate let inputPhone:String = "请输入新手机号"
fileprivate let inputVerifyCode:String = "请输入验证码"
fileprivate let confirmStr:String = "确定"

class changePhoneVC: UIViewController {

    
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm: LoginViewModel = LoginViewModel.init()
    
    
    private var des:String{
        get{
            return phone.isEmpty ? "绑定新手机号码" : "当前绑定手机号"
        }
    }
    
    // 新手机号
    private var newPhone = ""
    // 收到的验证码
    private var verifyCode:String = ""
    private var inputCode:String = ""
    
    // 当前手机号
    private var phone = ""
    private lazy var topLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = des
        return label
    }()
    
    
    // 
    private lazy var  currentPhoneLabel:UILabel = {
        let lable = UILabel.init(frame: CGRect.zero)
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textAlignment = .center
        lable.textColor = UIColor.black
        lable.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        return lable
    }()
    
    
    private lazy var inputPhoneView:UIView = {  [unowned self] in
        let outView = UIView.init(frame: CGRect.zero)
        outView.backgroundColor = UIColor.white
        let textfiled = UITextField.init(frame: CGRect.zero)
        textfiled.placeholder = inputPhone
        textfiled.textAlignment = .left
        textfiled.delegate = self
        textfiled.tag = 10
        textfiled.keyboardType = .numberPad
        outView.addSubview(textfiled)
        _ = textfiled.sd_layout().leftSpaceToView(outView,10)?.rightEqualToView(outView)?.topEqualToView(outView)?.bottomEqualToView(outView)
        
        return outView
        
    }()
    
    
    private lazy var inputCodeView:UIView = {  [unowned self] in
        let outView = UIView.init(frame: CGRect.zero)
        outView.backgroundColor = UIColor.white
        let textfiled = UITextField.init(frame: CGRect.zero)
        textfiled.placeholder = inputVerifyCode
        textfiled.delegate = self
        textfiled.tag = 11
        textfiled.keyboardType = .numberPad
        textfiled.textAlignment = .left
        
        
        outView.addSubview(textfiled)
        _ = textfiled.sd_layout().leftSpaceToView(outView,10)?.rightSpaceToView (outView,100)?.topEqualToView(outView)?.bottomEqualToView(outView)
        
        let codeBtn = UIButton.init(frame: CGRect.zero)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        codeBtn.setTitleColor(UIColor.green, for: .normal)
        codeBtn.backgroundColor = UIColor.clear
        codeBtn.layer.cornerRadius = 10
        codeBtn.layer.borderColor = UIColor.blue.cgColor
        codeBtn.layer.borderWidth = 1
        
        codeBtn.addTarget(self, action: #selector(receiveCode), for: .touchUpInside)
        self.refBtn = codeBtn
        outView.addSubview(codeBtn)
        _ = codeBtn.sd_layout().rightSpaceToView(outView,10)?.topSpaceToView(outView,5)?.bottomSpaceToView(outView,5)?.widthIs(80)
        
        
        return outView
        
    }()
    
    
    private lazy var confirmBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.blue
        btn.setTitle(confirmStr, for: .normal)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.white, for: .normal)
        
        return btn
        
    }()
    
    private lazy var tap:UITapGestureRecognizer = { [unowned self] in
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(tapClick))
        return tap
    }()
    
    
    // 倒计时
    private var refBtn:UIButton?
    private var countNumber:ValidateNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        countNumber = ValidateNumber(button: refBtn)
        
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(phone:String){
        self.init(nibName: nil, bundle: nil)
        self.phone = phone
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit changePhoneVC \(self)")
    }
   
    

}

extension changePhoneVC{
    
    private func initView(){
        self.title = self.phone.isEmpty ? "添加手机号" : "修改手机号"
        
        currentPhoneLabel.text = phone
        self.view.backgroundColor = UIColor.init(r: 246, g: 246, b: 246)
        self.view.addGestureRecognizer(tap)
        self.view.addSubview(topLabel)
        self.view.addSubview(currentPhoneLabel)
        self.view.addSubview(inputPhoneView)
        self.view.addSubview(inputCodeView)
        self.view.addSubview(confirmBtn)
        _ = topLabel.sd_layout().centerXEqualToView(self.view)?.topSpaceToView(self.view,20 + GlobalConfig.NavH)?.widthIs(200)?.heightIs(10)
        _ = currentPhoneLabel.sd_layout().centerXEqualToView(self.view)?.topSpaceToView(topLabel,5)?.autoHeightRatio(0)
        _ = inputPhoneView.sd_layout().leftSpaceToView(self.view,20)?.rightSpaceToView(self.view,20)?.topSpaceToView(currentPhoneLabel,20)?.heightIs(40)
        _ = inputCodeView.sd_layout().leftEqualToView(inputPhoneView)?.rightEqualToView(inputPhoneView)?.topSpaceToView(inputPhoneView,10)?.heightIs(40)
        _ = confirmBtn.sd_layout().leftEqualToView(inputCodeView)?.rightEqualToView(inputCodeView)?.topSpaceToView(inputCodeView,30)?.heightIs(40)
        
        
    }

    // 确认修改phone
    @objc func confirm(){
        self.view.endEditing(true)
        self.vm.changePhone(phone: self.newPhone, code: self.inputCode).subscribe(onNext: { [weak self] (res) in
            guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                self?.view.showToast(title: res.returnMsg ?? "", customImage: nil, mode: .text)
                return
            }
            self?.currentPhoneLabel.text = self?.newPhone
            self?.view.showToast(title: "修改成功", customImage: nil, mode: .text)
            
            UserDefaults.init().setValue(self?.newPhone ?? "", forKey: UserDefaults.userAccount)

            
            self?.navigationController?.popvc(animated: true)
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//        if self.verifyCode.count == 6 &&  self.inputCode == "\(self.verifyCode)" {
//
//        }else{
//        }
//
//        if self.phone.isEmpty{
//            // 添加号码
//        }else{
//            // 修改号码
//        }
 
         
    }
    
    // 获取验证码
    @objc func receiveCode(){
        // 判断手机号码 是否正确
        self.view.endEditing(true)
        guard  Validate.phoneNum(self.newPhone).isRight else {
            self.view.showToast(title: "手机号码不正确", customImage: nil, mode: .text)
            return
        }
        
        countNumber?.start()
        
        // 获取验证码
        self.vm.sendCode(phone: self.newPhone).subscribe(onNext: { [weak self] (res) in
            if let code = res.body?.code{
                self?.verifyCode = code
            }else{
                self?.view.showToast(title: "获取验证码错误", customImage: nil, mode: .text)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        
    }
    // 点击空白处 收齐键盘
    @objc func tapClick(){
        self.view.endEditing(true)
    }
}



extension changePhoneVC: UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 10{
            self.newPhone = textField.text ?? ""
            
        }else if textField.tag == 11{
            self.inputCode = textField.text ?? ""
        }
    }
    
}
