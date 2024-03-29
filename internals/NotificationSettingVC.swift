//
//  notificationVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let navTitle:String = "消息提醒"

fileprivate let sectionH:CGFloat = 40

class NotificationSettingVC: BaseTableViewController {

    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm: PersonViewModel = PersonViewModel.shared
    
    
    private lazy var items:[Int:[notifyMesModel]] = [0:[],1:[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
    }
    

    
    override func setViews(){
        self.title = navTitle
        self.tableView.tableFooterView = UIView.init()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(switchCell.self, forCellReuseIdentifier: switchCell.identity())
                
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
    
    deinit {
        print("deinit notificationSettingVC \(self)")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items[section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: switchCell.identity(), for: indexPath) as! switchCell
        // 映射到数字
        if let item = items[indexPath.section]?[indexPath.row]{
            
            cell.mode = (on:item.open ?? false, tag:indexPath.section * 10 + indexPath.row, name:item.kind.des)
            
            // 开启事件
            cell.switchOff.addTarget(self, action: #selector(onMsg(_:)), for: .valueChanged)
        }
      
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
            label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 20)
            v.addSubview(label)
            _ = label.sd_layout().leftSpaceToView(v,TableCellOffsetX)?.bottomSpaceToView(v,5)?.autoHeightRatio(0)
        default:
            break
        }
        
        return v
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? sectionH : 0
    }

}



extension NotificationSettingVC {
    
    // 获取数据
    private func loadData(){
        self.vm.notifySettings().asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            
            for (_, item) in modes.enumerated(){
                if item.kind == .night{
                    self?.items[1]?.append(item)
                }else{
                    self?.items[0]?.append(item)
                }
            }
            self?.didFinishloadData()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            // 异步网络请求
//            let res = [notifyMesModel(JSON: ["type":"subscribe","isOn":false]), notifyMesModel(JSON: ["type":"text","isOn":false]),notifyMesModel(JSON: ["type":"applyProgress","isOn":false]),notifyMesModel(JSON: ["type":"invitation","isOn":false]),notifyMesModel(JSON: ["type":"night","isOn":false])]
//
//                Thread.sleep(forTimeInterval: 3)
//                res.forEach{
//                    if  let mode = $0{
//                        if mode.kind ==  .night{
//                            self?.items[1]!.append(mode)
//                        }else{
//                            self?.items[0]!.append(mode)
//                        }
//                    }
//                }
//
//
//            DispatchQueue.main.async(execute: {
//                self?.didFinishloadData()
//            })
//
//        }
        
    }
}

extension NotificationSettingVC{
    // 得到某个item
    @objc func onMsg(_ sender: UISwitch){
        // 服务器更新状态
        let tag = sender.tag
        let section = tag / 10
        let row = tag % 10
        if let type = items[section]?[row].kind{
            
            self.vm.updateNotiySetting(type: type.rawValue, flag: sender.isOn).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    //self?.tableView.showToast(title: "", customImage: nil, mode: .text)
                }else{
                    self?.tableView.showToast(title: "跟新失败", customImage: nil, mode: .text)
                    sender.isOn = !sender.isOn
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        }
    }
}


