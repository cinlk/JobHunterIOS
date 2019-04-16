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
import RxDataSources
import ObjectMapper


fileprivate let text = "登录代表你同意 "
fileprivate let agreement = "<<app用户协议>>"


fileprivate class tableViewFoot: UIView {
    
    
    private lazy var des:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .center
        lb.textColor = UIColor.black
        lb.text = text
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        return lb
    }()

    lazy var btn: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.white
        btn.setTitle(agreement, for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.textAlignment = .left
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        self.addSubview(des)
        self.addSubview(btn)
        _ = btn.sd_layout()?.rightSpaceToView(self,10)?.centerYEqualToView(self)?.heightRatioToView(self,0.8)?.widthRatioToView(self,0.4)
        _ = des.sd_layout()?.rightSpaceToView(btn, 10)?.centerYEqualToView(btn)?.autoHeightRatio(0)
        
        super.layoutSubviews()
    }
    
    
}


class QuickLoggingViewController: UIViewController, UITableViewDelegate {

    
    weak var parentVC:UserLogginViewController?
    
    
    
     lazy var tableView:UITableView = {  [unowned self] in
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableHeaderView = UIView()
        tb.tableFooterView = tableFootView
        tb.isScrollEnabled = false
        tb.bounces = false
        tb.register(InnerTextFiledCell.self, forCellReuseIdentifier: InnerTextFiledCell.identity())
        tb.backgroundColor = UIColor.white
        return tb
    }()
    private lazy var verifyBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 20))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        //btn.addTarget(self, action: #selector(self.validateCode), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    // 倒计时
    private  lazy var codeNumber:ValidateNumber =  ValidateNumber(button: verifyBtn)!
    private lazy var tableFootView: tableViewFoot = {
        return  tableViewFoot.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40))
    }()
    
    // rxSwift
    private var dispose = DisposeBag()
    
    private var phoneNumber: BehaviorRelay<String> = BehaviorRelay<String>.init(value: "")
    private var verifyCode: BehaviorRelay<String> = BehaviorRelay<String>.init(value: "")
    private var quickVM = LoginViewModel()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

   
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = self.tableView.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    
    deinit {
        
        print("deinit quikLoggingVC \(String.init(describing: self))")
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}




extension QuickLoggingViewController{
    private func setViews(){
       self.view.addSubview(tableView)
       self.tableView.rx.setDelegate(self).disposed(by: self.dispose)
    }
}


// viewmodel

extension QuickLoggingViewController{
    
