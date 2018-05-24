//
//  PersonViewController.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let SectionN = 3
fileprivate let tableHeaderH:CGFloat = ScreenH / 4


class PersonViewController: UIViewController {

    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds)
        table.isScrollEnabled = false
        table.tableFooterView = UIView.init()
        table.backgroundColor = UIColor.viewBackColor()
        table.delegate = self
        table.dataSource = self
        table.register(SetFourItemTableViewCell.self, forCellReuseIdentifier: SetFourItemTableViewCell.identity())
        
        table.register(personTableCell.self, forCellReuseIdentifier: personTableCell.identity())
        return table
    }()
    
    
    private lazy var tableHeader: personTableHeader = {
        let v = personTableHeader.init(frame:CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        v.isHR = false
        // test 用个人信息
        v.mode = (image:"chicken",name:"名字", introduce:"")
        v.layoutSubviews()
        return v
        
    }()
    
    private var mode:[(image:UIImage, title:String)] = [(#imageLiteral(resourceName: "namecard"),"我的订阅"),(#imageLiteral(resourceName: "settings"),"帮助中心"),(#imageLiteral(resourceName: "collection"),"设置"),(#imageLiteral(resourceName: "private"),"隐私设置")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.table.contentInsetAdjustmentBehavior = .never
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.removeCustomerView()

    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        //self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.insertCustomerView()

        
    }
    
    override func viewWillLayoutSubviews() {
        self.view.addSubview(table)
        self.table.tableHeaderView = tableHeader
        //tableHeader.avatarImg.image = UIImage.init(named: "chicken")
        //tableHeader.nameTitle.text = "我的名字"
        
    }


}


extension PersonViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionN
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }
        return self.mode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier:SetFourItemTableViewCell.identity() , for: indexPath) as! SetFourItemTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: personTableCell.identity(), for: indexPath) as! personTableCell
            cell.mode = (image:#imageLiteral(resourceName: "personResume"),title:"我的简历")
            return cell
            
        case 2:
            let cell =  tableView.dequeueReusableCell(withIdentifier: personTableCell.identity(), for: indexPath) as! personTableCell
            cell.mode = self.mode[indexPath.row]
            return cell
        default:
            return UITableViewCell.init()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return  section == 0 ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? SetFourItemTableViewCell.cellHeight() : personTableCell.cellHeight()
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            return
        case 1:
            let resumeView = personResumeTable()
            resumeView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resumeView, animated: true)
        case 2:
            
            
            let row = indexPath.row
            switch row{
            case 0:
                // 我的订阅
                let subscrible = subconditions()
                self.present(subscrible, animated: true, completion: nil)
            case 1:
                // 帮助中心
                let help  = HelpsVC()
                help.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(help, animated: true)
            case 2:
                // 设置
                let setting = SettingVC()
                setting.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(setting, animated: true)
            case 3:
                // 隐私设置
                let privicy = PrivacySetting()
                privicy.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(privicy, animated: true)
                
                break
            default:
                break
            }
            
            
        default:
            return
        }
        
      
    }
    
}


// 代理实现
extension PersonViewController:selectedItemDelegate{
    
    func showdelivery() {
        let vc = deliveredHistory()
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showInvitation() {
        let vc = InvitationViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showollections() {
        let vc = MyCollectionVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPostArticle() {
        let vc =  MyPostViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.type = .mypost
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

