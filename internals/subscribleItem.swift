//
//  subscribleItem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let maxCount = 5
fileprivate let section = 2
fileprivate let imageSize = CGSize.init(width: 25, height: 25)

class subscribleItem: BaseTableViewController {


    private lazy var internData:[internSubscribeModel]  = []
    private lazy var compuseData:[graduateSubscribeModel] = []
    
    
    
    
    private lazy var addBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30 , height: 30))
        btn.setImage(UIImage.init(named: "plus")?.changesize(size: imageSize).withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.blue
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
        self.navigationController?.insertCustomerView(UIColor.orange)
        
        //self.navigationController?.insertCustomerView(UIColor.orange)
        //self.loadData()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        
       
    }
    
    private lazy var footLabelView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 50))
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = "最多同时开启5个订阅"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().centerYEqualToView(v)?.centerXEqualToView(v)?.autoHeightRatio(0)
        return v
    }()
    
    override func setViews(){
        
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableHeaderView = UIView.init()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.title = "我的订阅"
        
        self.tableView.register(subScribeInternCell.self, forCellReuseIdentifier: subScribeInternCell.identity())
        self.tableView.register(subScribeGraduateCell.self, forCellReuseIdentifier: subScribeGraduateCell.identity())
        // sectionCell
        self.tableView.register(sectionCellView.self, forCellReuseIdentifier: sectionCellView.identity())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addBtn)
        
        self.handleViews.append(addBtn)
        super.setViews()
        
    }
    
    
    override func didFinishloadData(){
        super.didFinishloadData()
        // 这里赋值footView
        self.tableView.tableFooterView = footLabelView
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
            Thread.sleep(forTimeInterval: 1)
            
            
            // 根据type类型 构建不同的数据
            self?.internData.append(internSubscribeModel(JSON: ["id":getUUID(),"type":"intern","locate":"成都","internSalary":"200/天","business":"计算机","internDay":"4天/周","internMonth":"半年", "degree":"大专"])!)
            
            self?.compuseData.append(graduateSubscribeModel(JSON: ["id":getUUID(),"type":"graduate","locate":"北京","salary":"10-12K/月","business":"人工智能","degree":"本科"])!)
                self?.compuseData.append(graduateSubscribeModel(JSON: ["id":getUUID(),"type":"graduate",
                                                              "locate":"北京","salary":"20-30K/月","business":"学前教育", "degree":"硕士"])!)
            DispatchQueue.main.async {
                self?.didFinishloadData()
                
            }
        }
        
        
       
        
    }
    
    
    @objc func addItem(){
        if  internData.count + compuseData.count  >= maxCount{
            showOnlyTextHub(message: "达到上限", view: self.view)
            return
        }
        
        let condition:subconditions = subconditions()
        condition.navTitle = "新增订阅条件"
        condition.delegate = self
        self.present(condition, animated: true, completion: nil)
        
    }
}


