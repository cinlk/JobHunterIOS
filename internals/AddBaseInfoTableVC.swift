//
//  AddBaseInfoTableViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


// 添加
protocol addResumeItenDelegate: class {
    
    func addNewItem(type:ResumeSubItems)
    
}


let addResumeInfoNotify:String = "addResumeInfoNotify"

class AddBaseInfoTableViewController: BaseActionResumeVC {
    
    internal var itemType:ResumeSubItems = .none{
        didSet{
            
            self.title = itemType.add
            switch itemType {
            case .education:
                if let data = personEducationInfo(JSON: [:]){
                    setData(data)
                }
            
            case .works:
                if let data = personInternInfo(JSON: [:]){
                    setData(data)
                }
                
            case .project:
                if let data = personProjectInfo(JSON: [:]){
                    setData(data)
                }

            case .schoolWork:
                if let data =  studentWorkInfo(JSON: [:]){
                    setData(data)
                }
                
            case .practice:
                if let data = socialPracticeInfo(JSON: [:]){
                    setData(data)
                }
            case .other:
                if let data = resumeOther(JSON: [:]){
                    setData(data)
                }
            
            case .skills:
                if let data = personSkillInfo(JSON: [:]){
                    setData(data)
                }
                
            default:
                break
            }
        }
    }
    
    
    internal var placeholder:String = "输入专业描述,500子以内"
    // 添加item代理
    weak var delegate:addResumeItenDelegate?
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViews()
        
    }
    
    
    override func currentViewControllerShouldPop() -> Bool {
        
        
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "编辑尚未结束，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { (_) in
                self.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        // 未保存
        if self.isChange{
            
            let alertController = UIAlertController(title: nil, message: "修改尚未保存，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "保存并返回", style: .default) { (_) in
                self.save()
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃保存", style: .cancel) { (_) in
                self.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true

        

        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == keys.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            
            cell.textView.text = diction[.describe]
            cell.updateText = { value in
                self.isChange = true
                self.diction[.describe] =  value
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.placeHolderLabel.text = placeholder
            cell.placeHolderLabel.isHidden = diction[.describe]!.isEmpty ? false : true
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identity(), for: indexPath) as! AddItemCell
            
            cell.onlyPickerResumeType = onlyPickerResumeType
            cell.mode = (type:keys[indexPath.row],title:diction[keys[indexPath.row]]!)
            cell.delegate = self
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == keys.count - 1 ?  textViewCell.cellHeight() : AddItemCell.cellHeight()
    }
    
 
    

}


extension AddBaseInfoTableViewController{
    
    private func setData(_ data:reumseInfoAction){
        guard  let kv = data.getTypeValue()  else {
            return
        }
        diction =  kv 
        keys = data.getItemList()
        onlyPickerResumeType = data.getPickerResumeType()
        placeholder = data.placeHolder
        
    }
}

extension AddBaseInfoTableViewController{
    private func setViews(){
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces = false
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        self.tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
        NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NSNotification.Name.init(addResumeInfoNotify), object: nil)
    }
    
}

// pciker

extension AddBaseInfoTableViewController: AddItemCellUpdate{
    
 
    func updateTextfield(value: String, type: ResumeInfoType){
        diction[type] = value
        isChange = true 
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.index(of: type)!, section: 0)], with: .automatic)
     }

}
//save

extension AddBaseInfoTableViewController{
    
    @objc private  func save(){
        
        if super.checkValue() == false{
            return 
        }
        // 添加到服务器
        pManager.addItemBy(itemType: itemType, res: res)
        
        delegate?.addNewItem(type: itemType)
        self.navigationController?.popvc(animated: true)
    
    }
    
   
}




