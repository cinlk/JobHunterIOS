//
//  myAccount.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let cellIdentity:String = "cell"


class myAccount: BaseTableViewController {

    
    private lazy var datas:[AccountBinds] = []

    // 1 存在手机号   2 不存在手机号 显示绑定
    private var IsModifyPhone:Bool{
        get{
            if phoneNumber.isEmpty{
                return false
            }
            return true
        }
    }
    
    // 默认值
    private var sectionStr:[String] = ["账号安全设置","账号绑定"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()

    }
    

    
  
    // MARK: - Table view data source

    
    
    override func setViews(){
        self.title = "账号设置"
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsMultipleSelection = false
        super.setViews()
        
    }
    
    override func didFinishloadData(){
        
        super.didFinishloadData()
        
        self.tableView.reloadData()
        
    }
    
    override func showError(){
       super.showError()
    }
    
    override func reload(){
        
        super.reload()
        self.loadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return sectionStr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  section == 0 ? 2 : datas.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentity)
    
        cell.textLabel?.textAlignment = .left
       
        
        
        if indexPath.section == 0{
            // 修改密码
            if indexPath.row == 1{
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "修改密码"
                cell.imageView?.image =   UIImage.init(named: "password")!.changesize(size: CGSize.init(width: 30, height: 30))
                
            }else{
                // 修改手机号
                cell.textLabel?.text = "手机号码"
                let label = UILabel.init(frame: CGRect.zero)
                label.textColor = UIColor.blue
                label.font = UIFont.systemFont(ofSize: 16)
                //这里加空格
                label.text = IsModifyPhone ?  "  修改" : "  绑定"
                label.textAlignment = .right
                label.sizeToFit()
                cell.accessoryView = label
                cell.imageView?.image =    UIImage.init(named: "iPhoneIcon")!.changesize(size: CGSize.init(width: 30, height: 30))
            }
            
        }else{
            let item = datas[indexPath.row]
            
            // 处理图片默认值
            cell.imageView?.image = UIImage.init(named: item.imageName!)!.changesize(size: CGSize.init(width: 30, height: 30))
            
            if item.isBind!{
                cell.detailTextLabel?.text = "解除绑定"
                cell.detailTextLabel?.textColor = UIColor.blue
                cell.textLabel?.text = item.kind.des

            }else{
                cell.textLabel?.text = "绑定" + item.kind.des

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
               
                self.navigationController?.pushViewController(changePhone, animated: true)
            }else{
                let ps  = changePassword()
                self.navigationController?.pushViewController(ps, animated: true)
            }
        }else{
            let item = datas[indexPath.row]
            self.operationApp(type: item.kind, bind: item.isBind!, row: indexPath.row)
        }
        
        
        
        
    }
    
    
    // section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        v.clipsToBounds = false
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = sectionStr[section]
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,16)?.bottomSpaceToView(v,5)?.autoHeightRatio(0)
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return  section == 0 ? 25 : 10
    }
    
    
}



extension myAccount{
    
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            self?.datas = [AccountBinds(JSON: ["imageName":"qq","type":"qq","isBind": false])!,
                                           AccountBinds(JSON: ["imageName":"sina","type":"weibo","isBind": true])!,
                                           AccountBinds(JSON: ["imageName":"wechat","type":"weixin","isBind": false])!]
            
            
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
                // 出错
                
            })
            
        }
        
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
                // 绑定， 先判断手机是否安装 微信
                UMSocialManager.default().getUserInfo(with: .QQ, currentViewController: self) { (resp, error) in
                    if error != nil{
                        print("授权失败, 不能绑定")
                    }else{
                        if (resp as? UMSocialUserInfoResponse) != nil{
                            
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
                        print("授权失败\(String(describing: error)), 不能绑定")
                    }else{
                        if (resp as? UMSocialUserInfoResponse) != nil{
                            
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