// table
extension subscribleItem{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return  compuseData.count > 0 ?  1 + compuseData.count : 0
        }else{
            return  internData.count > 0 ?  1 + internData.count : 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellView.identity(), for: indexPath) as! sectionCellView
                cell.mode = indexPath.section == 0 ?  "校招" : "实习"
                cell.backgroundColor = UIColor.clear
                cell.rightBtn.isHidden = true
                return cell
            }
        
            switch indexPath.section{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: subScribeGraduateCell.identity(), for: indexPath) as! subScribeGraduateCell
                cell.mode = compuseData[indexPath.row - 1]
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: subScribeInternCell.identity(), for: indexPath) as! subScribeInternCell
                cell.mode =  internData[indexPath.row - 1]
                return cell
            default:
                break
            }
            
        return UITableViewCell()
        
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            let mode = indexPath.section == 0 ? "校招" : "实习"
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: sectionCellView.self, contentViewWidth: ScreenW)
        }
        
        if indexPath.section == 0 {
            let mode = compuseData[indexPath.row - 1]
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: subScribeGraduateCell.self, contentViewWidth: ScreenW)
        }else{
            
            let mode = internData[indexPath.row - 1]
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: subScribeInternCell.self, contentViewWidth: ScreenW)
        }
       
        
    }
    
 
    // edit cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.row != 0 ? true : false
    }
    
    
    // 选择进行编辑
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        //let type =  indexPath.section == 0 ? subscribeType.graduate : subscribeType.intern
        let editView:subconditions = subconditions()
        editView.navTitle = "修改订阅条件"
        editView.delegate = self
        
        self.present(editView, animated: true, completion: nil)
        
        if indexPath.section  == 0 {
            let data = self.compuseData[indexPath.row - 1]
            //editView.editData =  data
            editView.editData = (type:.graduate,  data:data, index:  IndexPath.init(row: indexPath.row - 1, section: indexPath.section))
            
        }else{
            let data = self.internData[indexPath.row - 1]
            editView.editData = (type:.intern,  data:data, index:  IndexPath.init(row: indexPath.row - 1, section: indexPath.section))
            
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    
    // 自定义cell 编辑方法
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        
        let edit = UITableViewRowAction(style: .normal, title: "编辑") { action, index in
            
            let editView:subconditions = subconditions()
            editView.navTitle = "修改订阅条件"
            editView.delegate = self
            
            if indexPath.section  == 0 {
                let data = self.compuseData[indexPath.row - 1]
                //editView.editData =  data
                editView.editData = (type:.graduate,  data:data, index:  IndexPath.init(row: indexPath.row - 1, section: indexPath.section))
             
            }else{
                let data = self.internData[indexPath.row - 1]
                editView.editData = (type:.intern,  data:data, index:  IndexPath.init(row: indexPath.row - 1, section: indexPath.section))

                
            }
            
            self.present(editView, animated: true, completion: nil)

            
        }
        
        //edit.backgroundColor = UIColor.orange
        
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in

            
            if indexPath.section == 0{
                self.compuseData.remove(at: indexPath.row - 1)
            }else{
                self.internData.remove(at: indexPath.row - 1)
            }
            
            tableView.reloadSections([indexPath.section], animationStyle: .automatic)

            
        }
        delete.backgroundColor = UIColor.red
        
        return [edit,delete]
    }
    
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "删除", handler: { (action, view, completion) in
            //TODO: Delete
          
            
            if indexPath.section == 0{
                self.compuseData.remove(at: indexPath.row - 1)
            }else{
                self.internData.remove(at: indexPath.row - 1)
            }
            
            tableView.reloadSections([indexPath.section], animationStyle: .automatic)
            completion(true)
        })
        
        
        let editView:subconditions = subconditions()
        editView.navTitle = "修改订阅条件"
        editView.delegate = self
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "编辑", handler: { [unowned self]  (action, view, completion) in
            // present 放在前面  subconditions的table可以刷新数据
            self.present(editView, animated: true, completion: nil)

            if indexPath.section  == 0 {
                let data = self.compuseData[indexPath.row - 1]
                editView.editData = (type:.graduate,  data:data, index: IndexPath.init(row: indexPath.row - 1, section: indexPath.section) )

            }else{
                let data = self.internData[indexPath.row - 1]
                editView.editData = (type:.intern,  data:data, index:  IndexPath.init(row: indexPath.row - 1, section: indexPath.section))

                
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
    
    func modifyCondition(index: IndexPath, item: BaseSubscribeModel) {
        if item.kind == .graduate{
            
            compuseData.remove(at: index.row)
            compuseData.insert(item as! graduateSubscribeModel, at: index.row)

            
        }else{
            internData.remove(at: index.row)
            internData.insert(item as! internSubscribeModel, at: index.row)

         }
         // 这样刷新 数据才更新
         self.tableView.reloadSections([index.section], animationStyle: .automatic)
        
    }
    
    
    func addNewConditionItem(item: BaseSubscribeModel) {
        
        if item.kind == .graduate{
            compuseData.append(item as! graduateSubscribeModel)
             self.tableView.reloadSections([0], animationStyle: .automatic)
        }else{
            internData.append(item as! internSubscribeModel)
            self.tableView.reloadSections([1], animationStyle: .automatic)

        }
       
    }
    
    
    
    
}

