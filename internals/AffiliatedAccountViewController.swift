//
//  AffiliatedAccountViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

fileprivate let navTitle:String = "绑定手机号"
fileprivate let describe:String = "请填写你已经注册的手机号或注册新的手机号, 绑定后即可登陆"



class AffiliatedAccountViewController: UIViewController {

    private lazy var dispose = DisposeBag()
    private var type:UMSocialPlatformType =  UMSocialPlatformType.unKnown
    private var socialId:String = ""
    
    private lazy var verifyBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 20))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
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
    
    
    private lazy var accountText:CustomerTextField = { [unowned self] in
        let field = CustomerTextField.init(frame: CGRect.zero)
        field.keyboardType = UIKeyboardType.default
        field.placeholder = "输入手机号"
        field.leftImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "me"), highlightedImage: #imageLiteral(resourceName: "sina"))
        field.leftPadding = 10
        return field
    }()
    
    private lazy var verifyCode:CustomerTextField = { [unowned self] in
        let field = CustomerTextField.init(frame: CGRect.zero)
        field.keyboardType = UIKeyboardType.numberPad
        field.placeholder = "输入验证码"
        field.leftImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "password"), highlightedImage: #imageLiteral(resourceName: "sina"))
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
        return btn
    }()
    
    
    private lazy var tapGestur:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired  = 1
        tap.addTarget(self, action: #selector(cancelEdit))
        return tap
    }()
    
    
    private  lazy var codeNumber:ValidateNumber?  =  ValidateNumber(button: verifyBtn)

    
    init(type: UMSocialPlatformType, id:String) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.socialId = id 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serViews()
        viewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.clear)
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
        
        _ = accountText.sd_layout().topSpaceToView(self.view, GlobalConfig.NavH + 30)?.centerXEqualToView(self.view)?.widthIs(GlobalConfig.ScreenW - 40)?.heightIs(50)
        _ = verifyCode.sd_layout().topSpaceToView(accountText, 15)?.centerXEqualToView(self.view)?.widthRatioToView(accountText,1)?.heightRatioToView(accountText,1)
        _ = confirmBtn.sd_layout().topSpaceToView(verifyCode,40)?.centerXEqualToView(self.view)?.widthRatioToView(verifyCode,1)?.heightIs(40)
        
        _ = introduce.sd_layout().topSpaceToView(confirmBtn,20)?.leftEqualToView(confirmBtn)?.autoHeightRatio(0)
        
        
        introduce.setMaxNumberOfLinesToShow(0)
     
        
    }
}



extension AffiliatedAccountViewController{
    
    
    private func viewModel(){
        // view 点击界面
        self.view.addGestureRecognizer(tapGestur)
    
        
        self.accountText.rx.text.subscribe(onNext: { (str) in
                self.accountText.leftImage?.isHighlighted = str?.count != 0
        }).disposed(by: self.dispose)
        self.verifyCode.rx.text .subscribe(onNext: { (str) in
                self.verifyCode.leftImage?.isHighlighted = str?.count != 0
        }).disposed(by: self.dispose)
        
        self.codeNumber?.obCount.bind(to: self.verifyBtn.rx.isEnabled).disposed(by: self.dispose)
        
        _ = self.verifyBtn.rx.tap.takeUntil(self.rx.deallocated).subscribe({ _ in
            self.codeNumber?.start()
           
        })
         // 发送验证码接口
        let ConfirmEnable = Driver<Bool>.combineLatest(self.accountText.rx.text.asDriver(), self.verifyCode.rx.text.asDriver()){ (phone, code) in
            return phone?.count == 13 && code?.count == 6
        }.distinctUntilChanged()
        
        ConfirmEnable.drive(self.confirmBtn.rx.isEnabled).disposed(by: self.dispose)
        
      
        // 判断 确定按钮是否可用
        
        _ = self.confirmBtn.rx.tap.takeUntil(self.rx.deallocated).subscribe(onNext: { _ in
            self.view.endEditing(true)
            
            //guard let phone =  self.accountText.text
            
            // 绑定第三方账号 登录
            // 成功跳转到主界面
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! MainTabBarViewController
            
            self.present(vc, animated: true, completion: nil)
            //self.navigationController?.popvc(animated: true)
            
        })
    }
    
   
    
    @objc private func cancelEdit(){
        self.view.endEditing(true)
    }
}
