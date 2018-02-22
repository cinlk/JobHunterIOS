//
//  notificationVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



class notificationVC: UITableViewController {

    
    private lazy var items:[Int:[String]] = [0:["投递反馈","订阅职位","其他"], 1:["夜间免打扰"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "消息提醒"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (items[section]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: switchCell.identity(), for: indexPath) as! switchCell
        cell.switchOff.tag = indexPath.section * 10 + indexPath.row
        cell.leftLabel.text = items[indexPath.section]?[indexPath.row]
        cell.switchOff.addTarget(self, action: #selector(onMsg(_:)), for: .valueChanged)
        return cell
    }
    // head section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(r: 239, g: 239, b: 244)
        switch section {
        case 1:
            let label = UILabel.init(frame: CGRect.zero)
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .left
            label.textColor = UIColor.lightGray
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.text = "开启后打我打我的期望对群无多哇多无吊袜带挖多手机在22:00-8:00之间不会震动和发出提示声音"
            label.sizeToFit()
            v.addSubview(label)
            _ = label.sd_layout().leftSpaceToView(v,TableCellOffsetX)?.rightSpaceToView(v,5)?.bottomSpaceToView(v,5)?.topSpaceToView(v,5)
        default:
            break
        }
        
        return v
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 40
    }

}

extension notificationVC {
    private func initView(){
        self.tableView.tableFooterView = UIView.init()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(switchCell.self, forCellReuseIdentifier: switchCell.identity())
        
    }
}

extension notificationVC{
    @objc func onMsg(_ sender: UISwitch){
        let tag = sender.tag
        let section = tag / 10
        let row = tag % 10
        print( items[section]![row],sender.isOn)
    }
}