    private func setViewModel(){
        
        // 查看协议
        _ = self.tableFootView.btn.rx.tap.takeUntil(self.rx.deallocated).subscribe {   _ in
            let vc = BaseWebViewController()
            vc.mode = SingletoneClass.shared.appAgreementURL
            vc.showRightBtn = false
            self.navigationController?.pushViewController(vc , animated: true)
        }
        
     
        
        // table
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String,String>>.init(configureCell:  { [weak self] (_, table, index, element) -> UITableViewCell in
            guard let `self` = self else {
                return UITableViewCell()
            }
            
            if  let cell = table.dequeueReusableCell(withIdentifier: InnerTextFiledCell.identity(), for: index) as?  InnerTextFiledCell{
                if index.row == 0 {
                    
                    cell.textFiled.leftImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "me").withRenderingMode(.alwaysTemplate), highlightedImage: #imageLiteral(resourceName: "sina").withRenderingMode(.alwaysTemplate))
                    // 监听账号值
                    
                    cell.textFiled.rx.text.orEmpty.share().bind(to: self.phoneNumber).disposed(by: cell.disposeBag)
                    
                }else if index.row == 1{
                    cell.textFiled.leftImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "password").withRenderingMode(.alwaysTemplate), highlightedImage: #imageLiteral(resourceName: "sina").withRenderingMode(.alwaysTemplate))
                    cell.textFiled.rightBtn = self.verifyBtn
                    cell.textFiled.righPadding = 10
                    // 验证码
                    cell.textFiled.rx.text.orEmpty.share().bind(to: self.verifyCode).disposed(by: cell.disposeBag)
                    
                }
                
                cell.textFiled.placeholder = element
                cell.textFiled.leftView?.tintColor = UIColor.orange
                cell.textFiled.keyboardType = .numberPad
                cell.textFiled.leftPadding = 10
                
                return cell
            }
            
            return UITableViewCell()
        })
        
    
        let cellItem = Observable.just([AnimatableSectionModel.init(model: "", items: ["请输入手机号","请输入验证码"])])
        cellItem.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.dispose)
        
        
        
        
        let verifyBtnValid =  Observable.combineLatest(phoneNumber.asObservable().map{
            $0.count > 6
        }, codeNumber.obCount.asObservable()){ $0 && $1 }.distinctUntilChanged()
        
        // 验证码btn 可用
        verifyBtnValid.asObservable().debug().bind(to: self.verifyBtn.rx.rxEnable).disposed(by: dispose)
        _ = self.verifyBtn.rx.tap.throttle(1, scheduler: MainScheduler.instance).map({ [weak self] in
            self?.codeNumber.start()
        }).flatMapLatest {  [unowned self] _ in
            
            self.quickVM.sendCode(phone: self.phoneNumber.value).asDriver(onErrorJustReturn: Mapper<ResponseModel<CodeSuccess>>.init().map(JSON: [:])!)
            
            }.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (res) in
                
                if  let code = res.code,  HttpCodeRange.filterSuccessResponse(target: code) {
                    return
                }
                self?.codeNumber.stop()
                self?.view.showToast(title: res.returnMsg ?? "发送失败", customImage: nil, mode: .text)
                
                
            })
        
        
        
        // 登录按钮可用
        let obCode = verifyCode.asObservable().map{ [weak self] (v) -> Bool in
            
            return v.count == 6 && Int(v) != nil && (self?.parentVC?.currentIndex ?? -1) == 0
        }.share()
        
        
        let verifyLoginBtn = Observable.combineLatest(self.phoneNumber.asObservable().map{
                $0.count > 6
        }, obCode) { $0 && $1 }.distinctUntilChanged()
        
        verifyLoginBtn.asObservable().debug().bind(to: self.parentVC!.loggingBtn.rx.rxEnable).disposed(by: dispose)
        
        // 验证码登录
        _ = self.parentVC?.loggingBtn.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).filter({ [weak self] in
             self?.parentVC?.currentIndex == 0
        }).flatMapLatest({ [unowned self] _ in
            
            self.quickVM.quickLogin(phone: self.phoneNumber.value, code: self.verifyCode.value).asDriver(onErrorJustReturn: Mapper<ResponseModel<LoginSuccess>>().map(JSON: [:])!)
        }).takeUntil(self.rx.deallocated).subscribe(onNext: {  [weak self] (res) in
            guard let `self` = self else{
                return
            }
            if let token =  res.body?.token,  let lid = res.body?.leanCloudId{
               
                // 获取用户信息
                self.quickVM.getUserInfo(token: token).asDriver(onErrorJustReturn: "").drive(onNext: { [weak self] (any) in
                    if let json = any as? [String:Any], let data = json["body"] as? [String:Any]{
                        
                        GlobalUserInfo.shared.baseInfo(token: token, account: self?.phoneNumber.value ?? "", pwd: "", lid: lid, data: data)
                        // 跳转到主界面
                        guard let pv = self?.parentVC else {
                            return
                        }
                    
                        pv.navBack ? pv.dismiss(animated: true, completion: nil) : pv.performSegue(withIdentifier: pv.mainSegueIdentiy, sender: nil)
                        return
                        
                    }
                }).disposed(by: self.dispose)
                
            }
            self.view.showToast(title: res.returnMsg ?? "登录失败", customImage: nil, mode: .text)
            
        })
        // 网络
        self.quickVM.loginIn.drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible).disposed(by: self.dispose)
        // btn 上的菊花
        self.quickVM.loginIn.drive(self.parentVC!.activity.rx.isAnimating).disposed(by: self.dispose)
        // mbp hub 界面有多个hub，hide只会影藏最上一层的view, 所有不能直接用self.view.showloading
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.quickVM.loginIn.map { !$0
            }.debug().drive(hud.rx.isHidden).disposed(by: self.dispose)
        
    }

    
}


