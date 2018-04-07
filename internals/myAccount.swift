//
//  myAccount.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let cellIdentity:String = "cell"

fileprivate let sectionStr:[String] = ["账号安全设置","账号绑定"]

class myAccount: UITableViewController {

    
    private lazy var datas:[AccountBinds] = []
    private lazy var phoneNumber = "13718754627"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "账号设置"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ""
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionStr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of rows
         //return (datas[sectionStr[section]]?.count)!
        if section == 0 {
            return 2
        }
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentity)
        let item  = datas[indexPath.row]
        cell.textLabel?.textAlignment = .left
       
        
        
        if indexPath.section == 0{
            // 修改密码
            if indexPath.row == 1{
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "修改密码"
                cell.imageView?.image = UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "password")
            }else{
                // 修改手机号
                cell.textLabel?.text = "修改手机号"
                cell.detailTextLabel?.text = phoneNumber
                let label = UILabel.init(frame: CGRect.zero)
                label.textColor = UIColor.blue
                label.font = UIFont.systemFont(ofSize: 16)
                //这里加空格
                label.text = "  修改"
                label.textAlignment = .right
                label.sizeToFit()
                cell.accessoryView = label
                cell.imageView?.image = UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "iPhoneIcon")
            }
            
        }else{
             cell.imageView?.image = UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: item.imageName!)
            cell.textLabel?.text = item.apptype?.des
            if item.isBind!{
                cell.detailTextLabel?.text = "解除绑定"
                cell.detailTextLabel?.textColor = UIColor.blue
                
            }else{
                cell.accessoryType = .disclosureIndicator
            }
        }

         return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let changePhone = changePhoneVC()
                changePhone.currentPhoneLabel.text = phoneNumber
                self.navigationController?.pushViewController(changePhone, animated: true)
            }else{
                let ps  = changePassword()
                self.navigationController?.pushViewController(ps, animated: true)
            }
        }else{
            let item = datas[indexPath.row]
            self.operationApp(type: item.apptype!, bind: item.isBind!, row: indexPath.row)
        }
        
        
        
        
    }
    
    
    // section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = sectionStr[section]
        label.textColor = UIColor.lightGray
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,16)?.bottomEqualToView(v)?.topEqualToView(v)?.rightSpaceToView(v,10)
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    
}

extension myAccount{
    
    // 绑定或解绑app
    private func operationApp(type: appType, bind:Bool, row:Int ){
        
        switch type{
        case .qq:
            if bind{
                // 解绑
                self.datas[row].isBind = false
                self.tableView.reloadSections([1], animationStyle: .automatic)
                
            }else{
                // 绑定
                UMSocialManager.default().getUserInfo(with: .QQ, currentViewController: self) { (resp, error) in
                    if error != nil{
                        print("授权失败, 不能绑定")
                    }else{
                        if let response = resp as? UMSocialUserInfoResponse{
                            
                            // 得到uid 存入服务器
                            print("绑定成功")
                            // 刷新界面
                            self.datas[row].isBind = true
                            self.tableView.reloadSections([1], animationStyle: .automatic)
                        }
                    }
                }
            }
        case  .weixin:
            if bind{
                
                self.datas[row].isBind = false
                self.tableView.reloadSections([1], animationStyle: .automatic)
            }else{
                
                UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: self) { (resp, error) in
                    if error != nil{
                        print("授权失败\(error), 不能绑定")
                    }else{
                        if let response = resp as? UMSocialUserInfoResponse{
                            
                            // 得到uid 存入服务器 提示进度
                            print("绑定成功")
                            // 刷新界面
                            self.datas[row].isBind = true
                            self.tableView.reloadSections([1], animationStyle: .automatic)
                        }
                    }
                }
                
            }
        case .weibo:
            if bind{
                
                self.datas[row].isBind = false
                self.tableView.reloadSections([1], animationStyle: .automatic)
                
            }else{
                
            }
            
        default:
            break
        }
    }
}

extension myAccount{
    
    
    private func loadData(){
        
        // 获取手机号
        
        // 获取bindApps
        let bindApps:[AccountBinds] = [AccountBinds(JSON: ["imageName":"qq","type":"qq","isBind": false])!,
                                     AccountBinds(JSON: ["imageName":"sina","type":"weibo","isBind": true])!,
                                     AccountBinds(JSON: ["imageName":"wechat","type":"weixin","isBind": false])!]
        
        
        datas = bindApps
    }
    
    private func initView(){
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsMultipleSelection = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
    }
}
