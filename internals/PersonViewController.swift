//
//  PersonViewController.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



fileprivate let tableHeaderH:CGFloat = GlobalConfig.ScreenH / 4


class PersonViewController: UIViewController {

    
    private lazy var dispose: DisposeBag = DisposeBag.init()
    
    private var table:personTable = {
        let t = personTable.init()
        t.register(SetFourItemTableViewCell.self, forCellReuseIdentifier: SetFourItemTableViewCell.identity())
        return t
    }()
    private lazy var headerView: PersonTableHeader = {
        let h = PersonTableHeader.init(frame:CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableHeaderH))
        h.isHR = false
        h.backgroundColor = UIColor.orange
        h.mode = (GlobalUserInfo.shared.getIcon(), GlobalUserInfo.shared.getName() ?? "", "")
        h.touch = { [weak self ] in
            
            if let  mode =  PersonInTroduceInfo.init(JSON: [
                "icon_url":GlobalUserInfo.shared.getIcon()?.absoluteString,
                "name": GlobalUserInfo.shared.getName(),
                "gender":"男",
                "colleage":"大学"]){
                let vc = PersonIntroduceViewController.init(style: .plain, mode: mode )
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return h
    }()
    
    
    //private var mode:[(image:UIImage, title:String)]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.removeCustomerView()

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.insertCustomerView(UIColor.orange)
    }
    
    
    override func viewWillLayoutSubviews() {
        self.view.addSubview(table)
        _ = self.table.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }

    
    deinit {
        print("deinit personViewController \(self)")
    }
 
}


extension PersonViewController{
    private func setView(){
        
        self.table.contentInsetAdjustmentBehavior = .never
        //self.view.backgroundColor = UIColor.backGroundColor()
        (self.navigationController as! PersonNavViewController).currentStatusStyle = .lightContent
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        headerView.layoutSubviews()
        self.table.tableHeaderView = headerView
        // 布局完后设置背景颜色才有效？
        self.table.backgroundColor = UIColor.backGroundColor()
        self.navigationController?.delegate = self
        
    }
}


extension PersonViewController:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: OnlineApplyShowViewController.self){
            self.navigationController?.removeCustomerView()
        }
    }
}
extension PersonViewController{
    
    private func setViewModel(){
        
        NotificationCenter.default.rx.notification(NotificationName.personMainItem, object: nil).subscribe(onNext: { [weak self] (notify) in
            
            if let info = notify.userInfo as? [String:Any], let action = info["action"] as? String{
                if action == "push", let vc = info["target"] as? UIViewController{
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
       
    }
    
    
}



fileprivate class personTable: UITableView{
    
    
    private lazy var  mode:[(UIImage,String, UIViewController)] = {
        
        
      return  [(#imageLiteral(resourceName: "namecard"),"我的订阅", subscribleItem()),(#imageLiteral(resourceName: "settings"),"帮助中心", HelpsVC()),
         (#imageLiteral(resourceName: "collection"),"设置", SettingVC()),(#imageLiteral(resourceName: "private"),"隐私设置", PrivacySetting())]
    }()
    
    private lazy var topMode:[(UIImage, String, UIViewController)] = {
        let post = MyPostViewController()
        post.type = .mypost
        
       return [(#imageLiteral(resourceName: "delivery"), "投递记录", DeliveredHistory()), (#imageLiteral(resourceName: "delivery"), "我的简历", ResumePageViewController()), (#imageLiteral(resourceName: "delivery"), "我的收藏", MyCollectionVC()), (#imageLiteral(resourceName: "delivery"), "我的帖子", post)]
        
    }()
    
    private let section = 2
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView.init()
 
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    

    
}




extension personTable: UITableViewDelegate, UITableViewDataSource{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 禁止滚动
        scrollView.contentOffset.y = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0  ? 1 : self.mode.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier:SetFourItemTableViewCell.identity() , for: indexPath) as! SetFourItemTableViewCell
          
            cell.mode = topMode
            cell.navToVc = { [weak self] vc in
                NotificationCenter.default.post(name: NotificationName.personMainItem, object: self, userInfo: ["target": vc,"action":"push"])
            }
            
            //cell.delegate = self
            return cell
//        case 1:
//            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
//            cell.imageView?.image = #imageLiteral(resourceName: "feedback").changesize(size: CGSize.init(width: 40, height: 40))
//            cell.textLabel?.text = "我的简历"
//            return cell
            
        case 1:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell.imageView?.image = self.mode[indexPath.row].0.changesize(size: CGSize.init(width: 40, height: 40))
            cell.textLabel?.text = self.mode[indexPath.row].1
            
            
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
//        case 1:
//
//            NotificationCenter.default.post(name: NotificationName.personMainItem, object: self, userInfo: ["target":ResumePageViewController(),"action":"push"])
//
        case 1:
            
            
            let row = indexPath.row
            
            NotificationCenter.default.post(name: NotificationName.personMainItem, object: self, userInfo: ["target":self.mode[row].2,"action":"push"])
            
            
        default:
            return
        }
        
        
    }
    
}




