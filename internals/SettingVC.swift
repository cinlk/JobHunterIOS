//
//  SettingVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        case help = "帮助"
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
    
    
    // logoutAlert
    private lazy var logoutView:UIAlertController = { [unowned self] in
        let alertVC = UIAlertController.init(title: "是否退出登录", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancl = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alertVC.addAction(cancl)
        let confirm = UIAlertAction.init(title: "确认", style: UIAlertActionStyle.default, handler: { (action) in
            self.logout()
        })
        alertVC.addAction(confirm)
        
        return alertVC
    }()
    
    private lazy var items:[Int:[SettingCellItem]] = [0:[.myAccount,.messageSetting,.greeting,.help,.feedBack],1:[.clearCache,.aboutUS,.evaluationUS], 2:[.logout]]
    
    private lazy var records:[SettingCellItem:(Int,Int)] = [:]
    
    private lazy var label:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.text = ""
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
        
    }()
    
    
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
        self.navigationItem.title = "设置"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    

}


extension SettingVC {
    
    private func initView(){
        
        self.view.addSubview(tableView)
        _  = tableView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
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
            label.text = cacheSize
            label.sizeToFit()
            cell.accessoryView = label
            return cell
        // 退出cell
        }else if item == .logout{
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.blue
            return cell
        }
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textAlignment = .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    // header section view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemType:SettingCellItem = items[indexPath.section]![indexPath.row]
        records[itemType] = (indexPath.section, indexPath.row)
        
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
            clearCache()
        case .logout:
            logoutAlertShow()
        case .evaluationUS:
            evaluationApp()
        case .help:
            let help = HelpsVC()
            self.navigationController?.pushViewController(help, animated: true)
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
    
    private func clearCache(){
        
        SVProgressHUD.showSuccess(withStatus: "清理完成")
        SVProgressHUD.dismiss(withDelay: 3) {
            self.cacheSize = ""
            self.tableView.reloadData()
        }
        
        // MARK bug ???
        //self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
    
    }
    
    // 评价app
    private func evaluationApp(){
        
        openApp(appURL: "id444934666") { (bool) in
            print("open success \(bool)")
        }
    }
    
    // 退出提示
    private func logoutAlertShow(){
        self.present(logoutView, animated: true, completion: nil)
    }
    private func logout(){
        
       
       let loginView =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LogViewController
         // 禁止自动登录
         SqliteManager.shared.setLoginAuto(auto: false)
         self.dismiss(animated: false, completion: {
                self.present(loginView, animated: true, completion: nil)
        })
        
    }
}




