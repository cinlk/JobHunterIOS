//
//  ResumePageViewController.swift
//  internals
//
//  Created by ke.liang on 2018/7/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let maxCount = 5


class ResumePageViewController: BaseTableViewController {

    // 默认投递只有一个
    private  var defaultResumeRow:Int?
    // 当前行
    private  var selectedrow:Int?
    private lazy var myResumes:[reumseKind] = []
    

    // 控制 编辑内容
    private lazy var isEdit:Bool = false
    
    
    
    
    // 在线简历显示的操作
    private lazy var alertOnlineVC:UIAlertController = {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaults = UIAlertAction.init(title: "设置为默认", style: UIAlertActionStyle.default, handler: { action in
                self.setDefaultItem()
        })
        let rename = UIAlertAction.init(title: "重命名", style: UIAlertActionStyle.default, handler: { action in
                self.renameItem()
            
        })
        let copy = UIAlertAction.init(title: "复制", style: UIAlertActionStyle.default, handler: { action in
                self.copyItem()
        })
        
        let delete = UIAlertAction.init(title: "删除", style: UIAlertActionStyle.destructive, handler: { action in
                self.deleteItem()
        })
       
        let cancel =  UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(defaults)
        alert.addAction(rename)
        alert.addAction(copy)
        alert.addAction(delete)
        alert.addAction(cancel)
        return alert
    }()
    
    // 附件简历显示的操作
    private lazy var alertAttachVC:UIAlertController = {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaults = UIAlertAction.init(title: "设置为默认", style: UIAlertActionStyle.default, handler: { action in
            self.setDefaultItem()
        })
        let rename = UIAlertAction.init(title: "重命名", style: UIAlertActionStyle.default, handler: { action in
            self.renameItem()
            
        })
        
        let delete = UIAlertAction.init(title: "删除", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteItem()
        })
        
        let cancel =  UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(defaults)
        alert.addAction(rename)
        alert.addAction(delete)
        alert.addAction(cancel)
        return alert
    }()
    
    
    private lazy var menu:SearchTypeMenuView = {
        let m = SearchTypeMenuView.init(frame: CGRect.init(x: ScreenW - 100 , y: NavH, width: 120, height: 70),arrowLeftMargin: 65)
        m.delegate = self
        m.table.layer.cornerRadius = 0
        m.datas = [.online, .attachment]
        return m
        
    }()
    
    // 背景btn
    private lazy var backgroundBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        btn.addTarget(self, action: #selector(hiddenPopMenu), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
     }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func setViews() {
    
        self.title = "我的简历"
        
        
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.register(ResumePageCell.self, forCellReuseIdentifier: ResumePageCell.identity())
        
        self.navigationController?.delegate = self
        
        
       
        _ = menu.sd_layout().topSpaceToView(self.view,NavH)?.rightSpaceToView(self.view,10)?.widthIs(100)?.heightIs(60)
        
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 20, height: 20)), style: .plain, target: self, action: #selector(addMore))
        
        
        self.tableView.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    
    // 如果需要拦截系统返回按钮就重写该方法返回 false
    override func currentViewControllerShouldPop() -> Bool {
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "简历名称尚未保存，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { (_) in
                //self.view.endEditing(true)
                self.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        
        }
        
        return true
        
    }

}




extension ResumePageViewController: SearchMenuDelegate{
    func selectedItem(item: searchItem){
       
        self.hiddenPopMenu()
        
        // 添加在线简历
        if item == .online{
            if self.myResumes.count >= maxCount{
                showOnlyTextHub(message: "最多添加\(maxCount)个在线简历", view: self.tableView)
                return
            }
            
            if let resume = reumseKind(JSON: ["name":"我的简历","isDefault":false,"id":getUUID(),
                            "create_time":Date().timeIntervalSince1970,"kind":item.rawValue]){
                
                self.myResumes.append(resume)
                self.tableView.reloadSections([0], animationStyle: .automatic)
                
            }
            
        }else{
            // 添加附件简历
            // 给出提示
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let fromPC = UIAlertAction.init(title: "从电脑上传", style: .default) { action in
                
            }
            let fromPhone = UIAlertAction.init(title: "从手机上传", style: .default) { action in
                
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(fromPC)
            alert.addAction(fromPhone)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        }
       
    }
}


extension ResumePageViewController: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController.isKind(of: PersonViewController.self){
            navigationController.removeCustomerView()
        }
    }
}


