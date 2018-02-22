//
//  greetingVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD


fileprivate let sections:Int = 2
fileprivate let cellIdentity:String = "cell"
fileprivate let openGreeting:String = "启动打招呼用语"
class greetingVC: UITableViewController {

    
    // 网络加载数据
    private var datas:[String] = ["默认第一条","语句1", "语句2", "语句3", "语句4", "语句5", "语句6"]
    //private var isShow:Bool = true
    
    private var currentChooseRow:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        let currentMsg  = localData.shared.getGreetingMSG()!["msg"] as! String
        IsGreeting = (localData.shared.getGreetingMSG()!["isGreeting"] as? Bool) ?? true
        
        currentChooseRow =  datas.index(of: currentMsg) ?? 0 
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "打招呼语"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        if IsGreeting{
            return datas.count
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: switchCell.identity(), for: indexPath) as! switchCell
            cell.leftLabel.text = openGreeting
            cell.switchOff.isOn = IsGreeting
            cell.switchOff.addTarget(self, action: #selector(switchBtn(sender:)), for: .valueChanged)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        
        if indexPath.row == currentChooseRow{
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = datas[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
                currentChooseRow = indexPath.row
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = .checkmark
                updateGreeting()
            
            
            
        }
    
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
        }
    }
    
    
    // section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        if section == 1 {
            let label = UILabel.init(frame: CGRect.zero)
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .left
            label.text = "请选择打招呼语"
            label.sizeToFit()
            view.addSubview(label)
            _ = label.sd_layout().leftSpaceToView(view,10)?.rightSpaceToView(view,10)?.bottomSpaceToView(view,10)?.heightIs(20)
        }
        return view
    }
  
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        if IsGreeting{
            return 20
        }else{
            return 0
        }
    }
    
}

extension greetingVC{
   private func  initView(){
        self.tableView.tableFooterView = UIView.init()
        self.tableView.allowsMultipleSelection = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        self.tableView.register(switchCell.self, forCellReuseIdentifier: switchCell.identity())
    
    }
    
    
}

extension greetingVC{
    @objc func switchBtn(sender: UISwitch){
        IsGreeting = sender.isOn
        localData.shared.setOnGreeting(flag: IsGreeting)
        self.tableView.reloadSections([1], animationStyle: .none)
        
        //print(tableView.indexPathsForSelectedRows)
    }
    
    private func updateGreeting(){
        let msg = datas[currentChooseRow]
        let time = Float(Date().timeIntervalSince1970)
        GreetingMsg = msg
        let loading = Bundle.main.url(forResource: "loading", withExtension: "gif")
        SVProgressHUD.show( UIImage.animationImageWithData(data: NSData.init(contentsOf: loading!)), status: "加载")
        SVProgressHUD.dismiss(withDelay: 1, completion: nil)
        // 上传数据(数据同步问题？？ 本地一份，远端一份 比较时间)
        localData.shared.setGreetingNSG(msg: msg, timeInterval: time)
    }
}





