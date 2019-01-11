//
//  greetingVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let sections:Int = 2
fileprivate let cellIdentity:String = "cell"
fileprivate let openGreeting:String = "启动打招呼用语"

class greetingVC: BaseTableViewController {

    private var data:greetingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
    }

    
    
    override func setViews() {
        self.title = "打招呼语"
        self.tableView.tableFooterView = UIView.init()
        self.tableView.allowsMultipleSelection = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        self.tableView.register(switchCell.self, forCellReuseIdentifier: switchCell.identity())
        
        
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.tableView.reloadData()
        
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    override func showError() {
        super.showError()
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
        //
        if let data = data{
            return  data.isOn ? data.des.count : 0
        }
        return 0
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: switchCell.identity(), for: indexPath) as! switchCell
            
            // tag 值默认（不使用）
            cell.mode = (on:data?.isOn ?? false, tag:1, name:openGreeting)
            //cell.switchOff.addTarget(self, action: #selector(switchBtn(sender:)), for: .valueChanged)
            cell.callChange = change
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.row == data?.currentIndex{
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.blue
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }else{
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .none
        }
        cell.textLabel?.text = data?.des[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            
            updateGreeting(){ bool in
                if bool == true{
                    self.data?.currentIndex = indexPath.row
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.accessoryType = .checkmark
                    cell?.textLabel?.textColor = UIColor.blue

                }
            }
           
            
            
        }
    
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            cell?.textLabel?.textColor = UIColor.black

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
            label.textColor = UIColor.lightGray
            label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
            view.addSubview(label)
            _ = label.sd_layout().leftSpaceToView(view,TableCellOffsetX)?.bottomSpaceToView(view,10)?.autoHeightRatio(0)
        }
        return view
    }
  
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        if data?.isOn ?? false{
            return 20
        }else{
            return 0
        }
    }
    
}


extension greetingVC{
    
    private func change(_ name: String, _ sender:UISwitch){
        IsGreeting = sender.isOn
        data?.isOn = sender.isOn
        // 服务器更新数据
        self.tableView.reloadSections([1], animationStyle: .none)
        
     }
    
    // 服务器更新数据 回调执行结果
    private func updateGreeting(complete:@escaping ((_ :Bool)->Void)){
        
        let msg = data!.des[data!.currentIndex]
        // 本地招呼用语
        GreetingMsg = msg
        
        self.view.showLoading(title: "加载数据", customImage: nil, mode: .customView)
        //let hub = showProgressHun(message: "加载数据", view: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //hub.hide(animated: true)
            self.view.hiddenLoading()
            complete(true)
            
            
        }
        
        
        
       
    }
}


// 异步获取数据
extension greetingVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
           
            
            Thread.sleep(forTimeInterval: 1)
            self?.data = greetingModel(JSON: ["isOn":true,"des":["默认第一条","第二条","第三条","第四条","第五条"],"currentIndex":0])
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
        
    }
}




