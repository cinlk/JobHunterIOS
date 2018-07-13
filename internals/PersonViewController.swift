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
        
        //table.register(personTableCell.self, forCellReuseIdentifier: personTableCell.identity())
        return table
    }()
    
    
    private lazy var tableHeader: personTableHeader = {
        let v = personTableHeader.init(frame:CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        v.isHR = false
        v.backgroundColor = UIColor.orange
        // test 用个人信息
        v.mode = (image:"chicken",name:"名字", introduce:"")
        v.layoutSubviews()
        return v
        
    }()
    
    private var mode:[(image:UIImage, title:String)] = [(#imageLiteral(resourceName: "namecard"),"我的订阅"),(#imageLiteral(resourceName: "settings"),"帮助中心"),(#imageLiteral(resourceName: "collection"),"设置"),(#imageLiteral(resourceName: "private"),"隐私设置")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        (self.navigationController as! PersonNavViewController).currentStatusStyle = .lightContent
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        
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


        
    }
    
  
    
    
    
    override func viewWillLayoutSubviews() {
        self.view.addSubview(table)
        self.table.tableHeaderView = tableHeader
        
    }


}


extension PersonViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionN
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return section == 0 || section == 1 ? 1 : self.mode.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier:SetFourItemTableViewCell.identity() , for: indexPath) as! SetFourItemTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell.imageView?.image = #imageLiteral(resourceName: "feedback").changesize(size: CGSize.init(width: 40, height: 40))
            cell.textLabel?.text = "我的简历"
            return cell
            
        case 2:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell.imageView?.image = self.mode[indexPath.row].image.changesize(size: CGSize.init(width: 40, height: 40))
            cell.textLabel?.text = self.mode[indexPath.row].title
            
          
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
        return indexPath.section == 0 ? SetFourItemTableViewCell.cellHeight() : 50
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            return
        case 1:
            let resumeView = ResumePageViewController()
            resumeView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resumeView, animated: true)
        case 2:
            
            
            let row = indexPath.row
            switch row{
            case 0:
                // 我的订阅
                let subscrible = subscribleItem()
                subscrible.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(subscrible, animated: true)
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

