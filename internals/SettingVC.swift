//
//  SettingVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


fileprivate let cellIdentifier:String = "default"
fileprivate let navTitle:String = "个人设置"

class SettingVC: UIViewController {
    
    enum SettingCellItem:String{
        case none
        case myAccount = "我的账号"
        case messageSetting = "推送消息设置"
        case greeting = "打招呼设置"
        case clearCache = "清理缓存"
        case aboutUS = "关于我们"
        case evaluationUS = "给我们评价"
        case logout = "退出当前账号"
        case feedBack = "问题反馈"
        case hiddenResume = "隐藏简历"
    }
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    private lazy var resumeOpen:Bool = true

    private lazy var tableView:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: CGRect.zero)
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .singleLine
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        tb.tableHeaderView = UIView.init()
        tb.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tb
    }()
    
    
  
    private lazy var items:[Int:[SettingCellItem]] = [0:[.myAccount,.messageSetting,.greeting,.feedBack],1:[.hiddenResume,.clearCache,.aboutUS,.evaluationUS], 2:[.logout]]
    
  
    
    // 获取 缓存 还有其他内容？
   private lazy var cacheSize:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        getResumOpenStatu()
       
                
          
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView(UIColor.orange)
        // 计算缓存
        self.currentCache()
    
        
      }
    
  
    
    deinit {
        print("deinit settingVC\(String.init(describing: self))")
    }
    

}


extension SettingVC {
    
