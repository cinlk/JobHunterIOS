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
import RxDataSources
import ObjectMapper

fileprivate let titles = ["请输入手机号","请输入密码"]

fileprivate class tableFooter:UIView {
    
    fileprivate lazy var forgetPasswordBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记密码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        return btn
    }()
    
    // 注册账号
    fileprivate lazy var registryNewAccountBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册账号", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        self.addSubview(forgetPasswordBtn)
        self.addSubview(registryNewAccountBtn)
        _ = forgetPasswordBtn.sd_layout()?.leftSpaceToView(self,20)?.centerYEqualToView(self)?.heightRatioToView(self,0.8)?.widthIs(160)
        _ = registryNewAccountBtn.sd_layout()?.rightSpaceToView(self,20)?.centerYEqualToView(forgetPasswordBtn)?.heightRatioToView(forgetPasswordBtn,1)?.widthRatioToView(forgetPasswordBtn,1)
        
        super.layoutSubviews()
        
    }
    
    
}


class PasswordLoggingViewController: UIViewController, UITableViewDelegate {
    
    weak var parentVC: UserLogginViewController?
    
    private lazy var lash:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.backgroundColor = UIColor.clear
        btn.setBackgroundImage(UIImage.init(named: "lash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setBackgroundImage(UIImage.flipImage(image: #imageLiteral(resourceName: "lash"), orientation: UIImage.Orientation.down).withRenderingMode(.alwaysTemplate), for: UIControl.State.selected)
        btn.tintColor = UIColor.lightGray
        return btn
        
    }()
    
    private lazy var tableFootView:tableFooter = {
        return tableFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40))
    }()
    
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.tableHeaderView = UIView()
        tb.tableFooterView = tableFootView
        tb.isScrollEnabled = false
        tb.bounces = false
        tb.register(InnerTextFiledCell.self, forCellReuseIdentifier: InnerTextFiledCell.identity())
        tb.backgroundColor = UIColor.white
        return tb
    }()
    

    
    //rxswift
    private var account:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    private var pwd:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    private var dispose:DisposeBag = DisposeBag()
    private var viewModel:LoginViewModel = LoginViewModel()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

}




extension PasswordLoggingViewController{
    
    private func setViews(){
     
        self.view.addSubview(tableView)
        _ = tableView.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


//viewmodel
extension PasswordLoggingViewController{
    
    private func setViewModel(){
        
        // 重置密码
        _ = self.tableFootView.forgetPasswordBtn.rx.tap.takeUntil(self.rx.deallocated).subscribe { _ in
            let vc = ResetPasswordViewController()
            vc.isResetPwd = true
            vc.resetBtn.setTitle("重置密码", for: .normal)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 注册账号
        _ = self.tableFootView.registryNewAccountBtn.rx.tap.takeUntil(self.rx.deallocated).subscribe(onNext: { _ in
            let vc = ResetPasswordViewController()
            vc.isResetPwd = false
            vc.resetBtn.setTitle("确认", for: .normal)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        
        // 密码明文显示
        _ = self.lash.rx.tap.takeUntil(self.rx.deallocated).subscribe(onNext: { _ in
            self.lash.isSelected = !self.lash.isSelected
            self.lash.tintColor =  self.lash.isSelected ? UIColor.orange : UIColor.lightGray
            if let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? InnerTextFiledCell{
                cell.textFiled.isSecureTextEntry = !self.lash.isSelected
            }
        })
        
        // table
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String,String>>.init(configureCell:  { (_, table, index, element) -> UITableViewCell in
            
          
            if let cell = table.dequeueReusableCell(withIdentifier: InnerTextFiledCell.identity()) as? InnerTextFiledCell{
                
                if index.row == 0 {
                    
                    cell.textFiled.leftImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "me").withRenderingMode(.alwaysTemplate), highlightedImage: nil)
                    cell.textFiled.rx.text.orEmpty.bind(to: self.account).disposed(by: self.dispose)
                    
                }else if index.row == 1{
                    
                    cell.textFiled.leftImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), image: #imageLiteral(resourceName: "password").withRenderingMode(.alwaysTemplate), highlightedImage: nil)
                    cell.textFiled.rightBtn = self.lash
                    cell.textFiled.showLine = false
                    cell.textFiled.isSecureTextEntry = true
                    cell.textFiled.rx.text.orEmpty.bind(to: self.pwd).disposed(by: self.dispose)
                }
                cell.textFiled.placeholder = element
                cell.textFiled.leftView?.tintColor = UIColor.orange
                cell.textFiled.leftPadding = 10
                
                return cell
            }
            return UITableViewCell()
        })
        
        
        let cellItem = Observable.just([AnimatableSectionModel.init(model: "", items: titles)])
        cellItem.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.dispose)
        
        self.tableView.rx.setDelegate(self).disposed(by: self.dispose)
        
        // 登录按钮检查 当前view
        let enableLogin = Observable.combineLatest(account.share().map({  a in
           return a.count == 11  && Int(a) != nil && self.parentVC?.currentIndex == 1
        }), pwd.map({ p in
            p.count >= 6
        })){
            $0 && $1
        }
        
        enableLogin.bind(to: self.parentVC!.loggingBtn.rx.rxEnable).disposed(by: dispose)
        
        // 登录
        _ = self.parentVC?.loggingBtn.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).filter({
             self.parentVC?.currentIndex == 1
        }).flatMapLatest({ _ in
            self.viewModel.passwordLogin(accont: self.account.value, pwd: self.pwd.value).asDriver(onErrorJustReturn: Mapper<ResponseModel<LoginSuccess>>().map(JSON: [:])!)
        }).takeUntil(self.rx.deallocated).subscribe(onNext: { res in
            
            guard let token =  res.body?.token, let lid = res.body?.leanCloudId else{
                self.view.showToast(title: res.returnMsg ?? "用户名或密码错误", customImage: nil, mode: .text)
                return
            }
            
            self.viewModel.getUserInfo(token: token).asDriver(onErrorJustReturn: "").drive(onNext: { (json) in
                guard let j = json as? [String:Any], let  data = j["body"] as? [String:Any]
                else {
                    self.view.showToast(title: "获取用户信息失败", customImage: nil, mode: .text)
                    return
                }
                // 判断用户角色 切换场景 TODO
                
                GlobalUserInfo.shared.baseInfo(token: token, account: self.account.value , pwd: self.pwd.value, lid: lid, data: data)
                
                guard let pv = self.parentVC else {
                    return
                }
                pv.navBack ? pv.dismiss(animated: true, completion: nil) : pv.performSegue(withIdentifier: pv.mainSegueIdentiy, sender: nil)
                
            }).disposed(by: self.dispose)
               
           
            
            
            
        })
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        // 登录加载
        self.viewModel.loginIn.map({ !$0
        }).drive(hud.rx.isHidden).disposed(by: self.dispose)
        
        
    }
    
   
    
  
}




