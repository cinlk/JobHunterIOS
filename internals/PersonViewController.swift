//
//  PersonViewController.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let SectionN = 3
fileprivate let tableHeaderH:CGFloat = GlobalConfig.ScreenH / 4
fileprivate let delegateNotify = NSNotification.Name.init("tableDelegateImplement")


class PersonViewController: UIViewController {

  
    private  var table:personTable!
    private var mode:[(image:UIImage, title:String)]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        (self.navigationController as! PersonNavViewController).currentStatusStyle = .lightContent
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        loadData()
        bindNotify()
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
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension PersonViewController{
    private func bindNotify(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotify), name: delegateNotify, object: nil)
    }
    
    @objc private func handleNotify(_ sender: Notification){
        if let info = sender.userInfo as? [String:Any], let action = info["action"] as? String{
            if action == "push", let vc = info["target"] as? UIViewController{
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension PersonViewController{
    private func loadData(){
        mode = [(#imageLiteral(resourceName: "namecard"),"我的订阅"),(#imageLiteral(resourceName: "settings"),"帮助中心"),(#imageLiteral(resourceName: "collection"),"设置"),(#imageLiteral(resourceName: "private"),"隐私设置")]
        
        //  构建table 或 view
        table =  personTable.init(frame: self.view.bounds, style: .plain)
        table.setHeaderView(data:  (image:"chicken",name:"名字", introduce:""))
        table.mode = mode
        
    }
}



fileprivate class personTable:BaseTableView<[(image:UIImage, title:String)]>{
    
    override internal var mode:[(image:UIImage, title:String)]!{
        didSet{
            setDelegate()
            self.reloadData()
        }
    }
    
    private  var implement:tableDelegateImplement?
    

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.register(SetFourItemTableViewCell.self, forCellReuseIdentifier: SetFourItemTableViewCell.identity())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func setHeaderView(data:Any?) {
        
        if let data = data as? (image:String,name:String, introduce:String){
            let head  = personTableHeader.init(frame:CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableHeaderH))
            head.isHR = false
            head.backgroundColor = UIColor.orange
            // test 用个人信息
            head.mode = data
            head.layoutSubviews()
            self.tableHeaderView = head
        }
    }
    
    override internal func setDelegate(){
        
        implement = tableDelegateImplement(mode: mode,section: SectionN)
        self.dataSource = implement
        self.delegate = implement
    }
    
}



fileprivate class tableDelegateImplement: NSObject{
    
    private var mode:[(image:UIImage, title:String)]!
    private var section:Int!
    
    init(mode: [(image:UIImage, title:String)], section:Int) {
        self.mode = mode
        self.section = section
        super.init()
       
    }
}

extension tableDelegateImplement:UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section
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
          
            NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":ResumePageViewController(),"action":"push"])
            
        case 2:
            
            
            let row = indexPath.row
            switch row{
            case 0:
                // 我的订阅
               
                 NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":subscribleItem(),"action":"push"])
            case 1:
                // 帮助中心
                NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":HelpsVC(),"action":"push"])
            case 2:
                // 设置
              
                
                NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":SettingVC(),"action":"push"])
            case 3:
                // 隐私设置
                
                NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":PrivacySetting(),"action":"push"])
                break
            default:
                break
            }
            
            
        default:
            return
        }
        
        
    }
    
}


extension tableDelegateImplement:selectedItemDelegate{
    
    
    func showdelivery() {
       
        NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":deliveredHistory(),"action":"push"])
    }
    
    func showInvitation() {
 
        
        NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":InvitationViewController(),"action":"push"])
    }
    
    func showollections() {
 
        NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":MyCollectionVC(),"action":"push"])
    }
    
    func showPostArticle() {
        let vc =  MyPostViewController()
        vc.type = .mypost
        NotificationCenter.default.post(name: delegateNotify, object: self, userInfo: ["target":vc,"action":"push"])
    }
    
    
}


