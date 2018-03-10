//
//  PersonViewController.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let SectionN = 2
fileprivate let tableHeaderH:CGFloat = ScreenH / 3


class PersonViewController: UIViewController {

    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds)
        table.isScrollEnabled = false
        table.tableFooterView = UIView.init()
        table.delegate = self
        table.dataSource = self
         table.register(personTableCell.self, forCellReuseIdentifier: personTableCell.identity())
        return table
    }()
    
    
    private lazy var tableHeader: personTableHeader = {
        let v = personTableHeader.init(frame:CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        v.isHR = false
        return v
        
    }()
    
    private var mode:[(image:UIImage, title:String)] = [(#imageLiteral(resourceName: "namecard"),"我的名片"),(#imageLiteral(resourceName: "settings"),"通用设置"),(#imageLiteral(resourceName: "collection"),"我的收藏"),(#imageLiteral(resourceName: "private"),"隐私设置")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.table.contentInsetAdjustmentBehavior = .never
        self.navigationController?.navigationBar.isHidden = true
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = ""
    }
    
    override func viewWillLayoutSubviews() {
        self.view.addSubview(table)
        self.table.tableHeaderView = tableHeader
        tableHeader.avatarImg.image = UIImage.init(named: "chicken")
        tableHeader.nameTitle.text = "我的名字"
        
    }


}


extension PersonViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionN
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? 1 : self.mode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell =  table.dequeueReusableCell(withIdentifier: personTableCell.identity(), for: indexPath) as! personTableCell
            cell.mode = (image:#imageLiteral(resourceName: "personResume"),title:"我的简历")
            return cell
            
        case 1:
            let cell =  table.dequeueReusableCell(withIdentifier: personTableCell.identity(), for: indexPath) as! personTableCell
            cell.mode = self.mode[indexPath.row]
            return cell
        default:
            return UITableViewCell.init()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return personTableCell.cellHeight()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tabBarController?.tabBar.isHidden = true
        if indexPath.section == 0 {
            let resumeView = personResumeTable(style: .plain)
            self.navigationController?.pushViewController(resumeView, animated: true)
        }else{
            
            let row = indexPath.row
            switch row{
            case 0:
                // 我的名片
                let mycard = personCardVC()
                self.navigationController?.pushViewController(mycard, animated: true)
            case 1:
                // 通用设置
                let setting  = SettingVC()
                self.navigationController?.pushViewController(setting, animated: true)
            case 2:
                // 我的收藏
                let mycollection = MyCollectionVC()
                self.navigationController?.pushViewController(mycollection, animated: true)
            case 3:
                // 目前只是反馈界面
                //let myfeedBAck = feedBackVC()
                //self.navigationController?.pushViewController(myfeedBAck, animated: true)
                // 隐私设置
                let privicy = PrivacySetting()
                self.navigationController?.pushViewController(privicy, animated: true)
                
                break
            default:
                break
            }
        }
      
    }
    
}



