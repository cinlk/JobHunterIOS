//
//  invitationSettingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let sections:Int = 2
fileprivate let cellIdentity:String = "cell"
fileprivate let viewTitle:String = "邀请设置"
fileprivate let sectionItem:[String] = ["开启邀请后获得更多offer机会", "邀请通知方式"]

class invitationSettingViewController: BaseTableViewController {


    private var mode:InvitationModel?{
        didSet{
            guard let mode = mode else {return}
            items = mode.getItems()
        }
    }
    
    private lazy var items:[(InvitationModel.item, Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = viewTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        
    }
    
    
    override func setViews() {
        
        self.tableView.tableFooterView = UIView.init()
        self.tableView.allowsMultipleSelection = false
        self.tableView.isScrollEnabled = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.register(switchCell.self, forCellReuseIdentifier: switchCell.identity())
        //self.navigationItem.rightBarButtonItem
        
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
    
    
    // table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mode = self.mode else { return 0 }
        if section == 0 {
            return 1
        }
        // 第二个section
        if mode.permit  == true{
            return items.count - 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: switchCell.identity(), for: indexPath) as? switchCell{
            
            var item:(InvitationModel.item, Bool) = (.none, false)
            // 区分section
            if indexPath.section == 0 {
                item = items[indexPath.row]
            }else{
                item = items[indexPath.row + 1]
            }
            
            cell.mode = (on:item.1 ,tag: indexPath.row, name:item.0.describe)
            
            cell.callChange = change
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  45
    }
    
    
    //section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel.init(frame: CGRect.zero)
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.lightGray
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        title.text = sectionItem[section]
        
        view.addSubview(title)
        _ = title.sd_layout().centerYEqualToView(view)?.leftSpaceToView(view,10)?.autoHeightRatio(0)
        
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


extension invitationSettingViewController{
    
    @objc private func change( name:String,sender:UISwitch){
        guard  let mode = mode  else {
            return
        }
        print(name, sender.isOn)
        mode.changeValue(name:name, value: sender.isOn)
        items = mode.getItems()
        
        self.tableView.reloadSections([1], animationStyle: .none)
    }
}


extension invitationSettingViewController{
    private func loadData(){
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            
            Thread.sleep(forTimeInterval: 3)
            self?.mode = InvitationModel(JSON: ["permit":false, "openEmail":true,"openSms":false])
            //self?.data = greetingModel(JSON: ["isOn":true,"des":["默认第一条","第二条","第三条","第四条","第五条"],"currentIndex":0])
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}