    private func  getResumOpenStatu(){
        
        self.vm.userOpenResumeState().subscribe(onNext: { [weak self] (res) in
            if let state = res.body?.open{
                
                self?.resumeOpen = state
                self?.tableView.reloadData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
    private func setView(){
        self.title = navTitle
        self.view.addSubview(tableView)
        _  = tableView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    private func currentCache(){
        
        DispatchQueue.global().async {
            self.cacheSize = AppFileManager.shared.fileSizeOfCache()
            //获取数据异步
            DispatchQueue.main.async {
                //修改主线程UI
                self.tableView.reloadData()
                //self.clearLable.text = "已用 "+String(self.fileSize)+" MB";
            }
        }
        
    }
}





extension SettingVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.keys.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items[section]?.count)!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
 
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
    
        let item = items[indexPath.section]?[indexPath.row]
        cell.textLabel?.text = item?.rawValue
        cell.selectionStyle = .none
        
        
        // 清理缓存
        if item == .clearCache {
            
            //
            let label = UILabel.init(frame: CGRect.zero)
            label.textColor = UIColor.black
            label.textAlignment = .right
            //label.text = "\(cacheSize)"
            label.sizeToFit()
            cell.accessoryView  = label
            
            
        // 退出cell
        }else if item == .logout{
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.blue
        }else if item == .hiddenResume{
            let swich:UISwitch = UISwitch.init()
            swich.isOn = self.resumeOpen ? false : true
            swich.addTarget(self, action: #selector(hiddenResume), for: .valueChanged)
            
            cell.accessoryView = swich
            cell.textLabel?.textAlignment = .left
        }else{
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    //  section view
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  20
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemType:SettingCellItem = items[indexPath.section]![indexPath.row]
        
        switch  itemType {
            
        case .myAccount:
            let account = MyAccount(style: .grouped)
            self.navigationController?.pushViewController(account, animated: true)
        case .aboutUS:
            let us = aboutUS()
            self.navigationController?.pushViewController(us, animated: true)
        case .messageSetting:
            let notify = NotificationSettingVC(style: .grouped)
            self.navigationController?.pushViewController(notify, animated: true)
        case .greeting:
            let greet = GreetingVC(style: .grouped)
            self.navigationController?.pushViewController(greet, animated: true)
        case .clearCache:
            
            let cell = tableView.cellForRow(at: indexPath)
          
            cell?.presentAlert(type: .alert, title: "清理缓存", message: nil, items: [actionEntity.init(title: "确定", selector: #selector(clearCache), args: indexPath)], target: self, complete: { alert in
                self.present(alert, animated: true, completion: nil)
            })
            
            
        case .logout:
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.presentAlert(type: .alert, title: nil, message: "是否退出登录", items: [actionEntity.init(title: "退出", selector: #selector(logout), args: nil)], target: self, complete: { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            })
            
        
        case .evaluationUS:
            //evaluationApp()
            let cell = tableView.cellForRow(at: indexPath)
            cell?.presentAlert(type: .alert, title: "觉得好用的话，给我个评价吧！", message: nil, items: [actionEntity.init(title: "好的", selector: #selector(evaluationApp), args: "itms-apps://itunes.apple.com/app/id444934666")], target: self, complete: { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
//
            })
            
        case .feedBack:
            let problem = UserFeedBackVC()
            self.navigationController?.pushViewController(problem, animated: true)
        default:
            break
        }
        
        
    }
    
    
}

extension SettingVC: UIScrollViewDelegate{
    
    // tableview 不能向上滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            
            let offsetY =  scrollView.contentOffset.y
            if offsetY > -64 {
                scrollView.contentOffset.y = -64
            }
        }
    }
}


extension SettingVC {
    
    @objc private func hiddenResume(s: UISwitch){
        
        // 变成 可见状态
        if s.isOn == false{
            
            self.vm.changeUserOpenResumeStatus(flag: true).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                }else{
                    self?.tableView.showToast(title: "取消隐藏失败", customImage: nil, mode: .text)
                    s.isOn = true
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            return
        }
        
    
        // 变成不可见状态
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            s.isOn = false
        }
        let confirm = UIAlertAction.init(title: "确定", style: .default) { [weak self]  (action) in
            guard let `self`  = self else {
                return
            }
            self.vm.changeUserOpenResumeStatus(flag: false).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    s.isOn = true
                }else{
                    self?.tableView.showToast(title: "影藏失败", customImage: nil, mode: .text)
                    s.isOn = false
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        }
        
        let alert = UIAlertController.init(title: "隐藏简历", message: "隐藏后hr 无法查看", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // 清理缓存 d 缓存的文件？
    //  清楚 app 保留的userdefault 数据
    @objc private func clearCache(_ params: IndexPath?){
        
          guard  let index = params else {
            return
          }
//          UserDefaults.standard.localKeys.forEach { (k) in
//                UserDefaults.standard.removeObject(forKey: k)
//          }
        do{
            try  AppFileManager.shared.deleteCache()
            self.tableView.showToast(title: "清楚完成", customImage: nil, mode: .text)
            //self.cacheSize = 0
            self.tableView.reloadRows(at: [index], with: .automatic)
        }catch {
            print(error)
            self.tableView.showToast(title: "清楚失败\(error)", customImage: nil, mode: .text)

        }
        
    }
    
    // 评价app
   @objc  private func evaluationApp(_ url:String){
        
        Utils.openApp(appURL: url) { (bool) in
            print("open success \(bool)")
        }
    }
    
   
    
   @objc  private func logout(){
         // 禁止自动登录
        //DBFactory.shared.getUserDB().setLoginAuto(account: "123456", auto: false)
        if GlobalUserInfo.shared.isLogin == false {
            self.navgateToLginVC()
            return
        }
        SingletoneClass.shared.logout { (b) in
                b ? self.navgateToLginVC() : self.view.showToast(title: "退出失败", customImage: nil, mode: .text)
            }
    
    }
    
    private func navgateToLginVC(){
        // 登录界面进入
        if  let _ = self.presentingViewController as? LoginNavigationController{

            self.dismiss(animated: true, completion: nil)
        }else{
             // 直接进入
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                let loginView =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as! LoginNavigationController
            
                UIApplication.shared.keyWindow?.rootViewController?.present(loginView, animated: true, completion: nil)
               // self?.view.window?.rootViewController?.present(loginView, animated: true, completion: nil)
            })
            
//            self.dismiss(animated: true) { [weak self] in
//
//                // 直接进入
//                let loginView =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as! LoginNavigationController
//
//                self?.present(loginView, animated: true, completion: nil)
//            }
           
        }
    }
}




