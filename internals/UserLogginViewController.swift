//
//  UserLogginViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
fileprivate let contentViewH:CGFloat = 140
class UserLogginViewController: UIViewController {

    
    private lazy var appImage:UIImageView = {
        let image = UIImageView.init()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "ali")
        return image
    }()
    
    private lazy var itemTitleView:pagetitleView = {
        let title = pagetitleView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - 20, height: 25), titles: ["快捷登录","密码登录"],itemWidth: 100)
        title.delegate = self
        
        return title
    }()
    
    private lazy var contentView: pageContentView = { [unowned self] in
        
        let vc1 = QuickLoggingViewController()
        vc1.parentVC = self 
        let vc2 = PasswordLoggingViewController()
        vc2.parentVC = self 
        
        let content = pageContentView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW - 20, height: contentViewH), childVCs: [vc1,vc2], pVC: self)
        content.delegate = self
        return content
    }()
    
     lazy var loggingBtn:UIButton = {
        let btn = UIButton.init()
        btn.setTitle("登 录", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.titleLabel?.textAlignment = .center
        //btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    // 匿名登录
    private lazy var skipBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setBackgroundImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(skip), for: .touchUpInside)
        btn.tintColor = UIColor.black
        btn.backgroundColor = UIColor.clear
        return btn
        
    }()
    
    
    // 第三方登录
    private lazy var socialAppLoginView:ThirdPartLoginView = {
        let view = ThirdPartLoginView()
        view.delegate = self
        return view 
    }()
    
    private lazy var tapGestur:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired  = 1
        tap.addTarget(self, action: #selector(cancelEdit))
        
        return tap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.settranslucent(true)

    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}


extension UserLogginViewController{
    private func setViews(){
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.view.backgroundColor = UIColor.white
        let views:[UIView] = [appImage, itemTitleView,contentView,loggingBtn, skipBtn, socialAppLoginView]
        self.view.sd_addSubviews(views)
        
        _ = appImage.sd_layout().topSpaceToView(self.view,NavH)?.centerXEqualToView(self.view)?.heightIs(ScreenH/4)?.widthIs(160)
        
        _ = itemTitleView.sd_layout().topSpaceToView(appImage,10)?.centerXEqualToView(self.view)?.widthIs(ScreenW - 20)?.heightIs(25)
        _ = contentView.sd_layout().topSpaceToView(itemTitleView,0)?.centerXEqualToView(self.view)?.widthRatioToView(itemTitleView,1)?.heightIs(contentViewH)
       
        _ = loggingBtn.sd_layout().topSpaceToView(contentView,20)?.centerXEqualToView(self.view)?.widthIs(ScreenW - 60)?.heightIs(30)
        
        _ = skipBtn.sd_layout().leftEqualToView(contentView)?.topSpaceToView(self.view,20)?.widthIs(40)?.heightIs(40)

        _ = socialAppLoginView.sd_layout().heightIs(100)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        // watch ketboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // view 点击界面
        self.view.addGestureRecognizer(tapGestur)
        
    }
}

extension UserLogginViewController{
    @objc private func keyboardShow(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
              self.view.frame.origin.y = -100
        }, completion: nil)
        
    }
    @objc private func keyboardHidden(){
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame.origin.y = 0
            
        }, completion: nil)
        
       
        
    }
    
    @objc private func cancelEdit(){
        self.view.endEditing(true)
    }
    
    
    func quickLogin(token:String, hasIdentity:Bool = false){
        // 验证码登录
        let queue = DispatchQueue(label: "myqueue")
        queue.sync {
            //showProgressHun(message: "登录成功", view: self.view)
            
            self.performSegue(withIdentifier: "showMain", sender: nil)
        }
      
        
    }
    @objc private func login(anoymous:Bool = true){
        // 默认匿名用户登录
        
        //
        
    //    anonymous = false
        
        // 假设 用户d输入正确
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            DBFactory.shared.getUserDB().insertUser(account: "123456", password: "123456", auto:true)
//        }
//
//        self.performSegue(withIdentifier: "showMain", sender: nil)
        
    }
}

extension UserLogginViewController: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        // 必须有这个不然collection cell view消失
        self.view.endEditing(true)
        self.contentView.moveToIndex(index)
    }
    
    
}

extension UserLogginViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        // 必须有这个不然collection cell view消失
        self.view.endEditing(true)
        self.itemTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
    
    
    
}

extension UserLogginViewController{
    @objc private func skip(){
        // 去主界面
        anonymous = true
        
        self.performSegue(withIdentifier: "showMain", sender: nil)
        
    }
}


//  跳转到主界面

extension UserLogginViewController{
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "showMain"{
        let _ = segue.destination as? MainTabBarViewController
        
        //传入用户信息
        //MARK 存储或更新个人信息到本地
        
        }
    
    }
}


// 第三方登录

extension UserLogginViewController: SocialAppLoginDelegate{
    
    func verifyLoggable(view: UIView, type: UMSocialPlatformType, respons: UMSocialUserInfoResponse) {
        // 判断response 已经有绑定的手机号？
        // 如果没有绑定对应的账号（手机或邮箱）
        let setVC = AffiliatedAccountViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    
    func showError(view: UIView, message: String) {
        
    }
    
    
}