extension ResumePageViewController{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return myResumes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ResumePageCell.identity(), for: indexPath) as! ResumePageCell
        cell.textTitle.delegate = self
        
        let mode = myResumes[indexPath.row]
        if mode.isDefault == true{
            defaultResumeRow =  indexPath.row
        }
        cell.mode = mode
        cell.setting = {
            
            if !self.isEdit{
                self.selectedrow = indexPath.row
                if mode.type == .online{
                    self.present(self.alertOnlineVC, animated: true, completion: nil)
                }else {
                    self.present(self.alertAttachVC, animated: true, completion: nil)

                }
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEdit{
            return
        }
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = myResumes[indexPath.row]
        if mode.type == .online{
            let vc = personResumeTable()
            vc.resumeID = mode.id
        
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
            let vc = ShowPDFResumeVC()
            vc.url = "http://127.0.0.1:9090/test.pdf"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = myResumes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumePageCell.self, contentViewWidth: ScreenW)
    }
}


extension  ResumePageViewController{
    
    private func setDefaultItem(){
        if let row = self.selectedrow, row != self.defaultResumeRow{
            
            myResumes[row].isDefault = true
            // 默认的index 改变
            if let df = self.defaultResumeRow{
                 myResumes[df].isDefault = false
            }
            self.defaultResumeRow = row
            self.tableView.reloadSections([0], animationStyle: .automatic)
        }
    }
    
    // 编辑简历 名字
    private func renameItem(){
        if let row = self.selectedrow{
            let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as! ResumePageCell
            cell.startEdit = true
            self.isEdit = true
        }
    }
    
    
    // 只对在线简历拷贝
    private func copyItem(){
        
        if let row = self.selectedrow{
            
            if myResumes.count >= maxCount{
                showOnlyTextHub(message: "最多添加\(maxCount)个简历", view: self.tableView)
                return
            }
            // 拷贝字典
            let target =  myResumes[row]
            
            guard target.type == .online else {
                return
            }
            
            // 服务器数据复制一份 MARK ！！
            
            if let data = reumseKind(JSON: ["name":target.name! + "副本","isDefault":false,"id":getUUID(),
                                            "create_time":Date().timeIntervalSince1970,"kind":target.type.rawValue]){
                
                myResumes.append(data)
                self.tableView.reloadSections([0], animationStyle: .automatic)
                
            }
           
            
        }
        
    }
    
    private func deleteItem(){
        
        // 提示告警
        let alert = UIAlertController(title: nil, message: "删除后无法恢复，确认删除?", preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: "确定", style: .default) { action in
            
            if let row = self.selectedrow{
                
                self.myResumes.remove(at: row)
                // 服务器删除
                // 重置默认简历row
                if row == self.defaultResumeRow{
                    self.defaultResumeRow = nil
                }
                self.tableView.reloadSections([0], animationStyle: .automatic)
            }
            
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
        
        
       
    }
    
}


// 编辑textfield
extension ResumePageViewController: UITextFieldDelegate{
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 结束编辑(失去焦点结束会调用)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 键盘输入结束会调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,  text.isEmpty{
            return false
        }
        let text = textField.text?.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        if (text?.isEmpty)!{
            return false
        }
        
        updateName(textField.text!)
        textField.isUserInteractionEnabled = false
        self.isEdit = false
        return true
    }
    
    private func updateName(_ text: String){
        // 更新d简历名称
        if let row = self.selectedrow{
            myResumes[row].name = text
            self.tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
        }
        
    }
    
}

extension ResumePageViewController{
    @objc private func addMore(){
        if self.isEdit{
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.navigationController?.view.addSubview(self.backgroundBtn)
        }, completion: { bool in
            self.menu.show()
            
        })
        
    }
    
    @objc private func hiddenPopMenu(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menu.dismiss()
            
        }) { bool in
            self.backgroundBtn.removeFromSuperview()
            
        }
    }
}

extension ResumePageViewController{
    private func loadData(){
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 1)
            
            
            //  MARK ！附件简历 显示pdf 没有固定格式数据
            for _ in 0..<2{
                if let data = reumseKind(JSON: ["name":"我的简历","isDefault":false,"id":getUUID(),
                                                "create_time":Date().timeIntervalSince1970,"kind":"attachment"]){
                    self?.myResumes.append(data)

                }
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
            
        }
    }
}
