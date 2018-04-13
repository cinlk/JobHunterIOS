//
//  subscribleItem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let campus = "campus"
fileprivate let intern = "intern"
fileprivate let section = 2
fileprivate let  ImageSize = CGSize.init(width: 25, height: 25)

class subscribleItem: BaseTableViewController {

    
    // 数据保持在本地(校招,实习) 还是服务器？
    private lazy var internData:[subscribeConditionModel]  = []
    private lazy var compuseData:[subscribeConditionModel] = []
    
    private lazy var addBtnImage = UIImage.barImage(size: ImageSize, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "plus")

    private lazy var addBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30 , height: 30))
        btn.setImage(self.addBtnImage, for: .normal)
        btn.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "我的订阅"
        self.navigationController?.insertCustomerView()
        //self.loadData()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
        self.navigationItem.title = ""
       
    }
    
    override func setViews(){
        //self.navigationController?.view.backgroundColor = UIColor.white
        
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableHeaderView = UIView.init()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(subjobitemCell.self, forCellReuseIdentifier: subjobitemCell.identity())
        // sectionCell
        self.tableView.register(sectionCellView.self, forCellReuseIdentifier: sectionCellView.identity())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addBtn)
        
        self.handleViews.append(tableView)
        self.handleViews.append(addBtn)
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
 
}


extension subscribleItem{
    
    
    // 加载数据
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            
            
            self?.internData.removeAll()
            self?.compuseData.removeAll()
            Thread.sleep(forTimeInterval: 3)
            
            
            self?.internData.append(subscribeConditionModel(JSON: ["type":"实习","des":["后台开发","IOS研发"],"locate":"成都","internSalary":"200/天","business":"计算机","internDay":"4天/周","internMonth":"半年", "degree":"大专"])!)
            
            self?.compuseData.append(subscribeConditionModel(JSON: ["type":"校招","des":["产品经理","产品设计"],"locate":"北京","salary":"10-12K/月","business":"人工智能","degree":"本科"])!)
            self?.compuseData.append(subscribeConditionModel(JSON: ["type":"校招","des":["运维","推广"],
                                                              "locate":"北京","salary":"20-30K/月","business":"学前教育", "degree":"硕士"])!)
            DispatchQueue.main.async {
                self?.didFinishloadData()
                
            }
        }
        
        
       
        
    }
    
    
    @objc func addItem(){
        let condition:subconditions = subconditions()
        condition.delegate = self
        self.present(condition, animated: true, completion: nil)
        
    }
}


// table
extension subscribleItem{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            return  compuseData.count > 0 ?  1 + compuseData.count : 0
        }else{
            return  internData.count > 0 ?  1 + internData.count : 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            switch indexPath.section{
            case 0:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellView.identity(), for: indexPath) as! sectionCellView
                    cell.mode = "校招"
                    return cell
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: subjobitemCell.identity(), for: indexPath) as! subjobitemCell
                
                let data = compuseData[indexPath.row - 1]
                cell.mode = data
                return cell
                
            case 1:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellView.identity(), for: indexPath) as! sectionCellView
                    cell.mode = "实习"
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: subjobitemCell.identity(), for: indexPath) as! subjobitemCell
                let data = internData[indexPath.row - 1]
                cell.mode = data
                return cell
            default:
                break
            }
            
        return UITableViewCell()
        
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let mode = "校招"
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: sectionCellView.self, contentViewWidth: ScreenW)
            }
            let mode = compuseData[indexPath.row - 1]
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: subjobitemCell.self, contentViewWidth: ScreenW)
        }else{
            
            if indexPath.row == 0 {
                let mode = "实习"
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: sectionCellView.self, contentViewWidth: ScreenW)
            }
            
            let mode = internData[indexPath.row - 1]
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: subjobitemCell.self, contentViewWidth: ScreenW)
        }
       
        
    }
    
 
    // edit cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 {
            return true
        }
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    
    // 自定义cell 编辑方法
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        
        let edit = UITableViewRowAction(style: .normal, title: "edit") { action, index in
            
            let editView:subconditions = subconditions.init(row: indexPath.row - 1)
            editView.delegate = self
            self.present(editView, animated: true, completion: nil)
            
            if indexPath.section  == 0 {
                let data = self.compuseData[indexPath.row - 1]
                editView.editData = data
             
            }else{
                let data = self.internData[indexPath.row - 1]
                editView.editData = data
                
            }
            
        }
        
        edit.backgroundColor = UIColor.orange
        
        let delete = UITableViewRowAction(style: .normal, title: "delete") { action, index in

            
            if indexPath.section == 0{
                self.compuseData.remove(at: indexPath.row - 1)
                //tableView.reloadSections([0], animationStyle: UITableViewRowAnimation.automatic)
            }else{
                self.internData.remove(at: indexPath.row - 1)
                //tableView.reloadSections([0], animationStyle: UITableViewRowAnimation.automatic)
            }
            
            tableView.reloadData()
            //tableView.deleteRows(at: [IndexPath.init(row: indexPath.row - 1, section: indexPath.section)], with: UITableViewRowAnimation.fade)
            
        }
        
        delete.backgroundColor = UIColor.blue
        
        return [edit,delete]
    }
    
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "delete", handler: { (action, view, completion) in
            //TODO: Delete
            if indexPath.section == 0{
                self.compuseData.remove(at: indexPath.row - 1)
                //tableView.reloadSections([0], animationStyle: UITableViewRowAnimation.automatic)
            }else{
                self.internData.remove(at: indexPath.row - 1)
                //tableView.reloadSections([1], animationStyle: UITableViewRowAnimation.automatic)
            }
            tableView.reloadData()
            completion(true)
        })
        
        
        let editView:subconditions = subconditions.init(row: indexPath.row - 1)
        editView.delegate = self
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "edit", handler: { [unowned self]  (action, view, completion) in
            print("ios 11")
            // present 放在前面  subconditions的table可以刷新数据
            self.present(editView, animated: true, completion: nil)

            if indexPath.section  == 0 {
                let data = self.compuseData[indexPath.row - 1]
                editView.editData = data
                
            }else{
                let data = self.internData[indexPath.row - 1]
                editView.editData = data
            
                
            }
            
            completion(true)
        })
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        // 禁止 full swipe 触发action
        config.performsFirstActionWithFullSwipe = false
        return config
        
    }
    

}


// delegate

extension subscribleItem: subconditionDelegate{
    
    func modifyCondition(row: Int, item: subscribeConditionModel) {
        if item.type == "校招"{
            compuseData.remove(at: row)
            compuseData.insert(item, at: row)
            
            //self.tableView.reloadSections([0], animationStyle: .automatic)
            //self.tableView.layoutSubviews()
            // 这个不刷新？ 上面可以刷新
            //self.tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
        }else{
            internData.remove(at: row)
            internData.insert(item, at: row)
           
            //self.tableView.reloadSections([1], animationStyle: .automatic)
            //self.tableView.layoutSubviews()
            // 这个不刷新？ 上面可以刷新
            //self.tableView.reloadRows(at: [IndexPath.init(row: row, section: 1)], with: .automatic)

            
         }
         // 用这个 cell的autolayout 才有效
         self.tableView.reloadData()
        
    }
    
    
    func addNewConditionItem(item: subscribeConditionModel) {
        
        if item.type == "校招"{
            compuseData.append(item)
        }else{
            internData.append(item)
        }
        self.tableView.reloadData()
    }
    
    
    
    
}

