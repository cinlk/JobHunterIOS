//
//  myAccount.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD


fileprivate let cellIdentity:String = "cell"

fileprivate let sectionStr:[String] = ["账号安全设置","账号绑定"]

class myAccount: UITableViewController {

    
    private lazy var datas:[String:[AccountBase]] = [:]
    
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
         return (datas[sectionStr[section]]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentity)
        let item  = datas[sectionStr[indexPath.section]]![indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.imageView?.image = UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: item.imageName!)
        cell.textLabel?.text = item.name
        
        if indexPath.section == 0{
            let sec =   (item as! AccountSecurity)
            if (sec.extra?.isEmpty)!{
                cell.accessoryType = .disclosureIndicator
            }else{
            
                cell.detailTextLabel?.text = sec.extra!
                let label = UILabel.init(frame: CGRect.zero)
                label.textColor = UIColor.blue
                label.font = UIFont.systemFont(ofSize: 16)
                //这里加空格
                label.text = "  修改"
                label.textAlignment = .right
                label.sizeToFit()
                cell.accessoryView = label
            }
            
        }else{
            let bind = (item as! AccountBinds)
            if bind.isBind!{
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
        if  let name =  datas[sectionStr[indexPath.section]]?[indexPath.row].name{
            switch name{
            case "手机号":
                let changePhone = changePhoneVC()
                changePhone.currentPhoneLabel.text = "13718754627"
                self.navigationController?.pushViewController(changePhone, animated: true)
            case "修改密码":
                let ps  = changePassword()
                self.navigationController?.pushViewController(ps, animated: true)
            // MARK TODO 微信，微博，qq 第三方接入 绑定
            default:
                break
            }
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
    
    
    private func loadData(){
        
        let phone =  AccountSecurity(JSON: ["imageName":"iPhoneIcon","name":"手机号","extra":"13718754627"])
        let secutiy = AccountSecurity(JSON: ["imageName":"private","name":"修改密码","extra":""])
        let first:[AccountSecurity]  = [phone!, secutiy!]
        datas["账号安全设置"] = first
        let second:[AccountBinds] = [AccountBinds(JSON: ["imageName":"qq","name":"绑定QQ账号","isBind": false])!,
                                     AccountBinds(JSON: ["imageName":"sina","name":"绑定微博账号","isBind": true])!,
                                     AccountBinds(JSON: ["imageName":"wechat","name":"绑定微信账号","isBind": false])!]
        
        
        datas["账号绑定"] = second
    }
    
    private func initView(){
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsMultipleSelection = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
    }
}
