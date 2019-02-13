//
//  UserLogginViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift

fileprivate let contentViewH:CGFloat = GlobalConfig.ScreenH / 4

fileprivate let titles  = ["快捷登录","密码登录"]



class UserLogginViewController: UIViewController {

    let mainSegueIdentiy = "showMain"
    
    lazy var currentIndex = 0
    
    lazy var activity = {
       return UIActivityIndicatorView.init()
    }()
    
    private lazy var appImage:UIImageView = {
        let image = UIImageView.init()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage.init(named:  GlobalConfig.defaultImage)!
        return image
    }()
    
    private lazy var itemTitleView:PagetitleView = {
        let title = PagetitleView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW - 20, height: 30), titles: titles, itemWidth: 100)
        title.delegate = self
        return title
    }()
    
    private lazy var contentView: PageContentView = { [unowned self] in
        
        let vc1 = QuickLoggingViewController()
        vc1.parentVC = self 
        let vc2 = PasswordLoggingViewController()
        vc2.parentVC = self 
        
        let content = PageContentView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW - 20, height: contentViewH), childVCs: [vc1,vc2], pVC: self)
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
        btn.addSubview(activity)
        _ = activity.sd_layout()?.leftSpaceToView(btn,20)?.centerYEqualToView(btn)?.heightRatioToView(btn,0.8)?.widthEqualToHeight()
        return btn
    }()
    
    // 匿名登录
    private lazy var skipBtn:UIButton = {
        //  宽高 大小调试
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 60))
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.tintColor = UIColor.blue
        btn.backgroundColor = UIColor.clear
        btn.setPositionWith(image: UIImage.init(named: "forward")?.changesize(size: CGSize.init(width: 20, height: 20), renderMode: .alwaysTemplate), title: "跳过", titlePosition: .left, additionalSpacing: -3, state: .normal, offsetY: 0)
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
    
    private var dispose = DisposeBag()
     private var quickVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        viewModel()
        
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

    
    
    
    
}


extension UserLogginViewController{
    private func setViews(){
        
       // print("ios 10 nac height", self.navigationController?..frame.height)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.view.backgroundColor = UIColor.white
        let views:[UIView] = [appImage, itemTitleView,contentView,loggingBtn, skipBtn, socialAppLoginView]
        self.view.sd_addSubviews(views)
        
        _ = appImage.sd_layout().topSpaceToView(self.view, GlobalConfig.NavH)?.centerXEqualToView(self.view)?.heightIs(GlobalConfig.ScreenH/4)?.widthIs(GlobalConfig.ScreenW/2)
        
        _ = itemTitleView.sd_layout().topSpaceToView(appImage,20)?.centerXEqualToView(self.view)?.widthIs(GlobalConfig.ScreenW - 20)?.heightIs(25)
        _ = contentView.sd_layout().topSpaceToView(itemTitleView,0)?.centerXEqualToView(self.view)?.widthRatioToView(itemTitleView,1)?.heightIs(contentViewH)
       
        _ = loggingBtn.sd_layout().topSpaceToView(contentView,20)?.centerXEqualToView(self.view)?.widthIs(GlobalConfig.ScreenW - 60)?.heightIs(45)
        
        _ = skipBtn.sd_layout().leftEqualToView(contentView)?.topSpaceToView(self.view,GlobalConfig.NavH - 20)

        _ = socialAppLoginView.sd_layout().heightIs(100)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
    }
    
    private func viewModel(){
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).takeUntil(
            self.rx.deallocated).subscribe { notify in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    //notify.element?.userInfo
                    // TODO  根据键盘计算 高度
                    self.view.frame.origin.y = -100
                }, completion: nil)
        }
        
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).takeUntil(self.rx.deallocated).subscribe(onNext: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.frame.origin.y = 0
                
            }, completion: nil)
            
        })
        
        // view 点击界面
        self.view.addGestureRecognizer(tapGestur)
        
        
        // 匿名使用
        _ = self.skipBtn.rx.tap.takeUntil(self.rx.deallocated).subscribe({ _ in
            
            GlobalUserInfo.shared.isLogin = false
            self.quickVM.anonymouseLogin().asDriver(onErrorJustReturn: ResponseModel<LoginSuccess>(JSON: [:])!).drive(onNext: { (res) in
                if let token = res.body?.token{
                       GlobalUserInfo.shared.baseInfo(role: UserRole.role.anonymous, token: token, account: "" , pwd: "")
                }
             
            }).disposed(by: self.dispose)
            self.performSegue(withIdentifier: self.mainSegueIdentiy, sender: nil)
            
        })
        
    }
}

extension UserLogginViewController{
    
    
    @objc private func cancelEdit(){
        self.view.endEditing(true)
    }
 
}

extension UserLogginViewController: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int) {
        // 必须有这个不然collection cell view消失
        self.view.endEditing(true)
        self.contentView.moveToIndex(index)
        self.currentIndex = index
    }
    
    
}

extension UserLogginViewController: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        // 必须有这个不然collection cell view消失
        self.view.endEditing(true)
        self.itemTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
        self.currentIndex = targetIndex
    }
    
    
    
}




//  跳转到主界面

extension UserLogginViewController{
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == mainSegueIdentiy{
        let _ = segue.destination as? MainTabBarViewController
        
        }
    
    }
}


// 第三方登录

extension UserLogginViewController: SocialAppLoginDelegate{
    
    func verifyLoggable(view: UIView, type: UMSocialPlatformType, respons: UMSocialUserInfoResponse) {
        // 判断response 已经有绑定的手机号？
        // 如果没有绑定对应的账号（手机或邮箱）
        switch type {
        case .QQ:
            // 假设绑定了手机号 直接登录，返回用户信息
            //self.performSegue(withIdentifier: mainSegueIdentiy, sender: ["userinfo":"name"])
            // 否则 显示绑定账号界面
            self.navigationController?.pushViewController(AffiliatedAccountViewController.init(type: type, id: "id"), animated: true)
        case .wechatSession:
            break
        default:
            break
        }
       
    }
    
    func showError(view: UIView, message: String) {
        self.view.showToast(title: message, customImage: nil, mode: .text)
    }
    
    
}

