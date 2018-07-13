//
//  SettingVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let cellIdentifier:String = "default"


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
    }

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
    
    
  
    private lazy var items:[Int:[SettingCellItem]] = [0:[.myAccount,.messageSetting,.greeting,.feedBack],1:[.clearCache,.aboutUS,.evaluationUS], 2:[.logout]]
    
  
    
    // 获取 缓存 还有其他内容？
    private lazy var cacheSize:String = "2.13MB"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
      }
    
  
    
    

}


extension SettingVC {
    
    private func initView(){
        self.title = "设置"
        self.view.addSubview(tableView)
        _  = tableView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
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
            label.text = cacheSize
            label.sizeToFit()
            cell.accessoryView  = label
            
            
        // 退出cell
        }else if item == .logout{
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.blue
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
            let account = myAccount(style: .grouped)
            self.navigationController?.pushViewController(account, animated: true)
        case .aboutUS:
            let us = aboutUS()
            self.navigationController?.pushViewController(us, animated: true)
        case .messageSetting:
            let notify = notificationVC(style: .grouped)
            self.navigationController?.pushViewController(notify, animated: true)
        case .greeting:
            let greet = greetingVC(style: .grouped)
            self.navigationController?.pushViewController(greet, animated: true)
        case .clearCache:
            
            let cell = tableView.cellForRow(at: indexPath)
          
            cell?.presentAlert(type: .alert, title: "清理缓存", message: nil, items: [actionEntity.init(title: "确定", selector: #selector(clearCache), args: indexPath)], target: self, complete: { alert in
                self.present(alert, animated: true, completion: nil)
            })
            
            
        case .logout:
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.presentAlert(type: .alert, title: nil, message: "是否退出登录", items: [actionEntity.init(title: "退出", selector: #selector(logout), args: nil)], target: self, complete: { alert in
                self.present(alert, animated: true, completion: nil)
            })
            
        
        case .evaluationUS:
            //evaluationApp()
            let cell = tableView.cellForRow(at: indexPath)
            cell?.presentAlert(type: .alert, title: "觉得好用的话，给我个评价吧！", message: nil, items: [actionEntity.init(title: "好的", selector: #selector(evaluationApp), args: "itms-apps://itunes.apple.com/app/id444934666")], target: self, complete: { alert in
                self.present(alert, animated: true, completion: nil)
                
            })
            
        case .feedBack:
            let problem = feedBackVC()
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
    
    // 清理缓存
    @objc private func clearCache(_ params: IndexPath?){
        
          guard  let index = params else {
            return
          }
          showOnlyTextHub(message: "清楚完成", view: self.view)
          self.cacheSize = "0.00MB"
          self.tableView.reloadRows(at: [index], with: .automatic)
        
    }
    
    // 评价app
   @objc  private func evaluationApp(_ url:String){
        
        openApp(appURL: url) { (bool) in
            print("open success \(bool)")
        }
    }
    
   
    
   @objc  private func logout(){
        
      
         // 禁止自动登录
         DBFactory.shared.getUserDB().setLoginAuto(auto: false)
        // 登录界面进入
        if  let _ = self.presentingViewController as? LoginNavigationController{
            self.dismiss(animated: true, completion: nil)
        }else{
            // 直接进入
             let loginView =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as! LoginNavigationController
            
            self.present(loginView, animated: true, completion: nil)
        }
        
        
        
    }
}




